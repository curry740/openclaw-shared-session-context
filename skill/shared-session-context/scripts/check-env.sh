#!/usr/bin/env bash
set -euo pipefail

missing=0

if [ -z "${OV_CONTEXT_ROOT:-}" ]; then
  echo "missing: OV_CONTEXT_ROOT"
  missing=1
fi

if [ -z "${OV_IDENTITY_MAP:-}" ]; then
  echo "missing: OV_IDENTITY_MAP"
  missing=1
elif [ ! -f "${OV_IDENTITY_MAP}" ]; then
  echo "missing file: ${OV_IDENTITY_MAP}"
  missing=1
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "missing: python3"
  missing=1
fi

if [ "$missing" -eq 0 ]; then
  echo "environment ok"
fi
