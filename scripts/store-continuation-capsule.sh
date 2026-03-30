#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 4 ]; then
  echo "usage: $0 <canonical_user> <topic> <channel> <exchange_json_file>" >&2
  exit 1
fi

CANONICAL_USER="$1"
TOPIC="$2"
CHANNEL="$3"
EXCHANGE_JSON_FILE="$4"
ROOT="${OV_CONTEXT_ROOT:-}"
BASE_DIR="${ROOT}/capsules/${CANONICAL_USER}/${TOPIC}"
TARGET_FILE="${BASE_DIR}/continuation-capsule.json"

if [ -z "$ROOT" ] || [ ! -d "$ROOT" ]; then
  echo "OV_CONTEXT_ROOT is not set or directory not found" >&2
  exit 2
fi
if [ ! -f "$EXCHANGE_JSON_FILE" ]; then
  echo "exchange json file not found: $EXCHANGE_JSON_FILE" >&2
  exit 1
fi

mkdir -p "$BASE_DIR"

python3 - "$EXCHANGE_JSON_FILE" "$TARGET_FILE" "$TOPIC" "$CHANNEL" <<'PY'
import json
import re
import sys
from pathlib import Path

src = Path(sys.argv[1]); dst = Path(sys.argv[2]); topic = sys.argv[3]; channel = sys.argv[4]
try:
    data = json.loads(src.read_text(encoding='utf-8'))
except Exception:
    raise SystemExit(1)

def clean_text(text: str) -> str:
    text = str(text or '').replace('[[reply_to_current]]', '').strip()
    text = re.sub(r'```.*?```', ' ', text, flags=re.S)
    text = re.sub(r'`([^`]*)`', r'\1', text)
    text = re.sub(r'\s+', ' ', text)
    return text.strip()

user_text = clean_text(data.get('user_text', ''))
assistant_text = clean_text(data.get('assistant_text', ''))
intent = str(data.get('intent') or '').strip() or 'default'

def pick(*vals):
    for v in vals:
        v = clean_text(v)
        if v:
            return v[:220]
    return ''

result = {
    'topic': topic,
    'channel': channel,
    'last_user_intent': intent,
    'last_effective_question': pick(data.get('last_effective_question'), user_text),
    'last_assistant_conclusion': pick(data.get('last_assistant_conclusion'), data.get('state_delta'), assistant_text),
    'current_focus': pick(data.get('current_focus'), data.get('state_delta')),
    'next_best_response': pick(data.get('next_best_response'), data.get('continuation_hint')),
    'answer_mode': str(data.get('answer_mode') or 'default'),
    'source_exchange_id': str(data.get('exchange_id') or ''),
    'updated_at': str(data.get('timestamp') or '')
}

if not any(result.get(k) for k in ['last_effective_question', 'last_assistant_conclusion', 'current_focus', 'next_best_response']):
    print(f'{dst}\tSKIP_EMPTY')
    raise SystemExit(0)

old = None
if dst.exists():
    try:
        old = json.loads(dst.read_text(encoding='utf-8'))
    except Exception:
        old = None
keys = ['topic', 'last_user_intent', 'last_effective_question', 'last_assistant_conclusion', 'current_focus', 'next_best_response', 'answer_mode', 'source_exchange_id']
if old and all(old.get(k) == result.get(k) for k in keys):
    print(f'{dst}\tUNCHANGED')
    raise SystemExit(0)

dst.write_text(json.dumps(result, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print(str(dst))
PY
