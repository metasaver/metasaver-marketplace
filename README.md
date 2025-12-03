# MetaSaver Official Marketplace

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Plugin-blue)](https://github.com/metasaver/claude-marketplace)
[![Agents](https://img.shields.io/badge/Agents-54-green)](https://github.com/metasaver/claude-marketplace)
[![Skills](https://img.shields.io/badge/Skills-28-green)](https://github.com/metasaver/claude-marketplace)

Official marketplace for MetaSaver plugins - Professional development tools, agents, and skills for Claude Code.

## What is MetaSaver?

MetaSaver is a comprehensive system of specialized agents, reusable skills, and intelligent routing commands designed to supercharge your development workflow in Claude Code. Built for professional multi-monorepo development with Turborepo, pnpm, and TypeScript.

## Available Plugins

### @metasaver/core-claude-plugin (v1.4.0)

Complete agent and skill system for multi-mono (producer-consumer monorepo) architecture.

**Includes:**
- 54 specialized agents (15 generic, 11 domain, 28 config)
- 28 reusable skills with templates
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

### Generic Agents (15)
**Development & Architecture:**
- `architect` - Architecture design specialist with SPARC methodology
- `backend-dev` - Backend development with Express, Prisma, and MetaSaver API patterns
- `coder` - Implementation specialist enforcing MetaSaver coding standards and SOLID principles
- `devops` - DevOps specialist with Docker, Turborepo, and GitHub Actions expertise
- `agent-author` - Meta-level agent for creating, refactoring, and validating agent/skill definitions

> **Roadmap:** Additional agents planned - `frontend-dev` (general frontend development) and `ux-ui-agent` (UX/UI design and patterns)

**Quality & Validation:**
- `tester` - Testing specialist with Jest expertise and MetaSaver test patterns
- `code-quality-validator` - Technical validation with scaled quality checks (build/security/lint/prettier/test based on change size)

> **Note:** Final workflow validation has two phases:
> 1. **code-quality-validator** - Technical validation (does code build/compile?)
> 2. **business-analyst** - PRD sign-off (are all requirements complete?)

**Analysis & Planning:**
- `business-analyst` - Requirements analysis and audit planning specialist
- `project-manager` - Resource scheduler that transforms plans into Gantt charts and consolidates execution results
- `security-engineer` - Security assessment specialist with automated Semgrep scanning, OWASP expertise, and threat modeling
- `performance-engineer` - Performance optimization specialist using data-driven profiling
- `root-cause-analyst` - Systematic debugging specialist using evidence-based investigation
- `azure-devops-agent` - Azure DevOps specialist for CI/CD pipelines, Azure Repos, and infrastructure automation
- `code-explorer` - Codebase exploration specialist using Serena, repomix, and MCP ecosystem for token-efficient research

### Domain Agents (11)
All domain agents support both **Build** and **Audit** modes.

**Backend Services:**
- `data-service-agent` - REST APIs, CRUD operations, validation, authentication, database integration
- `integration-service-agent` - External API integration, webhooks, HTTP clients, retry logic, circuit breakers

**Database:**
- `prisma-database-agent` - Prisma schema design, migrations, seeding, and query optimization

**Frontend:**
- `react-component-agent` - Functional components, hooks, TypeScript props, Tailwind styling, accessibility
- `shadcn-component-agent` - shadcn/ui component installation, customization, and integration for MetaSaver libraries
- `mfe-host-agent` - Micro-frontend host setup, module federation, remote loading, shared dependencies
- `mfe-remote-agent` - Micro-frontend remote setup, exposed components, Vite federation plugin configuration

**Testing:**
- `unit-test-agent` - Jest unit tests, AAA pattern, mocking strategies, coverage requirements
- `integration-test-agent` - API integration tests, Supertest, database fixtures, end-to-end flows
- `e2e-test-agent` - End-to-end testing specialist using Chrome DevTools for browser automation and visual testing

**Monorepo:**
- `monorepo-setup-agent` - Monorepo creation and auditing, Turborepo setup, pnpm workspaces, root structure validation

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
- `root-package-json-agent` - Root package.json configuration (build & audit modes)
- `scripts-agent` - Scripts directory management (build & audit modes)
- `typescript-agent` - TypeScript configuration (build & audit modes)
- `vscode-agent` - VS Code settings (build, audit, and file cleanup modes)
- `repomix-config-agent` - Repomix configuration for AI-friendly codebase compression (build & audit modes)

### Cross-Cutting Skills (9)
- `building-blocks-advisor` - Pattern and building block recommendations
- `mcp-coordination` - Agent-to-agent coordination via MCP memory (status sharing, task handoffs, swarm communication)
- `mcp-tool-selection` - Determines WHICH external MCP tools to use based on task type (Context7, Sequential Thinking, Serena, Recall, etc.)
- `confidence-check` - Pre-implementation confidence assessment (prevents wrong-direction work)
- `security-scan-workflow` - Automated security scanning workflow using Semgrep (OWASP Top 10, CWE patterns, hardcoded secrets)
- `monorepo-navigation` - Workspace navigation patterns
- `scope-check` - Determines which repositories a task affects (replaces repository-detection)
- `repomix-cache-refresh` - Repomix cache management for 70% token savings
- `serena-code-reading` - Serena progressive disclosure patterns for 93% token savings

> **Note:** `mcp-coordination` and `mcp-tool-selection` serve different purposes:
> - **mcp-coordination**: Agent swarm communication patterns (how agents talk to each other via MCP memory)
> - **mcp-tool-selection**: External tool selection logic (which MCP servers to invoke for a task)

### Domain Skills (5)
- `audit-workflow` - Comprehensive audit orchestration across files and domains
- `config-validation` - Configuration file validation and standards compliance
- `monorepo-audit` - Monorepo-wide auditing with agent coordination
- `remediation-options` - Issue remediation strategies and recommendations
- `workflow-orchestration` - Complex workflow coordination for multi-step tasks

## Understanding Skills vs Agents

**Domain Agents** (specialized workers):

- Agents that BUILD or AUDIT domain-specific things
- Examples: `data-service-agent` builds REST APIs, `react-component-agent` builds React components
- All domain agents support both Build and Audit modes
- They DO the actual work (code generation, auditing, testing)

**Domain Skills** (reusable workflows):

- Patterns and processes that agents USE to do their work
- Examples: `audit-workflow` provides the comparison logic, `config-validation` provides validation patterns
- Skills are like libraries/utilities that multiple agents can invoke
- They define HOW to do something, not the actual implementation

**Key Difference:**

- **Agents** = Workers (who does the work)
- **Skills** = Utilities (how the work gets done)

Example: The `eslint-agent` (config agent) uses the `audit-workflow` skill (domain skill) to perform its audit.

### Config Skills (14)
Complete template libraries for configuration agents:
- **Build Tools:** pnpm-workspace, postcss, turbo, vite, vitest configs with templates
- **Version Control:** commitlint, gitattributes, gitignore, husky hooks with templates
- **Workspace:** dockerignore, nodemon, npmrc, tailwind, vscode with templates

### Commands (4)
- `/audit` - Natural language audit command (validates configs, code quality, standards compliance)
- `/build` - Build new features with architecture validation and technical documentation
- `/ms` - MetaSaver intelligent command router (complexity scoring, automatic agent spawning)
- `/ss` - Screenshot command for processing saved screenshots with instructions

## Intelligent Model Selection

MetaSaver commands automatically select the optimal Claude model based on task complexity, delivering 60-90% cost savings while maintaining quality.

**Model Selection Strategy:**
- **Haiku** (Score ≤4): Simple fixes/explanations only (fix, debug, explain, config audits)
- **Sonnet** (Score 5-29): All implementation work - create, build, implement, refactor (default)
- **Opus** (Score ≥30): Ultra-complex architecture, system-wide changes (rare, <5% usage)

**Examples:**
```bash
# Haiku - Simple fixes/audits only
/ms fix TypeScript error in service
/audit turbo.json
→ Quick fixes, config audits (score ≤4)

# Sonnet - All implementation work (default)
/build simple REST API endpoint
/ms implement user authentication
/build JWT auth service with tests
→ backend-dev, unit-test-agent (sonnet) (score 5-29)

# Opus - Ultra-complex architecture (rare)
/build multi-tenant SaaS architecture
→ BA, Architect (opus) + Workers (sonnet) (score ≥30)
```

**Cost Optimization:**
- Config agents (28 total): Always haiku (score ≤4) - 10-20x cheaper than opus
- Domain agents (11 total): Always sonnet (score 5+) - all implementation work
- Generic agents (15 total): Sonnet (default) or Opus (ultra-complex only)

Full monorepo audit (28 config agents):
- ❌ All Opus: 390x cost
- ❌ All Sonnet: 78x cost
- ✅ Haiku configs + Sonnet orchestration: 35x cost (91% savings vs opus)

**Key Insight:** Haiku is NOT for implementation (create, build, implement). Those need Sonnet's reasoning. Haiku only for truly simple operations (fix, debug, explain, config checks).

**See:** [`plugins/metasaver-core/MODEL-SELECTION.md`](plugins/metasaver-core/MODEL-SELECTION.md) for detailed model selection guide.

## MCP Server Configuration

The plugin includes `.mcp.json` configuration for recommended MCP servers:

```json
{
  "mcpServers": {
    "Context7": { "command": "npx", "args": ["-y", "@upstash/context7-mcp@latest"] },
    "chrome-devtools": { "command": "npx", "args": ["-y", "chrome-devtools-mcp@latest", "--browserUrl=http://127.0.0.1:9222"] },
    "recall": { "command": "npx", "args": ["-y", "@joseairosa/recall"], "env": { "REDIS_URL": "redis://localhost:6379" } },
    "semgrep": { "command": "uvx", "args": ["semgrep-mcp"] },
    "sequential-thinking": { "command": "npx", "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"] },
    "serena": { "command": "uvx", "args": ["--from", "git+https://github.com/oraios/serena", "serena", "start-mcp-server"] },
    "vibe-check": { "command": "npx", "args": ["-y", "@pv-bhat/vibe-check-mcp", "start", "--stdio"] }
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

### v1.1.0 (2025-01-19)
- Added intelligent model selection (haiku/sonnet/opus)
- 60-90% cost savings through automatic model routing
- Updated all commands (/ms, /build, /audit) with model selection logic
- Added MODEL-SELECTION.md comprehensive guide

### v1.0.0 (2025-01-18)
- Initial marketplace release
- Added @metasaver/core-claude-plugin v1.0.0
- Multi-mono (producer-consumer monorepo) architecture support
