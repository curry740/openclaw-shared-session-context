# Demo

## Goal

Show a real end-to-end continuation loop with the reusable bridge.

## What the demo does

1. writes a sample `session_summary`
2. writes a sample `task_state`
3. writes a sample semantic `recent_exchange`
4. generates a `continuation_capsule`
5. reads the shared context back with a `continue` query

## Run

```bash
export OV_CONTEXT_ROOT="$HOME/.openviking/workspace/viking/default/resources"
export OV_IDENTITY_MAP="/path/to/identity-map.json"

scripts/demo.sh feishu YOUR_FEISHU_USER_ID cross-channel-default
```

## Expected result

The final output should show:
- identity block
- continuation capsule
- recent exchanges
- task state
- session summary

## Why this matters

This proves the repository can do more than explain the protocol.
It proves the reference implementation can write and read a real continuation chain against an OpenViking-style backend tree.
