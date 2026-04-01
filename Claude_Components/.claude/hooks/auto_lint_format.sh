#!/bin/bash
# PostToolUse Hook - Auto lint and format Python files after Edit or Write
#
# Runs:
#   black  - code formatter
#   flake8 - linter (style + error checks)
#
# Exit codes:
#   0 = success (always allow, just report issues)

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | grep -o '"tool_name":"[^"]*"' | sed 's/"tool_name":"//;s/"//')

# Only trigger on Edit or Write
if [[ "$TOOL_NAME" != "Edit" && "$TOOL_NAME" != "Write" ]]; then
    exit 0
fi

# Extract the file path
FILE_PATH=$(echo "$INPUT" | grep -o '"file_path":"[^"]*"' | sed 's/"file_path":"//;s/"//')

# Only process Python files
if [[ "$FILE_PATH" != *.py ]]; then
    exit 0
fi

echo ">>> Auto lint/format: $FILE_PATH"

# Run black formatter
if command -v black &>/dev/null; then
    echo "[black] formatting..."
    black "$FILE_PATH" 2>&1
else
    echo "[black] not found — skipping (install with: pip install black)"
fi

# Run flake8 linter
if command -v flake8 &>/dev/null; then
    echo "[flake8] linting..."
    flake8 "$FILE_PATH" 2>&1
    if [[ $? -eq 0 ]]; then
        echo "[flake8] no issues found"
    fi
else
    echo "[flake8] not found — skipping (install with: pip install flake8)"
fi

exit 0
