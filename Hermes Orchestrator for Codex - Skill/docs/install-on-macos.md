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

## 3. Fast path for end users

If the repository is already on GitHub, a user-facing install flow should look like this.

### One-command clone + install

Replace `<repo-url>` with your actual GitHub repository URL.

```bash
mkdir -p ~/development/github/skills && cd ~/development/github/skills && git clone <repo-url> "Hermes Orchestrator for Codex - Skill" && cd "Hermes Orchestrator for Codex - Skill" && bash scripts/install.sh
```

If the repository already exists locally:

```bash
cd ~/development/github/skills/"Hermes Orchestrator for Codex - Skill" && git pull && bash scripts/install.sh
```

---

## 4. What installation actually does

The install script copies the skill package into Codex's local skill directory.

Default target:

```text
$HOME/.codex/skills/Hermes
```

It also:
1. copies `README.md`, `SKILL.md`, and `manifest.json`
2. copies `prompts/@Hermes.md`
3. copies workspace templates
4. copies helper scripts
5. checks whether `hermes` already exists on `PATH`
6. records the runtime path into `HERMES_RUNTIME.txt`

If your Codex installation uses another directory, set:

```bash
export CODEX_SKILLS_DIR=/your/custom/codex/skills
```

before running the installer.

---

## 5. The missing piece: make Codex know about the skill

Installing files into the local skills directory is only half of the job.

The user still needs a **Codex-facing activation instruction**.
The minimum contract is:

```text
@Hermes -> prompts/@Hermes.md
```

That means one of these must exist in the user's Codex environment:
- prompt alias
- custom skill registration
- named reusable prompt mapping
- a manual paste workflow into a Codex conversation

Because Codex environments differ, this repository should provide **both**:
1. filesystem install instructions
2. a ready-to-paste bootstrap message for Codex

---

## 6. Ready-to-paste bootstrap text for Codex

If the user's Codex environment does not yet support automatic alias registration, they should still be able to paste the following block directly into a new Codex conversation.

### Paste this into Codex

```text
You are now running Hermes Orchestrator mode.

Load the workflow from the locally installed Hermes skill with these rules:
1. Hermes plans, Codex executes.
2. Every round plan must be written to disk.
3. Use workspace files as the durable project memory.
4. For risky, cross-module, or architectural tasks, run adversarial role review first.
5. Use these role perspectives: PM/Business, Architect/Technical Lead, Execution Engineer, QA/Operations, Skeptic/Risk Officer.
6. Do not rely on long chat context as the source of truth.
7. Read and update these files when available:
   - .hermes/workspace/PROJECT_STATE.md
   - .hermes/workspace/CURRENT_PLAN.md
   - .hermes/workspace/EXECUTION_LOG.md
   - .hermes/workspace/DECISIONS.md
8. External channels such as WeChat must update workspace state, not native chat history.
9. If the user writes @Hermes, treat that as a request to re-enter this governed workflow.
10. Before implementation, restate goal, constraints, current phase, and execution boundary.
```

This is not as good as native skill registration, but it gives the user a **one-paste fallback path**.

---

## 7. Recommended alias-style user command

After the skill is installed, the ideal user experience should be one of these:

```text
@Hermes 项目 TorchVision，只分析，不改代码
```

```text
@Hermes 读取当前状态并继续上一轮计划
```

```text
@Hermes 先做对抗评审，再决定是否进入实施
```

So the documentation should always be written from the user's point of view:
- how to install
- how to activate
- what to paste
- what to type next

---

## 8. Initialize a project workspace

Before the workflow is useful, the project must have durable workspace files.

### Initialize with the bundled script

```bash
bash "$HOME/.codex/skills/Hermes/scripts/bootstrap_workspace.sh" /path/to/project
```

This creates:

```text
<project>/.hermes/workspace/
```

with:
- `PROJECT_STATE.md`
- `CURRENT_PLAN.md`
- `EXECUTION_LOG.md`
- `DECISIONS.md`

---

## 9. Recommended user flow on macOS

A good end-user flow is:

### Step 1
Clone from GitHub and run the installer.

### Step 2
Initialize the target project workspace.

### Step 3
Open Codex.

### Step 4
If Codex already supports the alias, type:

```text
@Hermes 项目 <project-name>
```

### Step 5
If Codex does not yet support alias registration, paste the bootstrap block from this document into the conversation, then continue with:

```text
项目 <project-name>，进入 Hermes Orchestrator 模式
```

---

## 10. Reusing an existing Hermes runtime

Check whether Hermes is already available:

```bash
command -v hermes
```

If Hermes is found, reuse it.
This repository should be treated as the skill package only.

---

## 11. Troubleshooting

### Codex does not know `@Hermes`
That means the skill files may be installed locally, but Codex has no alias/registration bound to them yet.

Use either:
- your Codex runtime's skill registration mechanism
- or the ready-to-paste bootstrap block in this document

### The skill is installed but behavior is inconsistent
Make sure the project workspace has actually been initialized:

```bash
bash "$HOME/.codex/skills/Hermes/scripts/bootstrap_workspace.sh" /path/to/project
```

### Hermes runtime not found
Check:

```bash
command -v hermes
```

If empty, either install Hermes or configure your Codex-side workflow to run in a shell where Hermes is already available.

---

## 12. Related docs

- `README.md`
- `docs/codex-integration.md`
- `docs/wechat-routing.md`
- `docs/role-panel.md`
- `docs/install-on-windows.md`
