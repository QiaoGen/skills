# Install on macOS

## Goal
Install **Hermes Orchestrator for Codex - Skill** on macOS from the perspective of an **end user**.

This repository under GitHub is the **origin/source package**.
A user should be able to:
1. clone or download the repository
2. install the skill into their local Codex skills directory
3. paste a ready-made `@Hermes` bootstrap instruction into Codex
4. start using the workflow without manually rebuilding the skill from source

---

## 1. Origin repo vs user install

There are two different viewpoints:

### A. Origin / source repository
This is the GitHub-hosted source of truth for the skill.
It contains:
- docs
- templates
- prompts
- scripts
- manifest

### B. User installation target
This is where the skill must actually be copied so Codex can use it locally.
By default:

```text
$HOME/.codex/skills/Hermes
```

So the installation story should be:

> pull from GitHub → install locally → tell Codex how to use it

not:

> edit the origin repo directly and assume Codex already knows it exists

---

## 2. Prerequisites

Recommended on macOS:
- Codex runtime available locally
- terminal shell (`zsh` or `bash`)
- `git`
- optional but recommended: local `hermes` runtime already installed and available on `PATH`

This skill is a **package** that should reuse Hermes if Hermes already exists.
It should not blindly install another Hermes runtime.

---

## 3. 最简安装方式

对 Codex 直接发这两句话：

```text
安装这个 skill：https://github.com/QiaoGen/skills/tree/main/Hermes%20Orchestrator%20for%20Codex%20-%20Skill
安装完成后，启用 @Hermes，并告诉我下一条应该如何开始使用。
```

这应该是 macOS 上的首选用户路径。

---

## 4. 安装后的第一句

```text
@Hermes 项目 TorchVision，只分析，不改代码
```

---

## 5. 如果还需要初始化项目 workspace

```bash
bash "$HOME/.codex/skills/Hermes/scripts/bootstrap_workspace.sh" /path/to/project
```

---

## 6. 说明

如果当前 Codex 环境暂时还不能直接处理“安装这个 skill：<url>”，再退回到手动安装说明或 bootstrap fallback。
