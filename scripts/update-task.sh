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
cp "$TASK_JSON_FILE" "$TARGET_FILE"
echo "$TARGET_FILE"
