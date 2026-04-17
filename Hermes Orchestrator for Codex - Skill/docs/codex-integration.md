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

## 2. User installation from GitHub

Replace `<repo-url>` with the actual repository URL.

### Fresh install
```bash
mkdir -p ~/development/github/skills && cd ~/development/github/skills && git clone <repo-url> "Hermes Orchestrator for Codex - Skill" && cd "Hermes Orchestrator for Codex - Skill" && bash scripts/install.sh
```

### Update existing checkout
```bash
cd ~/development/github/skills/"Hermes Orchestrator for Codex - Skill" && git pull && bash scripts/install.sh
```

---

## 3. Required mapping

The intended mapping is:

```text
@Hermes -> prompts/@Hermes.md
```

If Codex supports custom skills or aliases, register `@Hermes` against that file.

If Codex does not support it yet, use the bootstrap fallback below.

---

## 4. One-paste fallback for Codex conversations

Paste the following text into a fresh Codex conversation to emulate the skill even before native alias registration is fully wired.

```text
You are now running Hermes Orchestrator mode.
Hermes plans, Codex executes.
Every round plan must be persisted to disk.
Use .hermes/workspace/PROJECT_STATE.md, CURRENT_PLAN.md, EXECUTION_LOG.md, and DECISIONS.md as the durable project memory.
For risky or architectural tasks, run adversarial review using these roles: PM/Business, Architect/Technical Lead, Execution Engineer, QA/Operations, Skeptic/Risk Officer.
Do not rely on long transcript context as the source of truth.
If the user says @Hermes, treat that as a request to enter or resume this governed workflow.
Before implementation, restate goal, constraints, phase, plan, and execution boundary.
```

This fallback should be documented because users need a path that works even before Codex-side alias plumbing is perfect.

---

## 5. Expected usage after activation

```text
@Hermes 项目 TorchVision，只分析，不改代码
```

```text
@Hermes 读取当前 workspace 状态，进入下一阶段规划
```

```text
@Hermes 先做对抗评审，再决定是否进入实施
```

---

## 6. Workspace initialization

Before using the workflow, initialize workspace files:

```bash
bash "$HOME/.codex/skills/Hermes/scripts/bootstrap_workspace.sh" /path/to/project
```

---

## 7. Recommended local wrapper (future enhancement)

If Codex supports local wrappers, a future enhancement is a command like:

```bash
codex-hermes /path/to/project
```

This wrapper could:
- change to the project directory
- ensure `.hermes/workspace/` exists
- load or initialize templates
- preload `@Hermes`

---

## 8. Non-goals

This repository intentionally does **not** require:
- intrusive patching of Codex internal conversation storage
- direct embedding of WeChat transcript into Codex UI
- installing a second Hermes runtime if one already exists locally
