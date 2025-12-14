#!/usr/bin/env bash
# PreToolUse: Block reading .env and .npmrc files to prevent secret leaks

set -euo pipefail

INPUT=$(cat)

# Extract values (works with or without jq)
if command -v jq &>/dev/null; then
  TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty' 2>/dev/null)
  FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.path // empty' 2>/dev/null)
else
  TOOL_NAME=$(echo "$INPUT" | grep -o '"tool_name"[[:space:]]*:[[:space:]]*"[^"]*"' | cut -d'"' -f4 || echo "")
  FILE_PATH=$(echo "$INPUT" | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | cut -d'"' -f4 || echo "")
  [[ -z "$FILE_PATH" ]] && FILE_PATH=$(echo "$INPUT" | grep -o '"path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | cut -d'"' -f4 || echo "")
fi

# Only check Read operations
[[ "$TOOL_NAME" == "Read" ]] || exit 0
[[ -n "$FILE_PATH" ]] || exit 0

# Block .env and .npmrc (but allow .example and .template variants)
if [[ "$FILE_PATH" =~ \.(env|npmrc)$ ]]; then
  if [[ ! "$FILE_PATH" =~ \.(example|template) ]]; then
    cat >&2 << EOF
{
  "decision": "block",
  "reason": "🔒 Blocked: Cannot read $FILE_PATH!\n\nThis file may contain secrets. Reading it could leak sensitive data to the conversation context."
}
EOF
    exit 2
  fi
fi

exit 0
