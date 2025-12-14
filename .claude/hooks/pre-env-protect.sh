#!/usr/bin/env bash
# PreToolUse: Block edits to .env and .npmrc files

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

# Only check Write/Edit operations
[[ "$TOOL_NAME" =~ ^(Write|Edit)$ ]] || exit 0
[[ -n "$FILE_PATH" ]] || exit 0

# Block .env and .npmrc (but allow .example and .template variants)
if [[ "$FILE_PATH" =~ \.(env|npmrc)$ ]]; then
  if [[ ! "$FILE_PATH" =~ \.(example|template) ]]; then
    cat >&2 << EOF
{
  "decision": "block",
  "reason": "⚠️  Blocked: Never edit $FILE_PATH directly!\n\nThese files are auto-generated. Use .example or .template files instead."
}
EOF
    exit 2
  fi
fi

exit 0
