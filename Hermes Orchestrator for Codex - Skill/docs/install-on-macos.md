# Install on macOS

## Goal
Install **Hermes Orchestrator for Codex - Skill** on macOS, reuse any existing local Hermes runtime, and expose `@Hermes` as the Codex entrypoint for the governed workflow.

---

## 1. Recommended environment

On macOS, the recommended setup is straightforward:
- Codex CLI / Codex runtime installed locally
- terminal environment available (`zsh` or `bash`)
- optional but recommended: an existing `hermes` command on `PATH`

This repository is a **skill package**, not a second Hermes runtime.
If Hermes already exists locally, this skill should reuse it instead of reinstalling it.

---

## 2. Default install target

By default, the bundled install script writes the skill to:

```text
$HOME/.codex/skills/Hermes
```

If your Codex installation uses a different skills directory, set:

```bash
export CODEX_SKILLS_DIR=/your/custom/codex/skills
```

before running the install script.

---

## 3. Install steps

From the skill repository root, run:

```bash
cd "/Users/drogonz/development/github/skills/Hermes Orchestrator for Codex - Skill"
bash scripts/install.sh
```

### What the install script does
1. Creates the target skill directory
2. Copies `README.md`, `SKILL.md`, and `manifest.json`
3. Copies `prompts/@Hermes.md`
4. Copies workspace templates
5. Copies helper scripts
6. Detects whether `hermes` is already available on `PATH`
7. Writes a runtime note into `HERMES_RUNTIME.txt`

---

## 4. Reusing an existing Hermes runtime

The install script checks:

```bash
command -v hermes
```

If Hermes is already installed and on `PATH`, the skill records that runtime and does not install another copy.

This is the preferred setup on macOS.

---

## 5. Register `@Hermes` in Codex

After installation, your Codex runtime must map:

```text
@Hermes -> prompts/@Hermes.md
```

The exact way depends on the Codex runtime you use. Typical options include:
- prompt alias registration
- custom skill registration
- command alias registration
- named reusable prompt loading

The minimum requirement is that invoking `@Hermes` loads the workflow defined in:

```text
prompts/@Hermes.md
```

---

## 6. Initialize a project workspace

Before daily use, initialize workspace files inside the target project.

Example:

```bash
bash "$HOME/.codex/skills/Hermes/scripts/bootstrap_workspace.sh" /path/to/project
```

This creates:

```text
<project>/.hermes/workspace/
```

with these files:
- `PROJECT_STATE.md`
- `CURRENT_PLAN.md`
- `EXECUTION_LOG.md`
- `DECISIONS.md`

---

## 7. First-run examples

Once the skill is installed and `@Hermes` is registered, you can start from any Codex thread with commands like:

```text
@Hermes 项目 TorchVision，只分析，不改代码
```

```text
@Hermes 读取当前项目状态并总结下一步
```

```text
@Hermes 先做对抗评审，再决定是否进入实施
```

---

## 8. Recommended macOS workflow

A practical daily workflow on macOS is:
1. install the skill once
2. initialize each project workspace once
3. use `@Hermes` whenever you want to enter governed mode
4. let Hermes update workspace files every round
5. resume from new Codex threads by reading workspace state rather than relying on long chat context

This matches the core rule of this skill:

> Hermes plans, Codex executes, and the plan must live on disk.

---

## 9. Troubleshooting

### `bash: command not found`
Unusual on macOS, but if it happens, use `/bin/bash` explicitly:

```bash
/bin/bash scripts/install.sh
```

### `hermes` not detected
Check:

```bash
command -v hermes
```

If nothing is returned, either:
- Hermes is not installed
- or it is not on your current shell `PATH`

### `@Hermes` does nothing in Codex
This usually means Codex has not yet mapped `@Hermes` to `prompts/@Hermes.md`.

### workspace files missing
Run:

```bash
bash "$HOME/.codex/skills/Hermes/scripts/bootstrap_workspace.sh" /path/to/project
```

---

## 10. Related docs

- `README.md`
- `docs/codex-integration.md`
- `docs/wechat-routing.md`
- `docs/role-panel.md`
- `docs/install-on-windows.md`
