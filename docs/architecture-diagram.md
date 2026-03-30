# Architecture Diagram

```text
┌──────────────────────────┐
│   Chat Channels          │
│  Feishu / QQ / others    │
└─────────────┬────────────┘
              │ inbound message
              ▼
┌──────────────────────────┐
│        OpenClaw          │
│ orchestration + replies  │
│                          │
│ before-answer hook       │
│ after-answer hook        │
└─────────────┬────────────┘
              │ calls bridge scripts
              ▼
┌──────────────────────────┐
│   This Repository        │
│ bridge + protocol layer  │
│                          │
│ resolve identity         │
│ read shared context      │
│ write summary/task       │
│ write exchange/capsule   │
└─────────────┬────────────┘
              │ read/write shared objects
              ▼
┌──────────────────────────┐
│       OpenViking         │
│ shared-state backend     │
│                          │
│ session_summary          │
│ task_state               │
│ continuation_capsule     │
│ recent_exchange          │
└──────────────────────────┘
```

## Reading Path

`continuation_capsule -> recent_exchanges -> task_state -> session_summary`

## Key Point

`OpenClaw` is the host.
`OpenViking` is the backend.
This repository is the bridge.
