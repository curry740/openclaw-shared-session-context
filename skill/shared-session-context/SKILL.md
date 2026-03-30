---
name: shared-session-context
description: Add reusable shared-session continuity to OpenClaw bots across channels such as Feishu, QQ, Telegram, or Discord. Use when installing, packaging, integrating, or validating a cross-channel shared-session bridge backed by structured objects like session summary, task state, continuation capsule, and recent exchanges.
---

# Shared Session Context

Wrap the standalone `openclaw-shared-session-context` repository into an OpenClaw-friendly integration.

## Workflow

1. Run `scripts/bootstrap-config.sh` to create a local identity map template.
2. Run `scripts/check-env.sh` to validate minimum environment.
3. Read `references/integration-checklist.md`.
4. Wire the standalone repo scripts into your before-answer and after-answer flow.
5. Validate with one real cross-channel continuation test.

## Resources

- `scripts/bootstrap-config.sh`
- `scripts/check-env.sh`
- `references/integration-checklist.md`
- `references/publish-plan.md`
- `references/repository-layout.md`

## Rules

- Keep this skill thin.
- Do not duplicate protocol, schema, or backend logic here.
- Keep the standalone repository as the single source of truth.
