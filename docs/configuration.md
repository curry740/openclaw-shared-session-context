# Configuration

## Required

### `OV_CONTEXT_ROOT`
OpenViking resources root.

Example:
`$HOME/.openviking/workspace/viking/default/resources`

### `OV_IDENTITY_MAP`
Path to your identity map JSON.

## Optional

### `OV_RECENT_LIMIT`
How many recent exchanges to consider.

### `OV_RECENT_MAX_CHARS`
Character budget for `recent_exchanges` injection.

### Exchange writeback inputs
If you want the full continuation chain, also pass these optional arguments into `scripts/after-answer.sh`:
- `exchange_id`
- `exchange_json_file`

That enables:
- semantic exchange writeback
- continuation capsule regeneration

## Identity Map Shape

See `examples/identity-map.json`.

Each user entry should map multiple channels into one canonical identity.
