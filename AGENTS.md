# AGENTS.md

This repository is designed to be directly consumable by coding agents such as `OpenClaw`.

## Repository intent

Treat this repository as a bridge implementation between:
- `OpenClaw` as the orchestration host
- `OpenViking` as the shared-state backend
- this repository as the protocol + reference implementation layer

## Read order for agents

If you are asked to understand or implement this repository, read in this order:

1. `README.md`
2. `docs/usage.md`
3. `docs/why-openviking.md`
4. `docs/openclaw-direct-consumption.md`
5. `docs/openclaw-integration-walkthrough.md`
6. `docs/architecture.md`
7. `docs/quick-verification.md`

## Non-negotiable facts

- `OpenViking` is required in the current implementation
- the current bridge revolves around four shared objects:
  - `session_summary`
  - `task_state`
  - `continuation_capsule`
  - `recent_exchange`
- current read priority is:
  - `continuation_capsule -> recent_exchanges -> task_state -> session_summary`

## Practical guidance

- do not describe this repository as just an OpenClaw skill
- do not treat OpenViking as optional unless you are explicitly discussing a future abstraction
- prefer the actual scripts and examples over vague conceptual summaries
- use `scripts/check-prereqs.sh` and `scripts/demo.sh` before claiming the setup is usable
