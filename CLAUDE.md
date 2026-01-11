# CLAUDE.md

This file provides guidance to Claude Code when working with this repository.

---

## MetaSaver Constitution (MANDATORY)

These rules apply to EVERY response in this repository:

| #   | Rule                                                                     |
| --- | ------------------------------------------------------------------------ |
| 1   | ALWAYS use MetaSaver agents for implementation (coder, tester, reviewer) |
| 2   | ALWAYS spawn agents in parallel when tasks are independent               |
| 3   | ALWAYS follow /build or /ms workflow for any code changes                |
| 4   | ALWAYS get user approval (HITL) before marking work complete             |
| 5   | ALWAYS update story files during execution (status, acceptance criteria) |
| 6   | ALWAYS use AskUserQuestion tool for user interactions                    |

**Session Recovery:** After any crash or interruption, type `/session` to restore workflow context.

---

## CRITICAL: Author Agent Requirements (metasaver-marketplace repo ONLY)

**NEVER edit agent, skill, or command files directly in this repository.**

This is the plugin source repository. ALL modifications to plugin components MUST go through author agents:

| File Type | Location Pattern           | MUST Use Agent                              |
| --------- | -------------------------- | ------------------------------------------- |
| Agents    | `plugins/*/agents/**/*.md` | `core-claude-plugin:generic:agent-author`   |
| Skills    | `plugins/*/skills/**/*.md` | `core-claude-plugin:generic:skill-author`   |
| Commands  | `plugins/*/commands/*.md`  | `core-claude-plugin:generic:command-author` |

**BEFORE any edit to these files, STOP and spawn the appropriate author agent.**

```
# Creating or updating a SKILL:
Task: subagent_type="core-claude-plugin:generic:skill-author"

# Creating or updating an AGENT:
Task: subagent_type="core-claude-plugin:generic:agent-author"

# Creating or updating a COMMAND:
Task: subagent_type="core-claude-plugin:generic:command-author"
```

**Why:** Author agents enforce standards, validate structure, handle marketplace registration, and ensure consistency. Direct edits bypass all quality gates.

**The ONLY exception:** Fixing typos in a single line (use Edit tool directly).

---

## MetaSaver Principles

| #   | Principle        | Rule                                           |
| --- | ---------------- | ---------------------------------------------- |
| 1   | **Minimal**      | Change only what must change                   |
| 2   | **Root Cause**   | Fix the source (address symptoms at origin)    |
| 3   | **Read First**   | Understand existing code before modifying      |
| 4   | **Verify**       | Confirm it works before marking done           |
| 5   | **Exact Scope**  | Do precisely what was asked                    |
| 6   | **Root Scripts** | Always run npm/pnpm scripts from monorepo root |

## Always-On Behavior

**See MetaSaver Constitution (MANDATORY) above for mandatory workflow rules.**

Use MetaSaver agents for optimal workflow tracking:

**Command Selection:**

| Task Type                  | Command      |
| -------------------------- | ------------ |
| Quick fixes, small tasks   | `/ms`        |
| Large features, multi-epic | `/build`     |
| PRD creation only          | `/architect` |
| Questions about code       | `/qq`        |
| Config/standards audits    | `/audit`     |

**Questions to user:** Always use AskUserQuestion tool.

See [/ms Command Target State](docs/architecture/ms-command-target-state.md) for workflow details.

**Agent Replacement Table:**

| Core Agent        | Use Instead                                        |
| ----------------- | -------------------------------------------------- |
| `Explore`         | `core-claude-plugin:generic:code-explorer`         |
| `Plan`            | `core-claude-plugin:generic:architect`             |
| `general-purpose` | Task-specific agent (see `/skill agent-selection`) |

**Auto-invoke skills:**

- Before reading code: `serena-code-reading`
- After modifying files: `repomix-cache-refresh`

---

## Repository Overview

**MetaSaver Official Marketplace** - A Claude Code marketplace containing plugins with agents, skills, and commands.

- **Repository Type:** Claude Code marketplace (not a code project)
- **Primary Plugin:** `@metasaver/core-claude-plugin`

## Repository Structure

```
metasaver-marketplace/
├── .claude-plugin/
│   └── marketplace.json        # Marketplace manifest
├── plugins/
│   └── metasaver-core/         # Plugin root
│       ├── .claude-plugin/
│       │   └── plugin.json     # Plugin manifest
│       ├── agents/
│       │   ├── generic/        # Standalone agents
│       │   ├── domain/         # Domain-specific agents
│       │   └── config/         # Config file agents
│       ├── skills/
│       │   ├── cross-cutting/  # Shared skills
│       │   ├── domain/         # Domain skills
│       │   └── config/         # Config skills
│       ├── commands/           # Slash commands
│       ├── templates/          # Template libraries
│       ├── settings.json
│       └── .mcp.json
├── README.md
└── LICENSE
```

## Key Standards

- `.claude-plugin/` directory required for Claude Code discovery
- Plugin components (`agents/`, `skills/`, `commands/`) at plugin root, NOT in `.claude/`
- Agent/skill files use `.md` extension with frontmatter format

## File Formats

### Agent/Skill Files

```markdown
---
name: agent-name
description: Brief description
---

# Agent Title

[Prompt content]
```

### Manifest Files

**marketplace.json**: `name`, `owner`, `metadata`, `plugins[]`
**plugin.json**: `name`, `description`, `version`, `author`, `hooks`

### Marketplace Plugin Entry (CRITICAL)

Skills MUST be explicitly listed in marketplace.json for discovery:

```json
{
  "plugins": [
    {
      "name": "core-claude-plugin",
      "source": "./plugins/metasaver-core",
      "strict": false,
      "skills": ["./skills/workflow-steps/analysis-phase", "./skills/domain/monorepo-audit"]
    }
  ]
}
```

**Key rules:**

- `skills[]` array is REQUIRED for skill discovery (no auto-discovery)
- Skill paths are RELATIVE to `source` directory
- `strict: false` recommended for flexibility
- Agents and commands auto-discover from `./agents/` and `./commands/`

## Agent Organization

- **generic/**: Standalone agents (architect, coder, tester, reviewer, etc.)
- **domain/**: Organized by subdirectory (backend/, frontend/, database/, testing/, monorepo/)
- **config/**: Organized by category (build-tools/, code-quality/, version-control/, workspace/)

## Skill Organization

- **cross-cutting/**: Shared utilities used by multiple agents
- **domain/**: Domain-specific workflows
- **config/**: Configuration-related patterns

## Development

**No build process** - this is a documentation/configuration repository.

**Validation:**

```bash
# Validate JSON
cat .claude-plugin/marketplace.json | jq
cat plugins/metasaver-core/.claude-plugin/plugin.json | jq

# List agents/skills
find plugins/metasaver-core/{agents,skills} -name "*.md"
```

## Conventions

- File naming: kebab-case with `.md` extension
- Paths: forward slashes (cross-platform)
- Never commit `.env` or `.npmrc` files

## Version Management

Versions are **auto-bumped** by GitHub Actions on every push to `master`.

- **Patch versions**: Automatic (on any change to `plugins/`, `commands/`, or `marketplace.json`)
- **Major/Minor versions**: Manual update to `plugin.json` and `marketplace.json`

**Version files:**

- `plugins/metasaver-core/.claude-plugin/plugin.json`
- `.claude-plugin/marketplace.json` (plugin version field)
