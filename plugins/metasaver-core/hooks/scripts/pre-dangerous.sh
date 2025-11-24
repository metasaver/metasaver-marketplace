#!/usr/bin/env bash
# PreToolUse: Block dangerous bash commands

set -euo pipefail

INPUT=$(cat)

# Extract values (works with or without jq)
if command -v jq &>/dev/null; then
  TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty' 2>/dev/null)
  COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null)
else
  TOOL_NAME=$(echo "$INPUT" | grep -o '"tool_name"[[:space:]]*:[[:space:]]*"[^"]*"' | cut -d'"' -f4 || echo "")
  COMMAND=$(echo "$INPUT" | grep -o '"command"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | cut -d'"' -f4 || echo "")
fi

# Only check Bash tool
[[ "$TOOL_NAME" == "Bash" ]] || exit 0
[[ -n "$COMMAND" ]] || exit 0

# Check for dangerous patterns
if echo "$COMMAND" | grep -qE '(rm\s+-rf\s+/[^a-zA-Z]|DROP\s+DATABASE|git\s+push.*--force)'; then
  cat >&2 << EOF
{
  "decision": "block",
  "reason": "⚠️  Dangerous command blocked!\n\nCommand: ${COMMAND:0:100}\n\nThis command could cause data loss. Please review carefully."
}
EOF
  exit 2
fi

exit 0
