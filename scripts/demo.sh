#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 3 ]; then
  echo "usage: $0 <channel> <channel_user_id> <topic>" >&2
  exit 1
fi

CHANNEL="$1"
CHANNEL_USER_ID="$2"
TOPIC="$3"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

cp "$SCRIPT_DIR/../examples/session-summary.md" "$TMP_DIR/summary.md"
cp "$SCRIPT_DIR/../schema/task-state.json" "$TMP_DIR/task.json"
cp "$SCRIPT_DIR/../examples/exchange.json" "$TMP_DIR/exchange.json"

EXCHANGE_ID="$(python3 - "$TMP_DIR/exchange.json" <<'PY'
import json, sys
from pathlib import Path
print(json.loads(Path(sys.argv[1]).read_text(encoding='utf-8')).get('exchange_id', 'demo-exchange'))
PY
)"

"$SCRIPT_DIR/after-answer.sh" "$CHANNEL" "$CHANNEL_USER_ID" "$TOPIC" cross-channel-default "$TMP_DIR/summary.md" "$TMP_DIR/task.json" "$EXCHANGE_ID" "$TMP_DIR/exchange.json"

echo
echo "-----"
"$SCRIPT_DIR/before-answer.sh" "$CHANNEL" "$CHANNEL_USER_ID" "continue" "$TOPIC"
