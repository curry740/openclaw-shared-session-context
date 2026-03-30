# Install

## Prerequisites

Before using this repository, you need a working `OpenViking` backend.
That is the first dependency, not an optional add-on.

Required:
- `OpenClaw` already running or available for integration
- `OpenViking` already running or available as the shared-state backend
- shell environment with `bash` and `python3`

## What You Are Installing

You are installing a bridge layer.
You are not replacing OpenClaw and you are not replacing OpenViking.

- `OpenClaw` stays the orchestration and reply host
- `OpenViking` stays the persistence and retrieval backend
- this repository wires the two together

## Step 1: Prepare OpenViking

Confirm that your OpenViking resource root exists.
A common default is:

```bash
$HOME/.openviking/workspace/viking/default/resources
```

That path will be used as `OV_CONTEXT_ROOT`.

## Step 2: Clone This Repository

Clone the repository and enter it.

## Step 3: Configure Identity Mapping

Copy `examples/identity-map.json` to your local config path and map your channel user ids to a canonical user.

## Step 4: Set Required Environment Variables

```bash
export OV_CONTEXT_ROOT="$HOME/.openviking/workspace/viking/default/resources"
export OV_IDENTITY_MAP="/path/to/identity-map.json"
```

## Step 5: Validate Identity Resolution

```bash
scripts/resolve-identity.sh feishu YOUR_FEISHU_USER_ID
```

If this fails, your bridge cannot work, because the canonical user mapping is the entry point into OpenViking-backed shared state.

## Step 6: Validate Context Read

```bash
scripts/before-answer.sh feishu YOUR_FEISHU_USER_ID "continue" your-topic
```

## Step 7: Run the Isolated Demo

Use the demo to validate the full read/write chain without needing your live production data first.

If your resource tree is not prepared yet, initialize it with:

```bash
scripts/init-backend-tree.sh "$OV_CONTEXT_ROOT"
```

## Integration Rule

Do not patch your runtime core first.
First validate that:
- OpenViking is reachable
- identity mapping works
- the bridge can read and write shared objects
- the end-to-end continuation loop behaves correctly
