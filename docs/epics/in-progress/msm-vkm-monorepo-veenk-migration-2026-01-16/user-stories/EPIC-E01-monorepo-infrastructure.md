---
epic_id: "MSM-VKM-E01"
title: "Monorepo Infrastructure Setup"
status: "pending"
priority: "P0"
created: "2026-01-16"
updated: "2026-01-16"
---

# EPIC-E01: Monorepo Infrastructure Setup

## Overview

Add monorepo foundations to metasaver-marketplace repository including pnpm workspace configuration, Turborepo orchestration, TypeScript configuration, and root package.json updates.

## Goals

- Enable monorepo structure for code packages alongside plugin marketplace
- Support parallel builds and caching with Turborepo
- Establish TypeScript configuration for shared code packages
- Merge package.json scripts and dependencies from veenk repository

## Requirements Covered

| Requirement | Description                                          |
| ----------- | ---------------------------------------------------- |
| FR-001      | Add pnpm-workspace.yaml configuration                |
| FR-002      | Add tsconfig.json at root level                      |
| FR-003      | Create standard monorepo directories                 |
| FR-007      | Merge root package.json scripts and dependencies     |
| NFR-001     | Zero impact on plugins/metasaver-core/               |
| NFR-004     | Build process succeeds: `pnpm install && pnpm build` |

## User Stories

- MSM-VKM-E01-001: Create pnpm workspace configuration
- MSM-VKM-E01-002: Add Turborepo configuration
- MSM-VKM-E01-003: Add root TypeScript configuration
- MSM-VKM-E01-004: Create standard monorepo directories
- MSM-VKM-E01-005: Merge root package.json from both repositories

## Success Criteria

- [ ] pnpm-workspace.yaml present and valid
- [ ] turbo.json present with task definitions
- [ ] tsconfig.json present at root level
- [ ] Standard directories created (packages/, apps/, services/)
- [ ] Root package.json contains merged scripts and dependencies
- [ ] `pnpm install` executes successfully
- [ ] Turborepo builds execute successfully
- [ ] plugins/metasaver-core/ completely untouched

## Dependencies

None - This is the foundation epic that other epics depend on.

## Estimated Stories

5 stories (approximately 90 minutes total)
