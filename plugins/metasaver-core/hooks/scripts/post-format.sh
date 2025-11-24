#!/usr/bin/env bash
# PostToolUse: Auto-format files with prettier after Write/Edit

set -euo pipefail

INPUT=$(cat)

# Extract values (works with or without jq)
if command -v jq &>/dev/null; then
  TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty' 2>/dev/null)
  FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.path // empty' 2>/dev/null)
else
  # Fallback: Simple grep-based extraction
  TOOL_NAME=$(echo "$INPUT" | grep -o '"tool_name"[[:space:]]*:[[:space:]]*"[^"]*"' | cut -d'"' -f4 || echo "")
  FILE_PATH=$(echo "$INPUT" | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | cut -d'"' -f4 || echo "")
  [[ -z "$FILE_PATH" ]] && FILE_PATH=$(echo "$INPUT" | grep -o '"path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | cut -d'"' -f4 || echo "")
fi

# Only run on Write/Edit operations
[[ "$TOOL_NAME" =~ ^(Write|Edit)$ ]] || exit 0
[[ -n "$FILE_PATH" ]] || exit 0
[[ -f "$FILE_PATH" ]] || exit 0

# Run prettier silently (exit 0 even if fails)
npx prettier --write "$FILE_PATH" 2>/dev/null || true

exit 0
