# Compatibility

## Current contract

This repository does not promise universal compatibility.
It defines a narrow reference contract that is intentionally explicit.

## Expected components

| Component | Current expectation |
| --- | --- |
| OpenClaw | can invoke bridge scripts before and after reply generation |
| OpenViking | provides an OpenViking-style resource tree |
| Shell | `bash` |
| Python | `python3` |
| Identity mapping | explicit `OV_IDENTITY_MAP` file |
| Scope | one canonical user, private chat continuation first |

## Environment variables

Required:
- `OV_CONTEXT_ROOT`
- `OV_IDENTITY_MAP`

Optional:
- `OV_RECENT_LIMIT`
- `OV_RECENT_MAX_CHARS`

## Operational compatibility guidance

Start with:
- one user
- two private channels
- one topic
- isolated demo validation

Do not treat the current reference scripts as validated by default for:
- group chat sharing
- unreviewed multi-tenant deployments
- full transcript synchronization
- backend substitution without adapter work

## Versioning guidance

The safest assumption is:
- patch releases preserve the current bridge contract
- minor releases may expand capabilities without pretending old deployment shortcuts are enough

See also:
- `docs/usage.md`
- `docs/quick-verification.md`
- `docs/release-strategy.md`
