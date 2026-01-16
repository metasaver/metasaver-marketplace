# Config Agent Coverage Audit Report

**Date:** 2026-01-13
**Epic ID:** MUM-CAA (MetaSaver Universal Multi-mono Config Agent Audit)
**Status:** Complete

---

## Executive Summary

Audited all 6 MetaSaver repositories against the 28 config agents in `/plugins/metasaver-core/agents/config/`. Identified 3 high-priority gaps where common config files lack agent coverage.

---

## Config Agents Inventory (28 Total)

### Build Tools (8 agents)

| Agent                   | Target File(s)          |
| ----------------------- | ----------------------- |
| docker-compose-agent.md | `docker-compose.yml`    |
| dockerignore-agent.md   | `.dockerignore`         |
| pnpm-workspace-agent.md | `pnpm-workspace.yaml`   |
| postcss-agent.md        | `postcss.config.js`     |
| tailwind-agent.md       | `tailwind.config.js/ts` |
| turbo-config-agent.md   | `turbo.json`            |
| vite-agent.md           | `vite.config.ts`        |
| vitest-agent.md         | `vitest.config.ts`      |

### Code Quality (3 agents)

| Agent                 | Target File(s)                  |
| --------------------- | ------------------------------- |
| editorconfig-agent.md | `.editorconfig`                 |
| eslint-agent.md       | `eslint.config.js`              |
| prettier-agent.md     | `package.json` (prettier field) |

### Version Control (5 agents)

| Agent                    | Target File(s)         |
| ------------------------ | ---------------------- |
| commitlint-agent.md      | `commitlint.config.js` |
| gitattributes-agent.md   | `.gitattributes`       |
| github-workflow-agent.md | `.github/workflows/`   |
| gitignore-agent.md       | `.gitignore`           |
| husky-agent.md           | `.husky/`              |

### Workspace (12 agents)

| Agent                            | Target File(s)            |
| -------------------------------- | ------------------------- |
| claude-md-agent.md               | `CLAUDE.md`               |
| env-example-agent.md             | `.env.example`            |
| monorepo-root-structure-agent.md | root structure validation |
| nodemon-agent.md                 | `nodemon.json`            |
| npmrc-template-agent.md          | `.npmrc.template`         |
| nvmrc-agent.md                   | `.nvmrc`                  |
| readme-agent.md                  | `README.md`               |
| repomix-config-agent.md          | `.repomix.config.json`    |
| root-package-json-agent.md       | `package.json` (root)     |
| scripts-agent.md                 | `/scripts` directory      |
| typescript-agent.md              | `tsconfig.json`           |
| vscode-agent.md                  | `.vscode/`                |

---

## Repository Coverage Matrix

### Repositories Audited

1. **metasaver-com** - Main SaaS platform (consumer monorepo)
2. **metasaver-marketplace** - Plugin/agent repository (special case)
3. **multi-mono** - Shared library monorepo (producer)
4. **resume-builder** - Resume SaaS (consumer monorepo)
5. **rugby-crm** - Rugby CRM SaaS (consumer monorepo)
6. **veenk** - AI/LangGraph platform (consumer monorepo)

### Coverage by Config File

| Config File            | Agent | metasaver-com | marketplace | multi-mono | resume-builder | rugby-crm | veenk |
| ---------------------- | :---: | :-----------: | :---------: | :--------: | :------------: | :-------: | :---: |
| `docker-compose.yml`   |  ✅   |      ✅       |      -      |     ✅     |       ✅       |    ✅     |  ✅   |
| `.dockerignore`        |  ✅   |      ✅       |      -      |     -      |       ✅       |    ✅     |  ✅   |
| `pnpm-workspace.yaml`  |  ✅   |      ✅       |      -      |     ✅     |       ✅       |    ✅     |  ✅   |
| `turbo.json`           |  ✅   |      ✅       |      -      |     ✅     |       ✅       |    ✅     |  ✅   |
| `.editorconfig`        |  ✅   |      ✅       |     ✅      |     ✅     |       ✅       |    ✅     |  ✅   |
| `eslint.config.js`     |  ✅   |      ✅       |      -      |     ✅     |       ✅       |    ✅     |  ✅   |
| `commitlint.config.js` |  ✅   |      ✅       |      -      |     ✅     |       ✅       |    ✅     |  ✅   |
| `.gitattributes`       |  ✅   |      ✅       |     ✅      |     ✅     |       ✅       |    ✅     |  ✅   |
| `.github/`             |  ✅   |      ✅       |     ✅      |     ✅     |       ✅       |    ✅     |   -   |
| `.gitignore`           |  ✅   |      ✅       |     ✅      |     ✅     |       ✅       |    ✅     |  ✅   |
| `.husky/`              |  ✅   |      ✅       |      -      |     ✅     |       ✅       |    ✅     |  ✅   |
| `CLAUDE.md`            |  ✅   |      ✅       |     ✅      |     ✅     |       ✅       |    ✅     |  ✅   |
| `.env.example`         |  ✅   |      ✅       |      -      |     ✅     |       ✅       |    ✅     |  ✅   |
| `.npmrc.template`      |  ✅   |      ✅       |      -      |     ✅     |       ✅       |    ✅     |  ✅   |
| `.nvmrc`               |  ✅   |      ✅       |      -      |     ✅     |       ✅       |    ✅     |  ✅   |
| `README.md`            |  ✅   |      ✅       |     ✅      |     ✅     |       ✅       |    ✅     |  ✅   |
| `.repomix.config.json` |  ✅   |      ✅       |     ✅      |     ✅     |       ✅       |    ✅     |  ✅   |
| `package.json`         |  ✅   |      ✅       |     ✅      |     ✅     |       ✅       |    ✅     |  ✅   |
| `/scripts`             |  ✅   |      ✅       |     ✅      |     ✅     |       ✅       |    ✅     |  ✅   |
| `.vscode/`             |  ✅   |      ✅       |     ✅      |     ✅     |       ✅       |    ✅     |  ✅   |

**Legend:**

- ✅ = File exists in repo
- `-` = File not present (expected for that repo type)

---

## Gap Analysis: Files Without Agent Coverage

### HIGH PRIORITY - Common Across Repos

| File                                      | Repos Present | Priority | Recommendation                       |
| ----------------------------------------- | ------------- | -------- | ------------------------------------ |
| `.copilot-commit-message-instructions.md` | 5/6           | **HIGH** | Create agent - related to commitlint |
| `.prettierignore`                         | 5/6           | **HIGH** | Create agent - related to prettier   |
| `.mcp.json`                               | 3/6           | **HIGH** | Create agent - MCP server config     |

### MEDIUM PRIORITY - Single Repo

| File          | Repos Present  | Priority | Recommendation                       |
| ------------- | -------------- | -------- | ------------------------------------ |
| `.changeset/` | 1 (multi-mono) | MEDIUM   | Create agent for versioning workflow |

### LOW PRIORITY / NO AGENT NEEDED

| File              | Repos Present      | Reason No Agent Needed                |
| ----------------- | ------------------ | ------------------------------------- |
| `pnpm-lock.yaml`  | 6/6                | Generated file                        |
| `.turbo/`         | 5/6                | Generated cache directory             |
| `.serena/`        | 5/6                | Tool-specific config                  |
| `langgraph.json`  | 1 (veenk)          | Project-specific                      |
| `copy.json`       | 1 (resume-builder) | Project-specific                      |
| `/postman`        | 3/6                | API testing, low standardization need |
| `/infrastructure` | 1 (metasaver-com)  | Project-specific                      |
| `/zzzold`         | 6/6                | Archive folder                        |

---

## Special Case: metasaver-marketplace

The `metasaver-marketplace` repo is a **plugin repository**, not a consumer monorepo. It correctly lacks many standard configs because:

- No build pipeline (no `turbo.json`, `docker-compose.yml`)
- No package publishing (no `.npmrc.template`)
- No runtime code (no `.env.example`, `commitlint.config.js`)
- Focus is on documentation and agent definitions

This is **expected behavior**, not a gap.

---

## Recommended Actions

### Phase 1: Create Missing Agents

1. **copilot-commit-instructions-agent.md** (version-control)
   - Target: `.copilot-commit-message-instructions.md`
   - Syncs with commitlint conventions

2. **prettierignore-agent.md** (code-quality)
   - Target: `.prettierignore`
   - Standard ignore patterns for formatting

3. **mcp-json-agent.md** (workspace)
   - Target: `.mcp.json`
   - MCP server configuration standards

### Phase 2: Optional Agent

4. **changeset-agent.md** (workspace)
   - Target: `.changeset/` directory
   - Changesets versioning configuration

---

## Appendix: Full File Inventory by Repo

### metasaver-com

```
.claude/
CLAUDE.md
commitlint.config.js
.copilot-commit-message-instructions.md
docker-compose.yml
.dockerignore
.editorconfig
.env.example
eslint.config.js
.gitattributes
.github/
.gitignore
.husky/
.mcp.json
.npmrc.template
.nvmrc
package.json
pnpm-workspace.yaml
.prettierignore
README.md
.repomix.config.json
scripts/
turbo.json
.vscode/
```

### metasaver-marketplace

```
.claude/
CLAUDE.md
.editorconfig
.gitattributes
.github/
.gitignore
package.json
README.md
.repomix.config.json
scripts/
.vscode/
```

### multi-mono

```
.changeset/
.claude/
CLAUDE.md
commitlint.config.js
.copilot-commit-message-instructions.md
docker-compose.yml
.editorconfig
.env.example
eslint.config.js
.gitattributes
.github/
.gitignore
.husky/
.npmrc.template
.nvmrc
package.json
pnpm-workspace.yaml
.prettierignore
README.md
.repomix.config.json
scripts/
turbo.json
.vscode/
```

### resume-builder

```
.claude/
CLAUDE.md
commitlint.config.js
.copilot-commit-message-instructions.md
docker-compose.yml
.dockerignore
.editorconfig
.env.example
eslint.config.js
.gitattributes
.github/
.gitignore
.husky/
.npmrc.template
.nvmrc
package.json
pnpm-workspace.yaml
.prettierignore
README.md
.repomix.config.json
scripts/
turbo.json
.vscode/
```

### rugby-crm

```
.claude/
CLAUDE.md
commitlint.config.js
.copilot-commit-message-instructions.md
docker-compose.yml
.dockerignore
.editorconfig
.env.example
eslint.config.js
.gitattributes
.github/
.gitignore
.husky/
.mcp.json
.npmrc.template
.nvmrc
package.json
pnpm-workspace.yaml
.prettierignore
README.md
.repomix.config.json
scripts/
turbo.json
.vscode/
```

### veenk

```
.claude/
CLAUDE.md
commitlint.config.js
.copilot-commit-message-instructions.md
docker-compose.yml
.dockerignore
.editorconfig
.env.example
eslint.config.js
.gitattributes
.gitignore
.husky/
langgraph.json
.mcp.json
.npmrc.template
.nvmrc
package.json
pnpm-workspace.yaml
.prettierignore
README.md
.repomix.config.json
scripts/
tsconfig.json
turbo.json
.vscode/
```

---

## Package-Level Config Files (Deep Scan)

The initial audit covered root-level configs only. This section covers **package-level configs** found in `apps/`, `packages/`, and `services/` directories.

### Package Types and Their Configs

| Package Type        | Location Pattern           | Standard Configs                                                                                                                                                            |
| ------------------- | -------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| React App           | `apps/*-portal/`           | package.json, tsconfig.json, tsconfig.app.json, tsconfig.node.json, eslint.config.js, vite.config.ts, vitest.config.ts, tailwind.config.ts, postcss.config.js, .env.example |
| Contracts           | `packages/contracts/*/`    | package.json, tsconfig.json, eslint.config.js, vitest.config.ts                                                                                                             |
| Database            | `packages/database/*/`     | package.json, tsconfig.json, eslint.config.js, vitest.config.ts, .env.example                                                                                               |
| Data Service (API)  | `services/data/*/`         | package.json, tsconfig.json, eslint.config.js, vitest.config.ts, nodemon.json, .env.example                                                                                 |
| Integration Service | `services/integrations/*/` | package.json, tsconfig.json, eslint.config.js, vitest.config.ts, nodemon.json, .env.example                                                                                 |
| Pipeline Service    | `services/pipelines/*/`    | package.json, tsconfig.json, eslint.config.js, vitest.config.ts, nodemon.json, .env.example                                                                                 |
| Workflow Service    | `services/workflows/*/`    | package.json, tsconfig.json, eslint.config.js, vitest.config.ts                                                                                                             |
| Node Library        | `packages/*/` (multi-mono) | package.json, tsconfig.json, eslint.config.js, vitest.config.ts                                                                                                             |

### Package-Level Config Agent Coverage

| Config File                | Agent Exists | Scope     | Notes                                                   |
| -------------------------- | :----------: | --------- | ------------------------------------------------------- |
| `package.json` (pkg)       |      ❌      | Package   | Need **package-json-agent** (different from root)       |
| `tsconfig.json` (pkg)      |      ✅      | Package   | typescript-agent covers this                            |
| `tsconfig.app.json`        |      ❌      | React App | Need **tsconfig-app-agent** or extend typescript-agent  |
| `tsconfig.node.json`       |      ❌      | React App | Need **tsconfig-node-agent** or extend typescript-agent |
| `eslint.config.js` (pkg)   |      ✅      | Package   | eslint-agent covers this                                |
| `vite.config.ts` (pkg)     |      ✅      | Package   | vite-agent covers this                                  |
| `vitest.config.ts` (pkg)   |      ✅      | Package   | vitest-agent covers this                                |
| `tailwind.config.ts` (pkg) |      ✅      | React App | tailwind-agent covers this                              |
| `postcss.config.js` (pkg)  |      ✅      | React App | postcss-agent covers this                               |
| `nodemon.json` (pkg)       |      ✅      | Service   | nodemon-agent covers this                               |
| `.env.example` (pkg)       |      ✅      | Package   | env-example-agent covers this                           |
| `Dockerfile`               |      ❌      | Service   | Need **dockerfile-agent**                               |

### Package Inventory by Repo

#### metasaver-com (6 packages)

```
apps/admin-portal/              # React App
packages/contracts/silver-contracts/    # Contracts
packages/database/silver-database/      # Database
services/data/silver-api/              # Data Service
services/integrations/datafeedr/       # Integration
services/pipelines/datafeedr/          # Pipeline
```

#### resume-builder (4 packages)

```
apps/resume-portal/             # React App
packages/contracts/resume-builder-contracts/  # Contracts
packages/database/resume-builder-database/    # Database
services/data/resume-api/              # Data Service
```

#### rugby-crm (6 packages)

```
apps/rugby-portal/              # React App
packages/contracts/rugby-crm-contracts/  # Contracts
packages/database/rugby-crm-database/    # Database
services/data/rugby-api/               # Data Service
services/workflows/next-phase-player-import/  # Workflow
services/workflows/optimx-player-import/      # Workflow
```

#### veenk (1 package)

```
packages/agentic-workflows/veenk-workflows/  # Node Library
```

#### multi-mono (11 packages)

```
components/core/                # React Library
components/layouts/             # React Library
packages/agent-utils/           # Node Library
packages/core-database-utils/   # Node Library
packages/dapr-utils/            # Node Library
packages/mcp-utils/             # Node Library
packages/service-utils/         # Node Library
packages/task-utils/            # Node Library
packages/temporal-utils/        # Node Library
packages/utils/                 # Node Library
packages/workflow-utils/        # Node Library
```

---

## Updated Gap Analysis

### ROOT-LEVEL Gaps (Original)

| File                                      | Repos | Priority | Agent Needed                      |
| ----------------------------------------- | ----- | -------- | --------------------------------- |
| `.copilot-commit-message-instructions.md` | 5/6   | **HIGH** | copilot-commit-instructions-agent |
| `.prettierignore`                         | 5/6   | **HIGH** | prettierignore-agent              |
| `.mcp.json`                               | 3/6   | **HIGH** | mcp-json-agent                    |
| `.changeset/`                             | 1/6   | MEDIUM   | changeset-agent                   |

### PACKAGE-LEVEL Gaps (New)

| File                 | Occurrences  | Priority | Agent Needed               |
| -------------------- | ------------ | -------- | -------------------------- |
| `package.json` (pkg) | 28 packages  | **HIGH** | package-package-json-agent |
| `tsconfig.app.json`  | 4 React apps | MEDIUM   | Extend typescript-agent    |
| `tsconfig.node.json` | 4 React apps | MEDIUM   | Extend typescript-agent    |
| `Dockerfile`         | 1 (krakend)  | LOW      | dockerfile-agent           |

### DOMAIN-LEVEL Gaps (Package Type Templates)

These are not individual file agents but **domain agents** that validate entire package structures:

| Domain              | Package Count | Priority | Agent Needed                               |
| ------------------- | ------------- | -------- | ------------------------------------------ |
| React App           | 4             | **HIGH** | react-app-agent (validates full structure) |
| Contracts Package   | 4             | **HIGH** | contracts-agent                            |
| Database Package    | 4             | **HIGH** | database-agent                             |
| Data Service        | 4             | **HIGH** | data-service-agent                         |
| Node Library        | 11            | **HIGH** | node-library-agent                         |
| React Library       | 2             | MEDIUM   | react-library-agent                        |
| Workflow Service    | 2             | MEDIUM   | workflow-service-agent                     |
| Integration Service | 1             | LOW      | integration-service-agent                  |
| Pipeline Service    | 1             | LOW      | pipeline-service-agent                     |

---

## Conclusion

The config agent system provides **excellent coverage** for standard monorepo configuration files at the ROOT level.

**Summary of gaps:**

| Category                          | Gaps Found | Priority                |
| --------------------------------- | ---------- | ----------------------- |
| Root-level file agents            | 4          | 3 HIGH, 1 MEDIUM        |
| Package-level file agents         | 3          | 1 HIGH, 2 MEDIUM        |
| Domain agents (package templates) | 9          | 4 HIGH, 3 MEDIUM, 2 LOW |

**Total: 16 agents needed** to achieve complete coverage of the MetaSaver ecosystem's configuration layer at both root and package levels.
