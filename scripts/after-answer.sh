#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 6 ]; then
  echo "usage: $0 <channel> <channel_user_id> <topic> <task_id> <summary_file> <task_json_file> [exchange_id] [exchange_json_file]" >&2
  exit 1
fi

CHANNEL="$1"
CHANNEL_USER_ID="$2"
TOPIC="$3"
TASK_ID="$4"
SUMMARY_FILE="$5"
TASK_JSON_FILE="$6"
EXCHANGE_ID="${7:-}"
EXCHANGE_JSON_FILE="${8:-}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
RESOLVER="$SCRIPT_DIR/resolve-identity.sh"
STORE_SUMMARY="$SCRIPT_DIR/store-summary.sh"
UPDATE_TASK="$SCRIPT_DIR/update-task.sh"
STORE_EXCHANGE="$SCRIPT_DIR/store-exchange.sh"
STORE_CAPSULE="$SCRIPT_DIR/store-continuation-capsule.sh"

CANONICAL_USER="$($RESOLVER "$CHANNEL" "$CHANNEL_USER_ID")"
if [ -z "$CANONICAL_USER" ]; then
  echo "identity_not_found" >&2
  exit 2
fi

summary_is_writable() {
  local file="$1"
  [ -f "$file" ] || return 1
  grep -Eqi '^(goal:|progress:|decisions:|blockers:|next_step:)' "$file"
}

task_is_writable() {
  local file="$1"
  [ -f "$file" ] || return 1
  python3 - "$file" <<'PY'
import json, sys
from pathlib import Path
path = Path(sys.argv[1])
try:
    data = json.loads(path.read_text(encoding='utf-8'))
except Exception:
    raise SystemExit(1)
keys = {'current_goal', 'latest_progress', 'blockers', 'next_step', 'status', 'title'}
for key in keys:
    value = data.get(key)
    if isinstance(value, list) and any(str(x).strip() for x in value):
        raise SystemExit(0)
    if isinstance(value, str) and value.strip():
        raise SystemExit(0)
raise SystemExit(1)
PY
}

SUMMARY_CHANGED="false"
TASK_CHANGED="false"
CAPSULE_CHANGED="false"

if summary_is_writable "$SUMMARY_FILE"; then
  summary_result="$($STORE_SUMMARY "$CANONICAL_USER" "$CHANNEL" "$TOPIC" "$SUMMARY_FILE")"
  case "$summary_result" in *$'\tUNCHANGED'|*$'\tSKIP_EMPTY') ;; *) SUMMARY_CHANGED="true" ;; esac
  printf '%s\n' "$summary_result"
fi

if task_is_writable "$TASK_JSON_FILE"; then
  task_result="$($UPDATE_TASK "$CANONICAL_USER" "$TASK_ID" "$TASK_JSON_FILE")"
  case "$task_result" in *$'\tUNCHANGED'|*$'\tSKIP_EMPTY') ;; *) TASK_CHANGED="true" ;; esac
  printf '%s\n' "$task_result"
fi

if [ -n "$EXCHANGE_ID" ] && [ -n "$EXCHANGE_JSON_FILE" ] && [ -f "$EXCHANGE_JSON_FILE" ]; then
  exchange_result="$($STORE_EXCHANGE "$CANONICAL_USER" "$TOPIC" "$EXCHANGE_ID" "$EXCHANGE_JSON_FILE")"
  printf '%s\n' "$exchange_result"
  capsule_result="$($STORE_CAPSULE "$CANONICAL_USER" "$TOPIC" "$CHANNEL" "$EXCHANGE_JSON_FILE")"
  case "$capsule_result" in *$'\tUNCHANGED'|*$'\tSKIP_EMPTY') ;; *) CAPSULE_CHANGED="true" ;; esac
  printf '%s\n' "$capsule_result"
fi

if [ "$SUMMARY_CHANGED" = "false" ] && [ "$TASK_CHANGED" = "false" ] && [ "$CAPSULE_CHANGED" = "false" ]; then
  printf 'NOOP\n'
fi
