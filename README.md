# MetaSaver Official Marketplace

Official marketplace for MetaSaver plugins - Professional development tools, agents, and skills for Claude Code.

## What is MetaSaver?

MetaSaver is a comprehensive system of specialized agents, reusable skills, and intelligent routing commands designed to supercharge your development workflow in Claude Code. Built for professional multi-monorepo development with Turborepo, pnpm, and TypeScript.

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
/plugin marketplace add https://github.com/metasaver/claude-marketplace
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
# Use intelligent routing (no quotes needed)
/ms Build new REST API with authentication

# Run comprehensive audits
/audit monorepo root

# System automatically spawns appropriate agents based on complexity
# You just describe what you want - agents handle the rest
```

## Complete Agent & Skill Inventory

### Generic Agents (12)
**Development & Architecture:**
- `architect` - Architecture design specialist with SPARC methodology
- `backend-dev` - Backend development with Express, Prisma, and MetaSaver API patterns
- `coder` - Implementation specialist enforcing MetaSaver coding standards and SOLID principles
- `devops` - DevOps specialist with Docker, Turborepo, and GitHub Actions expertise

**Quality & Testing:**
- `tester` - Testing specialist with Jest expertise and MetaSaver test patterns
- `reviewer` - Code review specialist enforcing MetaSaver quality standards and security checklist
- `production-validator` - Technical validation ensuring code compiles and passes all checks

**Analysis & Planning:**
- `business-analyst` - Requirements analysis and audit planning specialist
- `project-manager` - Resource scheduler that transforms plans into Gantt charts and consolidates execution results
- `security-engineer` - Security assessment specialist with OWASP expertise and threat modeling
- `performance-engineer` - Performance optimization specialist using data-driven profiling
- `root-cause-analyst` - Systematic debugging specialist using evidence-based investigation

### Domain Agents (9)
**Backend Services:**
- `data-service-agent` - REST APIs, CRUD operations, validation, authentication, database integration
- `integration-service-agent` - External API integration, webhooks, HTTP clients, retry logic, circuit breakers

**Database:**
- `prisma-database-agent` - Prisma schema design, migrations, seeding, and query optimization

**Frontend:**
- `react-component-agent` - Functional components, hooks, TypeScript props, Tailwind styling, accessibility
- `mfe-host-agent` - Micro-frontend host setup, module federation, remote loading, shared dependencies
- `mfe-remote-agent` - Micro-frontend remote setup, exposed components, Vite federation plugin configuration

**Testing:**
- `unit-test-agent` - Jest unit tests, AAA pattern, mocking strategies, coverage requirements
- `integration-test-agent` - API integration tests, Supertest, database fixtures, end-to-end flows

**Infrastructure:**
- `monorepo-setup-agent` - New monorepo creation, Turborepo setup, pnpm workspaces, root structure

### Config Agents (26)
**Build Tools (8):**
- `docker-compose-agent` - Docker Compose configuration (build & audit modes)
- `dockerignore-agent` - Docker ignore patterns (build & audit modes)
- `pnpm-workspace-agent` - pnpm workspace configuration (build & audit modes)
- `postcss-agent` - PostCSS configuration (build & audit modes)
- `tailwind-agent` - Tailwind CSS configuration (build & audit modes)
- `turbo-config-agent` - Turbo.json configuration (build & audit modes)
- `vite-agent` - Vite configuration (build & audit modes)
- `vitest-agent` - Vitest configuration (build & audit modes)

**Code Quality (3):**
- `editorconfig-agent` - EditorConfig settings (build & audit modes)
- `eslint-agent` - ESLint flat config (build & audit modes)
- `prettier-agent` - Prettier configuration (build & audit modes)

**Version Control (5):**
- `commitlint-agent` - Commitlint and GitHub Copilot commit messages (build & audit modes)
- `gitattributes-agent` - Git attributes configuration (build & audit modes)
- `github-workflow-agent` - GitHub Actions workflows (build & audit modes)
- `gitignore-agent` - Git ignore patterns (build & audit modes)
- `husky-agent` - Husky git hooks (build & audit modes)

**Workspace Configuration (10):**
- `claude-md-agent` - CLAUDE.md configuration with multi-mono architecture awareness (build & audit modes)
- `env-example-agent` - Environment example (.env.example) configuration (build & audit modes)
- `monorepo-root-structure-agent` - Detects unexpected files and validates directory organization
- `nodemon-agent` - Nodemon configuration (build & audit modes)
- `npmrc-template-agent` - NPM registry template configuration (build & audit modes)
- `nvmrc-agent` - Node version (.nvmrc) configuration (build & audit modes)
- `readme-agent` - README.md documentation (build & audit modes)
- `root-package-json-agent` - Root package.json configuration (build & audit modes)
- `scripts-agent` - Scripts directory management (build & audit modes)
- `typescript-agent` - TypeScript configuration (build & audit modes)
- `vscode-agent` - VS Code settings (build, audit, and file cleanup modes)

### Cross-Cutting Skills (6)
- `building-blocks-advisor` - Pattern and building block recommendations
- `mcp-coordination` - MCP tool coordination and orchestration
- `mcp-tool-selection` - Intelligent MCP tool selection based on task requirements
- `confidence-check` - Pre-implementation confidence assessment (prevents wrong-direction work)
- `monorepo-navigation` - Workspace navigation patterns
- `repository-detection` - Repository type detection and analysis

### Domain Skills (6)
- `audit-workflow` - Comprehensive audit orchestration across files and domains
- `config-validation` - Configuration file validation and standards compliance
- `monorepo-audit` - Monorepo-wide auditing with agent coordination
- `remediation-options` - Issue remediation strategies and recommendations
- `workflow-orchestration` - Complex workflow coordination for multi-step tasks
- `repository-detection` - Identifies monorepo structure and architecture patterns

### Config Skills (17)
Complete template libraries for all configuration agents:
- **Build Tools:** pnpm-workspace, postcss, turbo, vite, vitest configs with templates
- **Version Control:** commitlint, gitattributes, gitignore, husky hooks with templates
- **Workspace:** dockerignore, nodemon, npmrc, tailwind, vscode with templates

### Commands (2)
- `/audit` - Natural language audit command (validates configs, code quality, standards compliance)
- `/ms` - MetaSaver intelligent command router (complexity scoring, automatic agent spawning)

## Requirements

- Claude Code >=1.0.0
- Recommended MCP servers: recall, sequential-thinking, serena, Context7

## Repository Structure

This repository follows the **official Claude Code marketplace standard**:

```
claude-marketplace/
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

- Repository: https://github.com/metasaver/claude-marketplace
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
