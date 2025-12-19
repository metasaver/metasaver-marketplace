# MetaSaver Plugin Hooks

## Canonical Source of Truth

All hook definitions and scripts in this directory are the **single source of truth** for MetaSaver hooks.

## Current Status

**Plugin hooks are broken** - See GitHub issues:

- [#12151](https://github.com/anthropics/claude-code/issues/12151) - Plugin hook output not passed to agent
- [#13155](https://github.com/anthropics/claude-code/issues/13155) - Prompt-based hooks silently ignored in plugins

## Workaround

Until Claude Code fixes plugin hooks, hooks must be **temporarily duplicated** to each consumer repo:

1. Copy hook scripts to `<repo>/.claude/hooks/`
2. Add hook definitions to `<repo>/.claude/settings.json`

### Consumer Repos with Hooks Deployed

- `rugby-crm` - All hooks deployed
- `metasaver-com` - All hooks deployed
- `multi-mono` - All hooks deployed
- `resume-builder` - All hooks deployed

## Hook Inventory

| Hook Type                 | Script                | Purpose                                   |
| ------------------------- | --------------------- | ----------------------------------------- |
| UserPromptSubmit          | `ms-reminder-hook.js` | Reminds users about /ms for complex tasks |
| SessionStart              | `session-start.sh`    | Session initialization                    |
| PreToolUse (Bash)         | `pre-dangerous.sh`    | Dangerous command detection               |
| PreToolUse (Read)         | `pre-read-protect.sh` | Sensitive file protection                 |
| PreToolUse (Write\|Edit)  | `pre-env-protect.sh`  | Environment file protection               |
| PostToolUse (Write\|Edit) | `post-format.sh`      | Auto-formatting                           |
| PreCompact                | `pre-compact.sh`      | Context compaction prep                   |
| Stop                      | (inline)              | Session summary                           |

## Files

- `hooks.json` - Canonical hook definitions (plugin format)
- `scripts/` - Hook script implementations

## When Plugin Hooks Are Fixed

Once Claude Code fixes the plugin hook issues:

1. Remove hook scripts from consumer repos
2. Remove hook definitions from consumer repo settings.json
3. Plugin hooks will work automatically via `enabledPlugins`

Track progress: https://github.com/anthropics/claude-code/issues/12151
