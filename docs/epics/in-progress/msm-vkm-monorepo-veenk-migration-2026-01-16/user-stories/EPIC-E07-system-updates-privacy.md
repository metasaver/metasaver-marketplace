---
epic_id: "MSM-VKM-E07"
title: "System Updates & Privacy"
status: "pending"
priority: "P1"
created: "2026-01-16"
updated: "2026-01-16"
---

# EPIC-E07: System Updates & Privacy

## Overview

Update system documentation (README.md, CLAUDE.md), GitHub Actions workflows, create migration summary, and archive veenk repository.

## Goals

- Update README.md to document hybrid marketplace + monorepo structure
- Update CLAUDE.md with monorepo conventions
- Update GitHub Actions workflows to exclude /packages/ from version bumping
- Create migration summary document
- Archive veenk repository on GitHub with reference to marketplace
- Merge VS Code settings

## Requirements Covered

| Requirement | Description                                                      |
| ----------- | ---------------------------------------------------------------- |
| FR-019      | Merge VS Code settings (.vscode/settings.json)                   |
| FR-020      | Archive veenk reference implementations to zzzold/veenk-archive/ |
| FR-021      | Update root README.md to reflect hybrid structure                |
| FR-022      | Update CLAUDE.md with monorepo conventions                       |
| FR-023      | Create migration summary document                                |
| FR-024      | Update GitHub Actions workflows to exclude /packages/            |
| FR-025      | Archive veenk repository on GitHub                               |
| NFR-011     | Git history preserved via archived veenk repository              |
| NFR-015     | Private GitHub installation continues working via GITHUB_TOKEN   |

## User Stories

- MSM-VKM-E07-001: Update README.md for hybrid structure
- MSM-VKM-E07-002: Update CLAUDE.md with monorepo conventions
- MSM-VKM-E07-003: Merge VS Code settings
- MSM-VKM-E07-004: Update GitHub Actions workflows
- MSM-VKM-E07-005: Archive veenk reference implementations
- MSM-VKM-E07-006: Create migration summary document
- MSM-VKM-E07-007: Archive veenk repository on GitHub

## Success Criteria

- [ ] README.md documents LangGraph workflows and hybrid structure
- [ ] CLAUDE.md includes monorepo conventions and package paths
- [ ] VS Code settings merged and working
- [ ] GitHub Actions exclude /packages/ from version bumping
- [ ] Reference implementations archived in zzzold/veenk-archive/
- [ ] Migration summary document created with complete details
- [ ] Veenk repository archived on GitHub (not deleted)
- [ ] Veenk repository description references marketplace
- [ ] Private GitHub installation continues working
- [ ] Follows established template/pattern
- [ ] Format validated

## Dependencies

Depends on all other epics being complete.

## Estimated Stories

7 stories (approximately 120 minutes total)
