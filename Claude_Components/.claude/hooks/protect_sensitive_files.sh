#!/bin/bash
# PreToolUse Hook - Blocks edits to sensitive/critical files
#
# Intercepts Edit, Write, and Bash tool calls that attempt to
# modify sensitive files like .env, secrets, or prod configs.
#
# Exit codes:
#   0 = allow the tool to proceed
#   2 = block the tool; stdout is shown to Claude as the reason

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | grep -o '"tool_name":"[^"]*"' | sed 's/"tool_name":"//;s/"//')

# Sensitive filename patterns to protect
SENSITIVE_PATTERNS=(
    "\.env$"
    "\.env\."
    "secrets"
    "credentials"
    "id_rsa"
    "id_ed25519"
    "\.pem$"
    "\.key$"
    "\.pfx$"
    "\.p12$"
    "appsettings\.prod"
    "appsettings\.production"
    "web\.prod\.config"
    "web\.release\.config"
    "terraform\.tfvars"
    "\.aws/credentials"
    "\.kube/config"
)

check_path() {
    local FILE_PATH="$1"
    for PATTERN in "${SENSITIVE_PATTERNS[@]}"; do
        if echo "$FILE_PATH" | grep -qi "$PATTERN"; then
            echo "Blocked: '$FILE_PATH' matches sensitive file pattern '$PATTERN'. Modify this file manually if intended."
            exit 2
        fi
    done
}

# Check Edit and Write tools via file_path
if [[ "$TOOL_NAME" == "Edit" || "$TOOL_NAME" == "Write" ]]; then
    FILE_PATH=$(echo "$INPUT" | grep -o '"file_path":"[^"]*"' | sed 's/"file_path":"//;s/"//')
    check_path "$FILE_PATH"
fi

# Check Bash tool for redirect writes or common edit commands targeting sensitive files
if [[ "$TOOL_NAME" == "Bash" ]]; then
    COMMAND=$(echo "$INPUT" | grep -o '"command":"[^"]*"' | sed 's/"command":"//;s/"//')
    for PATTERN in "${SENSITIVE_PATTERNS[@]}"; do
        if echo "$COMMAND" | grep -qi "$PATTERN"; then
            echo "Blocked: Bash command references sensitive file pattern '$PATTERN'. Perform this action manually if intended."
            exit 2
        fi
    done
fi

exit 0
