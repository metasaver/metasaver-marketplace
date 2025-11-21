# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is the **MetaSaver Official Marketplace** - a Claude Code marketplace containing plugins with specialized agents, skills, and commands for professional multi-monorepo development.

**Repository Type:** Claude Code marketplace (not a code project)
**Primary Plugin:** `@metasaver/core-claude-plugin` - Complete agent/skill system for multi-mono architecture

## Repository Structure

Follows the **official Claude Code marketplace standard**:

```
claude-marketplace/
├── .claude-plugin/
│   └── marketplace.json        # REQUIRED: Marketplace manifest
├── plugins/
│   └── metasaver-core/         # Plugin root
│       ├── .claude-plugin/
│       │   └── plugin.json     # REQUIRED: Plugin manifest
│       ├── agents/             # At plugin root (NOT in .claude/)
│       │   ├── generic/        # 13 generic agents
│       │   ├── domain/         # 9 domain agents (organized by domain)
│       │   └── config/         # 26 config agents (organized by category)
│       ├── skills/             # At plugin root (NOT in .claude/)
│       │   ├── cross-cutting/  # 6 cross-cutting skills
│       │   ├── domain/         # 6 domain skills
│       │   └── config/         # 17 config skills with templates
│       ├── commands/           # At plugin root (NOT in .claude/)
│       │   ├── audit.md
│       │   ├── build.md
│       │   └── ms.md
│       ├── templates/          # Template libraries
│       │   ├── common/
│       │   ├── config/
│       │   └── github/
│       ├── settings.json       # Plugin settings with hooks
│       └── .mcp.json          # MCP server configuration
├── README.md
└── LICENSE
```

**CRITICAL Standards:**
- `.claude-plugin/` directory is REQUIRED by Claude Code
- `marketplace.json` MUST be in `.claude-plugin/` (not at root)
- Plugin components (`agents/`, `skills/`, `commands/`) MUST be at plugin root
- NEVER use `.claude/` directory for marketplace plugins (that's for project configs only)
- Agent/skill files MUST use `.md` extension and follow frontmatter format

## Working with Marketplace Files

### Manifest Files

**marketplace.json** (`.claude-plugin/marketplace.json`):
- Required fields: `name`, `owner`, `metadata`, `plugins[]`
- Plugin entries specify `name`, `source`, `description`, `version`, `category`, `keywords`
- Source paths are relative to marketplace root

**plugin.json** (`plugins/*/​.claude-plugin/plugin.json`):
- Required fields: `name`, `description`, `version`, `author`
- Must match corresponding entry in marketplace.json

### Agent Files

Location: `plugins/metasaver-core/agents/{generic,domain,config}/`

Format:
```markdown
---
name: agent-name
description: Brief description
---
# Agent Title
[Agent prompt content]
```

**Organization:**
- **generic/**: Standalone agents (architect, coder, tester, etc.)
- **domain/**: Organized by domain subdirectories (backend/, frontend/, database/, testing/, monorepo/)
- **config/**: Organized by category subdirectories (build-tools/, code-quality/, version-control/, workspace/)

### Skill Files

Location: `plugins/metasaver-core/skills/{cross-cutting,domain,config}/`

Same frontmatter format as agents. Skills are reusable workflows/patterns that agents invoke.

### Command Files

Location: `plugins/metasaver-core/commands/`

Commands define slash commands (`/audit`, `/build`, `/ms`) with routing logic and execution instructions.

## Development Commands

**Repository Inspection:**
```bash
# List marketplace structure
ls -R .claude-plugin/ plugins/

# Validate JSON manifests
cat .claude-plugin/marketplace.json | jq
cat plugins/metasaver-core/.claude-plugin/plugin.json | jq

# Search agents/skills
find plugins/metasaver-core/{agents,skills} -name "*.md"
```

**Git Workflow:**
```bash
git status
git diff
git log --oneline -10
```

**No Build Process:**
This is a documentation/configuration repository. There are no build, test, or lint commands.

## Key Architectural Patterns

### Multi-Mono Architecture

The plugin supports **producer-consumer monorepo** patterns:
- **Producer monorepos**: Create reusable packages (UI components, shared utilities)
- **Consumer monorepos**: Build applications using producer packages
- Agents understand cross-monorepo dependencies and workspace relationships

### Agent Categories & Responsibilities

**Generic Agents (13):**
- High-level workers (architect, business-analyst, project-manager)
- Implementation specialists (coder, backend-dev, devops)
- Quality gatekeepers (reviewer, tester, code-quality-validator)
- Meta-level (agent-author for creating/modifying agents)
- Analysis specialists (security-engineer, performance-engineer, root-cause-analyst)

**Domain Agents (9):**
- All support **Build** and **Audit** modes
- Backend: data-service-agent, integration-service-agent
- Database: prisma-database-agent
- Frontend: react-component-agent, mfe-host-agent, mfe-remote-agent
- Testing: unit-test-agent, integration-test-agent
- Monorepo: monorepo-setup-agent

**Config Agents (26):**
- All support **Build** and **Audit** modes
- Build Tools (8): docker-compose, vite, vitest, turbo, pnpm-workspace, etc.
- Code Quality (3): eslint, prettier, editorconfig
- Version Control (5): gitignore, gitattributes, husky, commitlint, github-workflow
- Workspace (10): typescript, vscode, readme, package.json, .nvmrc, etc.

### Skills vs Agents

**Agents = Workers** (who does the work):
- Build or audit domain-specific things
- Execute actual implementation

**Skills = Utilities** (how work gets done):
- Reusable workflows and patterns
- Invoked by multiple agents
- Examples: audit-workflow, config-validation, workflow-orchestration

### Intelligent Routing

The `/ms` command analyzes complexity and routes automatically:
- **Score ≥30**: Multi-agent orchestration (BA → Architect → PM → Workers → Validator → BA sign-off)
- **Score 10-29**: Coordinated swarm (Architect → PM → Workers → Reviewer)
- **Score <10**: Enhanced Claude with appropriate thinking level

Complexity scoring based on keywords, scope, and technical factors.

## Plugin Settings & Hooks

`plugins/metasaver-core/settings.json` defines:

**Permissions:**
- Allowed bash commands (git, npm, jq, node, ls, cat, etc.)
- File access patterns

**Hooks:**
- **PostToolUse**: Auto-format files after Write/Edit with Prettier
- **PreCompact**: Remind about available agents and golden rules
- **Stop**: Display session summary

**MCP Integration:**
- `enabledMcpjsonServers`: Configured MCP servers
- `.mcp.json`: Recommended servers (serena, recall, sequential-thinking, Context7, chrome-devtools)

## Common Workflows

### Adding a New Agent

1. Create `.md` file in appropriate directory:
   - Generic: `plugins/metasaver-core/agents/generic/`
   - Domain: `plugins/metasaver-core/agents/domain/{backend,frontend,database,testing,monorepo}/`
   - Config: `plugins/metasaver-core/agents/config/{build-tools,code-quality,version-control,workspace}/`

2. Follow frontmatter format:
```markdown
---
name: agent-name
description: Brief description
---
# Agent Title
[Agent prompt]
```

3. Update documentation (README.md) to reflect new agent

### Adding a New Skill

Same process as agents, but in `plugins/metasaver-core/skills/{cross-cutting,domain,config}/`

### Modifying Commands

Edit files in `plugins/metasaver-core/commands/`:
- `audit.md`: Natural language audit routing
- `build.md`: Build feature orchestration
- `ms.md`: MetaSaver intelligent router

### Version Management

When updating versions:
1. Update `plugins/metasaver-core/.claude-plugin/plugin.json`
2. Update `.claude-plugin/marketplace.json` (plugin entry)
3. Update README.md version references
4. Document changes in README "Version History" section

## Important Conventions

### File Naming
- Agent/skill files: kebab-case with `.md` extension
- Manifests: `marketplace.json`, `plugin.json`
- Settings: `settings.json`, `.mcp.json`

### Directory Structure
- NEVER mix plugins and marketplace files at root
- NEVER put agent/skill/command files in `.claude/` (that's for projects, not plugins)
- Keep config agents organized by category subdirectories

### Content Guidelines
- Agent descriptions: Brief, action-oriented
- Skill descriptions: Pattern/workflow focused
- Command descriptions: Explain routing logic and triggers
- Use frontmatter metadata consistently

### Token Efficiency Guidelines

**CRITICAL: Agents and skills should promote Serena usage for 90-95% token savings.**

**When writing agents/skills that involve code reading:**

**Token Savings:**
```
❌ Traditional: Read entire file → 2,000 lines = ~5,000 tokens
✅ Serena:      get_symbols_overview → ~200 tokens (96% savings)
                find_symbol (no body) → ~50 tokens
                find_symbol (with body) → ~100 tokens
                Total: ~350 tokens (93% savings)
```

**Mandatory patterns for agent instructions:**
1. **Instruct agents to use Serena's progressive disclosure:**
   - "Use get_symbols_overview before reading any file"
   - "Only use find_symbol(include_body=true) for symbols you need"
   - "NEVER read entire files unless absolutely necessary"

2. **Include Serena workflow in agent prompts:**
   ```markdown
   Before reading code:
   1. Use get_symbols_overview to see file structure
   2. Use find_symbol (without body) for signatures
   3. Use find_symbol (with body) only for needed symbols
   ```

3. **Reference mcp-tool-selection skill:**
   - Updated with comprehensive token efficiency guidance
   - Shows 90-95% token reduction examples
   - Includes progressive disclosure pattern

**Key Serena tools to mention in agent docs:**
- `get_symbols_overview` - File outline (200 tokens vs 5,000)
- `find_symbol` - Symbol-level reading (100 tokens vs 5,000)
- `find_referencing_symbols` - Find usage (500 tokens vs 20,000)
- `replace_symbol_body` - Edit without full file read
- `insert_after_symbol` / `insert_before_symbol` - Precise insertion

### Cross-Platform Compatibility
- All paths use forward slashes
- Settings configured for Windows WSL + Linux
- No platform-specific commands in agent prompts

## Security Considerations

From `.gitignore`:
- NEVER commit `.env`, `.npmrc` files (security critical)
- Auto-generated audit reports excluded from git
- Cache and build artifacts excluded

## Documentation Standards

**README.md Structure:**
1. Overview with badges (license, agents count, skills count)
2. Installation instructions
3. Complete agent/skill inventory with categorization
4. Architecture explanation (multi-mono, agents vs skills)
5. MCP server configuration
6. Repository structure
7. Version history

**Agent/Skill Documentation:**
- Clear role definition
- Mode support (Build/Audit where applicable)
- Tool access
- Coordination patterns

## Testing & Validation

**No automated tests** - this is a configuration/documentation repository.

**Manual validation:**
1. JSON manifests validate with `jq`
2. Markdown files follow frontmatter format
3. File paths match declared structure
4. Version numbers consistent across manifests

## Architecture Decision Records

**Why agents/ at plugin root (not .claude/)?**
- `.claude/` is for project-level configuration
- Plugin components must be at plugin root for Claude Code discovery
- Official marketplace standard requires this structure

**Why separate generic/domain/config agents?**
- Generic: Reusable across any codebase
- Domain: Specific technical domains (frontend, backend, database)
- Config: Configuration file specialists

**Why skills separate from agents?**
- Skills are reusable patterns/workflows
- Agents are execution units
- Many-to-many relationship (agents use multiple skills)
