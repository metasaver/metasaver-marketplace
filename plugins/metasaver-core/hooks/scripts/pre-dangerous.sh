#!/usr/bin/env bash
# PreToolUse: Block dangerous bash commands
# MULTI-MONO ENFORCEMENT: Use root scripts only!

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

# === MULTI-MONO ENFORCEMENT ===
# Block direct node_modules/pnpm-lock manipulation - MUST use pnpm cb
if echo "$COMMAND" | grep -qE '(rm\s+(-rf?|--recursive)?\s*[^|;]*node_modules|rm\s+(-f)?\s*[^|;]*pnpm-lock\.yaml)'; then
  cat >&2 << EOF
{
  "decision": "block",
  "reason": "🚫 BLOCKED: Direct node_modules/pnpm-lock deletion!\n\nCommand: ${COMMAND:0:100}\n\nUSE INSTEAD: pnpm cb (clean-and-build)\n\nThis script properly cleans, installs, and builds the entire monorepo."
}
EOF
  exit 2
fi

# Block standalone pnpm install (outside of root scripts) - MUST use pnpm cb
# Allow: pnpm add <package> (proper way to add dependencies)
# Allow: pnpm build, pnpm test, pnpm lint, pnpm clean, etc.
# Block: pnpm install, pnpm i (without package name)
if echo "$COMMAND" | grep -qE '\bpnpm\s+(install|i)(\s|$|&&|\||;)' && ! echo "$COMMAND" | grep -qE '\bpnpm\s+add\b'; then
  cat >&2 << EOF
{
  "decision": "block",
  "reason": "🚫 BLOCKED: Direct pnpm install!\n\nCommand: ${COMMAND:0:100}\n\nUSE INSTEAD: pnpm cb (clean-and-build)\n\nNote: 'pnpm add <package>' is allowed for adding dependencies."
}
EOF
  exit 2
fi

# Block npm publish (any registry) - MUST use pnpm publish or pnpm bp
if echo "$COMMAND" | grep -qE '\bnpm\s+(publish|unpublish|dist-tag|version)\b'; then
  cat >&2 << EOF
{
  "decision": "block",
  "reason": "🚫 BLOCKED: Direct npm publish!\n\nCommand: ${COMMAND:0:100}\n\nUSE INSTEAD:\n  - pnpm publish (publish to Verdaccio)\n  - pnpm bp (build and publish)\n\nThese scripts handle workspace:* dependency transformation correctly."
}
EOF
  exit 2
fi

# === ORIGINAL DANGEROUS PATTERNS ===
# Block git write operations and destructive commands
if echo "$COMMAND" | grep -qE '(rm\s+-rf\s+/[^a-zA-Z]|DROP\s+DATABASE|git\s+(add|commit|push|pull|rebase|reset|merge|cherry-pick|revert|checkout|switch|restore|stash|am|apply))'; then
  cat >&2 << EOF
{
  "decision": "block",
  "reason": "⚠️  Git/dangerous command blocked!\n\nCommand: ${COMMAND:0:100}\n\nClaude is BANNED from git operations unless explicitly requested by user.\nAllowed git commands: status, log, diff, show, branch -l, fetch, reflog"
}
EOF
  exit 2
fi

exit 0
