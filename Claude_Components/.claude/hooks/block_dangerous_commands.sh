#!/bin/bash
# PreToolUse Hook - Blocks dangerous bash commands before they execute
#
# Exit codes:
#   0 = allow the tool to proceed
#   2 = block the tool; stdout is shown to Claude as the reason

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | grep -o '"tool_name":"[^"]*"' | sed 's/"tool_name":"//;s/"//')

# Only check Bash tool calls
if [[ "$TOOL_NAME" != "Bash" ]]; then
    exit 0
fi

COMMAND=$(echo "$INPUT" | grep -o '"command":"[^"]*"' | sed 's/"command":"//;s/"//')

# List of dangerous patterns to block
DANGEROUS_PATTERNS=(
    "rm -rf"
    "rm -fr"
    "git reset --hard"
    "git clean -f"
    "git push --force"
    "git push -f"
    "chmod -R 777"
    "dd if="
    "mkfs"
    "> /dev/sd"
    "shutdown"
    "reboot"
    "format"
)

for PATTERN in "${DANGEROUS_PATTERNS[@]}"; do
    if echo "$COMMAND" | grep -qi "$PATTERN"; then
        echo "Blocked: dangerous command detected — '$PATTERN' is not allowed."
        exit 2
    fi
done

exit 0
