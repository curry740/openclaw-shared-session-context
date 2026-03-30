# OpenClaw Integration Walkthrough

This walkthrough shows how to connect `OpenClaw` to `OpenViking` through the bridge in this repository.

## Integration Model

Use this mental model first:

- `OpenClaw` owns message handling and reply generation
- `OpenViking` owns shared-session storage and retrieval
- this bridge owns protocol, object flow, and reference scripts

If you skip that model, the installation will look simpler than it really is and users will misconfigure the system.

## 1. Prepare OpenViking and Identity Mapping

Create an identity map based on `examples/identity-map.json`.

Set:

```bash
export OV_CONTEXT_ROOT="$HOME/.openviking/workspace/viking/default/resources"
export OV_IDENTITY_MAP="/path/to/identity-map.json"
```

## 2. Before-Answer Hook in OpenClaw

Before OpenClaw generates a reply, call:

```bash
scripts/before-answer.sh <channel> <channel_user_id> <query> [topic]
```

Expected result:
- resolve one `canonical_user`
- read compact shared state from OpenViking
- inject that state into the reply-generation context

## 3. After-Answer Hook in OpenClaw

After OpenClaw generates a reply and produces structured summary/task artifacts, call:

```bash
scripts/after-answer.sh <channel> <channel_user_id> <topic> <task_id> <summary_file> <task_json_file> [exchange_id] [exchange_json_file]
```

Expected result:
- store `session_summary` in OpenViking
- store `task_state` in OpenViking
- optionally store semantic `recent_exchange`
- optionally regenerate `continuation_capsule`

## 4. Why OpenViking Matters Here

The bridge only works because both channels read from and write to the same shared backend.
That shared backend is OpenViking.

Without that backend, you only have per-channel local memory and the continuation chain collapses.

## 5. Smoke Test

Use a real continuation phrase such as `continue` from another channel.

Then run:

```bash
scripts/smoke-test.sh <channel> <channel_user_id> "continue" <topic>
```

## 6. Operational Rule

Do not start with group chats.
Do not start with full transcript sync.
Make private-chat continuation stable first.

## 7. Practical Deployment Advice

Validate these in order:
- OpenViking root is correct
- identity map is correct
- before-answer read works
- after-answer write works
- continuation works across two private-chat channels
