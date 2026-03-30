# Quick Verification

## Goal

Let a new user prove the bridge works in under five minutes.

## Step 1

Set the required environment variables:

```bash
export OV_CONTEXT_ROOT="$HOME/.openviking/workspace/viking/default/resources"
export OV_IDENTITY_MAP="$PWD/examples/identity-map.demo.json"
```

## Step 2

Run the prerequisite check:

```bash
./scripts/check-prereqs.sh
```

## Step 3

Run the isolated demo:

```bash
mkdir -p "$OV_CONTEXT_ROOT"/{sessions,tasks,capsules,exchanges,memory/long-term}
./scripts/demo.sh feishu demo-feishu-user cross-channel-default
```

## Step 4

Confirm the output includes:
- `continuation_capsule`
- `recent_exchanges`
- `task_state`
- `session_summary`

## Interpretation

If all four appear, the bridge can complete a minimal write-then-read continuation loop against an OpenViking-style backend tree.
