# GitHub Release Draft

## Title

`v0.1.2` — tighten the bridge repo and add proof-oriented artifacts

## Summary

This release makes the repository easier to trust, easier to navigate, and easier to validate.
It does not change the core bridge architecture.
It makes the existing reference implementation more credible for real reuse.

## Included

- removed overlapping install/config/demo/release-draft docs
- tightened README quick start and verification path
- added baseline GitHub Actions CI for bash syntax and isolated demo smoke testing
- added `SECURITY.md`
- added README comparison framing for why this bridge exists versus simpler approaches
- added `docs/compatibility.md`
- added `docs/failure-modes.md`
- added `docs/demo-transcript.md` as a real cross-channel terminal proof artifact

## Why this release matters

The repository now has a stronger evidence chain:
- clearer entry path
- clearer limits
- clearer operational risks
- a reproducible proof that one mapped channel can write and another can read the same shared context chain

## Current limits

- OpenViking backend only
- private-chat continuation first
- manual identity mapping first
- shell reference implementation first
- semantic extraction is still heuristic

## Next

- publish a GIF or short recording for faster social proof
- continue hardening live writeback quality
- consider packaging or install automation only after more real-world validation
