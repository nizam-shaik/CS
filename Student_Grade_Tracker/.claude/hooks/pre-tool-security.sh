#!/usr/bin/env bash
# PreToolUse(Bash) hook — blocks dangerous commands before execution
# Claude Code passes the tool input JSON via stdin

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | python -c "import sys,json; print(json.load(sys.stdin).get('command',''))" 2>/dev/null)

BLOCKED_PATTERNS=(
  "rm -rf"
  "git push --force"
  "DROP TABLE"
  "DROP DATABASE"
  "truncate"
  "mkfs"
  "dd if="
  "> /dev/sd"
  "chmod -R 777"
  "curl.*|.*bash"
  "wget.*|.*bash"
)

for pattern in "${BLOCKED_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qiE "$pattern"; then
    echo "BLOCKED: dangerous command pattern detected: '$pattern'" >&2
    echo "Command: $COMMAND" >&2
    exit 2  # exit 2 = block the tool call and surface error to Claude
  fi
done

exit 0
