# MetaSaver Marketplace

[![Claude Code](https://img.shields.io/badge/Claude%20Code-Plugin-blue)](https://github.com/metasaver/metasaver-marketplace)
[![Agents](https://img.shields.io/badge/Agents-53-green)](https://github.com/metasaver/metasaver-marketplace)
[![Skills](https://img.shields.io/badge/Skills-71-green)](https://github.com/metasaver/metasaver-marketplace)

Official marketplace for MetaSaver plugins - Professional development tools, agents, and skills for Claude Code.

## What is MetaSaver?

MetaSaver is a comprehensive system of specialized agents, reusable skills, and intelligent routing commands designed to supercharge your development workflow in Claude Code. Built for professional multi-monorepo development with Turborepo, pnpm, and TypeScript.

## Available Plugins

### @metasaver/core-claude-plugin (v1.4.0)

Complete agent and skill system for multi-mono (producer-consumer monorepo) architecture.

**Includes:**

- 53 specialized agents (21 generic, 4 domain, 28 config)
- 71 reusable skills with templates
- Intelligent routing commands (/ms, /audit, /build)
- Complete template libraries
- Cross-platform compatibility (Windows WSL + Linux)

**Best for:**

- Turborepo monorepos with pnpm workspaces
- TypeScript/JavaScript projects
- Node.js microservices
- React/Next.js applications
- Full-stack applications with Prisma/PostgreSQL

[View Plugin Details](https://github.com/metasaver/metasaver-core)

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
# Use intelligent routing (no quotes needed)
/ms Build new REST API with authentication

# Run comprehensive audits
/audit monorepo root

# System automatically spawns appropriate agents based on complexity
# You just describe what you want - agents handle the rest
```

## Complete Agent & Skill Inventory

### Generic Agents (21)

**Development & Architecture:**

- `architect` - Architecture design specialist with SPARC methodology
- `enterprise-architect` - Enterprise-level architecture and system design
- `backend-dev` - Backend development with Express, Prisma, and MetaSaver API patterns
- `coder` - Implementation specialist enforcing MetaSaver coding standards and SOLID principles
- `reviewer` - Code review specialist for quality and standards compliance
- `agent-author` - Meta-level agent for creating, refactoring, and validating agent definitions
- `command-author` - Creates and maintains slash commands
- `skill-author` - Creates and maintains skills

**Quality & Validation:**

- `tester` - Testing specialist with Jest expertise and MetaSaver test patterns
- `code-quality-validator` - Technical validation with scaled quality checks (build/security/lint/prettier/test based on change size)
- `agent-check-agent` - Validates agent definitions and configurations

> **Note:** Final workflow validation has two phases:
>
> 1. **code-quality-validator** - Technical validation (does code build/compile?)
> 2. **business-analyst** - PRD sign-off (are all requirements complete?)

**Analysis & Planning:**

- `business-analyst` - Requirements analysis and audit planning specialist
- `project-manager` - Resource scheduler that transforms plans into Gantt charts and consolidates execution results
- `security-engineer` - Security assessment specialist with automated Semgrep scanning, OWASP expertise, and threat modeling
- `performance-engineer` - Performance optimization specialist using data-driven profiling
- `root-cause-analyst` - Systematic debugging specialist using evidence-based investigation
- `code-explorer` - Codebase exploration specialist using Serena, repomix, and MCP ecosystem for token-efficient research
- `innovation-advisor` - Innovation and improvement recommendations
- `scope-check-agent` - Determines scope and repository boundaries
- `complexity-check-agent` - Assesses task complexity for routing decisions

### Domain Agents (4)

All domain agents support both **Build** and **Audit** modes.

**Backend Services:**

- `data-service-agent` - REST APIs, CRUD operations, validation, authentication, database integration
- `contracts-agent` - API contracts and interface definitions

**Database:**

- `prisma-database-agent` - Prisma schema design, migrations, seeding, and query optimization

**Frontend:**

- `react-app-agent` - React application structure, components, and patterns

### Config Agents (28)

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

**Workspace Configuration (12):**

- `claude-md-agent` - CLAUDE.md configuration with multi-mono architecture awareness (build & audit modes)
- `env-example-agent` - Environment example (.env.example) configuration (build & audit modes)
- `monorepo-root-structure-agent` - Detects unexpected files and validates directory organization
- `nodemon-agent` - Nodemon configuration (build & audit modes)
- `npmrc-template-agent` - NPM registry template configuration (build & audit modes)
- `nvmrc-agent` - Node version (.nvmrc) configuration (build & audit modes)
- `readme-agent` - README.md documentation (build & audit modes)
- `repomix-config-agent` - Repomix configuration for AI-friendly codebase compression (build & audit modes)
- `root-package-json-agent` - Root package.json configuration (build & audit modes)
- `scripts-agent` - Scripts directory management (build & audit modes)
- `typescript-agent` - TypeScript configuration (build & audit modes)
- `vscode-agent` - VS Code settings (build, audit, and file cleanup modes)

### Skills Overview

Skills are organized into four categories:

**Cross-Cutting Skills (11):**

- `agent-check` - Agent definition validation
- `agent-selection` - Intelligent agent routing
- `chrome-devtools-testing` - Browser automation patterns
- `coding-standards` - MetaSaver coding standards reference
- `dry-check` - DRY principle validation
- `positive-framing-patterns` - Communication patterns
- `repomix-cache-refresh` - Repomix cache management for 70% token savings
- `scope-check` - Determines which repositories a task affects
- `serena-code-reading` - Serena progressive disclosure patterns for 93% token savings
- `structure-check` - Project structure validation
- `workflow-enforcement` - Workflow compliance checks

**Domain Skills (7):**

- `audit-workflow` - Comprehensive audit orchestration across files and domains
- `contracts-package` - API contracts patterns and templates
- `data-service` - Data service patterns and templates
- `monorepo-audit` - Monorepo-wide auditing with agent coordination
- `prisma-database` - Prisma schema patterns and templates
- `react-app-structure` - React application structure patterns
- `remediation-options` - Issue remediation strategies and recommendations

**Config Skills (22):**

Complete template libraries for configuration agents covering build tools, code quality, version control, and workspace configurations.

**Workflow-Steps Skills (31):**

Step-by-step workflow execution patterns including analysis, design, execution, validation, and reporting phases.

## Understanding Skills vs Agents

**Domain Agents** (specialized workers):

- Agents that BUILD or AUDIT domain-specific things
- Examples: `data-service-agent` builds REST APIs, `react-app-agent` builds React apps
- All domain agents support both Build and Audit modes
- They DO the actual work (code generation, auditing, testing)

**Domain Skills** (reusable workflows):

- Patterns and processes that agents USE to do their work
- Examples: `audit-workflow` provides the comparison logic, `coding-standards` provides standards reference
- Skills are like libraries/utilities that multiple agents can invoke
- They define HOW to do something, not the actual implementation

**Key Difference:**

- **Agents** = Workers (who does the work)
- **Skills** = Utilities (how the work gets done)

Example: The `eslint-agent` (config agent) uses the `audit-workflow` skill (domain skill) to perform its audit.

### Commands (7)

- `/architect` - Architecture design workflow with SPARC methodology
- `/audit` - Natural language audit command (validates configs, code quality, standards compliance)
- `/build` - Build new features with architecture validation and technical documentation
- `/debug` - Systematic debugging workflow
- `/ms` - MetaSaver intelligent command router (complexity scoring, automatic agent spawning)
- `/qq` - Quick question mode for fast responses
- `/session` - Session recovery after crashes or interruptions

## MCP Server Configuration

The plugin includes `.mcp.json` configuration for recommended MCP servers:

```json
{
  "mcpServers": {
    "Context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest"]
    },
    "chrome-devtools": {
      "command": "npx",
      "args": ["-y", "chrome-devtools-mcp@latest", "--browserUrl=http://127.0.0.1:9222"]
    },
    "recall": {
      "command": "npx",
      "args": ["-y", "@joseairosa/recall"],
      "env": { "REDIS_URL": "redis://localhost:6379" }
    },
    "semgrep": { "command": "uvx", "args": ["semgrep-mcp"] },
    "sequential-thinking": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"]
    },
    "serena": {
      "command": "uvx",
      "args": ["--from", "git+https://github.com/oraios/serena", "serena", "start-mcp-server"]
    },
    "vibe-check": {
      "command": "npx",
      "args": ["-y", "@pv-bhat/vibe-check-mcp", "start", "--stdio"]
    }
  }
}
```

**Recommended MCP Servers:**

- **serena** - Semantic code navigation and symbol search (90-95% token savings on code operations)
- **semgrep** - Automated security scanning for OWASP Top 10 vulnerabilities (scans changed files in 10-15s)
- **recall** - Cross-session memory and architectural pattern persistence
- **sequential-thinking** - Multi-step reasoning for complex debugging
- **Context7** - Up-to-date technical documentation for libraries
- **chrome-devtools** - Browser automation, debugging, and performance profiling (requires Chrome: `sudo apt install google-chrome-stable` on WSL)
- **vibe-check** - Metacognitive validation to prevent over-engineering and tunnel vision

**Note:** MCP servers enhance agent capabilities but are not required for basic functionality.

## Requirements

- Claude Code >=1.0.0
- Recommended MCP servers: recall, sequential-thinking, serena, semgrep, Context7

## Repository Structure

```
metasaver-marketplace/
├── plugins/
│   └── metasaver-core/
│       ├── agents/             # Agent definitions
│       │   ├── config/         # Configuration agents (28)
│       │   ├── domain/         # Domain agents (4)
│       │   └── generic/        # Generic agents (21)
│       ├── skills/             # Skill definitions (71)
│       │   ├── config/         # Config skills (22)
│       │   ├── cross-cutting/  # Cross-cutting skills (11)
│       │   ├── domain/         # Domain skills (7)
│       │   └── workflow-steps/ # Workflow skills (31)
│       ├── commands/           # Slash commands (7)
│       ├── templates/          # Template libraries
│       ├── settings.json       # Plugin settings
│       ├── README.md
│       └── LICENSE
├── README.md                   # This file
└── LICENSE                     # Repository license
```

## Support & Documentation

- Repository: https://github.com/metasaver/metasaver-marketplace
- Plugin Documentation: See `plugins/metasaver-core/README.md`
- Issues & Feature Requests: Create issues in this repository

## License

This repository is private and not licensed for public distribution.

Individual plugins: See respective plugin directories for license information.

## Version History

### v1.4.0 (Current)

- 53 specialized agents (21 generic, 4 domain, 28 config)
- 71 reusable skills across 4 categories
- 7 intelligent routing commands
- Enhanced workflow-steps skills for structured execution

### v1.0.0 (2025-01-18)

- Initial marketplace release
- Added @metasaver/core-claude-plugin v1.0.0
- Multi-mono (producer-consumer monorepo) architecture support
