# Use Cases

## Cross-channel continuation

A user starts a task in Feishu and later says `continue` in QQ.
The system resolves both channel identities to the same canonical user, reads the shared objects from OpenViking, and resumes the same workstream.

## Progress recall

A user asks `what is the current progress?`
The bridge reads `task_state` first and returns a compact progress-oriented view.

## Short-term recall

A user asks `where were we?`
The bridge prioritizes the continuation capsule and recent exchanges instead of replaying a full transcript.

## Design-context carryover

A user switches channels while discussing architecture.
The bridge preserves decisions and next steps through `session_summary`, `task_state`, and semantic exchanges.
