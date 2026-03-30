#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 3 ]; then
  echo "usage: $0 <channel> <channel_user_id> <query> [topic]" >&2
  exit 1
fi

CHANNEL="$1"
CHANNEL_USER_ID="$2"
QUERY="$3"
TOPIC="${4:-}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
RESOLVER="$SCRIPT_DIR/resolve-identity.sh"
GET_CONTEXT="$SCRIPT_DIR/get-context.sh"

CANONICAL_USER="$($RESOLVER "$CHANNEL" "$CHANNEL_USER_ID")"
if [ -z "$CANONICAL_USER" ]; then
  echo "identity_not_found" >&2
  exit 2
fi

if [ -n "$TOPIC" ]; then
  "$GET_CONTEXT" "$CANONICAL_USER" "$QUERY" "$CHANNEL" "$TOPIC"
else
  "$GET_CONTEXT" "$CANONICAL_USER" "$QUERY" "$CHANNEL"
fi
