#!/usr/bin/env bash
set -euo pipefail

TARGET_DIR="${1:-$PWD/.shared-session-context}"
mkdir -p "$TARGET_DIR"

cat > "$TARGET_DIR/identity-map.json" <<'JSON'
{
  "version": 1,
  "users": {
    "example-user": {
      "displayName": "Example User",
      "channels": {
        "feishu": { "userId": "ou_fill_me" },
        "qqbot": { "userId": "qq_fill_me" }
      }
    }
  }
}
JSON

cat > "$TARGET_DIR/env.sh" <<SH
export OV_CONTEXT_ROOT="\$HOME/.openviking/workspace/viking/default/resources"
export OV_IDENTITY_MAP="$TARGET_DIR/identity-map.json"
SH

echo "Bootstrap files created in: $TARGET_DIR"
echo "1. Fill identity-map.json"
echo "2. source $TARGET_DIR/env.sh"
echo "3. Run scripts/check-env.sh"
