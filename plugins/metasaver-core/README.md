# MetaSaver Core Claude Plugin

Complete agent and skill system for multi-mono (producer-consumer monorepo) architecture. Built for professional multi-monorepo development with Turborepo, pnpm, and TypeScript.

## What's Included

### 43+ Specialized Agents

**Generic Agents (12):**
- architect, backend-dev, coder, tester, reviewer, business-analyst, project-manager, devops, production-validator, security-engineer, performance-engineer, root-cause-analyst

**Domain Agents (9):**
- data-service-agent, integration-service-agent, prisma-database-agent, react-component-agent, mfe-host-agent, mfe-remote-agent, unit-test-agent, integration-test-agent, monorepo-setup-agent

**Config Agents (26):**
- Build Tools, Code Quality, Version Control, Workspace configuration

### 20+ Reusable Skills

Cross-cutting skills, domain skills, and complete config skill libraries with templates.

### Intelligent Routing Commands

- `/audit` - Natural language audit command
- `/ms` - MetaSaver intelligent command router

## Installation

Install via the MetaSaver marketplace:

```bash
/plugin marketplace add https://github.com/metasaver/claude-marketplace
/plugin install @metasaver/core-claude-plugin
```

## Usage

All agents, skills, and commands are immediately available in Claude Code.

```bash
# Intelligent routing - just describe what you want
/ms add authentication to the user API
/ms fix the TypeScript errors in services

# Comprehensive audits
/audit eslint.config.js
/audit check all docker configs

# System automatically:
- Analyzes complexity
- Spawns appropriate agents
- Coordinates multi-agent workflows
- No manual agent spawning needed
```

See the main marketplace README for complete documentation.

## License

MIT License - See LICENSE file
