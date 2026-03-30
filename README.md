# OpenClaw Shared Session Context

[English](README.md) | [简体中文](README.zh-CN.md)

A bridge layer between `OpenClaw` and `OpenViking` for cross-channel shared session continuity.

This repository is not just an OpenClaw skill and not just a set of hook scripts.
Its purpose is to connect:
- `OpenClaw` as the orchestration and reply host
- `OpenViking` as the shared state storage and retrieval backend
- a reusable bridge layer that makes cross-channel continuity actually work

## Architecture in One Sentence

`OpenClaw` decides when to read and write. `OpenViking` stores and serves the shared objects. This repository defines the protocol and the bridge between them.

## Why This Exists

When one user talks to the same bot from different channels, context usually fractures:
- each channel becomes its own isolated session
- short continuation prompts like `continue` or `where were we` become weak
- active task state drifts apart

The bridge in this repository solves that by making multiple channels read from and write to the same shared state backend.

## OpenViking Is Required

In the current implementation, `OpenViking` is not optional.
It is the backend that stores and retrieves the shared objects used for continuation:
- `session_summary`
- `task_state`
- `continuation_capsule`
- `recent_exchange`

Without a working `OpenViking` backend, the current bridge does not work as designed.

## What OpenClaw Does

`OpenClaw` is responsible for:
- receiving messages from chat channels
- deciding when to call the bridge before answer generation
- deciding when to call the bridge after answer generation
- generating the actual reply with injected context

## What OpenViking Does

`OpenViking` is responsible for:
- storing shared objects under one canonical user identity
- serving those objects back across channel boundaries
- acting as the shared continuity backend instead of per-channel local session memory

## What This Repository Does

This repository provides:
- protocol-level object definitions
- OpenViking-backed reference shell scripts
- OpenClaw integration notes
- example identity maps, config, summary, and exchange payloads
- demo, verification, rollout, and hardening docs
- a thin OpenClaw skill wrapper under `skill/shared-session-context`

## Core Objects

- `session_summary`
- `task_state`
- `continuation_capsule`
- `recent_exchange`

## Read Priority

`continuation_capsule -> recent_exchanges -> task_state -> session_summary`

## Current Scope

- private chat continuation first
- manual identity mapping first
- OpenViking backend first
- OpenClaw hook integration first

## Not Included

- full transcript sync
- group chat sharing by default
- automatic long-term memory extraction
- a hosted backend service

## Quick Start

1. Make sure `OpenViking` is installed and working first.
2. Clone this repository.
3. Copy `examples/identity-map.json` and fill your channel user ids.
4. Set:
   - `OV_CONTEXT_ROOT`
   - `OV_IDENTITY_MAP`
5. Run `scripts/check-prereqs.sh`.
6. If needed, initialize the backend tree with `scripts/init-backend-tree.sh`.
7. Call `scripts/before-answer.sh` before reply generation.
8. Call `scripts/after-answer.sh` after reply generation.
9. Optionally pass `exchange_id` and `exchange_json_file` into `scripts/after-answer.sh` to store semantic exchanges and regenerate continuation capsules.
10. Validate with `scripts/demo.sh` or a real two-channel continuation test.

You can also send this GitHub repository directly to your own `OpenClaw` instance and ask it to read and use the implementation. This repository is structured to be directly consumable by OpenClaw agents. See `docs/openclaw-direct-consumption.md`.

## Verify It Actually Works

Run the isolated demo with:

```bash
export OV_CONTEXT_ROOT="$(mktemp -d)"
mkdir -p "$OV_CONTEXT_ROOT"/{sessions,tasks,capsules,exchanges,memory/long-term}
export OV_IDENTITY_MAP="$PWD/examples/identity-map.demo.json"
./scripts/check-prereqs.sh
./scripts/demo.sh feishu demo-feishu-user cross-channel-default
```

If the final output shows `continuation_capsule`, `recent_exchanges`, `task_state`, and `session_summary`, the bridge is working against a valid OpenViking-style resource tree.

## OpenClaw Skill Wrapper

A thin OpenClaw skill wrapper is included under `skill/shared-session-context`.
It should stay thin and should not duplicate backend logic.
The backend contract belongs to `OpenViking`, and the bridge contract belongs to this repository.

## Recommended Packaging Strategy

- publish this repo as the bridge and reference implementation
- keep OpenViking explicit in all setup and architecture docs
- keep the skill as the OpenClaw-facing wrapper
- version the skill against tagged releases of this repo

## Additional Docs

- `docs/usage.md`
- `docs/openclaw-direct-consumption.md`
- `docs/agent-checklist.md`
- `docs/architecture-diagram.md`
- `docs/quick-verification.md`
- `docs/faq.md`
- `docs/use-cases.md`
- `docs/why-openviking.md`
- `docs/repository-maturity.md`
- `docs/release-strategy.md`

## License

MIT
