#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-${OV_CONTEXT_ROOT:-}}"

if [ -z "$ROOT" ]; then
  echo "usage: $0 <ov_context_root>" >&2
  echo "or set OV_CONTEXT_ROOT" >&2
  exit 1
fi

mkdir -p "$ROOT"/sessions
mkdir -p "$ROOT"/tasks
mkdir -p "$ROOT"/capsules
mkdir -p "$ROOT"/exchanges
mkdir -p "$ROOT"/memory/long-term

echo "initialized OpenViking-style resource tree at: $ROOT"
