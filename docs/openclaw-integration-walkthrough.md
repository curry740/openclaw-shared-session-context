# OpenClaw Integration Walkthrough

This walkthrough shows the minimum path to integrate the shared-session bridge into your own `clawbot`.

## 1. Prepare config

Create an identity map based on `examples/identity-map.json`.

Set:

```bash
export OV_CONTEXT_ROOT="$HOME/.openviking/workspace/viking/default/resources"
export OV_IDENTITY_MAP="/path/to/identity-map.json"
```

## 2. Before-answer hook

Before generating a reply, call:

```bash
scripts/before-answer.sh <channel> <channel_user_id> <query> [topic]
```

Expected result:
- resolve one `canonical_user`
- fetch compact shared context
- inject it into reply-generation context

## 3. After-answer hook

After generating a reply and producing structured summary/task artifacts, call:

```bash
scripts/after-answer.sh <channel> <channel_user_id> <topic> <task_id> <summary_file> <task_json_file>
```

Expected result:
- store `session_summary`
- store `task_state`

## 4. Smoke test

Use a real continuation phrase such as `continue` from another channel.

Then run:

```bash
scripts/smoke-test.sh <channel> <channel_user_id> "continue" <topic>
```

## 5. Operational rule

Do not start with group chats.
Do not start with full transcript sync.
Make private-chat continuation stable first.
