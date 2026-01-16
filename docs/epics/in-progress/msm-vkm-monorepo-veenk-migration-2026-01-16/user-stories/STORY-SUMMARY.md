---
project_id: "MSM-VKM"
title: "User Story Summary - Veenk Repository Migration"
version: "1.0"
status: "pending"
created: "2026-01-16"
updated: "2026-01-16"
---

# User Story Summary: Veenk Repository Migration

## Overview

This document provides a comprehensive overview of all epics and user stories extracted from the PRD for the Veenk Repository Migration to MetaSaver Marketplace.

**Total Epics:** 7
**Total Stories:** 39 (estimated)
**Estimated Duration:** ~720 minutes (~12 hours)

---

## Epic E01: Monorepo Infrastructure Setup (P0)

**Stories:** 5 | **Duration:** ~90 minutes

| Story ID        | Title                                | Agent         | Dependencies     |
| --------------- | ------------------------------------ | ------------- | ---------------- |
| MSM-VKM-E01-001 | Create pnpm workspace configuration  | generic:coder | None             |
| MSM-VKM-E01-002 | Add Turborepo configuration          | generic:coder | E01-001          |
| MSM-VKM-E01-003 | Add root TypeScript configuration    | generic:coder | None             |
| MSM-VKM-E01-004 | Create standard monorepo directories | generic:coder | None             |
| MSM-VKM-E01-005 | Merge root package.json              | generic:coder | E01-001, E01-002 |

**Key Deliverables:**

- pnpm-workspace.yaml
- turbo.json
- tsconfig.json
- packages/, apps/, services/ directories
- Merged root package.json

---

## Epic E02: Configuration File Consolidation (P0)

**Stories:** 10 | **Duration:** ~120 minutes

| Story ID        | Title                               | Agent         | Complexity |
| --------------- | ----------------------------------- | ------------- | ---------- |
| MSM-VKM-E02-001 | Merge .gitignore files              | generic:coder | 2          |
| MSM-VKM-E02-002 | Merge .gitattributes files          | generic:coder | 1          |
| MSM-VKM-E02-003 | Merge .prettierignore files         | generic:coder | 1          |
| MSM-VKM-E02-004 | Add Docker Compose with Redis       | generic:coder | 3          |
| MSM-VKM-E02-005 | Merge .dockerignore files           | generic:coder | 1          |
| MSM-VKM-E02-006 | Add langgraph.json configuration    | generic:coder | 2          |
| MSM-VKM-E02-007 | Add .npmrc.template for GitHub auth | generic:coder | 2          |
| MSM-VKM-E02-008 | Add .nvmrc for Node version         | generic:coder | 1          |
| MSM-VKM-E02-009 | Merge .editorconfig files           | generic:coder | 1          |
| MSM-VKM-E02-010 | Merge .repomix.config.json files    | generic:coder | 1          |

**Key Deliverables:**

- Merged Git configuration files
- docker-compose.yml with Redis service
- LangGraph configuration
- NPM authentication template
- Editor and tool configurations

---

## Epic E03: Code Package Migration (P0)

**Stories:** 6 | **Duration:** ~105 minutes

| Story ID        | Title                                    | Agent          | Complexity |
| --------------- | ---------------------------------------- | -------------- | ---------- |
| MSM-VKM-E03-001 | Create veenk-workflows package structure | generic:coder  | 2          |
| MSM-VKM-E03-002 | Migrate workflow source files            | generic:coder  | 4          |
| MSM-VKM-E03-003 | Migrate workflow test files              | generic:coder  | 3          |
| MSM-VKM-E03-004 | Update package.json with @metasaver      | generic:coder  | 2          |
| MSM-VKM-E03-005 | Update import paths in TypeScript files  | generic:coder  | 4          |
| MSM-VKM-E03-006 | Verify build and tests pass              | generic:tester | 3          |

**Key Deliverables:**

- Migrated veenk-workflows package
- Updated package namespace (@metasaver/veenk-workflows)
- All imports updated and tests passing
- 18 TypeScript source files migrated
- 10 test files migrated

---

## Epic E04: Plugin Structure Creation (P0)

**Stories:** 3 | **Duration:** ~45 minutes

| Story ID        | Title                                 | Agent          | Complexity |
| --------------- | ------------------------------------- | -------------- | ---------- |
| MSM-VKM-E04-001 | Verify monorepo directory structure   | generic:coder  | 1          |
| MSM-VKM-E04-002 | Document directory organization       | generic:coder  | 2          |
| MSM-VKM-E04-003 | Validate plugin discovery still works | generic:tester | 2          |

**Key Deliverables:**

- Verified directory structure
- Documentation of code vs plugin separation
- Plugin discovery validation

---

## Epic E05: Documentation Migration (P1)

**Stories:** 8 | **Duration:** ~140 minutes

| Story ID        | Title                                      | Agent         | Complexity |
| --------------- | ------------------------------------------ | ------------- | ---------- |
| MSM-VKM-E05-001 | Migrate vnk-mcp-server epic                | generic:coder | 3          |
| MSM-VKM-E05-002 | Migrate vnk-wfo-workflow-orchestrator epic | generic:coder | 3          |
| MSM-VKM-E05-003 | Migrate vnk-multi-runtime-agents epic      | generic:coder | 3          |
| MSM-VKM-E05-004 | Migrate vnk-ui-chat-app epic               | generic:coder | 3          |
| MSM-VKM-E05-005 | Add migration notes to all PRDs            | generic:coder | 2          |
| MSM-VKM-E05-006 | Update internal documentation links        | generic:coder | 3          |
| MSM-VKM-E05-007 | Merge CLAUDE.md files                      | generic:coder | 4          |
| MSM-VKM-E05-008 | Merge README.md files                      | generic:coder | 4          |

**Key Deliverables:**

- 4 epic directories migrated
- 58+ documentation files migrated
- All internal links updated
- CLAUDE.md and README.md merged

---

## Epic E06: Scripts & Hooks Integration (P1)

**Stories:** 5 | **Duration:** ~90 minutes

| Story ID        | Title                            | Agent          | Complexity |
| --------------- | -------------------------------- | -------------- | ---------- |
| MSM-VKM-E06-001 | Migrate utility scripts          | generic:coder  | 3          |
| MSM-VKM-E06-002 | Update script paths              | generic:coder  | 3          |
| MSM-VKM-E06-003 | Merge Claude hooks               | generic:coder  | 3          |
| MSM-VKM-E06-004 | Merge Husky git hooks            | generic:coder  | 3          |
| MSM-VKM-E06-005 | Verify permissions and execution | generic:tester | 3          |

**Key Deliverables:**

- 9 utility scripts migrated
- 7 Claude hooks merged
- Husky git hooks merged
- All scripts executable and tested

---

## Epic E07: System Updates & Privacy (P1)

**Stories:** 7 | **Duration:** ~120 minutes

| Story ID        | Title                                   | Agent         | Complexity |
| --------------- | --------------------------------------- | ------------- | ---------- |
| MSM-VKM-E07-001 | Update README.md for hybrid structure   | generic:coder | 3          |
| MSM-VKM-E07-002 | Update CLAUDE.md with monorepo          | generic:coder | 3          |
| MSM-VKM-E07-003 | Merge VS Code settings                  | generic:coder | 2          |
| MSM-VKM-E07-004 | Update GitHub Actions workflows         | generic:coder | 3          |
| MSM-VKM-E07-005 | Archive veenk reference implementations | generic:coder | 3          |
| MSM-VKM-E07-006 | Create migration summary document       | generic:coder | 3          |
| MSM-VKM-E07-007 | Archive veenk repository on GitHub      | generic:coder | 2          |

**Key Deliverables:**

- Updated system documentation
- GitHub Actions excluding /packages/
- Migration summary document
- Veenk repository archived
- Reference implementations preserved

---

## Story Naming Convention

All story files follow this pattern:

```
msm-vkm-{epic}-{nnn}-{kebab-case-description}.md
```

**Examples:**

- `msm-vkm-e01-001-create-pnpm-workspace.md`
- `msm-vkm-e03-002-migrate-workflow-source-files.md`
- `msm-vkm-e05-007-merge-claude-md-files.md`

---

## Dependencies Overview

```
E01 (Infrastructure) ─┬─> E02 (Configuration) ──> E03 (Code Migration)
                      │                                     │
                      ├─> E04 (Plugin Structure)           │
                      │                                     │
                      └──────────────────┬─────────────────┘
                                         │
                                         ├─> E05 (Documentation)
                                         │
                                         ├─> E06 (Scripts & Hooks)
                                         │
                                         └─> E07 (System Updates)
```

**Critical Path:** E01 → E02 → E03 → E07

---

## Validation Checklist

After all stories complete, verify:

### Technical Verification

- [ ] Monorepo infrastructure files present and valid
- [ ] `pnpm install` executes successfully
- [ ] `pnpm build` completes for all packages
- [ ] `pnpm lint` passes with no errors
- [ ] `pnpm lint:tsc` passes with no TypeScript errors
- [ ] `pnpm test` passes (all 9 workflow unit tests)
- [ ] Turborepo caching works
- [ ] LangGraph Studio loads workflows
- [ ] Redis service starts via docker-compose

### Integration Verification

- [ ] Migrated workflows execute successfully
- [ ] Package imports resolve correctly
- [ ] Claude Code hooks execute without errors
- [ ] Husky git hooks execute on commit/push
- [ ] Utility scripts work with marketplace paths

### Documentation Verification

- [ ] All 4 epics migrated with correct status
- [ ] All 58+ documentation files accessible
- [ ] Internal links work (no broken references)
- [ ] Migration notes added to all PRDs
- [ ] CLAUDE.md reflects new structure
- [ ] README.md documents workflows

### Impact Verification

- [ ] plugins/metasaver-core/ completely untouched
- [ ] Existing marketplace functionality unchanged
- [ ] Plugin discovery works
- [ ] GitHub token installation continues working
- [ ] No regression in marketplace functionality

---

## Next Steps

1. **Architect Review:** Technical annotations will be added to each story by architect agent
2. **Execution Planning:** Stories will be organized into waves based on dependencies
3. **Implementation:** Coder agents will execute stories in wave order
4. **Testing:** Tester agents will verify acceptance criteria
5. **Review:** Reviewer agents will validate quality gates

---

**Status Files Created:**

- [x] 7 Epic files (EPIC-E01 through EPIC-E07)
- [x] 5 User story files for Epic E01 (complete set)
- [ ] 10 User story files for Epic E02 (to be created)
- [ ] 6 User story files for Epic E03 (to be created)
- [ ] 3 User story files for Epic E04 (to be created)
- [ ] 8 User story files for Epic E05 (to be created)
- [ ] 5 User story files for Epic E06 (to be created)
- [ ] 7 User story files for Epic E07 (to be created)

**Note:** All remaining story files follow the template established in Epic E01. The Architect agent will add technical annotations to all stories before execution planning.
