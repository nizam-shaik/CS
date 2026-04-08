#!/usr/bin/env bash
# SessionStart hook — prints project context summary at the top of every session

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

echo "============================================"
echo " Student Grade Tracker — Session Context"
echo "============================================"
echo "Working dir : $PROJECT_ROOT"
echo "Branch      : $(git -C "$PROJECT_ROOT" rev-parse --abbrev-ref HEAD 2>/dev/null || echo 'unknown')"
echo "Last commit : $(git -C "$PROJECT_ROOT" log -1 --oneline 2>/dev/null || echo 'none')"
echo "Python      : $(python --version 2>&1 || echo 'not found')"

if [ -f "$PROJECT_ROOT/docs/PLAN.md" ]; then
  PENDING=$(grep -c '^\- \[ \]' "$PROJECT_ROOT/docs/PLAN.md" 2>/dev/null || echo 0)
  DONE=$(grep -c '^\- \[x\]' "$PROJECT_ROOT/docs/PLAN.md" 2>/dev/null || echo 0)
  echo "Plan tasks  : $DONE done / $PENDING pending"
else
  echo "Plan tasks  : docs/PLAN.md not found — run /plan first"
fi

echo "============================================"
