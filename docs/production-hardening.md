# Production Hardening

## Current level

This repository is now a usable reference implementation, not just a protocol sketch.

## What is production-friendly already

- identity resolution via explicit mapping
- OpenViking-backed shared object layout and retrieval order
- read prioritization across capsule, exchanges, task, and summary
- structured writeback with unchanged/empty gating
- thin OpenClaw skill wrapper included

## What you should still harden in your own deployment

- channel-specific query classification
- better semantic extraction for exchanges and capsules
- stronger validation for malformed input objects
- retention and pruning rules for large exchange histories
- channel-specific integration hooks

## Recommended deployment posture

- start with one user and two private-chat channels
- validate continuation and recall prompts first
- only expand to more channels after the read/write path is stable
- keep full transcript sync out of scope unless you really need it
