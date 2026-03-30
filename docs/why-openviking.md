# Why OpenViking

## Short answer

Because this project needs a shared backend that sits outside any single chat channel and outside any single local session.
In the current implementation, that backend is `OpenViking`.

## What problem OpenViking solves

Cross-channel continuity breaks if each channel keeps its own isolated local context.
To continue the same work across channels, the system needs a place to store shared objects that can be read back later from another channel.

That is what OpenViking provides here.

## What OpenViking stores in this design

- `session_summary`
- `task_state`
- `continuation_capsule`
- `recent_exchange`

These are the actual continuity objects used by the bridge.
They are not just examples.

## Why OpenClaw alone is not enough

`OpenClaw` is the orchestration host.
It is where message handling and answer generation happen.
But the current bridge design needs a separate shared-state backend so multiple channels can converge on the same user context.

That is why the current implementation is explicitly `OpenClaw + OpenViking`, not `OpenClaw only`.

## Why this repository exists at all

Because even with OpenClaw and OpenViking present, you still need:
- a shared object protocol
- identity resolution rules
- read priority rules
- writeback gating rules
- bridge scripts that connect OpenClaw hooks to OpenViking resources

This repository provides that middle layer.

## Current implementation boundary

If you remove OpenViking from the current implementation, the repository becomes an incomplete sketch.
It may still document the protocol, but it no longer provides the working shared continuity path described in the docs.

## Practical takeaway

Treat OpenViking as a required system component for the current version.
Do not treat it as an optional enhancement.
