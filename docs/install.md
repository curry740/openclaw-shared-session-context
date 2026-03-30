# Install

## Prerequisites

- OpenClaw already running
- OpenViking available
- shell environment with `bash` and `python3`

## Setup

1. Clone this repository.
2. Copy `examples/identity-map.json` to your local config path.
3. Set these environment variables:

```bash
export OV_CONTEXT_ROOT="$HOME/.openviking/workspace/viking/default/resources"
export OV_IDENTITY_MAP="/path/to/identity-map.json"
```

4. Test identity resolution:

```bash
scripts/resolve-identity.sh feishu YOUR_FEISHU_USER_ID
```

5. Test context read:

```bash
scripts/before-answer.sh feishu YOUR_FEISHU_USER_ID "continue" your-topic
```

## Integration

Wire these scripts into your own before/after answer flow.
Do not patch your runtime core first. Validate the bridge layer first.
