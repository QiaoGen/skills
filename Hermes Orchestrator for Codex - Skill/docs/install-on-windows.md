# Install on Windows

## Goal
Install **Hermes Orchestrator for Codex - Skill** on Windows with minimal duplication, while reusing an existing local Hermes runtime whenever possible.

---

## 1. What gets installed

This repository is a **skill package**, not a second Hermes runtime.

After installation, the important parts are:
- `README.md`
- `SKILL.md`
- `manifest.json`
- `prompts/@Hermes.md`
- `templates/`
- `scripts/`

The skill should be copied into your Codex skills directory, then `@Hermes` should be registered as a prompt alias / custom skill entrypoint.

---

## 2. Recommended Windows environments

Choose one of these:

### Option A: Git Bash
Recommended if you want to use the existing shell scripts directly.

### Option B: WSL
Recommended if your Codex workflow already runs in a Linux-like environment on Windows.

### Option C: PowerShell
Usable, but the current repository ships shell scripts (`.sh`), so you may need either:
- Git Bash
- WSL
- or manual installation steps in PowerShell

---

## 3. Prerequisites

Before installing, make sure you have:

- Codex CLI / Codex runtime installed
- a Codex skills directory (or a place where Codex can load custom skills)
- optional but recommended: an existing `hermes` command/runtime available locally
- Git Bash or WSL if you want to run the bundled shell scripts directly

If Hermes is already installed locally, this skill is designed to **reuse it** rather than reinstall it.

---

## 4. Default install target

On Windows, a reasonable Codex skills path might be one of these:

```text
%USERPROFILE%\.codex\skills\Hermes
```

or under Git Bash style path:

```text
$HOME/.codex/skills/Hermes
```

If your Codex runtime uses a custom skills directory, set `CODEX_SKILLS_DIR` before installation.

---

## 5. Install with Git Bash

Open **Git Bash** and run:

```bash
cd "/c/Users/<your-user>/development/github/skills/Hermes Orchestrator for Codex - Skill"
bash scripts/install.sh
```

If you need a custom Codex skills directory:

```bash
export CODEX_SKILLS_DIR="/c/Users/<your-user>/path/to/codex/skills"
bash scripts/install.sh
```

### What the script does
1. Creates the target skill directory
2. Copies the skill files into the Codex skills path
3. Copies `prompts/@Hermes.md`
4. Copies workspace templates
5. Detects whether `hermes` already exists on `PATH`
6. Writes a small runtime note into `HERMES_RUNTIME.txt`

---

## 6. Install with WSL

If your Codex workflow runs inside WSL, install from the WSL environment instead of native Windows.

Example:

```bash
cd "/mnt/c/Users/<your-user>/development/github/skills/Hermes Orchestrator for Codex - Skill"
bash scripts/install.sh
```

If your Codex runtime inside WSL uses another directory:

```bash
export CODEX_SKILLS_DIR="$HOME/.codex/skills"
bash scripts/install.sh
```

### Important note
If Codex runs in Windows native mode but you install from WSL, make sure the actual skill directory is visible to the Codex runtime you are using. Avoid mixing environments unless you know which side loads the skills.

---

## 7. Manual installation with PowerShell

If you do not want to use Git Bash or WSL, you can install manually.

### Step 1: choose target directory
Example:

```powershell
$Target = "$env:USERPROFILE\.codex\skills\Hermes"
New-Item -ItemType Directory -Force -Path $Target | Out-Null
New-Item -ItemType Directory -Force -Path "$Target\prompts" | Out-Null
New-Item -ItemType Directory -Force -Path "$Target\templates" | Out-Null
New-Item -ItemType Directory -Force -Path "$Target\scripts" | Out-Null
```

### Step 2: copy files
Assuming the repository is here:

```powershell
$Repo = "C:\Users\<your-user>\development\github\skills\Hermes Orchestrator for Codex - Skill"
Copy-Item "$Repo\README.md" "$Target\README.md" -Force
Copy-Item "$Repo\SKILL.md" "$Target\SKILL.md" -Force
Copy-Item "$Repo\manifest.json" "$Target\manifest.json" -Force
Copy-Item "$Repo\prompts\@Hermes.md" "$Target\prompts\@Hermes.md" -Force
Copy-Item "$Repo\templates\*" "$Target\templates\" -Force
Copy-Item "$Repo\scripts\*" "$Target\scripts\" -Force
```

### Step 3: detect Hermes manually
You can check whether Hermes already exists:

```powershell
Get-Command hermes -ErrorAction SilentlyContinue
```

If the command exists, reuse it. Do not install a duplicate Hermes runtime unless you really need a separate environment.

---

## 8. Register `@Hermes`

After the files are installed, your Codex runtime must map:

```text
@Hermes -> prompts/@Hermes.md
```

The exact registration method depends on your Codex runtime. Common patterns include:
- prompt alias registration
- custom skill registration
- command alias registration
- loading a prompt file as a reusable named instruction

---

## 9. Initialize a project workspace

Once installed, initialize a project workspace before daily use.

If using Git Bash or WSL:

```bash
bash "$HOME/.codex/skills/Hermes/scripts/bootstrap_workspace.sh" /path/to/project
```

If using PowerShell only, you can manually create:

```text
<project>\.hermes\workspace\
```

and copy these template files into it:
- `PROJECT_STATE.md`
- `CURRENT_PLAN.md`
- `EXECUTION_LOG.md`
- `DECISIONS.md`

---

## 10. First run examples

After registration, you should be able to start from any Codex thread with something like:

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

## 11. Windows-specific notes

### Path style
Be careful about path style conversions:
- Git Bash: `/c/Users/...`
- PowerShell / CMD: `C:\Users\...`
- WSL: `/mnt/c/Users/...`

### Existing Hermes runtime
If Hermes is already available in one environment but not another, the install script may detect it only in the current shell. For example:
- detected in Git Bash
- not detected in PowerShell
- detected in WSL only

So the recommended rule is:
> install and run the skill in the same environment where your Codex runtime actually runs.

### Avoid duplicate installs
Do not separately install multiple copies of the same skill unless you intentionally isolate environments.

---

## 12. Troubleshooting

### Problem: `bash` not found
Use Git Bash or WSL, or perform the manual PowerShell install.

### Problem: `hermes` not detected
Check whether Hermes is on `PATH` in the shell you used for installation:

```powershell
Get-Command hermes
```

or in Git Bash:

```bash
command -v hermes
```

### Problem: `@Hermes` does nothing
This usually means Codex has not actually registered `@Hermes` to `prompts/@Hermes.md` yet.

### Problem: workspace files not found
Run the bootstrap script or manually create:

```text
.hermes/workspace/
```

inside the project directory.

---

## 13. Recommended next docs to read

- `README.md`
- `docs/codex-integration.md`
- `docs/wechat-routing.md`
- `docs/role-panel.md`
