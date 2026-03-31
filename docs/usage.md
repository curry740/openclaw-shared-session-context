# Usage

## Goal

This guide shows the shortest practical path from zero setup to a working shared-session bridge.

## What you need first

- a working `OpenViking` backend
- an `OpenClaw` environment where you can wire before-answer and after-answer hooks
- `bash` and `python3`

## Step 1: Clone the repository

```bash
git clone git@github.com:curry740/openclaw-shared-session-context.git
cd openclaw-shared-session-context
```

## Step 2: Prepare the backend root

Set the OpenViking resource root:

```bash
export OV_CONTEXT_ROOT="$HOME/.openviking/workspace/viking/default/resources"
```

If the resource tree is empty, initialize it:

```bash
./scripts/init-backend-tree.sh "$OV_CONTEXT_ROOT"
```

## Step 3: Prepare identity mapping

Copy and edit the example identity map:

```bash
cp examples/identity-map.json /tmp/identity-map.json
```

Then set:

```bash
export OV_IDENTITY_MAP="/tmp/identity-map.json"
```

The identity map is what lets multiple channels resolve to one `canonical_user`.

## Step 4: Validate prerequisites

```bash
./scripts/check-prereqs.sh
```

## Step 5: Validate the bridge in isolation

Run the demo:

```bash
./scripts/demo.sh feishu demo-feishu-user cross-channel-default
```

What should happen:
- a sample `session_summary` is written
- a sample `task_state` is written
- a sample semantic `recent_exchange` is written
- a `continuation_capsule` is generated
- the context is read back with a `continue` query

## Step 6: Read shared context before reply generation

In your OpenClaw flow, call:

```bash
./scripts/before-answer.sh <channel> <channel_user_id> <query> [topic]
```

Example:

```bash
./scripts/before-answer.sh feishu ou_xxx "continue" cross-channel-default
```

## Step 7: Write shared state after reply generation

After you generate a reply and produce structured artifacts, call:

```bash
./scripts/after-answer.sh <channel> <channel_user_id> <topic> <task_id> <summary_file> <task_json_file> [exchange_id] [exchange_json_file]
```

Example:

```bash
./scripts/after-answer.sh feishu ou_xxx cross-channel-default cross-channel-default /tmp/summary.md /tmp/task.json
```

If you also want semantic exchange writeback and continuation capsule regeneration:

```bash
./scripts/after-answer.sh feishu ou_xxx cross-channel-default cross-channel-default /tmp/summary.md /tmp/task.json 2026-03-30T00-00-00-000Z /tmp/exchange.json
```

## Step 8: Verify cross-channel continuation

From another mapped channel identity, use a short continuation prompt such as:
- `continue`
- `where were we`
- `what is the current progress`

Then confirm the bridge reads the expected object chain from OpenViking.

## Operational advice

Start narrow:
- one canonical user
- two private-chat channels
- one topic
- isolated validation first

Do not start with:
- group chats
- full transcript sync
- multi-user shared state

## Related docs

- `docs/quick-verification.md`
- `docs/openclaw-integration-walkthrough.md`
- `docs/architecture.md`
- `docs/why-openviking.md`
- `docs/production-hardening.md`
