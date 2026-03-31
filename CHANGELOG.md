# Changelog

## 0.1.2

- remove overlapping install, configuration, demo, and release-draft docs to reduce navigation noise
- tighten the README quick-start path and make verification more front-loaded
- add a baseline GitHub Actions CI workflow for bash syntax and isolated demo smoke testing
- add a SECURITY policy focused on identity mapping, shared-state isolation, and deployment posture
- add README positioning that explains when to use this bridge instead of simpler memory patterns
- add compatibility and failure-mode docs to make deployment boundaries explicit
- add a real cross-channel terminal transcript artifact showing `feishu -> write` and `qqbot -> read`

## 0.1.1

- upgrade the reference scripts from minimal placeholders into a usable read/write chain
- add semantic exchange writeback and continuation capsule regeneration
- add demo and production-hardening docs
- add example summary and exchange payloads
- improve after-answer writeback gating and recent-exchange selection

## 0.1.0

- define the first reusable shared-session protocol for OpenClaw bots
- provide OpenViking-backed reference scripts for identity resolution, context read, and structured writeback
- provide schema and examples for `session_summary`, `task_state`, and `continuation_capsule`
- provide first-pass docs for architecture, install, configuration, and rollout
- provide a thin OpenClaw skill wrapper in `../shared-session-context-skill`
