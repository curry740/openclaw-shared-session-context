#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 2 ]; then
  echo "usage: $0 <canonical_user> <topic> [limit] [max_chars] [mode]" >&2
  exit 1
fi

CANONICAL_USER="$1"
TOPIC="$2"
LIMIT="${3:-8}"
MAX_CHARS="${4:-4000}"
MODE="${5:-default}"
ROOT="${OV_CONTEXT_ROOT:-}"
BASE_DIR="${ROOT}/exchanges/${CANONICAL_USER}/${TOPIC}"

if [ -z "$ROOT" ] || [ ! -d "$ROOT" ]; then
  echo "OV_CONTEXT_ROOT is not set or directory not found" >&2
  exit 2
fi
if [ ! -d "$BASE_DIR" ]; then
  exit 0
fi

python3 - "$BASE_DIR" "$LIMIT" "$MAX_CHARS" "$MODE" <<'PY'
import json
import sys
from pathlib import Path

base = Path(sys.argv[1]); limit = int(sys.argv[2]); max_chars = int(sys.argv[3]); mode = sys.argv[4]
all_files = [p for p in sorted(base.glob('*.json'), key=lambda p: p.name) if p.name != 'manual-test.json']

def clean(text):
    return str(text or '').replace('[[reply_to_current]]', '').strip()

def score(data):
    s = {'high': 5, 'medium': 3, 'low': 1}.get(str(data.get('signal', '')).lower(), 0)
    if data.get('contains_decision'): s += 2
    if data.get('contains_next_step'): s += 2
    if str(data.get('role', '')).lower() == 'task': s += 2
    if mode == 'continuation' and str(data.get('intent', '')).lower() in {'continuation', 'progress', 'recall-summary'}: s += 2
    if mode == 'task-progress' and str(data.get('intent', '')).lower() == 'progress': s += 2
    return s

cand = []
for f in reversed(all_files):
    try:
        data = json.loads(f.read_text(encoding='utf-8'))
    except Exception:
        continue
    user = clean(data.get('user_text'))
    assistant = clean(data.get('continuation_summary') or data.get('assistant_text'))
    if not user and not assistant:
        continue
    if mode != 'default' and score(data) < 3:
        continue
    cand.append((score(data), f, data, user, assistant))

cand.sort(key=lambda x: (x[0], x[1].name), reverse=True)
selected = []
char_budget = 0
for item in cand:
    _, f, data, user, assistant = item
    size = len(user) + len(assistant)
    if selected and (len(selected) >= limit or char_budget + size > max_chars):
        continue
    selected.append((f, data, user, assistant))
    char_budget += size

selected.sort(key=lambda x: x[0].name)
if not selected:
    raise SystemExit(0)

print('=== recent_exchanges ===')
for f, data, user, assistant in selected:
    print(f'file: {f}')
    print(f'timestamp: {data.get("timestamp", "")}')
    print(f'channel: {data.get("channel", "")}')
    print('[user]')
    print(user or '(empty)')
    print('[assistant]')
    print(assistant or '(empty)')
    print('')
PY
