#!/usr/bin/env bash
set -euo pipefail

fail=0

check_cmd() {
  local cmd="$1"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "missing command: $cmd"
    fail=1
  fi
}

check_cmd bash
check_cmd python3

if [ -z "${OV_CONTEXT_ROOT:-}" ]; then
  echo "missing env: OV_CONTEXT_ROOT"
  fail=1
elif [ ! -d "${OV_CONTEXT_ROOT}" ]; then
  echo "invalid OV_CONTEXT_ROOT: ${OV_CONTEXT_ROOT}"
  fail=1
fi

if [ -z "${OV_IDENTITY_MAP:-}" ]; then
  echo "missing env: OV_IDENTITY_MAP"
  fail=1
elif [ ! -f "${OV_IDENTITY_MAP}" ]; then
  echo "missing OV_IDENTITY_MAP file: ${OV_IDENTITY_MAP}"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "prereqs ok"
else
  exit 1
fi
