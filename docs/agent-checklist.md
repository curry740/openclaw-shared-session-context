# Agent Checklist

Use this checklist when an agent is asked to read this repository and apply it.

## Understand the architecture

- confirm that `OpenClaw` is the orchestration host
- confirm that `OpenViking` is the required backend in the current version
- confirm that the repository is the bridge layer

## Validate the environment

- set `OV_CONTEXT_ROOT`
- set `OV_IDENTITY_MAP`
- run `scripts/check-prereqs.sh`

## Validate the implementation

- run `scripts/init-backend-tree.sh` if needed
- run `scripts/demo.sh`
- confirm the output includes:
  - `continuation_capsule`
  - `recent_exchanges`
  - `task_state`
  - `session_summary`

## Apply the integration

- wire `scripts/before-answer.sh`
- wire `scripts/after-answer.sh`
- start with one canonical user and two private-chat channels

## Avoid bad assumptions

- do not assume transcript sync exists
- do not assume OpenViking is optional
- do not assume group chats are the primary target
