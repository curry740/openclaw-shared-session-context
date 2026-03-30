# GitHub Release Draft

## Title

`v0.1.1` — Harden the reference implementation for real reuse

## Summary

This release upgrades the repository from a protocol sketch plus minimal scripts into a more usable reference implementation that other OpenClaw users can actually run, validate, and adapt.

## Included

- protocol-level shared objects
- OpenViking-backed reference scripts
- semantic exchange writeback
- continuation capsule regeneration
- clearer OpenClaw/OpenViking bridge documentation
- OpenClaw integration notes and bundled thin skill wrapper
- example identity maps and object payloads
- installation, demo, hardening, and rollout docs

## What improved

- `after-answer.sh` now supports optional exchange writeback inputs
- `store-exchange.sh` and `store-continuation-capsule.sh` were added
- readback and recent-exchange selection are more realistic
- isolated demo flow was added to prove the end-to-end chain
- docs now explain how to verify the implementation instead of only describing it

## Current limits

- OpenViking backend only
- private chat continuation first
- manual identity mapping first
- shell reference implementation first
- semantic extraction is still heuristic, not model-native summarization

## Next

- improve channel-specific query classification
- make semantic extraction more robust
- add pruning and retention guidance for large exchange histories
- consider a packaged installer path after more real-world validation
etention guidance for large exchange histories
- consider a packaged installer path after more real-world validation
