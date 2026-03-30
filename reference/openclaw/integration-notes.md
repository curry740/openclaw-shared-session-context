# OpenClaw Integration Notes

Use this repository as a bridge layer.

Recommended integration points:
- before generating a reply, call `scripts/before-answer.sh`
- after generating a reply, call `scripts/after-answer.sh`

Do not hardcode user ids, workspace paths, or private document links into the reusable package.
