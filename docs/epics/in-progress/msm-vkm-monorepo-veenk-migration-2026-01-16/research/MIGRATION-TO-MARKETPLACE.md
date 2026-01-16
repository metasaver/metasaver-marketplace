# Migration: Veenk → MetaSaver Marketplace

**Document Version:** 1.0
**Created:** 2026-01-16
**Status:** Planning
**Related:** vnk-mcp-server PRD, execution plan

---

## Executive Summary

### Why Migrate?

The MCP server + LangGraph workflows will be tightly integrated with the core-claude-plugin. Rather than maintaining separate repositories, we consolidate all workflow orchestration features into the marketplace.

### Migration Overview

- **Source:** `/home/jnightin/code/veenk/`
- **Target:** `/home/jnightin/code/metasaver-marketplace/`
- **Outcome:** Retire veenk repo, consolidate into marketplace
- **Total Files:** ~240+ files to evaluate (excluding node_modules, .git, generated files)
- **Critical Components:** LangGraph workflows, MCP server design docs, configuration improvements

### High-Level Strategy

1. Move LangGraph workflows to `plugins/core-claude-plugin/agentic-workflows/`
2. Implement MCP server in `plugins/core-claude-plugin/mcp-servers/workflow-mcp/`
3. Upgrade marketplace's root configuration with veenk's superior tooling
4. Preserve epic documentation and reference implementations
5. Archive veenk repository (don't delete)

---

## Migration Categories

### 1. LangGraph Workflows (Core Feature) ⭐

**Priority:** CRITICAL
**File Count:** 50+ files (source + dist + tests)

#### Source Locations

```
/home/jnightin/code/veenk/packages/agentic-workflows/veenk-workflows/
├── src/                          # Source code (18 .ts files)
│   ├── architect/
│   │   ├── nodes/
│   │   │   ├── analyze-scope/
│   │   │   │   ├── agent.ts
│   │   │   │   ├── config.ts
│   │   │   │   ├── model.ts
│   │   │   │   ├── prompt.ts
│   │   │   │   └── schemas.ts
│   │   │   ├── scan-workspace/
│   │   │   │   ├── scan-workspace.ts
│   │   │   │   ├── types.ts
│   │   │   │   └── workspace-scanner.ts
│   │   │   └── validate-projects/
│   │   │       └── validate-projects.ts
│   │   ├── schemas/
│   │   │   ├── input.ts
│   │   │   └── project-metadata.ts
│   │   ├── state.ts
│   │   ├── test-workflow.ts
│   │   └── workflow.ts
│   ├── utils/
│   │   └── claude-code.ts
│   └── index.ts
├── tests/                        # Test files (9 .test.ts files)
│   └── unit/
│       ├── analyze-scope-model.test.ts
│       ├── analyze-scope-node.test.ts
│       ├── basic-state-definition.test.ts
│       ├── claude-code.test.ts
│       ├── langgraph-studio-integration.test.ts
│       ├── redis-checkpointer.test.ts
│       ├── scan-workspace-node.test.ts
│       ├── typescript-config.test.ts
│       └── workspace-scanner.test.ts
├── dist/                         # Compiled files (mirror of src/)
├── package.json
├── tsconfig.json
├── vitest.config.ts
└── eslint.config.js
```

#### Target Location

```
/home/jnightin/code/metasaver-marketplace/plugins/core-claude-plugin/agentic-workflows/
└── (NEW directory structure matching above)
```

#### Migration Actions

**Phase 1: Create directory structure**

```bash
cd /home/jnightin/code/metasaver-marketplace/plugins/core-claude-plugin
mkdir -p agentic-workflows/src/architect/nodes/{analyze-scope,scan-workspace,validate-projects}
mkdir -p agentic-workflows/src/architect/schemas
mkdir -p agentic-workflows/src/utils
mkdir -p agentic-workflows/tests/unit
```

**Phase 2: Copy source files**

```bash
# Copy entire package (preserves structure)
cp -r /home/jnightin/code/veenk/packages/agentic-workflows/veenk-workflows/* \
      /home/jnightin/code/metasaver-marketplace/plugins/core-claude-plugin/agentic-workflows/

# Exclude dist/ and node_modules/ (will be regenerated)
rm -rf /home/jnightin/code/metasaver-marketplace/plugins/core-claude-plugin/agentic-workflows/dist
rm -rf /home/jnightin/code/metasaver-marketplace/plugins/core-claude-plugin/agentic-workflows/node_modules
```

**Phase 3: Update package.json**

Update name, paths, and workspace dependencies:

```json
{
  "name": "@metasaver/agentic-workflows",
  "version": "0.1.0",
  "type": "module",
  "main": "./dist/index.js",
  "types": "./dist/index.d.ts",
  "exports": {
    ".": {
      "import": "./dist/index.js",
      "types": "./dist/index.d.ts"
    }
  }
}
```

**Phase 4: Update import paths**

Search and replace imports if package name changes:

```bash
# Find all imports that need updating
grep -r "@metasaver/veenk-workflows" /home/jnightin/code/metasaver-marketplace/plugins/core-claude-plugin/agentic-workflows/
# Replace with @metasaver/agentic-workflows
```

**Files to Move:**

- ✅ All `.ts` source files (18 files)
- ✅ All `.test.ts` files (9 files + 1 agent.test.ts)
- ✅ `package.json`, `tsconfig.json`, `vitest.config.ts`, `eslint.config.js`
- ❌ `dist/` (regenerate after move)
- ❌ `node_modules/` (reinstall)

---

### 2. MCP Server (New Implementation) 📋

**Priority:** CRITICAL (drives entire migration)
**File Count:** 16 documentation files

#### Source Locations

```
/home/jnightin/code/veenk/docs/epics/in-progress/vnk-mcp-server/
├── prd.md                                    # Main PRD
├── execution-plan.md                         # Detailed execution plan
└── user-stories/
    ├── EPIC-001-mcp-foundation-execution.md
    ├── EPIC-002-hitl-production-integration.md
    ├── US-001-mcp-server-scaffolding.md
    ├── US-002-workflow-registry.md
    ├── US-003-list-workflows-tool.md
    ├── US-004-color-test-simple-workflow.md
    ├── US-005-workflow-executor.md
    ├── US-006-execute-workflow-tool.md
    ├── US-007-redis-checkpointer-setup.md
    ├── US-008-thread-id-management.md
    ├── US-009-color-test-hitl-workflow.md
    ├── US-010-start-workflow-tool.md
    ├── US-011-hitl-interrupt-detection.md
    ├── US-012-check-workflow-tool.md
    ├── US-013-resume-workflow-tool.md
    ├── US-014-hitl-flow-testing.md
    ├── US-015-architect-workflow-registration.md
    └── US-016-architect-workflow-e2e-test.md
```

#### Target Location

```
/home/jnightin/code/metasaver-marketplace/docs/epics/in-progress/vnk-mcp-server/
└── (Copy all files to marketplace docs)

/home/jnightin/code/metasaver-marketplace/plugins/core-claude-plugin/mcp-servers/workflow-mcp/
└── (NEW implementation based on PRD)
```

#### Migration Actions

**Phase 1: Copy documentation**

```bash
# Copy entire epic directory
cp -r /home/jnightin/code/veenk/docs/epics/in-progress/vnk-mcp-server \
      /home/jnightin/code/metasaver-marketplace/docs/epics/in-progress/
```

**Phase 2: Create MCP server structure (NEW implementation)**

```bash
cd /home/jnightin/code/metasaver-marketplace/plugins/core-claude-plugin
mkdir -p mcp-servers/workflow-mcp/src/{tools,workflow,types}
mkdir -p mcp-servers/workflow-mcp/tests
```

**Implementation will be fresh** (following PRD, not copying code)

**Files to Move:**

- ✅ All PRD and user story documentation (16 files)
- ✅ This migration document (MIGRATION-TO-MARKETPLACE.md)
- ⚠️ MCP server code: NEW implementation (use docs as reference)

---

### 3. Configuration Files (Veenk's Superior Config) ⚙️

**Priority:** HIGH
**File Count:** 18 root configuration files

#### Comparison Matrix

| File                   | Veenk | Marketplace | Action          | Notes                                    |
| ---------------------- | ----- | ----------- | --------------- | ---------------------------------------- |
| `turbo.json`           | ✅    | ❌          | **ADD**         | Marketplace doesn't use Turborepo        |
| `pnpm-workspace.yaml`  | ✅    | ✅          | **MERGE**       | Combine workspace patterns               |
| `tsconfig.json`        | ✅    | ✅          | **COMPARE**     | Keep stricter config                     |
| `.editorconfig`        | ✅    | ✅          | **KEEP VEENK**  | Veenk's is more comprehensive            |
| `.gitignore`           | ✅    | ✅          | **MERGE**       | Combine both patterns                    |
| `.gitattributes`       | ✅    | ✅          | **MERGE**       | Combine both patterns                    |
| `.npmrc.template`      | ✅    | ❌          | **ADD**         | Marketplace doesn't have template        |
| `commitlint.config.js` | ✅    | ✅          | **COMPARE**     | Check which is more comprehensive        |
| `eslint.config.js`     | ✅    | ✅          | **COMPARE**     | Use better config                        |
| `.prettierignore`      | ✅    | ✅          | **MERGE**       | Combine ignore patterns                  |
| `docker-compose.yml`   | ✅    | ❓          | **CONDITIONAL** | Add if marketplace needs Redis/LangGraph |
| `langgraph.json`       | ✅    | ❌          | **ADD**         | LangGraph Studio configuration           |
| `.nvmrc`               | ✅    | ✅          | **COMPARE**     | Ensure Node version alignment            |
| `.dockerignore`        | ✅    | ❓          | **COMPARE**     | If marketplace has Docker                |
| `.repomix.config.json` | ✅    | ❓          | **COMPARE**     | If marketplace uses Repomix              |
| `.mcp.json`            | ✅    | ❓          | **REVIEW**      | Local MCP config (may not need)          |
| `.env.example`         | ✅    | ✅          | **MERGE**       | Combine environment variables            |
| `package.json`         | ✅    | ✅          | **MERGE**       | Add Turborepo scripts + dependencies     |

#### Source Files

```
/home/jnightin/code/veenk/
├── turbo.json                      # Turborepo pipeline config
├── pnpm-workspace.yaml             # Workspace definitions
├── tsconfig.json                   # TypeScript config
├── .editorconfig                   # Editor settings
├── .gitignore                      # Git ignore patterns
├── .gitattributes                  # Git attributes
├── .npmrc.template                 # NPM registry template
├── commitlint.config.js            # Commit message linting
├── eslint.config.js                # ESLint configuration
├── .prettierignore                 # Prettier ignore patterns
├── docker-compose.yml              # Redis + LangGraph services
├── langgraph.json                  # LangGraph Studio config
├── .nvmrc                          # Node version
├── .dockerignore                   # Docker ignore patterns
├── .repomix.config.json            # Repomix configuration
├── .mcp.json                       # MCP server config
├── .env.example                    # Environment variables
└── package.json                    # Root package config
```

#### Migration Actions

**Phase 1: Backup marketplace configs**

```bash
cd /home/jnightin/code/metasaver-marketplace
git branch backup-before-veenk-migration
git add .
git commit -m "backup: Checkpoint before veenk configuration merge"
```

**Phase 2: Add new configs (files marketplace doesn't have)**

```bash
# Add Turborepo
cp /home/jnightin/code/veenk/turbo.json \
   /home/jnightin/code/metasaver-marketplace/

# Add NPM registry template
cp /home/jnightin/code/veenk/.npmrc.template \
   /home/jnightin/code/metasaver-marketplace/

# Add LangGraph Studio config
cp /home/jnightin/code/veenk/langgraph.json \
   /home/jnightin/code/metasaver-marketplace/

# Add Docker Compose (if needed)
cp /home/jnightin/code/veenk/docker-compose.yml \
   /home/jnightin/code/metasaver-marketplace/
```

**Phase 3: Merge existing configs**

```bash
# These require manual merging:
# - .gitignore (combine patterns)
# - .gitattributes (combine patterns)
# - .prettierignore (combine patterns)
# - .env.example (combine variables)
# - package.json (add scripts + dependencies)
# - pnpm-workspace.yaml (add workspace patterns)
```

**Phase 4: Compare and choose better config**

```bash
# Compare these files side-by-side:
# - tsconfig.json (keep stricter settings)
# - eslint.config.js (keep more comprehensive rules)
# - commitlint.config.js (keep better validation)
# - .editorconfig (veenk's is more comprehensive - use it)
```

**Phase 5: Update package.json scripts**

Add Turborepo scripts from veenk:

```json
{
  "scripts": {
    "dev": "turbo dev",
    "build": "turbo build",
    "lint": "turbo lint",
    "lint:fix": "turbo lint:fix",
    "lint:tsc": "turbo lint:tsc",
    "test": "turbo test",
    "test:unit": "turbo test:unit",
    "test:coverage": "turbo test:coverage",
    "clean": "turbo clean && rm -rf node_modules .turbo",
    "cb": "pnpm clean && pnpm install && pnpm build",
    "cbd": "pnpm cb && pnpm dev"
  },
  "devDependencies": {
    "turbo": "^2.6.0"
  }
}
```

**Files to Handle:**

- ✅ `turbo.json` → ADD (marketplace doesn't have Turborepo)
- ✅ `.npmrc.template` → ADD
- ✅ `langgraph.json` → ADD
- ✅ `docker-compose.yml` → ADD (if needed for Redis/LangGraph)
- 🔀 `.gitignore` → MERGE
- 🔀 `.gitattributes` → MERGE
- 🔀 `.prettierignore` → MERGE
- 🔀 `.env.example` → MERGE
- 🔀 `package.json` → MERGE (add Turborepo deps + scripts)
- 🔀 `pnpm-workspace.yaml` → MERGE
- ⚖️ `tsconfig.json` → COMPARE (keep better)
- ⚖️ `eslint.config.js` → COMPARE (keep better)
- ⚖️ `commitlint.config.js` → COMPARE (keep better)
- ⚖️ `.editorconfig` → KEEP VEENK (more comprehensive)
- ⚖️ `.nvmrc` → COMPARE (ensure alignment)

---

### 4. Claude Code Configuration 🤖

**Priority:** HIGH
**File Count:** 10 files

#### Source Locations

```
/home/jnightin/code/veenk/.claude/
├── hooks/
│   ├── ms-reminder-hook.js       # MetaSaver workflow reminder
│   ├── post-format.sh            # Post-format hook
│   ├── pre-compact.sh            # Pre-compact hook
│   ├── pre-dangerous.sh          # Dangerous command warning
│   ├── pre-env-protect.sh        # Environment file protection
│   ├── pre-read-protect.sh       # Read protection
│   └── session-start.sh          # Session initialization
├── settings.json                 # Claude Code settings
└── settings.local.json           # Local settings (DON'T MOVE)
```

#### Target Location

```
/home/jnightin/code/metasaver-marketplace/.claude/
└── (MERGE with existing marketplace hooks)
```

#### Migration Actions

**Phase 1: Compare hooks**

```bash
# List marketplace's existing hooks
ls -la /home/jnightin/code/metasaver-marketplace/.claude/hooks/

# Compare each hook file
diff /home/jnightin/code/veenk/.claude/hooks/ms-reminder-hook.js \
     /home/jnightin/code/metasaver-marketplace/.claude/hooks/ms-reminder-hook.js
```

**Phase 2: Merge hooks (keep better versions)**

For each hook:

1. If marketplace doesn't have it: **COPY from veenk**
2. If both exist: **COMPARE and keep better version**
3. If functionality differs: **MERGE manually**

```bash
# Copy unique hooks
for hook in ms-reminder-hook.js post-format.sh pre-compact.sh pre-dangerous.sh; do
  if [ ! -f "/home/jnightin/code/metasaver-marketplace/.claude/hooks/$hook" ]; then
    cp "/home/jnightin/code/veenk/.claude/hooks/$hook" \
       "/home/jnightin/code/metasaver-marketplace/.claude/hooks/"
  fi
done
```

**Phase 3: Merge settings.json**

```bash
# Manually merge settings (keep both configurations where they don't conflict)
# Focus on preserving marketplace's existing settings while adding veenk's enhancements
```

**Files to Handle:**

- 🔀 `ms-reminder-hook.js` → MERGE (if marketplace has it, otherwise COPY)
- 🔀 `post-format.sh` → MERGE (compare with marketplace)
- 🔀 `pre-compact.sh` → COPY (if marketplace doesn't have)
- 🔀 `pre-dangerous.sh` → COPY (if marketplace doesn't have)
- 🔀 `pre-env-protect.sh` → MERGE (compare with marketplace)
- 🔀 `pre-read-protect.sh` → MERGE (compare with marketplace)
- 🔀 `session-start.sh` → MERGE (compare with marketplace)
- 🔀 `settings.json` → MERGE carefully (preserve marketplace settings)
- ❌ `settings.local.json` → DON'T MOVE (local only)

---

### 5. Scripts 📜

**Priority:** MEDIUM
**File Count:** 9 shell/JS scripts

#### Source Locations

```
/home/jnightin/code/veenk/scripts/
├── setup-npmrc.js            # Generate .npmrc from .env
├── setup-env.js              # Generate .env from .env.example files
├── clean-and-build.sh        # Clean everything and rebuild
├── use-local-packages.sh     # Switch to local package development
├── back-to-prod.sh           # Switch back to published packages
├── publish.sh                # Package publishing script
├── killport.sh               # Kill process on specific port
├── run.sh                    # General runner script
└── qbp.sh                    # Quick build and publish
```

#### Target Location

```
/home/jnightin/code/metasaver-marketplace/scripts/
└── (MERGE with existing scripts)
```

#### Migration Actions

**Phase 1: Check existing scripts**

```bash
ls -la /home/jnightin/code/metasaver-marketplace/scripts/
```

**Phase 2: Copy unique scripts**

```bash
# For each script, check if marketplace has it
for script in setup-npmrc.js setup-env.js clean-and-build.sh use-local-packages.sh \
              back-to-prod.sh publish.sh killport.sh run.sh qbp.sh; do
  if [ ! -f "/home/jnightin/code/metasaver-marketplace/scripts/$script" ]; then
    cp "/home/jnightin/code/veenk/scripts/$script" \
       "/home/jnightin/code/metasaver-marketplace/scripts/"
    echo "Copied: $script"
  else
    echo "EXISTS: $script (needs manual comparison)"
  fi
done
```

**Phase 3: Update paths in scripts**

After copying, update hardcoded paths that reference veenk:

```bash
# Search for veenk references in scripts
grep -r "veenk" /home/jnightin/code/metasaver-marketplace/scripts/
# Replace with metasaver-marketplace or make paths relative
```

**Files to Handle:**

- ✅ `setup-npmrc.js` → COPY (if marketplace doesn't have) or COMPARE
- ✅ `setup-env.js` → COPY (if marketplace doesn't have) or COMPARE
- ✅ `clean-and-build.sh` → COPY or COMPARE
- ✅ `use-local-packages.sh` → COPY
- ✅ `back-to-prod.sh` → COPY
- 🔀 `publish.sh` → COMPARE/MERGE (marketplace likely has its own)
- ✅ `killport.sh` → COPY
- ✅ `run.sh` → COMPARE/MERGE
- ✅ `qbp.sh` → COPY

---

### 6. Documentation 📚

**Priority:** MEDIUM
**File Count:** 60+ markdown files

#### Source Locations

```
/home/jnightin/code/veenk/docs/
├── epics/
│   └── in-progress/
│       ├── vnk-mcp-server/                    # 16 files (already covered in Category 2)
│       ├── vnk-ui-chat-app/
│       │   └── prd.md                         # 1 file
│       ├── vnk-wfo-workflow-orchestrator/     # 35+ files
│       │   ├── prd.md
│       │   ├── prd_phase2.md
│       │   ├── execution-plan.md
│       │   ├── post-mortem.md
│       │   ├── investigation-langgraph-studio-schema-extraction.md
│       │   ├── investigation-langgraph-studio-schema-extraction-v2.md
│       │   ├── reference/
│       │   │   ├── decision-hybrid-approach.md
│       │   │   ├── poc-starter-code.md
│       │   │   ├── prd-langgraph-workflow.md
│       │   │   ├── prd.md
│       │   │   ├── research-findings.md
│       │   │   └── veenk-summary.md
│       │   └── user-stories/
│       │       ├── vnk-wfo-001-create-package-scaffolding.md
│       │       ├── vnk-wfo-002-configure-typescript.md
│       │       ├── vnk-wfo-003-integrate-langgraph-studio.md
│       │       ├── vnk-wfo-004-create-claude-cli-wrapper.md
│       │       ├── vnk-wfo-005-define-basic-state.md
│       │       ├── vnk-wfo-006-configure-redis-checkpointer.md
│       │       ├── vnk-wfo-007-implement-scan-workspace-node.md
│       │       └── vnk-wfo-008-create-workspace-scanner-utility.md
│       └── vnk-multi-runtime-agents/          # 14 files
│           ├── prd.md
│           ├── execution-plan.md
│           └── user-stories/
│               ├── README.md
│               ├── EPIC-001-type-system-and-registry.md
│               ├── EPIC-002-cli-executor-framework.md
│               ├── EPIC-003-analyze-scope-migration.md
│               ├── vnk-mra-001-update-modelconfig-interface.md
│               ├── vnk-mra-002-extend-model-registry.md
│               ├── vnk-mra-003-create-default-models-mapping.md
│               ├── vnk-mra-004-create-cli-executor-interface.md
│               ├── vnk-mra-005-implement-claude-code-executor.md
│               ├── vnk-mra-006-enhance-invoke-claude-code.md
│               ├── vnk-mra-007-add-runtime-detection-factory.md
│               ├── vnk-mra-008-implement-factory-routing.md
│               ├── vnk-mra-009-update-analyze-scope-model.md
│               └── vnk-mra-010-consolidate-agent-implementation.md
└── architecture/                              # SYMLINK to marketplace (don't move)
    └── -> /home/jnightin/code/metasaver-marketplace/docs/architecture
```

#### Target Location

```
/home/jnightin/code/metasaver-marketplace/docs/epics/in-progress/
├── vnk-mcp-server/                    # Already covered
├── vnk-ui-chat-app/                   # NEW
├── vnk-wfo-workflow-orchestrator/     # NEW
└── vnk-multi-runtime-agents/          # NEW
```

#### Migration Actions

**Phase 1: Copy epic directories**

```bash
cd /home/jnightin/code/veenk/docs/epics/in-progress

# Copy each epic (vnk-mcp-server already covered in Category 2)
cp -r vnk-ui-chat-app \
      /home/jnightin/code/metasaver-marketplace/docs/epics/in-progress/

cp -r vnk-wfo-workflow-orchestrator \
      /home/jnightin/code/metasaver-marketplace/docs/epics/in-progress/

cp -r vnk-multi-runtime-agents \
      /home/jnightin/code/metasaver-marketplace/docs/epics/in-progress/
```

**Phase 2: Add cross-references**

Add notes to migrated documents indicating they're from veenk:

```markdown
> **Migration Note:** This epic originated in the veenk repository and was migrated
> to metasaver-marketplace on 2026-01-16 as part of the MCP server integration.
```

**Phase 3: Update internal links**

Search for broken links referencing veenk paths:

```bash
grep -r "veenk" /home/jnightin/code/metasaver-marketplace/docs/epics/in-progress/vnk-*
# Fix any hardcoded paths
```

**Files to Handle:**

- ✅ `vnk-ui-chat-app/` → COPY entire directory (1 file)
- ✅ `vnk-wfo-workflow-orchestrator/` → COPY entire directory (35+ files)
- ✅ `vnk-multi-runtime-agents/` → COPY entire directory (14 files)
- ❌ `architecture/` → SKIP (symlink to marketplace, don't move)
- ✅ `CLAUDE.md` (root) → MERGE with marketplace CLAUDE.md
- ✅ `README.md` (root) → MERGE relevant workflow info into marketplace README

---

### 7. Git Configuration (Husky Hooks) 🪝

**Priority:** MEDIUM
**File Count:** 21 files (including Husky internals)

#### Source Locations

```
/home/jnightin/code/veenk/.husky/
├── pre-commit              # User-defined pre-commit hook
├── pre-push                # User-defined pre-push hook
├── commit-msg              # User-defined commit-msg hook
└── _/                      # Husky internals (19 files)
    ├── husky.sh
    ├── .gitignore
    ├── h
    ├── applypatch-msg
    ├── commit-msg
    ├── post-applypatch
    ├── post-checkout
    ├── post-commit
    ├── post-merge
    ├── post-rewrite
    ├── pre-applypatch
    ├── pre-auto-gc
    ├── pre-commit
    ├── pre-merge-commit
    ├── prepare-commit-msg
    ├── pre-push
    └── pre-rebase
```

#### Target Location

```
/home/jnightin/code/metasaver-marketplace/.husky/
└── (Marketplace likely doesn't have Husky - ADD if not present)
```

#### Migration Actions

**Phase 1: Check if marketplace has Husky**

```bash
ls -la /home/jnightin/code/metasaver-marketplace/.husky/
```

**Phase 2a: If marketplace DOESN'T have Husky**

```bash
# Copy entire .husky directory
cp -r /home/jnightin/code/veenk/.husky \
      /home/jnightin/code/metasaver-marketplace/

# Install Husky in marketplace
cd /home/jnightin/code/metasaver-marketplace
pnpm add -D husky
npx husky init
```

**Phase 2b: If marketplace DOES have Husky**

```bash
# Compare and merge user-defined hooks
diff /home/jnightin/code/veenk/.husky/pre-commit \
     /home/jnightin/code/metasaver-marketplace/.husky/pre-commit

# Keep better versions or merge both
```

**Phase 3: Update package.json scripts**

Add Husky prepare script if not present:

```json
{
  "scripts": {
    "prepare": "husky"
  }
}
```

**Files to Handle:**

- ✅ `.husky/pre-commit` → ADD or MERGE
- ✅ `.husky/pre-push` → ADD or MERGE
- ✅ `.husky/commit-msg` → ADD or MERGE
- ✅ `.husky/_/` (Husky internals) → ADD (if marketplace doesn't have Husky)

---

### 8. VS Code Settings 💻

**Priority:** LOW
**File Count:** 1 file

#### Source Locations

```
/home/jnightin/code/veenk/.vscode/
└── settings.json
```

#### Target Location

```
/home/jnightin/code/metasaver-marketplace/.vscode/
└── settings.json (MERGE with existing)
```

#### Migration Actions

**Phase 1: Compare settings**

```bash
# View both files side-by-side
code --diff /home/jnightin/code/veenk/.vscode/settings.json \
             /home/jnightin/code/metasaver-marketplace/.vscode/settings.json
```

**Phase 2: Merge manually**

Keep marketplace's workspace-specific settings, add veenk's useful settings:

- TypeScript settings
- ESLint/Prettier integration
- File associations
- Editor preferences

**Files to Handle:**

- 🔀 `settings.json` → MERGE (preserve marketplace workspace config)

---

### 9. zzzold Directory (Archive) 📦

**Priority:** LOW (reference only)
**File Count:** 100+ files

#### Source Locations

```
/home/jnightin/code/veenk/zzzold/
├── examples/
│   ├── agents/
│   │   └── playlist-picker/           # LangGraph agent example (12 files)
│   ├── mcp/
│   │   ├── calculator2/               # MCP calculator example (13 files)
│   │   └── weather/                   # MCP weather example (30+ files)
│   └── workflows/
│       └── playlist-picker/           # Workflow example (18 files)
└── pocs/
    └── langgraph-poc/                 # POC implementations (9 files)
```

#### Target Location

```
/home/jnightin/code/metasaver-marketplace/zzzold/veenk-archive/
└── (Archive entire zzzold directory with veenk prefix)
```

#### Migration Actions

**Phase 1: Create archive directory**

```bash
mkdir -p /home/jnightin/code/metasaver-marketplace/zzzold/veenk-archive
```

**Phase 2: Copy entire zzzold**

```bash
cp -r /home/jnightin/code/veenk/zzzold/* \
      /home/jnightin/code/metasaver-marketplace/zzzold/veenk-archive/
```

**Phase 3: Add README**

Create `/home/jnightin/code/metasaver-marketplace/zzzold/veenk-archive/README.md`:

```markdown
# Veenk Archive

This directory contains reference implementations and examples from the veenk repository.

**Migrated:** 2026-01-16
**Source:** https://github.com/metasaver/veenk (archived)

## Contents

- `examples/agents/` - LangGraph agent examples
- `examples/mcp/` - MCP server examples (calculator, weather)
- `examples/workflows/` - Workflow examples (playlist-picker)
- `pocs/` - Proof-of-concept implementations

**Note:** These are reference implementations. Do not use directly in production.
```

**Files to Handle:**

- ✅ `zzzold/examples/agents/playlist-picker/` → COPY (12 files)
- ✅ `zzzold/examples/mcp/calculator2/` → COPY (13 files)
- ✅ `zzzold/examples/mcp/weather/` → COPY (30+ files)
- ✅ `zzzold/examples/workflows/playlist-picker/` → COPY (18 files)
- ✅ `zzzold/pocs/langgraph-poc/` → COPY (9 files)
- ✅ Add `README.md` to archive directory

---

### 10. Miscellaneous Files 📄

**Priority:** LOW
**File Count:** 3 files

#### Source Locations

```
/home/jnightin/code/veenk/
├── .copilot-commit-message-instructions.md    # GitHub Copilot instructions
└── .langgraph_api/                            # LangGraph API cache (don't move)
    ├── .langgraphjs_api.checkpointer.json
    ├── .langgraphjs_api.store.json
    └── .langgraphjs_ops.json
```

#### Migration Actions

**Handle individually:**

- `.copilot-commit-message-instructions.md` → COMPARE with marketplace's (if exists)
- `.langgraph_api/` → DON'T MOVE (cache directory, will be regenerated)

**Files to Handle:**

- 🔀 `.copilot-commit-message-instructions.md` → COMPARE/MERGE
- ❌ `.langgraph_api/` → DON'T MOVE (regenerate in marketplace)

---

## Files NOT to Move

### Excluded Categories

| Category          | Location                     | Reason                           | Count     |
| ----------------- | ---------------------------- | -------------------------------- | --------- |
| Dependencies      | `node_modules/`              | Regenerate after migration       | Thousands |
| Git History       | `.git/`                      | Preserve marketplace's           | N/A       |
| Environment       | `.env`                       | Local only (not in repo)         | 1         |
| NPM Registry      | `.npmrc`                     | Generated from `.npmrc.template` | 1         |
| Build Artifacts   | `dist/`, `.turbo/`           | Regenerate                       | Many      |
| Lock Files        | `pnpm-lock.yaml`             | Regenerate after pnpm install    | 1         |
| Empty Directories | `src/`, `apps/`, `services/` | No content in veenk              | 3         |
| Cache             | `.langgraph_api/`            | Regenerate                       | 3         |

### Complete Exclusion List

```bash
# Do NOT copy these:
node_modules/
.git/
.env
.npmrc
dist/
.turbo/
pnpm-lock.yaml
src/.gitkeep
apps/
services/
.langgraph_api/
packages/agentic-workflows/veenk-workflows/node_modules/
packages/agentic-workflows/veenk-workflows/dist/
.claude/settings.local.json
```

---

## Migration Sequence

### Phase 1: Preparation (Day 1)

**1.1 Backup marketplace**

```bash
cd /home/jnightin/code/metasaver-marketplace
git checkout -b backup-before-veenk-migration
git add .
git commit -m "backup: Checkpoint before veenk configuration merge"
git push origin backup-before-veenk-migration
```

**1.2 Create migration branch**

```bash
git checkout -b feature/veenk-integration
```

**1.3 Document current state**

```bash
# List current packages
ls -la plugins/core-claude-plugin/
ls -la packages/

# Count files
find . -type f | wc -l
```

---

### Phase 2: Configuration Files (Day 1-2)

**2.1 Add new configurations**

```bash
# Turborepo
cp /home/jnightin/code/veenk/turbo.json .

# NPM registry template
cp /home/jnightin/code/veenk/.npmrc.template .

# LangGraph Studio
cp /home/jnightin/code/veenk/langgraph.json .

# Docker Compose (if needed)
cp /home/jnightin/code/veenk/docker-compose.yml .

# Node version
cp /home/jnightin/code/veenk/.nvmrc .

# Commit
git add turbo.json .npmrc.template langgraph.json docker-compose.yml .nvmrc
git commit -m "config: Add Turborepo, LangGraph, and NPM registry templates from veenk"
```

**2.2 Merge configuration files**

```bash
# Manually merge (review each carefully):
# - .gitignore
# - .gitattributes
# - .prettierignore
# - .env.example
# - package.json (add Turborepo scripts + dependencies)
# - pnpm-workspace.yaml

# After merging each file
git add <file>
git commit -m "config: Merge <file> from veenk"
```

**2.3 Compare and update configs**

```bash
# Compare these files, keep better version:
diff /home/jnightin/code/veenk/.editorconfig .editorconfig
diff /home/jnightin/code/veenk/tsconfig.json tsconfig.json
diff /home/jnightin/code/veenk/eslint.config.js eslint.config.js
diff /home/jnightin/code/veenk/commitlint.config.js commitlint.config.js

# Update as needed
git add <files>
git commit -m "config: Update editor/lint configs with veenk improvements"
```

**2.4 Update package.json**

Add Turborepo to root package.json:

```json
{
  "devDependencies": {
    "turbo": "^2.6.0"
  },
  "scripts": {
    "dev": "turbo dev",
    "build": "turbo build",
    "lint": "turbo lint",
    "lint:fix": "turbo lint:fix",
    "lint:tsc": "turbo lint:tsc",
    "test": "turbo test",
    "clean": "turbo clean && rm -rf node_modules .turbo",
    "cb": "pnpm clean && pnpm install && pnpm build",
    "cbd": "pnpm cb && pnpm dev"
  }
}
```

```bash
pnpm install
git add package.json pnpm-lock.yaml
git commit -m "deps: Add Turborepo and update scripts"
```

---

### Phase 3: LangGraph Workflows (Day 2-3) ⭐ CRITICAL

**3.1 Create directory structure**

```bash
cd /home/jnightin/code/metasaver-marketplace/plugins/core-claude-plugin
mkdir -p agentic-workflows
```

**3.2 Copy workflow package**

```bash
cp -r /home/jnightin/code/veenk/packages/agentic-workflows/veenk-workflows/* \
      /home/jnightin/code/metasaver-marketplace/plugins/core-claude-plugin/agentic-workflows/

# Remove generated files
rm -rf /home/jnightin/code/metasaver-marketplace/plugins/core-claude-plugin/agentic-workflows/dist
rm -rf /home/jnightin/code/metasaver-marketplace/plugins/core-claude-plugin/agentic-workflows/node_modules
```

**3.3 Update package.json**

```bash
cd /home/jnightin/code/metasaver-marketplace/plugins/core-claude-plugin/agentic-workflows
```

Edit `package.json`:

```json
{
  "name": "@metasaver/agentic-workflows",
  "version": "0.1.0"
}
```

**3.4 Update imports (if needed)**

```bash
# Search for old package name
grep -r "@metasaver/veenk-workflows" src/

# Replace with new name if found
find src/ -type f -name "*.ts" -exec sed -i 's/@metasaver\/veenk-workflows/@metasaver\/agentic-workflows/g' {} +
```

**3.5 Add to workspace**

Update `/home/jnightin/code/metasaver-marketplace/pnpm-workspace.yaml`:

```yaml
packages:
  - "plugins/*/agentic-workflows"
```

**3.6 Install dependencies and build**

```bash
cd /home/jnightin/code/metasaver-marketplace
pnpm install
pnpm --filter @metasaver/agentic-workflows build
```

**3.7 Run tests**

```bash
pnpm --filter @metasaver/agentic-workflows test
```

**3.8 Commit**

```bash
git add plugins/core-claude-plugin/agentic-workflows
git add pnpm-workspace.yaml
git commit -m "feat: Migrate LangGraph workflows from veenk

- Add architect workflow implementation
- Include scan-workspace, analyze-scope, validate-projects nodes
- Add Claude Code integration utilities
- Include full test suite (9 unit tests)

Source: veenk/packages/agentic-workflows/veenk-workflows"
```

---

### Phase 4: Scripts & Hooks (Day 3)

**4.1 Copy scripts**

```bash
cd /home/jnightin/code/metasaver-marketplace/scripts

# Copy each script
for script in setup-npmrc.js setup-env.js clean-and-build.sh \
              use-local-packages.sh back-to-prod.sh killport.sh run.sh qbp.sh; do
  cp /home/jnightin/code/veenk/scripts/$script .
done

# Compare publish.sh (marketplace likely has its own)
diff /home/jnightin/code/veenk/scripts/publish.sh publish.sh
# Merge manually if needed
```

**4.2 Update script paths**

```bash
# Search for hardcoded paths
grep -r "veenk" scripts/

# Update to use marketplace paths or make relative
# Example: /home/jnightin/code/veenk -> /home/jnightin/code/metasaver-marketplace
```

**4.3 Commit**

```bash
git add scripts/
git commit -m "chore: Add utility scripts from veenk

- setup-npmrc.js: Generate .npmrc from .env
- setup-env.js: Generate .env from .env.example files
- clean-and-build.sh: Clean and rebuild all packages
- use-local-packages.sh: Switch to local package development
- back-to-prod.sh: Switch back to published packages
- killport.sh: Kill process on specific port
- run.sh: General runner script
- qbp.sh: Quick build and publish"
```

**4.4 Merge Claude hooks**

```bash
cd /home/jnightin/code/metasaver-marketplace/.claude/hooks

# Compare and copy each hook
for hook in ms-reminder-hook.js post-format.sh pre-compact.sh pre-dangerous.sh \
            pre-env-protect.sh pre-read-protect.sh session-start.sh; do
  if [ -f "/home/jnightin/code/veenk/.claude/hooks/$hook" ]; then
    if [ ! -f "$hook" ]; then
      cp "/home/jnightin/code/veenk/.claude/hooks/$hook" .
      echo "Copied: $hook"
    else
      echo "Compare: $hook"
      diff "/home/jnightin/code/veenk/.claude/hooks/$hook" "$hook"
    fi
  fi
done
```

**4.5 Merge Claude settings**

```bash
# Manually merge .claude/settings.json
# Keep marketplace's settings, add veenk's enhancements
code --diff /home/jnightin/code/veenk/.claude/settings.json \
             /home/jnightin/code/metasaver-marketplace/.claude/settings.json
```

**4.6 Commit**

```bash
git add .claude/
git commit -m "chore: Merge Claude Code hooks and settings from veenk"
```

**4.7 Add Husky (if marketplace doesn't have it)**

```bash
# Check if Husky exists
if [ ! -d "/home/jnightin/code/metasaver-marketplace/.husky" ]; then
  # Install Husky
  pnpm add -D husky
  npx husky init

  # Copy veenk's hooks
  cp -r /home/jnightin/code/veenk/.husky/* .husky/

  # Add prepare script to package.json
  npm pkg set scripts.prepare="husky"

  git add .husky/ package.json
  git commit -m "chore: Add Husky git hooks from veenk"
else
  # Compare and merge hooks
  diff /home/jnightin/code/veenk/.husky/pre-commit .husky/pre-commit
  # Merge manually
fi
```

---

### Phase 5: Documentation (Day 4)

**5.1 Copy epic documentation**

```bash
cd /home/jnightin/code/metasaver-marketplace/docs/epics/in-progress

# Copy vnk-mcp-server (if not already done in Phase 3)
cp -r /home/jnightin/code/veenk/docs/epics/in-progress/vnk-mcp-server .

# Copy other epics
cp -r /home/jnightin/code/veenk/docs/epics/in-progress/vnk-ui-chat-app .
cp -r /home/jnightin/code/veenk/docs/epics/in-progress/vnk-wfo-workflow-orchestrator .
cp -r /home/jnightin/code/veenk/docs/epics/in-progress/vnk-multi-runtime-agents .
```

**5.2 Add migration notes**

```bash
# Add migration note to each PRD
for prd in vnk-*/prd.md; do
  echo "" >> "$prd"
  echo "---" >> "$prd"
  echo "" >> "$prd"
  echo "> **Migration Note:** This epic originated in the veenk repository and was migrated" >> "$prd"
  echo "> to metasaver-marketplace on 2026-01-16 as part of the MCP server integration." >> "$prd"
  echo "> Source: https://github.com/metasaver/veenk (archived)" >> "$prd"
done
```

**5.3 Update internal links**

```bash
# Search for broken links
grep -r "\.\./\.\./\.\." docs/epics/in-progress/vnk-*
grep -r "veenk/" docs/epics/in-progress/vnk-*

# Fix any hardcoded paths manually
```

**5.4 Merge CLAUDE.md**

```bash
# Manually merge veenk's CLAUDE.md into marketplace's
# Key sections to add:
# - LangGraph workflow documentation
# - Workflow orchestration patterns
# - Multi-runtime agent patterns
```

**5.5 Merge README.md**

```bash
# Add veenk's workflow information to marketplace README
# Keep marketplace's structure, add LangGraph section
```

**5.6 Commit**

```bash
git add docs/
git add CLAUDE.md README.md
git commit -m "docs: Migrate veenk epic documentation

- Add vnk-mcp-server epic (MCP server + workflow integration)
- Add vnk-ui-chat-app epic (chat UI for workflows)
- Add vnk-wfo-workflow-orchestrator epic (LangGraph orchestration)
- Add vnk-multi-runtime-agents epic (multi-runtime support)
- Merge CLAUDE.md and README.md with veenk content"
```

---

### Phase 6: zzzold Archive (Day 4)

**6.1 Create archive directory**

```bash
mkdir -p /home/jnightin/code/metasaver-marketplace/zzzold/veenk-archive
```

**6.2 Copy examples and POCs**

```bash
cp -r /home/jnightin/code/veenk/zzzold/* \
      /home/jnightin/code/metasaver-marketplace/zzzold/veenk-archive/
```

**6.3 Add archive README**

```bash
cat > /home/jnightin/code/metasaver-marketplace/zzzold/veenk-archive/README.md << 'EOF'
# Veenk Archive

This directory contains reference implementations and examples from the veenk repository.

**Migrated:** 2026-01-16
**Source:** https://github.com/metasaver/veenk (archived)

## Contents

- `examples/agents/` - LangGraph agent examples
- `examples/mcp/` - MCP server examples (calculator, weather)
- `examples/workflows/` - Workflow examples (playlist-picker)
- `pocs/` - Proof-of-concept implementations

**Note:** These are reference implementations. Do not use directly in production.

## Structure

### examples/agents/playlist-picker
Example LangGraph agent implementation for playlist generation.

### examples/mcp/calculator2
MCP server example with basic calculator tools.

### examples/mcp/weather
MCP server example with weather API integration and storage.

### examples/workflows/playlist-picker
Complete workflow example with HITL support.

### pocs/langgraph-poc
Initial LangGraph POC with HITL and scope-check examples.
EOF
```

**6.4 Commit**

```bash
git add zzzold/veenk-archive/
git commit -m "archive: Add veenk examples and POCs to archive

- Add agent examples (playlist-picker)
- Add MCP server examples (calculator2, weather)
- Add workflow examples (playlist-picker)
- Add POCs (langgraph-poc)
- Include archive README with context"
```

---

### Phase 7: Verification (Day 5) ✅

**7.1 Install dependencies**

```bash
cd /home/jnightin/code/metasaver-marketplace
pnpm install
```

**7.2 Build all packages**

```bash
pnpm build
```

**7.3 Run linters**

```bash
pnpm lint
pnpm lint:tsc
```

**7.4 Run tests**

```bash
# Run all tests
pnpm test

# Specifically test workflows
pnpm --filter @metasaver/agentic-workflows test
```

**7.5 Test LangGraph Studio**

```bash
# Start LangGraph Studio
pnpm --filter @metasaver/agentic-workflows dev

# Verify studio loads workflow
# Open http://localhost:8123
# Check that architect workflow is visible
```

**7.6 Verify Turborepo caching**

```bash
pnpm clean
pnpm build
# Should see "cache hit" on second build
pnpm build
```

**7.7 Test scripts**

```bash
# Test utility scripts
./scripts/setup-env.js
./scripts/setup-npmrc.js
./scripts/clean-and-build.sh
./scripts/killport.sh 3000
```

**7.8 Create verification checklist issue**

```bash
gh issue create --title "Veenk Migration Verification" --body "$(cat << 'EOF'
## Verification Checklist

### Core Functionality
- [ ] All workflows execute from marketplace location
- [ ] LangGraph Studio loads workflows correctly
- [ ] Tests pass (unit + integration)
- [ ] Build completes without errors
- [ ] Linting passes (ESLint + TypeScript)

### Configuration
- [ ] Turborepo caching works
- [ ] pnpm workspace resolution works
- [ ] Environment setup scripts work
- [ ] Git hooks execute correctly

### Documentation
- [ ] Epic docs are accessible
- [ ] Internal links work
- [ ] CLAUDE.md is accurate
- [ ] README is up to date

### Scripts
- [ ] setup-env.js works
- [ ] setup-npmrc.js works
- [ ] clean-and-build.sh works
- [ ] Other utility scripts work

### Archive
- [ ] zzzold examples are accessible
- [ ] Archive README is clear

### Future Work
- [ ] MCP server implementation (follows PRD)
- [ ] Additional workflows migration
- [ ] UI integration
EOF
)"
```

---

### Phase 8: Cleanup (Day 5)

**8.1 Review migration completeness**

```bash
# Check for missed files
find /home/jnightin/code/veenk -type f \
  ! -path "*/node_modules/*" \
  ! -path "*/.git/*" \
  ! -path "*/dist/*" \
  ! -path "*/.turbo/*" \
  -newer /home/jnightin/code/veenk/.git/refs/heads/master

# Verify nothing critical was missed
```

**8.2 Create summary document**

```bash
cat > /home/jnightin/code/metasaver-marketplace/docs/VEENK_MIGRATION_SUMMARY.md << 'EOF'
# Veenk Migration Summary

**Date:** 2026-01-16
**Status:** Complete
**Migration Branch:** feature/veenk-integration

## What Was Migrated

### Core Components (CRITICAL)
- ✅ LangGraph workflows (`plugins/core-claude-plugin/agentic-workflows/`)
- ✅ Epic documentation (4 epics, 66+ files)
- ✅ Turborepo configuration
- ✅ Configuration improvements (18 files)

### Supporting Files (HIGH/MEDIUM)
- ✅ Scripts (9 utility scripts)
- ✅ Claude Code hooks and settings
- ✅ Husky git hooks
- ✅ zzzold archive (reference implementations)

### Documentation (MEDIUM)
- ✅ PRDs and execution plans
- ✅ User stories (40+ files)
- ✅ CLAUDE.md merge
- ✅ README.md merge

## What Was NOT Migrated

- ❌ `node_modules/` (regenerated)
- ❌ `.git/` (preserved marketplace's history)
- ❌ `.env`, `.npmrc` (local only)
- ❌ `dist/`, `.turbo/` (build artifacts)
- ❌ Empty directories (`src/`, `apps/`, `services/`)

## File Counts

- **Total files moved:** ~240+
- **LangGraph workflow files:** 50+
- **Documentation files:** 66+
- **Configuration files:** 18
- **Scripts:** 9
- **Archive files:** 100+

## Next Steps

1. Implement MCP server (follows vnk-mcp-server PRD)
2. Test workflow integration with plugin
3. Implement HITL flow
4. Archive veenk repository

## Verification

See verification checklist in GitHub Issues.
EOF
```

**8.3 Push migration branch**

```bash
git add .
git commit -m "docs: Add veenk migration summary"
git push origin feature/veenk-integration
```

**8.4 Create pull request**

```bash
gh pr create \
  --title "feat: Migrate veenk workflows and configuration to marketplace" \
  --body "$(cat << 'EOF'
## Summary

Migrates LangGraph workflows, epic documentation, and configuration improvements from the veenk repository into metasaver-marketplace.

## What's Changed

### Core Components ⭐
- **LangGraph workflows** → `plugins/core-claude-plugin/agentic-workflows/`
  - Architect workflow implementation
  - Workflow nodes (scan-workspace, analyze-scope, validate-projects)
  - Claude Code integration utilities
  - Full test suite (9 unit tests)

### Configuration Improvements ⚙️
- **Turborepo** → Root-level build orchestration
- **NPM registry template** → `.npmrc.template`
- **LangGraph Studio** → `langgraph.json`
- **Improved configs** → `.editorconfig`, `tsconfig.json`, etc.

### Documentation 📚
- **4 Epic Directories** → 66+ documentation files
  - vnk-mcp-server (MCP server + workflow integration)
  - vnk-ui-chat-app (chat UI)
  - vnk-wfo-workflow-orchestrator (orchestration)
  - vnk-multi-runtime-agents (multi-runtime support)
- **Merged CLAUDE.md** → Added workflow documentation
- **Merged README.md** → Added LangGraph section

### Scripts & Tooling 📜
- **9 utility scripts** → Setup, build, publish, development tools
- **Claude Code hooks** → Merged `.claude/hooks/`
- **Husky git hooks** → Added `.husky/` (if not present)

### Archive 📦
- **zzzold/veenk-archive/** → Reference implementations
  - Agent examples
  - MCP server examples
  - Workflow examples
  - POCs

## Testing

- [x] `pnpm install` succeeds
- [x] `pnpm build` succeeds
- [x] `pnpm lint` passes
- [x] `pnpm test` passes
- [x] Workflow tests pass
- [x] LangGraph Studio loads workflows
- [x] Turborepo caching works

## Migration Details

See `docs/VEENK_MIGRATION_SUMMARY.md` for complete migration details.

## Related Issues

- Closes #<issue-number> (if exists)
- Blocks: MCP server implementation (vnk-mcp-server PRD)

## Post-Merge Steps

1. Archive veenk repository
2. Implement MCP server (follows PRD in `docs/epics/in-progress/vnk-mcp-server/`)
3. Test full workflow: Claude Code → MCP → LangGraph → agents

---

🤖 Generated with Claude Code

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

---

## Post-Migration Tasks

### 1. Archive Veenk Repository

**After marketplace PR is merged:**

```bash
# On GitHub:
# 1. Go to veenk repository settings
# 2. Scroll to "Danger Zone"
# 3. Click "Archive this repository"
# 4. Confirm archive

# Update repository description:
# "⚠️ ARCHIVED: Migrated to metasaver-marketplace on 2026-01-16. See marketplace for active development."
```

### 2. Update Local References

```bash
# Update Claude Code config (if needed)
# ~/.config/claude-code/config.json

# Update MCP config to point to marketplace
# ~/.config/mcp/config.json
```

### 3. Implement MCP Server

**Follow PRD in `docs/epics/in-progress/vnk-mcp-server/prd.md`:**

1. Create MCP server in `plugins/core-claude-plugin/mcp-servers/workflow-mcp/`
2. Implement workflow registry
3. Implement workflow executor
4. Add tools: `list_workflows`, `execute_workflow`, `start_workflow`, `check_workflow`, `resume_workflow`
5. Integrate with Redis checkpointer
6. Test with architect workflow

### 4. Update Package References

**If any external projects reference veenk:**

```bash
# Search for references
grep -r "@metasaver/veenk-workflows" ~/code/

# Update to:
# @metasaver/agentic-workflows
```

### 5. Test Full Integration

**Verify end-to-end workflow:**

```bash
# 1. Start services
cd /home/jnightin/code/metasaver-marketplace
pnpm docker:up  # Start Redis
pnpm dev        # Start LangGraph Studio

# 2. Start MCP server (once implemented)
# pnpm --filter workflow-mcp dev

# 3. Test via Claude Code
# /architect "analyze project structure"
# Verify: Claude Code → MCP → LangGraph → workflow → agents
```

---

## Risks & Mitigations

### Risk 1: Breaking Existing Marketplace Functionality

**Risk Level:** HIGH

**Mitigation:**

- Create backup branch before migration
- Merge configuration files carefully (don't overwrite blindly)
- Test incrementally after each phase
- Use Turborepo's task dependencies to ensure build order

**Rollback Plan:**

```bash
git checkout backup-before-veenk-migration
git branch -D feature/veenk-integration
```

---

### Risk 2: Path Import Issues After Moving Workflows

**Risk Level:** MEDIUM

**Mitigation:**

- Update `tsconfig.json` paths for new location
- Use relative imports within workflow package
- Test all imports after move: `pnpm lint:tsc`
- Run full test suite: `pnpm test`

**Fix Strategy:**

```bash
# If imports break:
# 1. Check tsconfig.json paths
# 2. Update package.json "exports"
# 3. Regenerate dist: pnpm build
# 4. Reinstall: pnpm install
```

---

### Risk 3: Losing Veenk's Git History

**Risk Level:** LOW (informational only)

**Mitigation:**

- Keep veenk repository archived (don't delete)
- Reference commit hashes in migration notes
- Add veenk repo link to archive README

**Reference Format:**

```markdown
Source: https://github.com/metasaver/veenk/commit/<hash>
Migrated: 2026-01-16
```

---

### Risk 4: Turborepo Configuration Conflicts

**Risk Level:** MEDIUM

**Mitigation:**

- Review marketplace's existing build process
- Update `turbo.json` tasks to match marketplace structure
- Test caching behavior: `pnpm build` twice (should see cache hits)
- Ensure pipeline dependencies are correct

**Validation:**

```bash
turbo build --dry-run
# Review task execution order
```

---

### Risk 5: Dependency Version Conflicts

**Risk Level:** MEDIUM

**Mitigation:**

- Review `package.json` dependencies before merging
- Use marketplace's versions where possible
- Test after `pnpm install`
- Run `pnpm outdated` to check for updates

**Resolution:**

```bash
# If conflicts occur:
pnpm install --force
# Or remove node_modules and pnpm-lock.yaml, reinstall
```

---

### Risk 6: Environment Variable Mismatches

**Risk Level:** LOW

**Mitigation:**

- Merge `.env.example` carefully
- Document any new variables in marketplace's setup docs
- Test scripts that depend on environment variables

**Validation:**

```bash
# Check if all required vars are present
./scripts/setup-env.js
diff .env.example .env
```

---

## Success Criteria

### ✅ Technical Success

- [ ] All workflows execute from marketplace location
- [ ] MCP server can load workflows from marketplace
- [ ] All scripts work with new paths
- [ ] Build completes without errors: `pnpm build`
- [ ] Linting passes: `pnpm lint && pnpm lint:tsc`
- [ ] All tests pass: `pnpm test`
- [ ] Turborepo caching works (cache hits on second build)

### ✅ Integration Success

- [ ] Claude Code can invoke workflows via plugin
- [ ] LangGraph Studio loads and displays workflows
- [ ] Redis checkpointer works (persists state)
- [ ] HITL interrupts work correctly
- [ ] Workflow execution end-to-end succeeds

### ✅ Documentation Success

- [ ] Epic documentation is complete and accessible
- [ ] Internal links work (no broken references)
- [ ] CLAUDE.md accurately reflects new structure
- [ ] README.md is up to date
- [ ] Migration summary document is complete

### ✅ Archive Success

- [ ] zzzold archive is intact and accessible
- [ ] Archive README is clear
- [ ] Reference implementations are preserved
- [ ] Veenk repository is archived (not deleted)

### ✅ Operational Success

- [ ] CI/CD pipeline passes (if applicable)
- [ ] Git hooks work correctly (Husky)
- [ ] Environment setup scripts work
- [ ] Developer onboarding documentation is updated

---

## Detailed File Inventory

### LangGraph Workflows (50+ files)

#### Source Files (18 .ts files)

```
src/architect/nodes/analyze-scope/agent.ts
src/architect/nodes/analyze-scope/config.ts
src/architect/nodes/analyze-scope/model.ts
src/architect/nodes/analyze-scope/prompt.ts
src/architect/nodes/analyze-scope/schemas.ts
src/architect/nodes/scan-workspace/scan-workspace.ts
src/architect/nodes/scan-workspace/types.ts
src/architect/nodes/scan-workspace/workspace-scanner.ts
src/architect/nodes/validate-projects/validate-projects.ts
src/architect/schemas/input.ts
src/architect/schemas/project-metadata.ts
src/architect/state.ts
src/architect/test-workflow.ts
src/architect/workflow.ts
src/utils/claude-code.ts
src/index.ts
```

#### Test Files (10 .test.ts files)

```
src/architect/nodes/analyze-scope/agent.test.ts
tests/unit/analyze-scope-model.test.ts
tests/unit/analyze-scope-node.test.ts
tests/unit/basic-state-definition.test.ts
tests/unit/claude-code.test.ts
tests/unit/langgraph-studio-integration.test.ts
tests/unit/redis-checkpointer.test.ts
tests/unit/scan-workspace-node.test.ts
tests/unit/typescript-config.test.ts
tests/unit/workspace-scanner.test.ts
```

#### Configuration Files (4 files)

```
package.json
tsconfig.json
vitest.config.ts
eslint.config.js
```

#### Distribution Files (~18 .d.ts + 18 .js files)

```
dist/architect/nodes/analyze-scope/agent.d.ts
dist/architect/nodes/analyze-scope/agent.js
dist/architect/nodes/analyze-scope/config.d.ts
dist/architect/nodes/analyze-scope/config.js
dist/architect/nodes/analyze-scope/model.d.ts
dist/architect/nodes/analyze-scope/model.js
dist/architect/nodes/analyze-scope/prompt.d.ts
dist/architect/nodes/analyze-scope/prompt.js
dist/architect/nodes/analyze-scope/schemas.d.ts
dist/architect/nodes/analyze-scope/schemas.js
dist/architect/nodes/scan-workspace/scan-workspace.d.ts
dist/architect/nodes/scan-workspace/scan-workspace.js
dist/architect/nodes/scan-workspace/types.d.ts
dist/architect/nodes/scan-workspace/types.js
dist/architect/nodes/scan-workspace/workspace-scanner.d.ts
dist/architect/nodes/scan-workspace/workspace-scanner.js
dist/architect/nodes/validate-projects/validate-projects.d.ts
dist/architect/nodes/validate-projects/validate-projects.js
dist/architect/schemas/input.d.ts
dist/architect/schemas/input.js
dist/architect/schemas/project-metadata.d.ts
dist/architect/schemas/project-metadata.js
dist/architect/state.d.ts
dist/architect/state.js
dist/architect/workflow.d.ts
dist/architect/workflow.js
dist/index.d.ts
dist/index.js
dist/utils/claude-code.d.ts
dist/utils/claude-code.js
```

**Note:** `dist/` files are not copied (regenerated after migration)

---

### Documentation Files (66+ files)

#### vnk-mcp-server (16 files)

```
docs/epics/in-progress/vnk-mcp-server/prd.md
docs/epics/in-progress/vnk-mcp-server/execution-plan.md
docs/epics/in-progress/vnk-mcp-server/MIGRATION-TO-MARKETPLACE.md  # This file
docs/epics/in-progress/vnk-mcp-server/user-stories/EPIC-001-mcp-foundation-execution.md
docs/epics/in-progress/vnk-mcp-server/user-stories/EPIC-002-hitl-production-integration.md
docs/epics/in-progress/vnk-mcp-server/user-stories/US-001-mcp-server-scaffolding.md
docs/epics/in-progress/vnk-mcp-server/user-stories/US-002-workflow-registry.md
docs/epics/in-progress/vnk-mcp-server/user-stories/US-003-list-workflows-tool.md
docs/epics/in-progress/vnk-mcp-server/user-stories/US-004-color-test-simple-workflow.md
docs/epics/in-progress/vnk-mcp-server/user-stories/US-005-workflow-executor.md
docs/epics/in-progress/vnk-mcp-server/user-stories/US-006-execute-workflow-tool.md
docs/epics/in-progress/vnk-mcp-server/user-stories/US-007-redis-checkpointer-setup.md
docs/epics/in-progress/vnk-mcp-server/user-stories/US-008-thread-id-management.md
docs/epics/in-progress/vnk-mcp-server/user-stories/US-009-color-test-hitl-workflow.md
docs/epics/in-progress/vnk-mcp-server/user-stories/US-010-start-workflow-tool.md
docs/epics/in-progress/vnk-mcp-server/user-stories/US-011-hitl-interrupt-detection.md
docs/epics/in-progress/vnk-mcp-server/user-stories/US-012-check-workflow-tool.md
docs/epics/in-progress/vnk-mcp-server/user-stories/US-013-resume-workflow-tool.md
docs/epics/in-progress/vnk-mcp-server/user-stories/US-014-hitl-flow-testing.md
docs/epics/in-progress/vnk-mcp-server/user-stories/US-015-architect-workflow-registration.md
docs/epics/in-progress/vnk-mcp-server/user-stories/US-016-architect-workflow-e2e-test.md
```

#### vnk-ui-chat-app (1 file)

```
docs/epics/in-progress/vnk-ui-chat-app/prd.md
```

#### vnk-wfo-workflow-orchestrator (35+ files)

```
docs/epics/in-progress/vnk-wfo-workflow-orchestrator/prd.md
docs/epics/in-progress/vnk-wfo-workflow-orchestrator/prd_phase2.md
docs/epics/in-progress/vnk-wfo-workflow-orchestrator/execution-plan.md
docs/epics/in-progress/vnk-wfo-workflow-orchestrator/post-mortem.md
docs/epics/in-progress/vnk-wfo-workflow-orchestrator/investigation-langgraph-studio-schema-extraction.md
docs/epics/in-progress/vnk-wfo-workflow-orchestrator/investigation-langgraph-studio-schema-extraction-v2.md
docs/epics/in-progress/vnk-wfo-workflow-orchestrator/reference/decision-hybrid-approach.md
docs/epics/in-progress/vnk-wfo-workflow-orchestrator/reference/poc-starter-code.md
docs/epics/in-progress/vnk-wfo-workflow-orchestrator/reference/prd-langgraph-workflow.md
docs/epics/in-progress/vnk-wfo-workflow-orchestrator/reference/prd.md
docs/epics/in-progress/vnk-wfo-workflow-orchestrator/reference/research-findings.md
docs/epics/in-progress/vnk-wfo-workflow-orchestrator/reference/veenk-summary.md
docs/epics/in-progress/vnk-wfo-workflow-orchestrator/user-stories/vnk-wfo-001-create-package-scaffolding.md
docs/epics/in-progress/vnk-wfo-workflow-orchestrator/user-stories/vnk-wfo-002-configure-typescript.md
docs/epics/in-progress/vnk-wfo-workflow-orchestrator/user-stories/vnk-wfo-003-integrate-langgraph-studio.md
docs/epics/in-progress/vnk-wfo-workflow-orchestrator/user-stories/vnk-wfo-004-create-claude-cli-wrapper.md
docs/epics/in-progress/vnk-wfo-workflow-orchestrator/user-stories/vnk-wfo-005-define-basic-state.md
docs/epics/in-progress/vnk-wfo-workflow-orchestrator/user-stories/vnk-wfo-006-configure-redis-checkpointer.md
docs/epics/in-progress/vnk-wfo-workflow-orchestrator/user-stories/vnk-wfo-007-implement-scan-workspace-node.md
docs/epics/in-progress/vnk-wfo-workflow-orchestrator/user-stories/vnk-wfo-008-create-workspace-scanner-utility.md
```

#### vnk-multi-runtime-agents (14 files)

```
docs/epics/in-progress/vnk-multi-runtime-agents/prd.md
docs/epics/in-progress/vnk-multi-runtime-agents/execution-plan.md
docs/epics/in-progress/vnk-multi-runtime-agents/user-stories/README.md
docs/epics/in-progress/vnk-multi-runtime-agents/user-stories/EPIC-001-type-system-and-registry.md
docs/epics/in-progress/vnk-multi-runtime-agents/user-stories/EPIC-002-cli-executor-framework.md
docs/epics/in-progress/vnk-multi-runtime-agents/user-stories/EPIC-003-analyze-scope-migration.md
docs/epics/in-progress/vnk-multi-runtime-agents/user-stories/vnk-mra-001-update-modelconfig-interface.md
docs/epics/in-progress/vnk-multi-runtime-agents/user-stories/vnk-mra-002-extend-model-registry.md
docs/epics/in-progress/vnk-multi-runtime-agents/user-stories/vnk-mra-003-create-default-models-mapping.md
docs/epics/in-progress/vnk-multi-runtime-agents/user-stories/vnk-mra-004-create-cli-executor-interface.md
docs/epics/in-progress/vnk-multi-runtime-agents/user-stories/vnk-mra-005-implement-claude-code-executor.md
docs/epics/in-progress/vnk-multi-runtime-agents/user-stories/vnk-mra-006-enhance-invoke-claude-code.md
docs/epics/in-progress/vnk-multi-runtime-agents/user-stories/vnk-mra-007-add-runtime-detection-factory.md
docs/epics/in-progress/vnk-multi-runtime-agents/user-stories/vnk-mra-008-implement-factory-routing.md
docs/epics/in-progress/vnk-multi-runtime-agents/user-stories/vnk-mra-009-update-analyze-scope-model.md
docs/epics/in-progress/vnk-multi-runtime-agents/user-stories/vnk-mra-010-consolidate-agent-implementation.md
```

---

### Configuration Files (18 files)

#### Root Configuration

```
turbo.json
pnpm-workspace.yaml
tsconfig.json
.editorconfig
.gitignore
.gitattributes
.npmrc.template
commitlint.config.js
eslint.config.js
.prettierignore
docker-compose.yml
langgraph.json
.nvmrc
.dockerignore
.repomix.config.json
.mcp.json
.env.example
package.json
```

---

### Scripts (9 files)

```
scripts/setup-npmrc.js
scripts/setup-env.js
scripts/clean-and-build.sh
scripts/use-local-packages.sh
scripts/back-to-prod.sh
scripts/publish.sh
scripts/killport.sh
scripts/run.sh
scripts/qbp.sh
```

---

### Claude Code Configuration (10 files)

```
.claude/hooks/ms-reminder-hook.js
.claude/hooks/post-format.sh
.claude/hooks/pre-compact.sh
.claude/hooks/pre-dangerous.sh
.claude/hooks/pre-env-protect.sh
.claude/hooks/pre-read-protect.sh
.claude/hooks/session-start.sh
.claude/settings.json
.claude/settings.local.json  # DON'T MOVE (local only)
```

---

### Git Hooks (21 files)

```
.husky/pre-commit
.husky/pre-push
.husky/commit-msg
.husky/_/husky.sh
.husky/_/.gitignore
.husky/_/h
.husky/_/applypatch-msg
.husky/_/commit-msg
.husky/_/post-applypatch
.husky/_/post-checkout
.husky/_/post-commit
.husky/_/post-merge
.husky/_/post-rewrite
.husky/_/pre-applypatch
.husky/_/pre-auto-gc
.husky/_/pre-commit
.husky/_/pre-merge-commit
.husky/_/prepare-commit-msg
.husky/_/pre-push
.husky/_/pre-rebase
```

---

### zzzold Archive (100+ files)

#### examples/agents/playlist-picker (12 files)

```
zzzold/examples/agents/playlist-picker/AGENT_TEMPLATE.md
zzzold/examples/agents/playlist-picker/.eslintrc.js
zzzold/examples/agents/playlist-picker/package.json
zzzold/examples/agents/playlist-picker/.prettierrc.js
zzzold/examples/agents/playlist-picker/README.md
zzzold/examples/agents/playlist-picker/src/index.ts
zzzold/examples/agents/playlist-picker/src/playlist-generator/agent.ts
zzzold/examples/agents/playlist-picker/src/playlist-generator/config.ts
zzzold/examples/agents/playlist-picker/src/playlist-generator/environments.ts
zzzold/examples/agents/playlist-picker/src/playlist-generator/index.ts
zzzold/examples/agents/playlist-picker/src/playlist-generator/model.ts
zzzold/examples/agents/playlist-picker/src/playlist-generator/prompts.ts
zzzold/examples/agents/playlist-picker/src/playlist-generator/schemas.ts
zzzold/examples/agents/playlist-picker/tsconfig.json
```

#### examples/mcp/calculator2 (13 files)

```
zzzold/examples/mcp/calculator2/ENV.md
zzzold/examples/mcp/calculator2/eslint.config.js
zzzold/examples/mcp/calculator2/package.json
zzzold/examples/mcp/calculator2/README.md
zzzold/examples/mcp/calculator2/src/index.ts
zzzold/examples/mcp/calculator2/src/server.ts
zzzold/examples/mcp/calculator2/src/tools/add-tool.ts
zzzold/examples/mcp/calculator2/src/tools/divide-tool.ts
zzzold/examples/mcp/calculator2/src/tools/index.ts
zzzold/examples/mcp/calculator2/src/tools/multiply-tool.ts
zzzold/examples/mcp/calculator2/src/tools/subtract-tool.ts
zzzold/examples/mcp/calculator2/tsconfig.json
zzzold/examples/mcp/calculator2/vitest.config.ts
```

#### examples/mcp/weather (30+ files)

```
zzzold/examples/mcp/weather/eslint.config.js
zzzold/examples/mcp/weather/initial-setup.sh
zzzold/examples/mcp/weather/package.json
zzzold/examples/mcp/weather/README.md
zzzold/examples/mcp/weather/sample-locations.json
zzzold/examples/mcp/weather/src/database/index.ts
zzzold/examples/mcp/weather/src/database/storage.ts
zzzold/examples/mcp/weather/src/index.ts
zzzold/examples/mcp/weather/src/server.ts
zzzold/examples/mcp/weather/src/tools/add-location-by-city.ts
zzzold/examples/mcp/weather/src/tools/add-location.ts
zzzold/examples/mcp/weather/src/tools/get-all-weather.ts
zzzold/examples/mcp/weather/src/tools/get-weather-by-city.ts
zzzold/examples/mcp/weather/src/tools/get-weather.ts
zzzold/examples/mcp/weather/src/tools/index.ts
zzzold/examples/mcp/weather/src/tools/list-locations.ts
zzzold/examples/mcp/weather/src/tools/remove-all-locations.ts
zzzold/examples/mcp/weather/src/tools/remove-location.ts
zzzold/examples/mcp/weather/src/types/index.ts
zzzold/examples/mcp/weather/src/weather/api.ts
zzzold/examples/mcp/weather/src/weather/formatters.ts
zzzold/examples/mcp/weather/src/weather/index.ts
zzzold/examples/mcp/weather/start.sh
zzzold/examples/mcp/weather/tsconfig.json
```

#### examples/workflows/playlist-picker (18 files)

```
zzzold/examples/workflows/playlist-picker/docs/HITL_PRODUCTION_READINESS_REVIEW.md
zzzold/examples/workflows/playlist-picker/eslint.config.js
zzzold/examples/workflows/playlist-picker/package.json
zzzold/examples/workflows/playlist-picker/src/index.ts
zzzold/examples/workflows/playlist-picker/src/playlist-picker-single-step/CONFIG.md
zzzold/examples/workflows/playlist-picker/src/playlist-picker-single-step/config.ts
zzzold/examples/workflows/playlist-picker/src/playlist-picker-single-step/index.ts
zzzold/examples/workflows/playlist-picker/src/playlist-picker-single-step/nodes/get-all-inputs.ts
zzzold/examples/workflows/playlist-picker/src/playlist-picker-single-step/nodes/index.ts
zzzold/examples/workflows/playlist-picker/src/playlist-picker-single-step/nodes/playlist.ts
zzzold/examples/workflows/playlist-picker/src/playlist-picker-single-step/schemas.ts
zzzold/examples/workflows/playlist-picker/src/playlist-picker-single-step/test/modes.js
zzzold/examples/workflows/playlist-picker/src/playlist-picker-single-step/test/single-step-test.js
zzzold/examples/workflows/playlist-picker/src/playlist-picker-single-step/workflow.ts
zzzold/examples/workflows/playlist-picker/tsconfig.json
zzzold/examples/workflows/playlist-picker/WORKFLOW_TEMPLATE.md
```

#### pocs/langgraph-poc (9 files)

```
zzzold/pocs/langgraph-poc/docker-compose.studio.yml
zzzold/pocs/langgraph-poc/langgraph.json
zzzold/pocs/langgraph-poc/package.json
zzzold/pocs/langgraph-poc/pnpm-lock.yaml
zzzold/pocs/langgraph-poc/README.md
zzzold/pocs/langgraph-poc/src/poc-hitl.ts
zzzold/pocs/langgraph-poc/src/poc-llm.ts
zzzold/pocs/langgraph-poc/src/poc-scope-check.ts
zzzold/pocs/langgraph-poc/src/poc.ts
zzzold/pocs/langgraph-poc/tsconfig.json
```

---

## Quick Reference Commands

### Complete Migration Script

```bash
#!/bin/bash
# migrate-veenk.sh
# Complete migration script (run from marketplace root)

set -e

echo "=== Veenk Migration Script ==="
echo "This will migrate veenk to metasaver-marketplace"
echo ""

# Phase 1: Backup
echo "Phase 1: Creating backup..."
git checkout -b backup-before-veenk-migration
git add .
git commit -m "backup: Checkpoint before veenk configuration merge" || true
git checkout -b feature/veenk-integration

# Phase 2: Configuration
echo "Phase 2: Copying configuration files..."
cp /home/jnightin/code/veenk/turbo.json .
cp /home/jnightin/code/veenk/.npmrc.template .
cp /home/jnightin/code/veenk/langgraph.json .
cp /home/jnightin/code/veenk/docker-compose.yml .
cp /home/jnightin/code/veenk/.nvmrc .
git add turbo.json .npmrc.template langgraph.json docker-compose.yml .nvmrc
git commit -m "config: Add Turborepo, LangGraph, and NPM registry templates from veenk"

# Phase 3: Workflows
echo "Phase 3: Migrating LangGraph workflows..."
mkdir -p plugins/core-claude-plugin/agentic-workflows
cp -r /home/jnightin/code/veenk/packages/agentic-workflows/veenk-workflows/* \
      plugins/core-claude-plugin/agentic-workflows/
rm -rf plugins/core-claude-plugin/agentic-workflows/dist
rm -rf plugins/core-claude-plugin/agentic-workflows/node_modules
git add plugins/core-claude-plugin/agentic-workflows
git commit -m "feat: Migrate LangGraph workflows from veenk"

# Phase 4: Scripts
echo "Phase 4: Copying scripts..."
for script in setup-npmrc.js setup-env.js clean-and-build.sh \
              use-local-packages.sh back-to-prod.sh killport.sh run.sh qbp.sh; do
  cp /home/jnightin/code/veenk/scripts/$script scripts/
done
git add scripts/
git commit -m "chore: Add utility scripts from veenk"

# Phase 5: Documentation
echo "Phase 5: Migrating documentation..."
cp -r /home/jnightin/code/veenk/docs/epics/in-progress/vnk-mcp-server docs/epics/in-progress/
cp -r /home/jnightin/code/veenk/docs/epics/in-progress/vnk-ui-chat-app docs/epics/in-progress/
cp -r /home/jnightin/code/veenk/docs/epics/in-progress/vnk-wfo-workflow-orchestrator docs/epics/in-progress/
cp -r /home/jnightin/code/veenk/docs/epics/in-progress/vnk-multi-runtime-agents docs/epics/in-progress/
git add docs/
git commit -m "docs: Migrate veenk epic documentation"

# Phase 6: Archive
echo "Phase 6: Creating archive..."
mkdir -p zzzold/veenk-archive
cp -r /home/jnightin/code/veenk/zzzold/* zzzold/veenk-archive/
git add zzzold/veenk-archive/
git commit -m "archive: Add veenk examples and POCs to archive"

# Phase 7: Verification
echo "Phase 7: Installing dependencies..."
pnpm install

echo "Phase 7: Building packages..."
pnpm build

echo "Phase 7: Running tests..."
pnpm test

echo ""
echo "=== Migration Complete ==="
echo "Next steps:"
echo "1. Review changes: git log"
echo "2. Push branch: git push origin feature/veenk-integration"
echo "3. Create PR: gh pr create"
echo "4. After merge: Archive veenk repository"
```

### Rollback Script

```bash
#!/bin/bash
# rollback-migration.sh
# Rollback to pre-migration state

set -e

echo "=== Rolling back veenk migration ==="
git checkout backup-before-veenk-migration
git branch -D feature/veenk-integration
echo "Rollback complete. Run 'git branch' to verify."
```

---

## Appendix: File Count Summary

| Category            | Files to Move | Files to Merge | Files to Compare | Total    |
| ------------------- | ------------- | -------------- | ---------------- | -------- |
| LangGraph Workflows | 32            | 0              | 0                | 32       |
| MCP Server Docs     | 16            | 0              | 0                | 16       |
| Configuration Files | 5             | 6              | 7                | 18       |
| Claude Code Config  | 7             | 2              | 0                | 9        |
| Scripts             | 8             | 1              | 0                | 9        |
| Documentation       | 66            | 2              | 0                | 68       |
| Git Hooks           | 21            | 0              | 0                | 21       |
| VS Code Settings    | 0             | 1              | 0                | 1        |
| zzzold Archive      | 100+          | 0              | 0                | 100+     |
| Miscellaneous       | 0             | 1              | 0                | 1        |
| **Total**           | **255+**      | **13**         | **7**            | **275+** |

**Excluded:** `node_modules/`, `.git/`, `.env`, `.npmrc`, `dist/`, `.turbo/`, `pnpm-lock.yaml`

---

## Document Metadata

**Document Version:** 1.0
**Created:** 2026-01-16
**Status:** Planning
**Author:** Claude Code
**Related Documents:**

- [vnk-mcp-server PRD](./prd.md)
- [vnk-mcp-server Execution Plan](./execution-plan.md)
- [Veenk CLAUDE.md](/home/jnightin/code/veenk/CLAUDE.md)
- [Marketplace CLAUDE.md](/home/jnightin/code/metasaver-marketplace/CLAUDE.md)

**Revision History:**

- 2026-01-16: Initial draft (v1.0)

---

**END OF MIGRATION DOCUMENT**
