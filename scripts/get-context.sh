#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 3 ]; then
  echo "usage: $0 <canonical_user> <query> <channel> [topic]" >&2
  exit 1
fi

CANONICAL_USER="$1"
QUERY="$2"
CHANNEL="$3"
TOPIC="${4:-}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="${OV_CONTEXT_ROOT:-}"
RECENT_EXCHANGES_SCRIPT="$SCRIPT_DIR/get-recent-exchanges.sh"
RECENT_LIMIT="${OV_RECENT_LIMIT:-8}"
RECENT_MAX_CHARS="${OV_RECENT_MAX_CHARS:-4000}"
CAPSULE_FILE="${ROOT}/capsules/${CANONICAL_USER}/${TOPIC}/continuation-capsule.json"

if [ -z "$ROOT" ] || [ ! -d "$ROOT" ]; then
  echo "OV_CONTEXT_ROOT is not set or directory not found" >&2
  exit 2
fi

query_type() {
  local q
  q="$(printf '%s' "$QUERY" | tr '[:upper:]' '[:lower:]')"
  case "$q" in
    *"what did you say exactly"*|*"exact words"*|*verbatim*) printf 'recall-verbatim' ;;
    *"where were we"*|*"what were we discussing"*|*"where did we stop"*) printf 'recall-summary' ;;
    *continue*|*resume*|*"pick up where we left off"*) printf 'continuation' ;;
    *blocked*|*blocker*|*"next step"*|*"current progress"*) printf 'task-progress' ;;
    *why*|*design*|*architecture*|*principle*) printf 'design-explanation' ;;
    *) printf 'default' ;;
  esac
}

latest_file() {
  local dir="$1"
  if [ -d "$dir" ]; then
    find "$dir" -maxdepth 1 -type f ! -name 'manual-test.json' | sort | tail -n 1
  fi
}

print_block() {
  local title="$1"
  local file="$2"
  if [ -n "$file" ] && [ -f "$file" ]; then
    printf '=== %s ===\n' "$title"
    printf 'file: %s\n' "$file"
    cat "$file" || true
    printf '\n'
  fi
}

print_recent_exchanges() {
  if [ -n "$TOPIC" ]; then
    "$RECENT_EXCHANGES_SCRIPT" "$CANONICAL_USER" "$TOPIC" "$RECENT_LIMIT_EFFECTIVE" "$RECENT_MAX_CHARS_EFFECTIVE" "$RECENT_MODE" || true
  fi
}

SESSION_DIR="${ROOT}/sessions/${CANONICAL_USER}"
if [ -n "$TOPIC" ]; then
  SESSION_FILE="$(latest_file "${SESSION_DIR}/${TOPIC}")"
else
  SESSION_FILE="$(latest_file "${SESSION_DIR}")"
fi
TASK_FILE="$(latest_file "${ROOT}/tasks/${CANONICAL_USER}")"
MEMORY_FILE="$(latest_file "${ROOT}/memory/long-term")"

QUERY_TYPE="$(query_type)"
RECENT_MODE="default"
RECENT_LIMIT_EFFECTIVE="$RECENT_LIMIT"
RECENT_MAX_CHARS_EFFECTIVE="$RECENT_MAX_CHARS"
case "$QUERY_TYPE" in
  continuation) RECENT_MODE="continuation"; RECENT_LIMIT_EFFECTIVE="3"; RECENT_MAX_CHARS_EFFECTIVE="1800" ;;
  recall-summary) RECENT_MODE="recall-summary"; RECENT_LIMIT_EFFECTIVE="3"; RECENT_MAX_CHARS_EFFECTIVE="1600" ;;
  recall-verbatim) RECENT_MODE="recall-verbatim"; RECENT_LIMIT_EFFECTIVE="2"; RECENT_MAX_CHARS_EFFECTIVE="2200" ;;
  task-progress) RECENT_MODE="task-progress"; RECENT_LIMIT_EFFECTIVE="2"; RECENT_MAX_CHARS_EFFECTIVE="1200" ;;
  design-explanation) RECENT_MODE="design-explanation"; RECENT_LIMIT_EFFECTIVE="2"; RECENT_MAX_CHARS_EFFECTIVE="1400" ;;
  *) ;;
esac

printf '=== identity ===\n'
printf 'canonical_user: %s\nchannel: %s\n' "$CANONICAL_USER" "$CHANNEL"
if [ -n "$TOPIC" ]; then
  printf 'topic: %s\n' "$TOPIC"
fi
printf 'query_type: %s\n\n' "$QUERY_TYPE"

case "$QUERY_TYPE" in
  continuation)
    print_block 'continuation_capsule' "$CAPSULE_FILE"
    print_recent_exchanges
    print_block 'task_state' "$TASK_FILE"
    print_block 'session_summary' "$SESSION_FILE"
    ;;
  recall-summary)
    print_block 'continuation_capsule' "$CAPSULE_FILE"
    print_recent_exchanges
    print_block 'session_summary' "$SESSION_FILE"
    print_block 'task_state' "$TASK_FILE"
    ;;
  recall-verbatim)
    print_recent_exchanges
    print_block 'session_summary' "$SESSION_FILE"
    ;;
  task-progress)
    print_block 'task_state' "$TASK_FILE"
    print_block 'continuation_capsule' "$CAPSULE_FILE"
    print_recent_exchanges
    ;;
  design-explanation)
    print_block 'session_summary' "$SESSION_FILE"
    print_block 'task_state' "$TASK_FILE"
    print_block 'continuation_capsule' "$CAPSULE_FILE"
    print_recent_exchanges
    ;;
  *)
    print_block 'task_state' "$TASK_FILE"
    print_block 'continuation_capsule' "$CAPSULE_FILE"
    print_recent_exchanges
    print_block 'session_summary' "$SESSION_FILE"
    ;;
esac
print_block 'long_term_memory' "$MEMORY_FILE"
