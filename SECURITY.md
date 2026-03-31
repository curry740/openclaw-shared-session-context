# Security Policy

## Current security posture

This repository is a reference bridge for cross-channel context continuity.
It handles user identity mapping, shared state lookup, and structured writeback.
That means incorrect deployment can leak context across users or channels.

This repository is not a hosted service and does not claim turnkey production security.
You must review and harden your own deployment.

## Supported scope

The current implementation is designed for:
- private chat continuation first
- explicit identity mapping first
- OpenViking-backed storage first
- controlled OpenClaw hook integration first

It is not designed for:
- unsafe multi-tenant deployments by default
- blind group-chat sharing
- unreviewed public backend exposure

## Key risks to understand

- wrong identity mapping can merge different users into one canonical identity
- broad filesystem permissions can expose shared context files
- untrusted writeback inputs can poison summaries, tasks, or exchanges
- missing retention rules can accumulate sensitive recent exchanges longer than intended

## Minimum deployment rules

- keep `OV_IDENTITY_MAP` under operator control
- restrict access to `OV_CONTEXT_ROOT`
- validate channel identity mapping before enabling writeback
- start with one user, two private channels, one topic
- verify with the isolated demo before wiring into production flows
- avoid group-chat sharing unless you add explicit policy and identity controls

## Reporting

If you find a security issue in this repository, open a private report with the maintainer before publishing details.

When reporting, include:
- affected script or document
- reproduction steps
- impact on identity isolation, context leakage, or writeback integrity
- suggested mitigation if you have one
