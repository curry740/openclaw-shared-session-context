#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 4 ]; then
  echo "usage: $0 <canonical_user> <channel> <topic> <summary_file>" >&2
  exit 1
fi

CANONICAL_USER="$1"
CHANNEL="$2"
TOPIC="$3"
SUMMARY_FILE="$4"
ROOT="${OV_CONTEXT_ROOT:-}"
DATE_STR="$(date +%F)"
BASE_DIR="${ROOT}/sessions/${CANONICAL_USER}/${TOPIC}"
TARGET_FILE="${BASE_DIR}/${DATE_STR}-${CHANNEL}.md"

if [ -z "$ROOT" ] || [ ! -d "$ROOT" ]; then
  echo "OV_CONTEXT_ROOT is not set or directory not found" >&2
  exit 2
fi
if [ ! -f "$SUMMARY_FILE" ]; then
  echo "summary file not found: $SUMMARY_FILE" >&2
  exit 1
fi
mkdir -p "$BASE_DIR"
cp "$SUMMARY_FILE" "$TARGET_FILE"
echo "$TARGET_FILE"
