#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 2 ]; then
  echo "usage: $0 <canonical_user> <topic> [limit] [max_chars] [mode]" >&2
  exit 1
fi

CANONICAL_USER="$1"
TOPIC="$2"
LIMIT="${3:-8}"
ROOT="${OV_CONTEXT_ROOT:-}"
BASE_DIR="${ROOT}/exchanges/${CANONICAL_USER}/${TOPIC}"

if [ -z "$ROOT" ] || [ ! -d "$ROOT" ]; then
  echo "OV_CONTEXT_ROOT is not set or directory not found" >&2
  exit 2
fi
if [ ! -d "$BASE_DIR" ]; then
  exit 0
fi

echo "=== recent_exchanges ==="
find "$BASE_DIR" -maxdepth 1 -type f -name '*.json' | sort | tail -n "$LIMIT" | while read -r file; do
  echo "file: $file"
  cat "$file"
  echo
 done
