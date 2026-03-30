# OpenClaw Shared Session Context

Reusable shared-session continuity for `OpenClaw` bots.

This repository turns cross-channel conversation continuity into a reusable layer instead of a one-off personal workspace hack.

## Problem

When one user talks to the same bot from different channels, context usually fractures:
- each channel becomes its own isolated session
- short continuation prompts like `continue` or `where were we` become weak
- active task state drifts apart

## Solution

This project provides a minimal shared-session bridge that:
- maps channel identities into one `canonical_user`
- reads shared context before answer generation
- writes structured state back after answer generation
- prefers compact state objects over full transcript replay

## Core Objects

- `session_summary`
- `task_state`
- `continuation_capsule`
- `recent_exchange`

## Read Priority

`continuation_capsule -> recent_exchanges -> task_state -> session_summary`

## What This Repo Contains

- protocol-level object definitions
- OpenViking-backed reference shell scripts
- OpenClaw integration notes
- example identity map and config
- rollout and packaging docs

## Scope for v0.1.0

- private chat continuation first
- manual identity mapping first
- OpenViking backend first
- OpenClaw hook integration first

## Not Included

- full transcript sync
- group chat sharing by default
- automatic long-term memory extraction
- hosted backend service

## Quick Start

1. Clone this repository.
2. Copy `examples/identity-map.json` and fill your channel user ids.
3. Set:
   - `OV_CONTEXT_ROOT`
   - `OV_IDENTITY_MAP`
4. Call `scripts/before-answer.sh` before reply generation.
5. Call `scripts/after-answer.sh` after reply generation.
6. Optionally pass `exchange_id` and `exchange_json_file` into `scripts/after-answer.sh` to store semantic exchanges and regenerate continuation capsules.
7. Validate with `scripts/demo.sh` or a real two-channel continuation test.

## Verify It Actually Works

Run the isolated demo with:

```bash
export OV_CONTEXT_ROOT="$(mktemp -d)"
mkdir -p "$OV_CONTEXT_ROOT"/{sessions,tasks,capsules,exchanges,memory/long-term}
export OV_IDENTITY_MAP="$PWD/examples/identity-map.demo.json"
./scripts/demo.sh feishu demo-feishu-user cross-channel-default
```

If the final output shows `continuation_capsule`, `recent_exchanges`, `task_state`, and `session_summary`, the reference implementation is working.

## OpenClaw Skill Wrapper

This repository is the reusable core.

A thin OpenClaw skill wrapper is included under `skill/shared-session-context` and should stay thin:
- bootstrap config
- integration checklist
- hook wiring guidance
- operational validation

## Recommended Packaging Strategy

- publish this repo as the protocol + reference implementation
- publish the skill as the OpenClaw-facing wrapper
- version the skill against tagged releases of this repo

## License

MIT
