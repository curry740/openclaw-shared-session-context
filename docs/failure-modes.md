# Failure Modes

## Why this document exists

Cross-channel continuity can fail in ways that look superficially successful.
A few files may exist, yet the actual continuation experience may still be wrong.

## Common failure modes

### 1. Identity merge error

Different real users resolve to the same canonical identity.
This is the highest-risk failure because it can leak context across people.

### 2. Identity miss

A valid channel user does not resolve to any canonical identity.
The bridge then cannot read or write the intended shared state.

### 3. Partial writeback

`session_summary` and `task_state` are written, but `recent_exchange` or `continuation_capsule` is missing or stale.
The system looks populated but short continuation prompts still perform poorly.

### 4. Weak exchange extraction

The stored exchange exists, but it does not capture the real user intent, conclusion, or next step.
That makes `continue` and `where were we` much weaker than expected.

### 5. Backend tree drift

The expected OpenViking-style resource layout is missing, renamed, or only partially initialized.
Scripts may pass some checks while still failing to read the real object chain.

### 6. Scope explosion too early

Trying to start with group chats, many users, or too many channels at once makes failures harder to isolate.
The recommended starting scope is intentionally narrow.

## Verification rule

Do not treat the bridge as validated just because files exist on disk.
Validate with a real cross-channel continuation prompt such as:
- `continue`
- `where were we`
- `what is the current progress`

## First checks when something feels wrong

1. verify `OV_CONTEXT_ROOT`
2. verify `OV_IDENTITY_MAP`
3. run `scripts/check-prereqs.sh`
4. run `scripts/demo.sh`
5. inspect whether `continuation_capsule`, `recent_exchanges`, `task_state`, and `session_summary` all exist and are fresh

## See also

- `docs/quick-verification.md`
- `docs/production-hardening.md`
- `docs/why-openviking.md`
