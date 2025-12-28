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
# Block ALL git operations that modify history or state (except read-only commands like status, log, diff, show, branch -l)
if echo "$COMMAND" | grep -qE '(rm\s+-rf\s+/[^a-zA-Z]|DROP\s+DATABASE|git\s+(add|commit|push|pull|rebase|reset|merge|cherry-pick|revert|checkout|switch|restore|stash|am|apply)|npm\s+(publish|unpublish|dist-tag|version))'; then
  cat >&2 << EOF
{
  "decision": "block",
  "reason": "⚠️  Git/dangerous command blocked!\n\nCommand: ${COMMAND:0:100}\n\nClaude is BANNED from git operations unless explicitly requested by user.\nAllowed git commands: status, log, diff, show, branch -l, fetch, reflog"
}
EOF
  exit 2
fi

exit 0
