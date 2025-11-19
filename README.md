# MetaSaver Official Marketplace

Official marketplace for MetaSaver plugins - Professional development tools, agents, and skills for Claude Code.

## What is MetaSaver?

MetaSaver is a comprehensive system of specialized agents, reusable skills, and intelligent routing commands designed to supercharge your development workflow in Claude Code. Built for professional monorepo development with Turborepo, pnpm, and TypeScript.

## Available Plugins

### @metasaver/core-claude-plugin (v1.0.0)

Complete agent and skill system for multi-mono (producer-consumer monorepo) architecture.

**Includes:**
- 43+ specialized agents (generic, domain, config)
- 20+ reusable skills with templates
- Intelligent routing commands (/ms, /audit)
- Complete template libraries
- Cross-platform compatibility (Windows WSL + Linux)

**Best for:**
- Turborepo monorepos with pnpm workspaces
- TypeScript/JavaScript projects
- Node.js microservices
- React/Next.js applications
- Micro-frontend architectures
- Full-stack applications with Prisma/PostgreSQL

[View Plugin Details →](https://github.com/metasaver/metasaver-core)

## Installation

### Step 1: Add the Marketplace

```bash
/plugin marketplace add https://github.com/metasaver/metasaver-marketplace
```

### Step 2: Install a Plugin

```bash
# Interactive installation (browse plugins)
/plugin install

# Direct installation
/plugin install @metasaver/core-claude-plugin
```

### Step 3: Start Using

All agents, skills, and commands are immediately available:

```bash
# Use intelligent routing
/ms "Build new REST API with authentication"

# Run comprehensive audits
/audit monorepo root

# Spawn specific agents
Task("backend-dev", "Create user service", "backend-dev")
```

## Plugin Categories

### Generic Agents
Architecture, backend development, testing, review, security, performance optimization, debugging, and more.

### Domain Agents
Specialized agents for data services, integration services, databases (Prisma), React components, micro-frontends, and testing.

### Config Agents
Complete coverage for build tools, code quality, version control, and workspace configuration.

### Skills
Cross-cutting and domain-specific skills with reusable templates, scripts, and workflows.

### Commands
Intelligent routing and audit commands with complexity scoring and auto-agent spawning.

## Requirements

- Claude Code >=1.0.0
- Recommended MCP servers: recall, sequential-thinking, serena, Context7

## Repository Structure

This repository follows the **official Claude Code marketplace standard**:

```
metasaver-marketplace/
├── .claude-plugin/
│   └── marketplace.json        # Required: Marketplace manifest
├── plugins/
│   └── metasaver-core/
│       ├── .claude-plugin/
│       │   └── plugin.json     # Required: Plugin manifest
│       ├── agents/             # At plugin root (not in .claude/)
│       ├── skills/             # At plugin root (not in .claude/)
│       ├── commands/           # At plugin root (not in .claude/)
│       ├── templates/          # Template libraries
│       ├── settings.json       # Plugin settings
│       ├── README.md
│       └── LICENSE
├── README.md                   # This file
└── LICENSE                     # Repository license
```

**Official Standards:**
- `.claude-plugin/` directory is **required** by Claude Code
- `marketplace.json` must be in `.claude-plugin/` (not at root)
- Plugin components (`agents/`, `skills/`, `commands/`) must be at plugin root
- Do NOT use `.claude/` directory for plugins (that's for project configs only)

## Support & Documentation

- Repository: https://github.com/metasaver/metasaver-marketplace
- Plugin Documentation: See `plugins/metasaver-core/README.md`
- Issues & Feature Requests: Create issues in this repository

## Contributing

Want to contribute a plugin to the MetaSaver marketplace? See our [contribution guidelines](CONTRIBUTING.md) (coming soon).

## License

Marketplace manifest: MIT License

Individual plugins: See respective plugin repositories for license information.

## Version History

### v1.0.0 (2025-01-18)
- Initial marketplace release
- Added @metasaver/core-claude-plugin v1.0.0
- Multi-mono (producer-consumer monorepo) architecture support
