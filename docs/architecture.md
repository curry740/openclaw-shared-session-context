# Architecture

## Layers

### Identity Layer
Map `channel + channel_user_id` into one `canonical_user`.

### Context Layer
Store four shared objects:
- `session_summary`
- `task_state`
- `continuation_capsule`
- `recent_exchange`

### Hook Layer
- `before-answer`: read shared context
- `after-answer`: write shared state back

### Policy Layer
Control:
- read priority
- noise filtering
- writeback gating
- continuation response shaping

### Backend Layer
Persist resources in OpenViking.

## Design Rules

- channels are entry points, not truth sources
- prefer structured state over raw transcript replay
- shared context must be short enough to inject safely
- write back only on meaningful state change
- keep protocol stable, keep implementation replaceable

## Reference Flow

1. Resolve identity
2. Read capsule
3. Read filtered recent exchanges
4. Read task state
5. Read session summary
6. Generate reply
7. Store summary/task/exchange/capsule if changed
