#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 3 ]; then
  echo "usage: $0 <canonical_user> <task_id> <task_json_file>" >&2
  exit 1
fi

CANONICAL_USER="$1"
TASK_ID="$2"
TASK_JSON_FILE="$3"
ROOT="${OV_CONTEXT_ROOT:-}"
BASE_DIR="${ROOT}/tasks/${CANONICAL_USER}"
TARGET_FILE="${BASE_DIR}/${TASK_ID}.json"

if [ -z "$ROOT" ] || [ ! -d "$ROOT" ]; then
  echo "OV_CONTEXT_ROOT is not set or directory not found" >&2
  exit 2
fi
if [ ! -f "$TASK_JSON_FILE" ]; then
  echo "task json file not found: $TASK_JSON_FILE" >&2
  exit 1
fi
mkdir -p "$BASE_DIR"

python3 - "$TASK_JSON_FILE" "$TARGET_FILE" <<'PY'
import json, re, sys
from pathlib import Path
src = Path(sys.argv[1]); dst = Path(sys.argv[2])
data = json.loads(src.read_text(encoding='utf-8'))

def clean_line(line: str) -> str:
    line = str(line or '').replace('[assistant]', '').replace('[[reply_to_current]]', '').strip()
    while line.startswith(('-', '*', '•')):
        line = line[1:].strip()
    line = re.sub(r'^#+\s*', '', line)
    line = re.sub(r'^(conclusion|current state|next step)[:：]\s*', '', line, flags=re.I)
    line = re.sub(r'\s+', ' ', line).strip()
    return line

def compress(value, max_items=3, max_len=90):
    raw_items = value if isinstance(value, list) else str(value or '').splitlines()
    out = []
    for raw in raw_items:
        line = clean_line(raw)
        if not line or line.startswith('#'):
            continue
        if len(line) > max_len:
            line = line[:max_len-3].rstrip() + '...'
        if line not in out:
            out.append(line)
        if len(out) >= max_items:
            break
    return out

if 'current_goal' in data:
    goal = clean_line(data.get('current_goal', ''))
    if len(goal) > 100:
        goal = goal[:97].rstrip() + '...'
    data['current_goal'] = goal
if 'latest_progress' in data:
    data['latest_progress'] = compress(data.get('latest_progress', []), 3, 110)
if 'blockers' in data:
    data['blockers'] = compress(data.get('blockers', []), 3, 110)
if 'next_step' in data:
    nxt = compress(data.get('next_step', []), 1, 120)
    data['next_step'] = nxt[0] if nxt else clean_line(data.get('next_step', ''))

allowed = {'task_id','title','status','current_goal','latest_progress','blockers','next_step','updated_at'}
data = {k:v for k,v in data.items() if k in allowed and v not in (None, '', [], {})}

if not any(data.get(k) for k in ['current_goal','latest_progress','blockers','next_step','status','title']):
    print(f'{dst}\tSKIP_EMPTY')
    raise SystemExit(0)

new_text = json.dumps(data, ensure_ascii=False, indent=2) + '\n'
old = None
if dst.exists():
    try:
        old = json.loads(dst.read_text(encoding='utf-8'))
    except Exception:
        old = None

old_cmp = dict(old or {})
old_cmp.pop('updated_at', None)
new_cmp = dict(data)
new_cmp.pop('updated_at', None)
if old_cmp == new_cmp:
    print(f'{dst}\tUNCHANGED')
    raise SystemExit(0)

dst.write_text(new_text, encoding='utf-8')
print(str(dst))
PY
