# WeChat Routing and Remote Control Model

## Goal
Use WeChat as a **remote instruction channel** for Hermes + Codex without trying to embed WeChat messages into Codex native chat history.

## Core Rule
WeChat writes to **workspace state**, not to Codex internal transcript state.

```text
WeChat message
  ↓
Hermes Gateway / Router
  ↓
Workspace state files or workspace DB
  ↓
Codex thread invokes @Hermes
  ↓
@Hermes reloads project state and resumes work
```

## Message Contract
A WeChat message should ideally contain these parts when possible:

- project selector
- phase selector
- task instruction
- execution boundary

### Example messages
```text
项目 TorchVision，只分析模型加载失败，不改代码
```

```text
项目 JiNanPack，进入实施阶段，继续上次 PLC 绑定问题
```

```text
项目 TorchVision，先组织对抗角色评审，再给建议
```

## Recommended Router Responsibilities
The gateway/router should:
1. Identify target project/workspace
2. Identify requested phase
3. Append instruction into workspace state
4. Mark whether adversarial review is required
5. Avoid writing directly into Codex internal session storage

## Why this model
This approach is preferred because it:
- avoids intrusive coupling with Codex native session implementation
- survives thread changes
- keeps the durable source of truth outside transient context windows
- allows the same workspace to be resumed from WeChat, terminal, or another tool

## Resume Pattern in Codex
When you return to the computer, you can use a fresh Codex thread and type:

```text
@Hermes 项目 TorchVision，读取最新状态并继续
```

The expectation is not UI-level continuity.
The expectation is **state-level continuity**.

## Future integration ideas
- Map WeChat topic/chat to default workspace
- Add `只分析 / 可执行 / 先评审` execution modes
- Auto-summarize remote instructions into `CURRENT_PLAN.md` draft
- Trigger notifications back to WeChat after plan update or task completion
