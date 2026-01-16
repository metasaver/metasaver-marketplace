---
epic_id: "MSM-VKM"
title: "Veenk Repository Migration to MetaSaver Marketplace"
version: "2.0"
status: "draft"
created: "2026-01-16"
updated: "2026-01-16"
owner: "business-analyst-agent"
---

# PRD: Veenk Repository Migration to MetaSaver Marketplace

## 1. Executive Summary

Consolidate the Veenk LangGraph workflow platform repository into the MetaSaver Marketplace repository, transforming it from a single-purpose marketplace into a hybrid marketplace + monorepo structure. This migration will enable unified management of Claude Code plugins alongside TypeScript-based code packages while maintaining strict separation of concerns.

**Goal:** Merge veenk repository into metasaver-marketplace as a hybrid structure with monorepo infrastructure, code packages, and plugin structure, without disrupting the existing metasaver-core plugin.

## 2. Problem Statement

### Current State

- **Separate Repositories:** Veenk and MetaSaver Marketplace exist as independent repositories with duplicate infrastructure
- **Split Development:** Developers must switch between repositories for plugin development vs. LangGraph workflow development
- **Duplicate Configurations:** Shared configurations (TypeScript, ESLint, Prettier, DevOps) are duplicated across repositories
- **Documentation Fragmentation:** 4 active epics and 58+ documentation files exist separately in veenk repository
- **Infrastructure Duplication:** Scripts, hooks, and DevOps files are maintained independently
- **No Code Distribution:** Marketplace currently only distributes plugins (agents, skills, commands), not executable code packages

### Pain Points

1. Context switching overhead between repositories slows development velocity
2. Configuration drift and inconsistency between repositories
3. Duplicated documentation and epic tracking complicates knowledge management
4. Separate Git histories complicate auditing and traceability
5. Redundant CI/CD pipelines and DevOps configurations increase maintenance burden
6. LangGraph workflows designed for core-claude-plugin integration require cross-repo coordination

## 3. Solution Overview

### Target State

A unified metasaver-marketplace repository with:

- **Hybrid Structure:** Marketplace for plugin distribution + monorepo for code packages
- **Monorepo Infrastructure:** pnpm workspace, Turborepo, TypeScript at root level
- **Code Packages:** Located at `/packages/` (root level, not in plugin directories)
- **MetaSaver Core Plugin:** Untouched at `plugins/metasaver-core/`
- **Unified Configuration:** Merged config files leveraging best practices from both repos
- **Consolidated Documentation:** All epics and docs in single location
- **Merged DevOps:** Combined scripts, hooks, Docker configurations

### Core Principles

| #   | Principle              | Description                                                        |
| --- | ---------------------- | ------------------------------------------------------------------ |
| 1   | Separation of Concerns | Code packages separate from plugins; plugins separate from code    |
| 2   | Zero Impact            | MetaSaver Core plugin remains completely untouched                 |
| 3   | Merge Only             | This is a repository consolidation, not feature implementation     |
| 4   | Standard Structure     | Follow standard monorepo conventions (apps/, packages/, services/) |
| 5   | Documentation Unity    | All epics and docs consolidated into single location               |
| 6   | Configuration Upgrade  | Adopt superior configurations where they improve tooling           |
| 7   | Archive Source         | Veenk repository archived (not deleted) to preserve Git history    |

## 4. Requirements

### Functional Requirements

| ID     | Requirement                                                                  | Priority |
| ------ | ---------------------------------------------------------------------------- | -------- |
| FR-001 | Add monorepo infrastructure files (pnpm-workspace.yaml, turbo.json)          | P0       |
| FR-002 | Add TypeScript configuration (tsconfig.json) at root level                   | P0       |
| FR-003 | Create standard monorepo directories (packages/, apps/, services/)           | P0       |
| FR-004 | Migrate code packages to /packages/ at repository root                       | P0       |
| FR-005 | Update package.json package names to @metasaver namespace                    | P0       |
| FR-006 | Update import paths in migrated code to reflect new package names            | P0       |
| FR-007 | Merge root package.json scripts and dependencies from both repositories      | P0       |
| FR-008 | Add Docker Compose configuration for Redis service (LangGraph checkpointing) | P0       |
| FR-009 | Merge configuration files (.gitignore, .gitattributes, .prettierignore)      | P0       |
| FR-010 | Add new configuration files (langgraph.json, .npmrc.template, .nvmrc)        | P0       |
| FR-011 | Migrate 4 epic directories (in-progress, backlog, completed) to docs/epics   | P1       |
| FR-012 | Migrate 58+ documentation markdown files from veenk repository               | P1       |
| FR-013 | Add migration notes to all migrated epic PRDs indicating veenk origin        | P1       |
| FR-014 | Update internal documentation links to work after migration                  | P1       |
| FR-015 | Migrate utility scripts from veenk/scripts/ to marketplace scripts/          | P1       |
| FR-016 | Merge .dockerignore files from both repositories                             | P1       |
| FR-017 | Merge Claude hooks from veenk/.claude/hooks/ with marketplace hooks          | P1       |
| FR-018 | Merge or add Husky git hooks from veenk/.husky/                              | P1       |
| FR-019 | Merge VS Code settings (.vscode/settings.json)                               | P2       |
| FR-020 | Archive veenk reference implementations to marketplace zzzold/veenk-archive/ | P1       |
| FR-021 | Update root README.md to reflect hybrid marketplace + monorepo structure     | P1       |
| FR-022 | Update CLAUDE.md with monorepo conventions and structure                     | P1       |
| FR-023 | Create migration summary document in marketplace                             | P1       |
| FR-024 | Update GitHub Actions workflows to exclude /packages/ from version bumping   | P2       |
| FR-025 | Archive veenk repository on GitHub (mark as archived, update description)    | P1       |

### Non-Functional Requirements

| ID      | Requirement                                                              | Priority |
| ------- | ------------------------------------------------------------------------ | -------- |
| NFR-001 | Zero impact on plugins/metasaver-core/ (no files modified or touched)    | P0       |
| NFR-002 | Migration completes without breaking existing marketplace functionality  | P0       |
| NFR-003 | All file paths use forward slashes for cross-platform compatibility      | P0       |
| NFR-004 | Build process succeeds: `pnpm install && pnpm build`                     | P0       |
| NFR-005 | Linting passes: `pnpm lint && pnpm lint:tsc`                             | P0       |
| NFR-006 | All migrated tests pass: `pnpm test`                                     | P0       |
| NFR-007 | LangGraph Studio successfully loads migrated workflows                   | P0       |
| NFR-008 | Turborepo caching functions correctly (cache hits on second build)       | P1       |
| NFR-009 | Scripts maintain executable permissions after migration                  | P1       |
| NFR-010 | Epic folder structure preserves status (in-progress, backlog, completed) | P1       |
| NFR-011 | Git history preserved via archived veenk repository                      | P1       |
| NFR-012 | Package naming follows @metasaver/\* namespace convention                | P1       |
| NFR-013 | Configuration files follow standard naming conventions                   | P1       |
| NFR-014 | Documentation searchable and cross-referenced after migration            | P1       |
| NFR-015 | Private GitHub installation continues working via GITHUB_TOKEN           | P0       |

## 5. Scope

### In Scope

**1. Monorepo Infrastructure**

- pnpm-workspace.yaml configuration
- turbo.json task orchestration
- tsconfig.json TypeScript settings
- Root package.json scripts and dependencies
- Standard directories (packages/, apps/, services/)

**2. Code Packages Migration**

- packages/agentic-workflows/veenk-workflows/ → packages/veenk-workflows/
- 18 TypeScript source files (workflow nodes, schemas, state, utilities)
- 10 test files (unit tests for workflows)
- All package.json files updated with @metasaver namespace
- Import paths updated to reflect new package names
- pnpm workspace configuration

**3. Documentation Migration**

- 4 epic folders (vnk-mcp-server, vnk-wfo-workflow-orchestrator, vnk-multi-runtime-agents, vnk-ui-chat-app)
- 58+ markdown files (PRDs, user stories, execution plans, investigations)
- Epic structure preservation (in-progress, backlog, completed)
- Migration notes added to all PRDs
- Internal links updated
- Merge CLAUDE.md sections
- Merge README.md sections

**4. DevOps Consolidation**

- docker-compose.yml merge (add Redis service)
- .dockerignore merge
- .editorconfig merge
- .gitignore merge
- .gitattributes merge
- .prettierignore merge
- .repomix.config.json merge
- langgraph.json addition
- .npmrc.template addition
- .nvmrc addition

**5. Scripts and Hooks**

- 9 utility scripts from veenk (setup-npmrc.js, setup-env.js, clean-and-build.sh, use-local-packages.sh, back-to-prod.sh, killport.sh, run.sh, qbp.sh, publish.sh)
- Script paths updated to marketplace directories
- Claude hooks merged (7 files from veenk/.claude/hooks/)
- Husky git hooks merged or added (from veenk/.husky/)
- Executable permissions preserved

**6. Archive & Preservation**

- Copy veenk zzzold/ directory to marketplace zzzold/veenk-archive/
- Reference implementations (examples/agents, examples/mcp, examples/workflows, pocs/)
- 100+ reference files archived
- README.md added to archive documenting contents

**7. System Files**

- VS Code settings merge (.vscode/settings.json)
- GitHub Actions workflow updates (exclude /packages/ from version bumping)
- Migration summary document creation

**8. GitHub Process**

- Archive veenk repository on GitHub
- Update veenk repository description to reference marketplace
- Document repository archival process

### Out of Scope

**NOT Included in This Migration:**

1. **MCP Server Implementation** - Only documentation migrated; implementation follows vnk-mcp-server PRD separately
2. **UI Chat App Implementation** - Only documentation migrated; implementation follows vnk-ui-chat-app PRD separately
3. **Veenk Plugin Creation** - No new Claude Code plugin created for veenk
4. **Code Refactoring** - Migrated code preserved as-is; refactoring happens separately
5. **Dependency Updates** - Package versions remain as-is unless conflicts require resolution
6. **Empty Directories** - Do not migrate empty directories (src/, services/ empty in veenk)
7. **Generated/Cache Files** - Do not migrate node_modules/, dist/, .turbo/, pnpm-lock.yaml, .langgraph_api/
8. **Local Environment Files** - Do not migrate .env, .npmrc, .claude/settings.local.json
9. **Git Metadata** - Do not migrate .git/ directory (marketplace keeps its own git history)
10. **CI/CD Pipeline Execution** - Updates only; no pipeline execution or testing
11. **Testing Infrastructure Setup** - Migrate tests only; no new test infrastructure
12. **Package Publishing** - No publishing to registries during migration
13. **Modification of metasaver-core** - plugins/metasaver-core/ completely off-limits
14. **Database Schema** - No database migrations or schema updates
15. **API Endpoints** - No API implementation or endpoint creation
16. **UI Components** - No UI/UX component implementation

## 6. Epic Summary

| Epic ID | Epic Name                        | Description                                                                                  | Priority | Story Count | Complexity |
| ------- | -------------------------------- | -------------------------------------------------------------------------------------------- | -------- | ----------- | ---------- |
| E01     | Monorepo Infrastructure Setup    | Add monorepo foundations (pnpm-workspace, turbo.json, tsconfig.json, root package.json)      | P0       | TBD         | TBD        |
| E02     | Configuration File Consolidation | Merge configuration files from both repositories (.gitignore, docker-compose, etc.)          | P0       | TBD         | TBD        |
| E03     | Code Package Migration           | Migrate LangGraph workflows to /packages/ with updated imports and package names             | P0       | TBD         | TBD        |
| E04     | Plugin Structure Creation        | Create standard monorepo directories (packages/, apps/, services/) without disrupting plugin | P0       | TBD         | TBD        |
| E05     | Documentation Migration          | Migrate 4 epics and 58+ documentation files with updated links and migration notes           | P1       | TBD         | TBD        |
| E06     | Scripts & Hooks Integration      | Merge utility scripts, Claude hooks, and Husky git hooks from both repositories              | P1       | TBD         | TBD        |
| E07     | System Updates & Privacy         | Update README/CLAUDE.md, GitHub Actions, archive veenk repository                            | P1       | TBD         | TBD        |

### E01: Monorepo Infrastructure Setup

**Architecture:**

- Files to create:
  - `pnpm-workspace.yaml` (base on veenk - copy workspace patterns)
  - `turbo.json` (base on veenk - copy build pipeline config)
  - `tsconfig.json` (base on veenk - copy compiler options)
  - `.nvmrc` (copy from veenk - Node 22.0.0)
  - `langgraph.json` (copy from veenk - workflow config)
- Files to modify:
  - `package.json` (merge scripts, dependencies, engines from veenk)
- Workspace config: `packages/*` pattern for package discovery
- Turbo tasks: build, lint, lint:tsc, test:unit, prettier

### E02: Configuration File Consolidation

**Architecture:**

- Files to merge (veenk → marketplace):
  - `.gitignore` (add Node.js, Turborepo, LangGraph patterns)
  - `.gitattributes` (add line ending rules)
  - `.prettierignore` (add build/cache directories)
  - `.dockerignore` (merge patterns)
  - `.editorconfig` (compare, keep marketplace version)
  - `.repomix.config.json` (add packages/ to include paths)
- Files to create:
  - `docker-compose.yml` (Redis service for LangGraph checkpointing)
  - `.npmrc.template` (copy from veenk - private registry config)
- Merge strategy: Union of patterns, marketplace takes precedence on conflicts

### E03: Code Package Migration

**Architecture:**

- Source: `/home/jnightin/code/veenk/packages/agentic-workflows/veenk-workflows/`
- Target: `/home/jnightin/code/metasaver-marketplace/packages/veenk-workflows/`
- Files to copy (32 total):
  - `src/**/*.ts` (18 workflow files)
  - `__tests__/**/*.test.ts` (10 test files)
  - `package.json`, `tsconfig.json`, `README.md`, `vitest.config.ts`
- Package name: Keep `@metasaver/veenk-workflows`
- Import updates: No cross-package imports yet (self-contained)
- Dependencies: Copy devDependencies from veenk package.json

### E04: Plugin Structure Creation

**Architecture:**

- Directories to create:
  - `/home/jnightin/code/metasaver-marketplace/packages/` (workspace root)
  - `/home/jnightin/code/metasaver-marketplace/apps/` (empty, future use)
  - `/home/jnightin/code/metasaver-marketplace/services/` (empty, future use)
- Files to create:
  - `packages/.gitkeep` (ensure directory tracked)
  - `apps/README.md` (document purpose)
  - `services/README.md` (document purpose)
- Zero impact: plugins/metasaver-core/ untouched

### E05: Documentation Migration

**Architecture:**

- Source epics: `/home/jnightin/code/veenk/docs/epics/in-progress/{vnk-mcp-server,vnk-wfo-workflow-orchestrator,vnk-multi-runtime-agents,vnk-ui-chat-app}/`
- Target: `/home/jnightin/code/metasaver-marketplace/docs/epics/in-progress/`
- Files to copy: 58+ markdown files (PRDs, stories, plans, investigations)
- Files to modify: All PRD files (add migration note header)
- Migration note template:
  ```markdown
  > **Migration Note:** Migrated from veenk repository (2026-01-16)
  > Original epic: [epic-id] | Veenk commit: [hash]
  ```
- Link updates: Replace `/home/jnightin/code/veenk/` with `/home/jnightin/code/metasaver-marketplace/`

### E06: Scripts & Hooks Integration

**Architecture:**

- Scripts to copy (9 files):
  - `/home/jnightin/code/veenk/scripts/` → `/home/jnightin/code/metasaver-marketplace/scripts/`
  - Files: setup-npmrc.js, setup-env.js, clean-and-build.sh, use-local-packages.sh, back-to-prod.sh, killport.sh, run.sh, qbp.sh, publish.sh
- Scripts to merge:
  - Compare existing marketplace scripts for conflicts
- Claude hooks to merge:
  - `/home/jnightin/code/veenk/.claude/hooks/` (7 files) → marketplace `.claude/hooks/`
- Husky hooks to add:
  - `/home/jnightin/code/veenk/.husky/` (21 files) → marketplace `.husky/`
- Files to modify:
  - Script path references (update to marketplace structure)
- Preserve: Executable permissions (chmod +x)

### E07: System Updates & Privacy

**Architecture:**

- Files to modify:
  - `README.md` (add monorepo structure section, LangGraph workflows)
  - `CLAUDE.md` (add monorepo conventions, workspace usage)
  - `.github/workflows/version-bump.yml` (exclude packages/ from auto-versioning)
- Files to create:
  - `docs/epics/in-progress/msm-vkm-monorepo-veenk-migration-2026-01-16/MIGRATION-SUMMARY.md`
  - `zzzold/veenk-archive/README.md` (document archived contents)
- Archive structure:
  - `/home/jnightin/code/veenk/zzzold/` → `/home/jnightin/code/metasaver-marketplace/zzzold/veenk-archive/`
  - 100+ reference files (examples/agents, examples/mcp, examples/workflows, pocs/)
- GitHub: Archive veenk repository via Settings → General → Archive

## 7. Success Criteria

**Technical Verification:**

- [ ] Monorepo infrastructure files present and valid (pnpm-workspace.yaml, turbo.json, tsconfig.json)
- [ ] `pnpm install` executes successfully without errors
- [ ] `pnpm build` completes successfully for all packages
- [ ] `pnpm lint` passes with no errors
- [ ] `pnpm lint:tsc` passes with no TypeScript errors
- [ ] `pnpm test` passes (all 9 workflow unit tests)
- [ ] Turborepo caching works (verified cache hits on second build)
- [ ] LangGraph Studio loads and displays architect workflow
- [ ] Redis service starts successfully via `docker-compose up`

**Integration Verification:**

- [ ] Migrated workflows execute successfully from marketplace location
- [ ] Workflow package imports resolve correctly after migration
- [ ] Claude Code hooks execute without errors
- [ ] Husky git hooks execute on commit/push
- [ ] Utility scripts work with marketplace paths

**Documentation Verification:**

- [ ] All 4 epics migrated with correct status folders
- [ ] All 58+ documentation files accessible in marketplace
- [ ] Internal documentation links work (no broken references)
- [ ] Migration notes added to all PRDs
- [ ] CLAUDE.md accurately reflects new hybrid structure
- [ ] README.md documents LangGraph workflows and new structure
- [ ] Archive README.md clearly documents reference implementations

**Preservation Verification:**

- [ ] All veenk reference implementations preserved in zzzold/veenk-archive/
- [ ] Veenk repository archived on GitHub (not deleted)
- [ ] Git history accessible via archived veenk repository
- [ ] Migration summary document created

**Impact Verification:**

- [ ] plugins/metasaver-core/ completely untouched (verified by git status)
- [ ] Existing marketplace functionality unchanged
- [ ] Plugin discovery works for metasaver-core plugin
- [ ] GitHub token-based private installation continues working
- [ ] Zero broken file references or import paths
- [ ] No regression in marketplace functionality

## 8. Risks & Mitigations

| Risk                                                | Impact | Likelihood | Mitigation                                                                                                   |
| --------------------------------------------------- | ------ | ---------- | ------------------------------------------------------------------------------------------------------------ |
| Accidental modification of metasaver-core plugin    | High   | Medium     | Create backup branch; use git status verification; automated pre-commit hook to prevent changes              |
| Package dependency conflicts during merge           | High   | Medium     | Carefully merge package.json; test pnpm install; resolve conflicts using marketplace versions where possible |
| Path import issues after moving workflows           | High   | Medium     | Update tsconfig.json paths; use relative imports; run pnpm lint:tsc after move; run full test suite          |
| Breaking marketplace plugin functionality           | High   | Medium     | Merge configs carefully (don't overwrite); test incrementally after each phase; maintain backup branch       |
| Script conflicts (duplicate script names)           | Medium | High       | Review scripts for conflicts; rename if necessary; document changes in migration notes                       |
| Hook conflicts (duplicate hook functionality)       | Medium | Medium     | Compare hooks; merge logic where beneficial; test hook execution after merge                                 |
| Broken internal documentation links after migration | Medium | High       | Update all relative paths; verify links post-migration; use grep to find hardcoded paths                     |
| Turborepo configuration conflicts                   | Medium | Medium     | Review existing build process; update turbo.json tasks; test caching with `turbo build --dry-run`            |
| Loss of Git history during migration                | High   | Low        | Archive veenk repository; reference commit hashes in migration notes; add veenk repo link to archive README  |
| GitHub Actions workflow failures post-migration     | Medium | High       | Update workflow paths; test CI pipeline; exclude /packages/ from version bumping                             |
| Docker Compose service name conflicts               | Low    | Low        | Review service names; namespace if needed; test docker-compose up                                            |
| Environment variable mismatches                     | Low    | Low        | Merge .env.example carefully; document new variables; run ./scripts/setup-env.js                             |
| Dependency version conflicts                        | Medium | Low        | Review package.json dependencies; use marketplace versions where possible; run pnpm outdated                 |

## 9. Dependencies

**Repository Access:**

- Read access to /home/jnightin/code/veenk repository
- Write access to /home/jnightin/code/metasaver-marketplace repository

**Tooling Requirements:**

- pnpm 10.20.0+ (package manager)
- Turbo 2.6.1+ (monorepo build system)
- Node.js 22.0.0+ (runtime)
- Docker + Docker Compose (for Redis service)
- Git (version control)

**External Dependencies:**

- GitHub (repository hosting and archiving)
- Redis 7 (LangGraph checkpointing service)
- LangGraph Studio (workflow visualization and testing)

**Technical Dependencies:**

- LangGraph workflows depend on Redis for state persistence
- Turborepo depends on pnpm workspaces for package discovery
- Claude Code plugin discovery depends on .claude-plugin/marketplace.json

**Knowledge Dependencies:**

- Veenk migration document: MIGRATION-TO-MARKETPLACE.md (comprehensive guide)
- Technical impact analysis: research.md (identifies affected files and systems)
- Marketplace structure: CLAUDE.md (current repository conventions)

## 10. Design Decisions

| Decision ID | Question                                                       | Decision                                                            | Rationale                                                                                                                                                         |
| ----------- | -------------------------------------------------------------- | ------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| DD-001      | Should repository structure be marketplace-only or hybrid?     | Hybrid marketplace + monorepo structure                             | Enables distribution of both plugins (agents/skills/commands) and executable code packages (workflows/MCP servers) from single repository; simplifies integration |
| DD-002      | Where should code packages live?                               | Root `/packages/` directory, not inside plugin directories          | Code packages are shared resources not specific to any plugin; root location supports multiple future plugins; follows standard monorepo patterns                 |
| DD-003      | Should metasaver-core plugin be modified during migration?     | No changes to existing plugin structure or files                    | Ensures zero breaking changes for existing users; migration is additive only; maintains backward compatibility                                                    |
| DD-004      | Should veenk repository be deleted or archived?                | Archive repository (mark as archived on GitHub)                     | Preserves git history for reference; allows future lookups of commit context; maintains audit trail; can be restored if needed                                    |
| DD-005      | Should configuration files be replaced or merged?              | Merge configurations, preferring marketplace values where conflicts | Prevents losing marketplace-specific settings; adopts veenk improvements where superior; requires manual review of each conflict                                  |
| DD-006      | Should epic documentation stay in-progress or move to archive? | Keep in `docs/epics/in-progress/` with migration notes in each PRD  | Documentation represents active work (MCP server, workflows); marking as migrated from veenk provides context; will move to completed/ when implemented           |
| DD-007      | Should Docker Compose be included for Redis?                   | Yes, add `docker-compose.yml` for Redis service                     | LangGraph workflows require Redis for checkpointing; simplifies developer onboarding; supports local development; documented in README                            |
| DD-008      | Should package namespace remain @metasaver or change?          | Keep `@metasaver` namespace                                         | Maintains brand consistency; clearly describes purpose; no conflicts with existing packages                                                                       |
| DD-009      | Should Turborepo be added even with one package?               | Yes, add full Turborepo infrastructure                              | Anticipates future packages (MCP server, UI app, shared libraries); establishes pattern early; minimal overhead; enables caching and parallel builds              |

---

**Document Status:** Draft v2.0 - Enterprise Architect Review Complete

**Next Steps:**

1. Review PRD with stakeholders
2. Hand off to Business Analyst for epic and user story extraction
3. Business Analyst creates execution plan with prioritized stories
4. Architect agent adds technical annotations to user stories
