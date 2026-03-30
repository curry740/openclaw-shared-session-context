# Contributing

## Scope

Contribute to the bridge layer, not to channel-specific product code or private local setup.

Good contributions include:
- better bridge scripts
- clearer OpenClaw/OpenViking integration docs
- stronger validation and hardening
- more realistic examples and demos
- backend abstraction work that preserves the current protocol contract

## Contribution Rules

- keep `OpenViking` explicit in architecture and installation docs
- do not hide required backend assumptions behind vague wording
- keep the skill wrapper thin
- avoid mixing private workspace specifics into reusable files
- prefer end-to-end verifiability over purely theoretical refactors

## Before Opening a PR

1. run the prerequisite check
2. run the isolated demo
3. confirm docs still match the actual scripts
4. keep examples free of private identifiers

## Change Philosophy

This repository should stay honest.
If something is still heuristic or limited, document that clearly instead of making the project look more complete than it is.
