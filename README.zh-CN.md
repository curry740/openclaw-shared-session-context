# OpenClaw Shared Session Context

一个用于实现跨渠道共享会话连续性的桥接层，连接 `OpenClaw` 与 `OpenViking`。

这个仓库不只是一个 OpenClaw skill，也不只是几段 hook 脚本。
它的作用是把以下三层接起来：
- `OpenClaw`：负责编排、消息处理、回答生成
- `OpenViking`：负责共享状态的存储与读取
- 本仓库：负责协议、桥接流程与参考实现

## 一句话概括架构

`OpenClaw` 决定什么时候读写，`OpenViking` 负责存取共享对象，本仓库定义两者之间的桥接协议与实现。

## 为什么要做这个

同一个用户如果在不同渠道与同一个 bot 对话，常见问题是：
- 每个渠道都变成独立会话
- `继续`、`我们聊到哪儿了` 这类短提示很弱
- 当前任务状态在渠道之间漂移

本仓库的目标，就是让多个渠道通过同一套共享状态后端读写同一个工作上下文。

## OpenViking 不是可选项

在当前实现里，`OpenViking` 不是可选增强，而是必需后端。
它负责存取以下共享对象：
- `session_summary`
- `task_state`
- `continuation_capsule`
- `recent_exchange`

如果没有可用的 `OpenViking` 后端，这套桥接链路就无法按设计工作。

## OpenClaw 负责什么

`OpenClaw` 负责：
- 接收来自不同聊天渠道的消息
- 在回答前调用 bridge 读取共享上下文
- 在回答后调用 bridge 写回共享状态
- 结合注入的上下文生成最终回答

## OpenViking 负责什么

`OpenViking` 负责：
- 以统一 `canonical_user` 为中心存储共享对象
- 让不同渠道可以读到同一份共享状态
- 作为跨渠道连续性的共享后端，而不是依赖单个渠道本地会话记忆

## 本仓库提供什么

本仓库提供：
- 协议级对象定义
- 基于 OpenViking 的参考 Shell 脚本
- OpenClaw 集成说明
- identity map、config、summary、exchange 的示例文件
- demo、验证、上线与 hardening 文档
- 一个薄封装的 OpenClaw skill，位于 `skill/shared-session-context`

## 核心对象

- `session_summary`
- `task_state`
- `continuation_capsule`
- `recent_exchange`

## 读取优先级

`continuation_capsule -> recent_exchanges -> task_state -> session_summary`

## 当前范围

- 先支持私聊场景的连续性
- 先采用手工 identity mapping
- 先以 OpenViking 作为后端
- 先通过 OpenClaw hook 集成

## 不包含的内容

- 全量 transcript 同步
- 默认支持群聊共享
- 自动长期记忆提取
- 托管式后端服务

## 快速开始

1. 先确保 `OpenViking` 已安装并可用。
2. 克隆本仓库。
3. 复制 `examples/identity-map.json` 并填入你的渠道用户 ID。
4. 设置：
   - `OV_CONTEXT_ROOT`
   - `OV_IDENTITY_MAP`
5. 运行 `scripts/check-prereqs.sh`。
6. 如有需要，使用 `scripts/init-backend-tree.sh` 初始化后端目录结构。
7. 在回答前调用 `scripts/before-answer.sh`。
8. 在回答后调用 `scripts/after-answer.sh`。
9. 如需写入 semantic exchange 与 continuation capsule，可给 `scripts/after-answer.sh` 额外传入 `exchange_id` 与 `exchange_json_file`。
10. 用 `scripts/demo.sh` 或真实双渠道续接场景验证。

你也可以直接把这个 GitHub 仓库链接发给你自己的 `OpenClaw`，让它读取并使用这套实现。本仓库的结构已经按“可被 OpenClaw 直接消费”来组织。详见 `docs/openclaw-direct-consumption.md`。

## 如何验证它真的可用

运行隔离 demo：

```bash
export OV_CONTEXT_ROOT="$(mktemp -d)"
mkdir -p "$OV_CONTEXT_ROOT"/{sessions,tasks,capsules,exchanges,memory/long-term}
export OV_IDENTITY_MAP="$PWD/examples/identity-map.demo.json"
./scripts/check-prereqs.sh
./scripts/demo.sh feishu demo-feishu-user cross-channel-default
```

如果最终输出中出现：
- `continuation_capsule`
- `recent_exchanges`
- `task_state`
- `session_summary`

就说明 bridge 已经能在一个 OpenViking 风格的资源树上完成最小写入与回读闭环。

更短的验证流程见：`docs/quick-verification.md`

## OpenClaw Skill Wrapper

仓库内置了一个薄封装 skill：`skill/shared-session-context`。

它应该保持“薄”，不复制后端逻辑。
后端契约属于 `OpenViking`，桥接契约属于本仓库。

## 推荐发布方式

- 把本仓库作为 bridge 与 reference implementation 发布
- 在所有安装与架构文档里明确写出 OpenViking 的关键地位
- 把 skill 作为面向 OpenClaw 的薄封装入口
- skill 版本跟随本仓库的 tag 发布

## 更多文档

- `docs/usage.md`
- `docs/usage.zh-CN.md`
- `docs/architecture-diagram.md`
- `docs/quick-verification.md`
- `docs/faq.md`
- `docs/use-cases.md`
- `docs/why-openviking.md`

## 许可证

MIT
