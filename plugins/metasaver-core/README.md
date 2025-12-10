# MetaSaver Core Claude Plugin

Complete agent and skill system for multi-mono (producer-consumer monorepo) architecture. Built for professional multi-monorepo development with Turborepo, pnpm, and TypeScript.

## What's Included

### 54 Specialized Agents

**Generic Agents (17):**

- architect, backend-dev, coder, tester, reviewer, business-analyst, project-manager, devops, code-quality-validator, agent-author, skill-author, security-engineer, performance-engineer, root-cause-analyst, code-explorer, azure-devops-agent, innovation-advisor

**Domain Agents (9):**

- data-service-agent, integration-service-agent, prisma-database-agent, react-component-agent, shadcn-component-agent, unit-test-agent, integration-test-agent, e2e-test-agent, monorepo-setup-agent

**Config Agents (28):**

- Build Tools, Code Quality, Version Control, Workspace configuration

### 39 Reusable Skills

Cross-cutting skills, domain skills, workflow steps, and complete config skill libraries with templates.

### Intelligent Routing Commands

- `/audit` - Natural language audit command
- `/build` - Build new features with architecture validation
- `/ms` - MetaSaver intelligent command router
- `/ss` - Screenshot processing command

## Installation

Install via the MetaSaver marketplace:

```bash
/plugin marketplace add https://github.com/metasaver/metasaver-marketplace
/plugin install @metasaver/core-claude-plugin
```

## Usage

All agents, skills, and commands are immediately available in Claude Code.

```bash
# Build new features with architecture validation
/build JWT authentication with refresh tokens
/build React dashboard with charts

# Comprehensive audits
/audit eslint.config.js
/audit check all docker configs

# Intelligent routing for any task
/ms add authentication to the user API
/ms fix the TypeScript errors in services

# System automatically:
- Analyzes complexity
- Spawns appropriate agents
- Coordinates multi-agent workflows
- No manual agent spawning needed
```

See the main marketplace README for complete documentation.

## License

MIT License - See LICENSE file
