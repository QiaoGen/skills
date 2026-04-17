#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
TARGET_ROOT="${CODEX_SKILLS_DIR:-$HOME/.codex/skills}"
TARGET_DIR="$TARGET_ROOT/Hermes"

mkdir -p "$TARGET_ROOT"
rm -rf "$TARGET_DIR"
mkdir -p "$TARGET_DIR"

cp "$ROOT_DIR/README.md" "$TARGET_DIR/README.md"
cp "$ROOT_DIR/SKILL.md" "$TARGET_DIR/SKILL.md"
cp "$ROOT_DIR/manifest.json" "$TARGET_DIR/manifest.json"
mkdir -p "$TARGET_DIR/prompts" "$TARGET_DIR/templates" "$TARGET_DIR/scripts"
cp "$ROOT_DIR/prompts/@Hermes.md" "$TARGET_DIR/prompts/@Hermes.md"
cp "$ROOT_DIR/templates/PROJECT_STATE.md" "$TARGET_DIR/templates/PROJECT_STATE.md"
cp "$ROOT_DIR/templates/CURRENT_PLAN.md" "$TARGET_DIR/templates/CURRENT_PLAN.md"
cp "$ROOT_DIR/templates/EXECUTION_LOG.md" "$TARGET_DIR/templates/EXECUTION_LOG.md"
cp "$ROOT_DIR/templates/DECISIONS.md" "$TARGET_DIR/templates/DECISIONS.md"
cp "$ROOT_DIR/scripts/bootstrap_workspace.sh" "$TARGET_DIR/scripts/bootstrap_workspace.sh"

if command -v hermes >/dev/null 2>&1; then
  HERMES_PATH="$(command -v hermes)"
  printf 'detected hermes at %s
' "$HERMES_PATH" | tee "$TARGET_DIR/HERMES_RUNTIME.txt"
else
  printf 'hermes runtime not found on PATH; install or point your Codex wrapper to an existing Hermes runtime.
' | tee "$TARGET_DIR/HERMES_RUNTIME.txt"
fi

cat <<EOF
Installed Hermes Orchestrator for Codex to:
  $TARGET_DIR

Next steps:
1. Register @Hermes in your Codex runtime and map it to:
   $TARGET_DIR/prompts/@Hermes.md
2. Optionally set CODEX_SKILLS_DIR if your Codex installation uses another skills directory.
3. Initialize a project workspace with:
   bash "$TARGET_DIR/scripts/bootstrap_workspace.sh" /path/to/project
EOF
