# Hermes Orchestrator for Codex - Skill

Hermes Orchestrator for Codex 是一个把 **Hermes 作为规划/审查/治理层**、把 **Codex 作为执行层** 的可安装 skill。

启用后，工作模式切换为：

- **Hermes 负责计划**：理解目标、拆分任务、识别风险、组织对抗角色评审、更新项目状态。
- **Codex 负责执行**：阅读代码、修改文件、运行命令、输出验证结果。
- **每轮计划必须落盘**：避免上下文过长导致项目偏移。
- **外部入口可接入微信机器人**：微信消息先写入 workspace 状态层，而不是侵入式写入 Codex 原生会话。
- **使用 `@Hermes` 启动模式**：即使在新的线程/会话下，也可以通过 `@Hermes` 重新加载治理模式与项目状态。

---

## 1. 核心目标

这个 skill 的目标不是“让 Codex 更像 Hermes”，而是建立一个双层工作流：

```text
用户 / 微信
    ↓
Hermes（计划、治理、审查、汇总）
    ↓
Codex（执行、验证、反馈）
```

Hermes 不是一次性 prompt，而是一个 **会话级 operating mode**。

---

## 2. 工作原则

### 固定分工

#### Hermes 负责
- 目标澄清
- 任务拆分
- 风险与约束提取
- 阶段计划制定
- 多角色对抗评审
- 阶段审查与总结
- 项目状态落盘

#### Codex 负责
- 代码分析
- 文件修改
- 命令执行
- 测试与验证
- 按当前批准计划执行

### 三条硬规则
1. **Hermes plan, Codex execute.**
2. **每轮计划都必须落盘。**
3. **外部消息接入通过 workspace 状态层，不侵入 Codex 原生会话。**

---

## 3. 对抗角色（必须启用）

当任务满足以下任一条件时，触发多角色评审：
- 涉及多个模块
- 涉及架构调整
- 高风险改动
- 用户明确要求先讨论方案
- 任务周期较长或跨阶段

默认角色：

1. **PM / 业务角色**
   - 关注真实需求、交付闭环、是否做大了。
2. **架构 / 技术负责人角色**
   - 关注技术边界、长期维护成本、抽象是否过度。
3. **执行工程师角色（Codex 视角）**
   - 关注落地步骤、改动范围、验证方式。
4. **QA / 运维角色**
   - 关注可测试性、回滚、监控、排障。
5. **反对者 / 风险审查官角色**
   - 负责主动挑刺，指出失败路径与隐含假设。

每个角色输出固定 5 项：
- 支持点
- 反对点
- 最大风险
- 建议修改
- 是否建议进入实施

最后由 Hermes 汇总为：
- 共识点
- 冲突点
- 待用户拍板事项
- 推荐下一步

---

## 4. 项目状态落盘

为了防止上下文过长导致目标漂移，每个 workspace 都要维护以下文件：

- `PROJECT_STATE.md`：项目长期状态、阶段、风险、约束、下一步
- `CURRENT_PLAN.md`：当前轮计划与执行边界
- `EXECUTION_LOG.md`：执行摘要与验证结果
- `DECISIONS.md`：关键决策记录

建议每个项目目录维护：

```text
.hermes/
  workspace/
    PROJECT_STATE.md
    CURRENT_PLAN.md
    EXECUTION_LOG.md
    DECISIONS.md
```

---

## 5. 微信机器人接入方式（非侵入式）

**不要把微信消息硬塞进 Codex 原生聊天记录。**

推荐模式：

```text
微信消息
  ↓
Hermes Gateway / Router
  ↓
Workspace State（落盘状态）
  ↓
Codex 读取状态继续工作
```

### 微信端应该支持：
- 指定项目：如 `项目 TorchVision`
- 指定阶段：如 `只分析，不改代码`
- 指定任务：如 `继续排查模型加载失败`

### Codex 端如何“无缝对接”
不是 UI 级无缝，而是 **状态级无缝**：
- 微信上发的指令进入 workspace 状态层
- 在电脑上新的 Codex 线程里输入 `@Hermes`，重新加载最近计划与项目状态
- 即便换线程，也能接着同一项目继续做

---

## 6. `@Hermes` 的约定

本 skill 假设你会在 Codex 里注册一个名为 `@Hermes` 的入口（prompt alias / command alias / custom skill alias）。

`@Hermes` 的语义：
- 加载本 skill 的系统工作流
- 加载当前项目 workspace 状态
- 如有必要先做对抗角色评审
- 输出本轮计划，再进入执行

示例：

```text
@Hermes 项目 TorchVision，只分析模型加载失败问题，先不要改代码。
```

```text
@Hermes 切换到 JiNanPack，进入实施阶段，按当前计划继续执行。
```

```text
@Hermes 读取当前项目状态并总结下一步。
```

---

## 7. 安装

### 前提
- 本地已安装 Codex CLI / Codex runtime
- **如本地已存在 Hermes，则直接复用，不重复安装 Hermes 本体**
- 可选：微信机器人 / Hermes Gateway

### 安装方式

运行：

```bash
cd "$(dirname "$0")"
bash scripts/install.sh
```

安装脚本会：
1. 检测本机是否已有 `hermes` 命令
2. 将本 skill 安装到 `${CODEX_SKILLS_DIR:-$HOME/.codex/skills}/Hermes`
3. 复制 `prompts/@Hermes.md` 作为主要入口提示
4. 复制模板文件到 skill 目录，供 workspace 初始化使用
5. 如果已安装 Hermes，仅记录桥接信息，不重复安装 Hermes

### 手动安装
如你有自己的 Codex skill 目录，可手动复制以下内容：
- `prompts/@Hermes.md`
- `manifest.json`
- `templates/`
- `scripts/`

到你的 Codex skills 目录，并将 `@Hermes` 映射到 `prompts/@Hermes.md`。

---

## 8. 目录结构

```text
Hermes Orchestrator for Codex - Skill/
  README.md
  SKILL.md
  manifest.json
  prompts/
    @Hermes.md
  templates/
    PROJECT_STATE.md
    CURRENT_PLAN.md
    EXECUTION_LOG.md
    DECISIONS.md
  scripts/
    install.sh
    bootstrap_workspace.sh
```

---

## 9. 推荐工作流

### A. 新项目启动
1. 安装 skill
2. 在项目目录初始化 workspace
3. 在 Codex 中输入 `@Hermes 项目 <name>`
4. Hermes 生成首版 `PROJECT_STATE.md` 与 `CURRENT_PLAN.md`

### B. 日常协作
1. 用户提出需求
2. Hermes 先规划
3. 必要时触发对抗角色评审
4. Codex 按计划执行
5. Hermes 更新落盘状态

### C. 微信远程指挥
1. 微信消息写入 workspace 状态层
2. 电脑上任意新线程输入 `@Hermes`
3. Codex 读取状态继续工作

---

## 10. 当前范围与后续

### 当前版本提供
- 技能定义
- `@Hermes` 入口 prompt
- 对抗角色规范
- 项目落盘模板
- 安装脚本
- workspace 初始化脚本

### 后续可扩展
- 微信 gateway 真正落地接入
- 自动角色选择器
- 更细粒度项目路由
- review 结果自动写回 issue / PR / 文档系统

---

## 11. 版本

当前版本：`v0.1`
定位：**可上传 GitHub 的 skill 骨架 + 安装入口 + 工作流定义**
