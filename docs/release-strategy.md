# Release Strategy

## Current release line

- `v0.1.0`: first public release
- `v0.1.1`: hardened the reference implementation for real reuse

## What a patch release should include

Use patch releases for:
- documentation corrections
- usability improvements
- safer validation and verification
- script fixes that do not change the overall architecture contract

## What a minor release should include

Use minor releases for:
- new bridge capabilities
- backend abstraction improvements
- stronger integration flows
- materially new examples or deployment paths

## Recommended next version boundary

The next version should only move past `0.1.x` when one of these is true:
- a second backend abstraction exists
- semantic extraction becomes materially more robust
- the OpenClaw integration path becomes meaningfully more automated
