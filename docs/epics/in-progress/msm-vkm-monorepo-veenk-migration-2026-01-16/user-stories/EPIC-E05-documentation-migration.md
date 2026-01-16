---
epic_id: "MSM-VKM-E05"
title: "Documentation Migration"
status: "pending"
priority: "P1"
created: "2026-01-16"
updated: "2026-01-16"
---

# EPIC-E05: Documentation Migration

## Overview

Migrate 4 epic directories and 58+ documentation files from veenk repository to marketplace, updating links and adding migration notes.

## Goals

- Migrate all epic directories (vnk-mcp-server, vnk-wfo-workflow-orchestrator, vnk-multi-runtime-agents, vnk-ui-chat-app)
- Preserve epic structure (in-progress, backlog, completed status)
- Add migration notes to all PRDs indicating veenk origin
- Update internal documentation links
- Merge CLAUDE.md sections
- Merge README.md sections

## Requirements Covered

| Requirement | Description                                                   |
| ----------- | ------------------------------------------------------------- |
| FR-011      | Migrate 4 epic directories to docs/epics                      |
| FR-012      | Migrate 58+ documentation markdown files from veenk           |
| FR-013      | Add migration notes to all migrated epic PRDs                 |
| FR-014      | Update internal documentation links to work after migration   |
| FR-021      | Update root README.md to reflect hybrid structure             |
| FR-022      | Update CLAUDE.md with monorepo conventions                    |
| NFR-010     | Epic folder structure preserves status                        |
| NFR-014     | Documentation searchable and cross-referenced after migration |

## User Stories

- MSM-VKM-E05-001: Migrate vnk-mcp-server epic documentation
- MSM-VKM-E05-002: Migrate vnk-wfo-workflow-orchestrator epic documentation
- MSM-VKM-E05-003: Migrate vnk-multi-runtime-agents epic documentation
- MSM-VKM-E05-004: Migrate vnk-ui-chat-app epic documentation
- MSM-VKM-E05-005: Add migration notes to all PRDs
- MSM-VKM-E05-006: Update internal documentation links
- MSM-VKM-E05-007: Merge CLAUDE.md files
- MSM-VKM-E05-008: Merge README.md files

## Success Criteria

- [ ] All 4 epics migrated to docs/epics/in-progress/
- [ ] All 58+ documentation files accessible in marketplace
- [ ] Internal documentation links work (no broken references)
- [ ] Migration notes added to all PRDs
- [ ] CLAUDE.md accurately reflects new hybrid structure
- [ ] README.md documents LangGraph workflows and new structure
- [ ] Documentation follows established template/pattern
- [ ] Format validated

## Dependencies

None - documentation migration can proceed independently.

## Estimated Stories

8 stories (approximately 140 minutes total)
