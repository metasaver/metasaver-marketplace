# CLAUDE.md

This file provides guidance to Claude Code when working with this repository.

## Repository Overview

**MetaSaver Official Marketplace** - A Claude Code marketplace containing plugins with agents, skills, and commands.

- **Repository Type:** Claude Code marketplace (not a code project)
- **Primary Plugin:** `@metasaver/core-claude-plugin`

## Repository Structure

```
claude-marketplace/
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
      "skills": [
        "./skills/cross-cutting/tool-check",
        "./skills/domain/monorepo-audit"
      ]
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

**Current Versions:**

- Marketplace: `1.7.1`
- Plugin: `1.7.1`

**When updating versions:**

1. Update `plugins/metasaver-core/.claude-plugin/plugin.json`
2. Update `.claude-plugin/marketplace.json` (both metadata.version AND plugin version)
3. Update this file (CLAUDE.md)
4. Update README.md if needed

**Bump versions on EVERY change** - even small config updates.
