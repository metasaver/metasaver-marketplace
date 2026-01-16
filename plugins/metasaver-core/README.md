# MetaSaver Core Claude Plugin

Complete agent and skill system for multi-mono (producer-consumer monorepo) architecture. Built for professional multi-monorepo development with Turborepo, pnpm, and TypeScript.

## What's Included

### 52 Specialized Agents

**Generic Agents (20):**

- agent-author, agent-check-agent, architect, backend-dev, business-analyst, code-explorer, code-quality-validator, coder, command-author, complexity-check-agent, enterprise-architect, innovation-advisor, performance-engineer, project-manager, reviewer, root-cause-analyst, scope-check-agent, security-engineer, skill-author, tester

**Domain Agents (4):**

- contracts-agent, data-service-agent, prisma-database-agent, react-app-agent

**Config Agents (28):**

- Build Tools, Code Quality, Version Control, Workspace configuration

### 70 Reusable Skills

Cross-cutting skills, domain skills, workflow steps, and complete config skill libraries with templates.

### Intelligent Routing Commands

- `/architect` - Architecture design workflow
- `/audit` - Natural language audit command
- `/build` - Build new features with architecture validation
- `/debug` - Debug workflow for issue investigation
- `/ms` - MetaSaver intelligent command router
- `/qq` - Quick question command
- `/session` - Session recovery after interruptions

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
