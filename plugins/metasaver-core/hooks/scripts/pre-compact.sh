#!/usr/bin/env bash
# PreCompact: Remind about key patterns before context compacts

set -euo pipefail

# Read input and extract matcher (works with or without jq)
INPUT=$(cat)
MATCHER="auto"
if command -v jq &>/dev/null; then
  MATCHER=$(echo "$INPUT" | jq -r '.matcher // "auto"' 2>/dev/null || echo "auto")
fi

echo
echo "🔄 Context Compacting ($MATCHER)"
echo
echo "Critical Reminders:"
echo "  • GOLDEN RULE: Batch ALL operations in ONE message"
echo "  • Use Serena symbolic tools (90%+ token savings)"
echo "  • Check CLAUDE.md for agent patterns and /ms routing"
echo
echo "✅ Ready for compact"
echo

exit 0
