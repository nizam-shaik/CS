#!/usr/bin/env bash
# PostToolUse(Write|Edit|MultiEdit) hook — auto-formats Python files after edits
# Claude Code passes the tool input JSON via stdin

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('file_path', d.get('path','')))" 2>/dev/null)

# Only act on Python files
if [[ "$FILE_PATH" != *.py ]]; then
  exit 0
fi

# File must exist
if [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

echo "Auto-formatting: $FILE_PATH"

if command -v black &>/dev/null; then
  black "$FILE_PATH" --quiet && echo "  black ✓"
else
  echo "  black not found — skipping"
fi

if command -v isort &>/dev/null; then
  isort "$FILE_PATH" --quiet && echo "  isort ✓"
else
  echo "  isort not found — skipping"
fi

exit 0
