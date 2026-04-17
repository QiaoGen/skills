# Codex Integration Guide

## Goal
Install this repository as a Codex skill and expose `@Hermes` as the entry point for a governed workflow.

## Integration Model
This repository assumes Codex supports one or more of the following:
- prompt aliases
- custom skills
- command aliases
- startup prompt files

The exact registration mechanism may vary by Codex runtime.

## Minimum integration requirement
`@Hermes` must map to:

```text
prompts/@Hermes.md
```

## Installation
Run:

```bash
bash scripts/install.sh
```

By default, it installs to:

```text
$HOME/.codex/skills/Hermes
```

If your Codex installation uses another directory, set:

```bash
export CODEX_SKILLS_DIR=/your/codex/skills/path
```

before running the install script.

## After install
Make sure your Codex runtime recognizes:
- `README.md`
- `SKILL.md`
- `manifest.json`
- `prompts/@Hermes.md`

Then register `@Hermes` as an alias or skill entrypoint.

## Expected usage

```text
@Hermes 项目 TorchVision，只分析，不改代码
```

```text
@Hermes 读取当前 workspace 状态，进入下一阶段规划
```

```text
@Hermes 先做对抗评审，再决定是否进入实施
```

## Behavior expectations
When `@Hermes` is invoked, the workflow should:
1. Load workspace files
2. Restate the goal and constraints
3. Run adversarial review if needed
4. Write a current-round plan to disk
5. Execute only inside the approved boundary
6. Update logs and decisions after execution

## Recommended local wrapper
If Codex supports custom shell wrappers, consider exposing something like:

```bash
codex-hermes /path/to/project
```

This wrapper can:
- change to the project directory
- ensure `.hermes/workspace/` exists
- load or initialize templates
- open Codex with `@Hermes` preloaded

## Non-goals
This repository intentionally does **not** require:
- intrusive patching of Codex internal conversation storage
- direct embedding of WeChat transcript into Codex UI
- installing a second Hermes runtime if one already exists locally
