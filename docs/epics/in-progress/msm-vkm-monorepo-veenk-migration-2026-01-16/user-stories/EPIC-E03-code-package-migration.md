---
epic_id: "MSM-VKM-E03"
title: "Code Package Migration"
status: "pending"
priority: "P0"
created: "2026-01-16"
updated: "2026-01-16"
---

# EPIC-E03: Code Package Migration

## Overview

Migrate LangGraph workflow packages from veenk repository to marketplace /packages/ directory with updated package names, import paths, and namespace.

## Goals

- Move veenk-workflows package to /packages/veenk-workflows/
- Update package.json with @metasaver namespace
- Update import paths in all TypeScript files
- Migrate test files with updated imports
- Preserve all functionality and test coverage

## Requirements Covered

| Requirement | Description                                                       |
| ----------- | ----------------------------------------------------------------- |
| FR-004      | Migrate code packages to /packages/ at repository root            |
| FR-005      | Update package.json package names to @metasaver namespace         |
| FR-006      | Update import paths in migrated code to reflect new package names |
| NFR-004     | Build process succeeds: `pnpm install && pnpm build`              |
| NFR-005     | Linting passes: `pnpm lint && pnpm lint:tsc`                      |
| NFR-006     | All migrated tests pass: `pnpm test`                              |

## User Stories

- MSM-VKM-E03-001: Create veenk-workflows package directory structure
- MSM-VKM-E03-002: Migrate workflow source files
- MSM-VKM-E03-003: Migrate workflow test files
- MSM-VKM-E03-004: Update package.json with @metasaver namespace
- MSM-VKM-E03-005: Update import paths in all TypeScript files
- MSM-VKM-E03-006: Verify build and tests pass

## Success Criteria

- [ ] Package migrated to /packages/veenk-workflows/
- [ ] Package name is @metasaver/veenk-workflows
- [ ] All import paths updated and resolve correctly
- [ ] `pnpm install` executes successfully
- [ ] `pnpm build` completes successfully
- [ ] `pnpm lint` passes with no errors
- [ ] `pnpm lint:tsc` passes with no TypeScript errors
- [ ] `pnpm test` passes (all 9 workflow unit tests)
- [ ] plugins/metasaver-core/ completely untouched

## Dependencies

Depends on Epic E01 (packages/ directory must exist) and Epic E02 (configuration files must be in place).

## Estimated Stories

6 stories (approximately 105 minutes total)
