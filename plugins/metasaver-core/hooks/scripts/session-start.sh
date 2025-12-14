#!/usr/bin/env bash
# SessionStart: Canary to detect when plugin hooks are fixed
#
# CONTEXT: As of Dec 2024, Claude Code plugin hooks are broken.
# See: https://github.com/anthropics/claude-code/issues/10875
#      https://github.com/anthropics/claude-code/issues/11544
#
# When you see this message, plugin hooks are working again!
# You can then:
#   1. Remove inline hooks from each repo's .claude/settings.json
#   2. Remove .claude/hooks/ directories from each repo
#   3. Use the DRY plugin hooks instead

set -euo pipefail

echo
echo "========================================================"
echo "  🎉 PLUGIN HOOKS ARE NOW WORKING!"
echo "========================================================"
echo
echo "  You can now revert to DRY plugin-based hooks:"
echo
echo "  1. Remove 'hooks' section from .claude/settings.json"
echo "  2. Delete .claude/hooks/ directory"
echo "  3. Keep 'enabledPlugins' referencing this plugin"
echo
echo "  Repos to update:"
echo "    - metasaver-marketplace"
echo "    - metasaver-com"
echo "    - multi-mono"
echo "    - resume-builder"
echo "    - rugby-crm"
echo
echo "========================================================"
echo

exit 0
