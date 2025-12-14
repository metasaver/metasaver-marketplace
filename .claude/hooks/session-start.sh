#!/usr/bin/env bash
# SessionStart: Show project context (INLINE WORKAROUND)
#
# NOTE: This is an inline hook workaround because plugin hooks are broken.
# When plugin hooks are fixed, this file can be deleted.
# The plugin's session-start.sh will show a message when that happens.

set -euo pipefail

# Get project name (works with or without jq)
PROJECT_NAME="Unknown"
if [[ -f "package.json" ]]; then
  if command -v jq &>/dev/null; then
    PROJECT_NAME=$(jq -r '.name // "Unknown"' package.json 2>/dev/null || echo "Unknown")
  else
    PROJECT_NAME=$(grep -o '"name"[[:space:]]*:[[:space:]]*"[^"]*"' package.json 2>/dev/null | head -1 | cut -d'"' -f4 || echo "Unknown")
  fi
fi

# Silent output - goes to Claude context, not terminal
# Keep it minimal since user won't see it anyway
echo "Project: $PROJECT_NAME | Hooks: inline workaround (plugin hooks broken)"

exit 0
