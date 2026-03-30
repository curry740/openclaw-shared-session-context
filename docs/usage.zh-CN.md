# 使用说明

## 目标

这份文档讲的是：如何从零开始，把仓库接起来并跑通最小可用的共享会话桥接链路。

## 先决条件

你需要先有：
- 一个可用的 `OpenViking` 后端
- 一个可以接入 before-answer / after-answer hook 的 `OpenClaw` 环境
- `bash` 与 `python3`

## 第一步：克隆仓库

```bash
git clone git@github.com:curry740/openclaw-shared-session-context.git
cd openclaw-shared-session-context
```

## 第二步：准备后端根目录

设置 OpenViking 资源根目录：

```bash
export OV_CONTEXT_ROOT="$HOME/.openviking/workspace/viking/default/resources"
```

如果这个资源树还没准备好，就先初始化：

```bash
./scripts/init-backend-tree.sh "$OV_CONTEXT_ROOT"
```

## 第三步：准备 identity map

复制并编辑示例 identity map：

```bash
cp examples/identity-map.json /tmp/identity-map.json
```

然后设置：

```bash
export OV_IDENTITY_MAP="/tmp/identity-map.json"
```

identity map 的作用，是把多个渠道身份映射到同一个 `canonical_user`。

## 第四步：检查前置条件

```bash
./scripts/check-prereqs.sh
```

## 第五步：先跑隔离 demo

运行 demo：

```bash
./scripts/demo.sh feishu demo-feishu-user cross-channel-default
```

预期行为：
- 写入一份示例 `session_summary`
- 写入一份示例 `task_state`
- 写入一份示例 semantic `recent_exchange`
- 生成一份 `continuation_capsule`
- 用 `continue` 查询把上下文读回来

## 第六步：在回答前读取共享上下文

在 OpenClaw 回答前调用：

```bash
./scripts/before-answer.sh <channel> <channel_user_id> <query> [topic]
```

例子：

```bash
./scripts/before-answer.sh feishu ou_xxx "continue" cross-channel-default
```

## 第七步：在回答后写回共享状态

当你生成回答，并且产出结构化 summary/task 文件后，调用：

```bash
./scripts/after-answer.sh <channel> <channel_user_id> <topic> <task_id> <summary_file> <task_json_file> [exchange_id] [exchange_json_file]
```

例子：

```bash
./scripts/after-answer.sh feishu ou_xxx cross-channel-default cross-channel-default /tmp/summary.md /tmp/task.json
```

如果你还希望写入 semantic exchange 并重建 continuation capsule：

```bash
./scripts/after-answer.sh feishu ou_xxx cross-channel-default cross-channel-default /tmp/summary.md /tmp/task.json 2026-03-30T00-00-00-000Z /tmp/exchange.json
```

## 第八步：验证跨渠道续接

换到另一个已映射的渠道身份，发送短续接提示，例如：
- `continue`
- `where were we`
- `what is the current progress`

然后确认 bridge 能从 OpenViking 中按预期读取对象链。

## 部署建议

先把范围收窄：
- 一个 canonical user
- 两个私聊渠道
- 一个 topic
- 先做隔离验证

不要一开始就上：
- 群聊
- 全量 transcript 同步
- 多用户共享状态

## 相关文档

- `docs/install.md`
- `docs/quick-verification.md`
- `docs/demo.md`
- `docs/openclaw-integration-walkthrough.md`
- `docs/why-openviking.md`
