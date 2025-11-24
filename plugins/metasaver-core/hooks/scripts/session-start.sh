#!/usr/bin/env bash
# SessionStart: Show project context when session begins

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

echo
echo "📋 Project: $PROJECT_NAME"
echo
echo "Key Reminders:"
echo "  • Root .env for all config (never edit .env/.npmrc directly!)"
echo "  • Use workspace: protocol for cross-package deps"
echo "  • Multi-mono pattern - check CLAUDE.md for architecture"
echo
echo "✅ Session started"
echo

exit 0
