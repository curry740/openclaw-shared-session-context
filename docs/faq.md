# FAQ

## Is OpenViking optional?

No, not in the current implementation.
The current bridge depends on OpenViking as the shared-state backend.

## Is this just an OpenClaw skill?

No.
The skill wrapper is only a thin integration layer.
The real system is `OpenClaw + OpenViking + this bridge repository`.

## Does this replace OpenClaw memory?

No.
It adds a shared-session continuity layer for cross-channel work.

## Does this support group chats?

Not as a first-class target yet.
The current recommended scope is private-chat continuation first.

## Does this sync full transcripts?

No.
The design prefers compact structured objects over full transcript sync.

## Can I use another backend instead of OpenViking?

In theory yes, but not with the current reference implementation.
Right now the scripts assume an OpenViking-style resource tree.

## Is the semantic extraction model-based?

Not yet.
The current implementation uses heuristics and writeback gating.
