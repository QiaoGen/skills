#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 /path/to/project [workspace_id]"
  exit 1
fi

PROJECT_DIR="$1"
WORKSPACE_ID="${2:-$(basename "$PROJECT_DIR")}" 
WORK_DIR="$PROJECT_DIR/.hermes/workspace"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)/templates"

mkdir -p "$WORK_DIR"
cp -n "$TEMPLATE_DIR/PROJECT_STATE.md" "$WORK_DIR/PROJECT_STATE.md"
cp -n "$TEMPLATE_DIR/CURRENT_PLAN.md" "$WORK_DIR/CURRENT_PLAN.md"
cp -n "$TEMPLATE_DIR/EXECUTION_LOG.md" "$WORK_DIR/EXECUTION_LOG.md"
cp -n "$TEMPLATE_DIR/DECISIONS.md" "$WORK_DIR/DECISIONS.md"

python3 - <<PY
from pathlib import Path
wd = Path(r"$WORK_DIR")
ps = wd / "PROJECT_STATE.md"
text = ps.read_text(encoding='utf-8')
text = text.replace('- root:
- workspace_id:', f'- root: {Path(r"$PROJECT_DIR")!s}
- workspace_id: $WORKSPACE_ID')
text = text.replace('- name:
- root:', f'- name: {Path(r"$PROJECT_DIR").name}
- root: {Path(r"$PROJECT_DIR")!s}')
ps.write_text(text, encoding='utf-8')
PY

echo "Workspace initialized at: $WORK_DIR"
echo "Open Codex and invoke: @Hermes 项目 $WORKSPACE_ID"
