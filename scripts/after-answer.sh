#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 6 ]; then
  echo "usage: $0 <channel> <channel_user_id> <topic> <task_id> <summary_file> <task_json_file>" >&2
  exit 1
fi

CHANNEL="$1"
CHANNEL_USER_ID="$2"
TOPIC="$3"
TASK_ID="$4"
SUMMARY_FILE="$5"
TASK_JSON_FILE="$6"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
RESOLVER="$SCRIPT_DIR/resolve-identity.sh"
STORE_SUMMARY="$SCRIPT_DIR/store-summary.sh"
UPDATE_TASK="$SCRIPT_DIR/update-task.sh"

CANONICAL_USER="$($RESOLVER "$CHANNEL" "$CHANNEL_USER_ID")"
if [ -z "$CANONICAL_USER" ]; then
  echo "identity_not_found" >&2
  exit 2
fi

"$STORE_SUMMARY" "$CANONICAL_USER" "$CHANNEL" "$TOPIC" "$SUMMARY_FILE"
"$UPDATE_TASK" "$CANONICAL_USER" "$TASK_ID" "$TASK_JSON_FILE"
