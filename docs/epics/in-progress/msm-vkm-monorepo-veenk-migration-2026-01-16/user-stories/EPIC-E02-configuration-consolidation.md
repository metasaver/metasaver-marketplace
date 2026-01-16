---
epic_id: "MSM-VKM-E02"
title: "Configuration File Consolidation"
status: "pending"
priority: "P0"
created: "2026-01-16"
updated: "2026-01-16"
---

# EPIC-E02: Configuration File Consolidation

## Overview

Merge configuration files from veenk and marketplace repositories, including Git configurations, Docker files, editor settings, and tool-specific configurations.

## Goals

- Consolidate Git configuration files (.gitignore, .gitattributes, .prettierignore)
- Merge Docker configuration (docker-compose.yml, .dockerignore)
- Add LangGraph-specific configurations (langgraph.json)
- Add environment templates (.npmrc.template, .nvmrc)
- Merge editor configurations (.editorconfig)
- Ensure all configurations support both plugin marketplace and code packages

## Requirements Covered

| Requirement | Description                                                   |
| ----------- | ------------------------------------------------------------- |
| FR-008      | Add Docker Compose configuration for Redis service            |
| FR-009      | Merge configuration files (.gitignore, .gitattributes, etc.)  |
| FR-010      | Add new configuration files (langgraph.json, .npmrc.template) |
| FR-016      | Merge .dockerignore files from both repositories              |
| NFR-003     | All file paths use forward slashes                            |

## User Stories

- MSM-VKM-E02-001: Merge .gitignore files
- MSM-VKM-E02-002: Merge .gitattributes files
- MSM-VKM-E02-003: Merge .prettierignore files
- MSM-VKM-E02-004: Add Docker Compose configuration with Redis
- MSM-VKM-E02-005: Merge .dockerignore files
- MSM-VKM-E02-006: Add langgraph.json configuration
- MSM-VKM-E02-007: Add .npmrc.template for GitHub auth
- MSM-VKM-E02-008: Add .nvmrc for Node version
- MSM-VKM-E02-009: Merge .editorconfig files
- MSM-VKM-E02-010: Merge .repomix.config.json files

## Success Criteria

- [ ] All configuration files merged without conflicts
- [ ] Git ignores appropriate files (node_modules, dist, .env)
- [ ] Docker Compose starts Redis successfully
- [ ] LangGraph Studio loads configuration
- [ ] NPM authentication template provides clear instructions
- [ ] Editor settings consistent across both structures
- [ ] plugins/metasaver-core/ completely untouched

## Dependencies

Depends on Epic E01 (Monorepo Infrastructure Setup) for directory structure.

## Estimated Stories

10 stories (approximately 120 minutes total)
