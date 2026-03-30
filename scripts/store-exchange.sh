#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 4 ]; then
  echo "usage: $0 <canonical_user> <topic> <exchange_id> <exchange_json_file>" >&2
  exit 1
fi

CANONICAL_USER="$1"
TOPIC="$2"
EXCHANGE_ID="$3"
EXCHANGE_JSON_FILE="$4"
ROOT="${OV_CONTEXT_ROOT:-}"
BASE_DIR="${ROOT}/exchanges/${CANONICAL_USER}/${TOPIC}"
TARGET_FILE="${BASE_DIR}/${EXCHANGE_ID}.json"

if [ -z "$ROOT" ] || [ ! -d "$ROOT" ]; then
  echo "OV_CONTEXT_ROOT is not set or directory not found" >&2
  exit 2
fi
if [ ! -f "$EXCHANGE_JSON_FILE" ]; then
  echo "exchange json file not found: $EXCHANGE_JSON_FILE" >&2
  exit 1
fi

mkdir -p "$BASE_DIR"

python3 - "$EXCHANGE_JSON_FILE" "$TARGET_FILE" <<'PY'
import json
import re
import sys
from pathlib import Path

src = Path(sys.argv[1])
dst = Path(sys.argv[2])

def clean_text(text: str) -> str:
    text = str(text or '').replace('[[reply_to_current]]', '').strip()
    text = re.sub(r'```.*?```', ' ', text, flags=re.S)
    text = re.sub(r'`([^`]*)`', r'\1', text)
    text = re.sub(r'\n{3,}', '\n\n', text)
    return text.strip()

try:
    data = json.loads(src.read_text(encoding='utf-8'))
except Exception:
    raise SystemExit(1)

user_text = clean_text(data.get('user_text', ''))
assistant_text = clean_text(data.get('assistant_text', ''))
combined = f"{user_text}\n{assistant_text}"

def infer_role() -> str:
    if any(k in assistant_text.lower() for k in ['i am implementing', 'patched', 'refactor', 'commit', 'changing files']):
        return 'implementation'
    if any(k in combined.lower() for k in ['shared context', 'cross-channel', 'next step', 'blocked', 'where were we', 'continue']):
        return 'task'
    return 'general'

def infer_signal(role: str) -> str:
    text = combined.lower()
    if role == 'implementation' and not any(k in text for k in ['conclusion', 'current state', 'next step', 'blocker', 'root cause']):
        return 'low'
    if any(k in text for k in ['conclusion', 'next step', 'current state', 'blocker', 'root cause', 'design', 'decision']):
        return 'high'
    if len(combined) >= 120:
        return 'medium'
    return 'low'

def infer_intent() -> str:
    user = user_text.lower()
    if any(k in user for k in ['continue', 'resume', 'pick up where we left off']):
        return 'continuation'
    if any(k in user for k in ['what did you say exactly', 'exact words', 'verbatim']):
        return 'recall-verbatim'
    if any(k in user for k in ['where were we', 'what were we discussing', 'where did we stop']):
        return 'recall-summary'
    if any(k in combined.lower() for k in ['next step', 'blocked', 'current progress']):
        return 'progress'
    if any(k in combined.lower() for k in ['design', 'decision', 'why', 'architecture']):
        return 'decision'
    return 'general'

def infer_answer_mode(intent: str) -> str:
    if intent in {'continuation', 'recall-verbatim', 'recall-summary'}:
        return 'recent_first'
    if intent == 'progress':
        return 'task_first'
    if intent == 'decision':
        return 'summary_first'
    return 'default'

def first_semantic_line(text: str, needles):
    for raw in text.splitlines():
        line = raw.strip(' -*•\t')
        if not line:
            continue
        if any(n in line.lower() for n in needles):
            return line[:220]
    return ''

role = infer_role()
intent = infer_intent()
payload = {
    'timestamp': data.get('timestamp', ''),
    'channel': data.get('channel', ''),
    'user_text': user_text[:500],
    'assistant_text': assistant_text[:2000],
    'signal': infer_signal(role),
    'intent': intent,
    'role': role,
    'answer_mode': infer_answer_mode(intent),
    'topic_ref': data.get('topic_ref', 'general'),
    'state_delta': data.get('state_delta') or first_semantic_line(assistant_text, ['current state', 'conclusion', 'done', 'completed', 'status']),
    'continuation_hint': data.get('continuation_hint') or first_semantic_line(assistant_text, ['next step', 'next', 'follow-up', 'continue']),
    'continuation_summary': data.get('continuation_summary', ''),
    'contains_decision': bool(data.get('contains_decision')) or ('decision' in combined.lower() or 'design' in combined.lower() or 'conclusion' in combined.lower()),
    'contains_next_step': bool(data.get('contains_next_step')) or ('next step' in combined.lower())
}

dst.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print(str(dst))
PY
