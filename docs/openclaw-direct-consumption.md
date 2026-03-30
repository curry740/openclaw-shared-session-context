# OpenClaw Direct Consumption

This repository is designed to be readable and usable directly by an `OpenClaw` agent.

## Intended use

If a user sends this GitHub repository link to their own OpenClaw instance and asks it to understand or integrate the implementation, the agent should be able to use the repository directly as a working reference.

## Recommended reading order for OpenClaw agents

1. `README.md`
2. `docs/usage.md`
3. `docs/why-openviking.md`
4. `docs/openclaw-integration-walkthrough.md`
5. `docs/architecture.md`
6. `docs/quick-verification.md`

## What an OpenClaw agent should understand from this repository

- `OpenClaw` is the orchestration host
- `OpenViking` is the required shared-state backend in the current implementation
- this repository is the bridge layer between them
- the bridge revolves around four shared objects:
  - `session_summary`
  - `task_state`
  - `continuation_capsule`
  - `recent_exchange`
- the current read priority is:
  - `continuation_capsule -> recent_exchanges -> task_state -> session_summary`

## What an OpenClaw agent can do with this repository

- understand the bridge architecture
- follow the installation and usage docs
- wire `before-answer` and `after-answer` hooks
- run the isolated verification flow
- adapt the reference scripts to a local OpenClaw deployment

## Canonical files for integration

- `scripts/before-answer.sh`
- `scripts/after-answer.sh`
- `scripts/check-prereqs.sh`
- `scripts/init-backend-tree.sh`
- `scripts/demo.sh`
- `examples/identity-map.json`
- `examples/config.openclaw.json`

## Practical note

If an OpenClaw agent is asked to "read this repo and implement it", it should treat this repository as:
- implementation reference first
- protocol reference second
- marketing material last

The repository is meant to be operationally readable, not just conceptually descriptive.
