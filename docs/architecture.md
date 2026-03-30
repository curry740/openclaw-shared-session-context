# Architecture

## System Roles

### OpenClaw
`OpenClaw` is the orchestration host.
It receives channel messages, runs the before-answer and after-answer hooks, and generates the final reply.

### OpenViking
`OpenViking` is the shared-state backend.
It stores and serves the objects that allow one user to continue the same work across multiple channels.

### This Repository
This repository is the bridge layer.
It defines the object shapes, read/write order, and reference scripts that connect OpenClaw to OpenViking.

## Architecture View

- channel adapters feed messages into `OpenClaw`
- `OpenClaw` resolves identity and calls bridge scripts
- bridge scripts read and write shared objects in `OpenViking`
- the reply is generated with shared context injected back into `OpenClaw`

## Shared Objects Stored In OpenViking

- `session_summary`
- `task_state`
- `continuation_capsule`
- `recent_exchange`

These objects are not abstract documentation only.
They are the persistence contract between OpenClaw and OpenViking.

## Layered Breakdown

### Identity Layer
Map `channel + channel_user_id` into one `canonical_user`.

### Backend Layer
Persist and retrieve shared objects in `OpenViking`.

### Bridge Layer
Apply the protocol rules for reading, writing, filtering, and prioritizing objects.

### Hook Layer
Attach the bridge to OpenClaw at:
- `before-answer`
- `after-answer`

### Policy Layer
Control:
- read priority
- noise filtering
- writeback gating
- continuation response shaping

## Design Rules

- channels are entry points, not truth sources
- `OpenViking` is the current system of record for shared session objects
- prefer structured state over raw transcript replay
- shared context must be small enough to inject safely into the answer path
- write back only on meaningful state change
- keep protocol stable while allowing implementation upgrades

## Reference Flow

1. OpenClaw receives a message
2. Identity is resolved into one canonical user
3. The bridge reads from OpenViking in this order:
   - continuation capsule
   - filtered recent exchanges
   - task state
   - session summary
4. OpenClaw generates the reply with injected shared context
5. The bridge writes updated objects back into OpenViking if they changed

## Current Boundary

This project is currently a reusable bridge plus reference implementation.
It is not a replacement for OpenClaw and not a replacement for OpenViking.
It sits between them.
