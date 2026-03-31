# Demo Transcript

This is a real terminal transcript from the reference implementation.
It shows one channel writing shared state and another mapped channel reading it back.

## Scenario

- source channel writes context as `feishu / demo-feishu-user`
- second channel reads continuation as `qqbot / demo-qq-user`
- both identities map to the same canonical user: `demo-user`

## Transcript

```bash
$ export OV_CONTEXT_ROOT="<temp-demo-root>"
$ export OV_IDENTITY_MAP="$PWD/examples/identity-map.demo.json"
$ ./scripts/check-prereqs.sh
prereqs ok

$ ./scripts/demo.sh feishu demo-feishu-user cross-channel-default
/tmp/tmp.z0aPa4VRuK/sessions/demo-user/cross-channel-default/2026-03-31-feishu.md
/tmp/tmp.z0aPa4VRuK/tasks/demo-user/cross-channel-default.json
/tmp/tmp.z0aPa4VRuK/exchanges/demo-user/cross-channel-default/2026-03-30T00-00-00-000Z.json
/tmp/tmp.z0aPa4VRuK/capsules/demo-user/cross-channel-default/continuation-capsule.json

-----
=== identity ===
canonical_user: demo-user
channel: feishu
topic: cross-channel-default
query_type: continuation

=== continuation_capsule ===
file: /tmp/tmp.z0aPa4VRuK/capsules/demo-user/cross-channel-default/continuation-capsule.json
{
  "topic": "cross-channel-default",
  "channel": "feishu",
  "last_user_intent": "default",
  "last_effective_question": "continue",
  "last_assistant_conclusion": "Conclusion: the main path is already usable. Current state: shared context read/write is working and the wording layer is being refined. Next step: keep improving continuation objects and reduce remaining noise.",
  "current_focus": "",
  "next_best_response": "",
  "answer_mode": "default",
  "source_exchange_id": "2026-03-30T00-00-00-000Z",
  "updated_at": "2026-03-30T00:00:00.000Z"
}

=== recent_exchanges ===
file: /tmp/tmp.z0aPa4VRuK/exchanges/demo-user/cross-channel-default/2026-03-30T00-00-00-000Z.json
timestamp: 2026-03-30T00:00:00.000Z
channel: feishu
[user]
continue
[assistant]
Conclusion: the main path is already usable.

Current state: shared context read/write is working and the wording layer is being refined.

Next step: keep improving continuation objects and reduce remaining noise.

=== task_state ===
file: /tmp/tmp.z0aPa4VRuK/tasks/demo-user/cross-channel-default.json
{
  "task_id": "cross-channel-default",
  "title": "Cross-channel shared session continuity",
  "status": "in_progress",
  "current_goal": "Keep multiple private-chat channels on the same working context",
  "latest_progress": [
    "Completed the minimal shared-context read path",
    "Completed structured writeback"
  ],
  "blockers": [
    "Legacy summary style is still inconsistent"
  ],
  "next_step": "Clean live summaries and capsules",
  "updated_at": "2026-03-30T00:00:00+08:00"
}

=== session_summary ===
file: /tmp/tmp.z0aPa4VRuK/sessions/demo-user/cross-channel-default/2026-03-31-feishu.md
# Session Summary

topic: cross-channel-default
goal: Keep Feishu and QQ private chats on the same working context
progress: Shared context read and structured writeback are working
decisions:
- Use structured objects instead of full transcript sync
- Prefer capsule and recent exchanges for short continuation prompts
blockers:
- Legacy summaries may still be verbose
next_step: Keep refining live summaries and continuation capsules
source_channel: feishu
timestamp: 2026-03-30T00:00:00.000Z

$ ./scripts/before-answer.sh qqbot demo-qq-user "where were we" cross-channel-default
=== identity ===
canonical_user: demo-user
channel: qqbot
topic: cross-channel-default
query_type: recall-summary

=== continuation_capsule ===
file: /tmp/tmp.z0aPa4VRuK/capsules/demo-user/cross-channel-default/continuation-capsule.json
{
  "topic": "cross-channel-default",
  "channel": "feishu",
  "last_user_intent": "default",
  "last_effective_question": "continue",
  "last_assistant_conclusion": "Conclusion: the main path is already usable. Current state: shared context read/write is working and the wording layer is being refined. Next step: keep improving continuation objects and reduce remaining noise.",
  "current_focus": "",
  "next_best_response": "",
  "answer_mode": "default",
  "source_exchange_id": "2026-03-30T00-00-00-000Z",
  "updated_at": "2026-03-30T00:00:00.000Z"
}

=== recent_exchanges ===
file: /tmp/tmp.z0aPa4VRuK/exchanges/demo-user/cross-channel-default/2026-03-30T00-00-00-000Z.json
timestamp: 2026-03-30T00:00:00.000Z
channel: feishu
[user]
continue
[assistant]
Conclusion: the main path is already usable.

Current state: shared context read/write is working and the wording layer is being refined.

Next step: keep improving continuation objects and reduce remaining noise.

=== session_summary ===
file: /tmp/tmp.z0aPa4VRuK/sessions/demo-user/cross-channel-default/2026-03-31-feishu.md
# Session Summary

topic: cross-channel-default
goal: Keep Feishu and QQ private chats on the same working context
progress: Shared context read and structured writeback are working
decisions:
- Use structured objects instead of full transcript sync
- Prefer capsule and recent exchanges for short continuation prompts
blockers:
- Legacy summaries may still be verbose
next_step: Keep refining live summaries and continuation capsules
source_channel: feishu
timestamp: 2026-03-30T00:00:00.000Z

=== task_state ===
file: /tmp/tmp.z0aPa4VRuK/tasks/demo-user/cross-channel-default.json
{
  "task_id": "cross-channel-default",
  "title": "Cross-channel shared session continuity",
  "status": "in_progress",
  "current_goal": "Keep multiple private-chat channels on the same working context",
  "latest_progress": [
    "Completed the minimal shared-context read path",
    "Completed structured writeback"
  ],
  "blockers": [
    "Legacy summary style is still inconsistent"
  ],
  "next_step": "Clean live summaries and capsules",
  "updated_at": "2026-03-30T00:00:00+08:00"
}
```

## What this proves

- `feishu` and `qqbot` can resolve to the same canonical user
- one channel can write the continuation objects
- another mapped channel can read back the same object chain
- the bridge returns `continuation_capsule`, `recent_exchanges`, `session_summary`, and `task_state`

## Why this artifact matters

This is stronger than a conceptual diagram.
It gives a concrete, reproducible terminal proof that the bridge works across channel boundaries.

See also:
- `docs/quick-verification.md`
- `docs/usage.md`
- `examples/identity-map.demo.json`
