#!/bin/bash
# PreToolUse Hook - Logs every tool call before it executes
#
# Claude Code passes a JSON payload via stdin with:
#   tool_name  - name of the tool being called (e.g. "Bash", "Read", "Edit")
#   tool_input - the parameters Claude is passing to the tool
#
# Exit codes:
#   0  = allow the tool to proceed (default)
#   2  = block the tool; anything on stdout is shown to Claude as the reason

# Read the JSON payload from stdin
INPUT=$(cat)

# Parse tool name and input using grep (no jq dependency)
TOOL_NAME=$(echo "$INPUT" | grep -o '"tool_name":"[^"]*"' | sed 's/"tool_name":"//;s/"//')
TOOL_INPUT=$(echo "$INPUT" | grep -o '"tool_input":{[^}]*}' | sed 's/"tool_input"://')
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Log to a file for learning/inspection
LOG_FILE="$(dirname "$0")/../logs/tool_calls.log"
mkdir -p "$(dirname "$LOG_FILE")"

echo "[$TIMESTAMP] TOOL: $TOOL_NAME | INPUT: $TOOL_INPUT" >> "$LOG_FILE"

# Exit 0 = allow the tool to run
exit 0
