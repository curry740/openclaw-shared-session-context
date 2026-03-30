#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 2 ]; then
  echo "usage: $0 <channel> <channel_user_id>" >&2
  exit 1
fi

CHANNEL="$1"
CHANNEL_USER_ID="$2"
MAP_FILE="${OV_IDENTITY_MAP:-}"

if [ -z "$MAP_FILE" ] || [ ! -f "$MAP_FILE" ]; then
  echo "OV_IDENTITY_MAP is not set or file not found" >&2
  exit 2
fi

python3 - "$CHANNEL" "$CHANNEL_USER_ID" "$MAP_FILE" <<'PY'
import json, sys
channel=sys.argv[1]
user_id=sys.argv[2]
path=sys.argv[3]
with open(path,'r',encoding='utf-8') as f:
    data=json.load(f)
needle = user_id.casefold()
for canonical, payload in data.get('users',{}).items():
    channels=payload.get('channels',{})
    candidate = str(channels.get(channel,{}).get('userId', ''))
    if candidate.casefold() == needle:
        print(canonical)
        raise SystemExit(0)
print("")
PY
