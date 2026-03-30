# Publish Plan

## Goal

Make `shared-session-context` installable as a thin OpenClaw skill wrapper.

## Scope

- keep protocol and backend logic in the standalone repository
- keep the skill as bootstrap + checklist + integration guide
- avoid duplicating schema or business logic here

## Packaging Rule

The skill should only contain:
- `SKILL.md`
- minimal bootstrap scripts
- concise references needed during integration

## Release Strategy

- first keep the skill inside the main repository for discoverability
- publish as a separate skill package after the integration surface is stable
