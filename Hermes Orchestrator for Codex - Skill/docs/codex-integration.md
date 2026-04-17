# Codex Integration Guide

## Goal
Install this repository as a Codex skill and expose `@Hermes` as the user-facing entry point for a governed workflow.

This document is written from the perspective of a **user installing the skill**, not from the perspective of editing the origin repository.

---

## 1. Two layers of integration

There are two separate things that must happen:

### Layer A: local filesystem installation
The skill package must exist in a location that Codex can access locally.

Default target:

```text
$HOME/.codex/skills/Hermes
```

### Layer B: Codex activation
Codex must be told how to enter this mode.
The desired user-facing activation is:

```text
@Hermes
```

So installing files is necessary, but not sufficient.
The user also needs either:
- native alias / skill registration
- or a ready-to-paste bootstrap prompt in a Codex conversation

---

## 2. 给 Codex 的最简安装指令

把下面两句话直接发给 Codex：

```text
安装这个 skill：https://github.com/QiaoGen/skills/tree/main/Hermes%20Orchestrator%20for%20Codex%20-%20Skill
安装完成后，启用 @Hermes，并告诉我下一条应该如何开始使用。
```

这是本仓库推荐的默认安装方式。

---

## 3. Codex 需要完成的事情

Codex 收到上面的两句话后，预期要完成：
- 拉取这个 skill 子目录
- 安装到本地 Codex skill 目录
- 识别或注册 `@Hermes`
- 返回一条可直接使用的启动命令

---

## 4. 安装后的第一句

```text
@Hermes 项目 TorchVision，只分析，不改代码
```

---

## 5. 如果还需要初始化 workspace

```bash
bash "$HOME/.codex/skills/Hermes/scripts/bootstrap_workspace.sh" /path/to/project
```

---

## 6. 说明

如果某个 Codex 环境暂时还不能自动处理“安装这个 skill：<url>”这种指令，再退回到手动安装或 bootstrap 粘贴方案。
