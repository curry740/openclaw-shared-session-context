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

python3 - "$SUMMARY_FILE" "$TARGET_FILE" <<'PY'
import re, sys
from pathlib import Path
src = Path(sys.argv[1]); dst = Path(sys.argv[2])
required = ('goal:', 'progress:', 'decisions:', 'blockers:', 'next_step:')
allowed = ('# Session Summary','topic:','goal:','progress:','decisions:','blockers:','next_step:','source_channel:','timestamp:')

def sanitize(text: str) -> str:
    out = []; in_list = False
    for raw in text.splitlines():
        line = raw.rstrip(); stripped = line.strip()
        if not stripped:
            if out and out[-1] != '': out.append('')
            continue
        if stripped.startswith('## Latest Exchange'): break
        if stripped.startswith('- ') and in_list:
            out.append(stripped); continue
        if any(stripped.startswith(prefix) for prefix in allowed):
            out.append(stripped)
            in_list = stripped.endswith(':') and stripped[:-1] in {'decisions', 'blockers'}
            continue
        if stripped.startswith('[user]') or stripped.startswith('[assistant]'): continue
        in_list = False
    while out and out[-1] == '': out.pop()
    return '\n'.join(out) + ('\n' if out else '')

def norm(text: str) -> str:
    lines = []
    for raw in text.splitlines():
        line = raw.strip()
        if not line: continue
        if line.startswith('timestamp:') or line.startswith('source_channel:'): continue
        lines.append(re.sub(r'\s+', ' ', line))
    return '\n'.join(lines)

cleaned = sanitize(src.read_text(encoding='utf-8'))
if not any(marker in cleaned for marker in required):
    print(f'{dst}\tSKIP_EMPTY')
    raise SystemExit(0)
if dst.exists() and norm(dst.read_text(encoding='utf-8')) == norm(cleaned):
    print(f'{dst}\tUNCHANGED')
    raise SystemExit(0)
dst.write_text(cleaned, encoding='utf-8')
print(str(dst))
PY
