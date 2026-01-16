---
story_id: "MSM-VKM-E01-005"
epic_id: "MSM-VKM-E01"
title: "Merge root package.json from both repositories"
status: "pending"
complexity: 5
wave: 0
agent: "core-claude-plugin:generic:coder"
dependencies: ["MSM-VKM-E01-001", "MSM-VKM-E01-002"]
created: "2026-01-16"
updated: "2026-01-16"
---

# MSM-VKM-E01-005: Merge root package.json from both repositories

## User Story

**As a** developer working in the unified monorepo
**I want** a merged root package.json with scripts and dependencies from both repositories
**So that** I can run all necessary build, test, and development commands from the root

---

## Acceptance Criteria

- [ ] Root package.json contains merged scripts from marketplace and veenk
- [ ] Root package.json contains merged dependencies from both repos
- [ ] Root package.json contains merged devDependencies from both repos
- [ ] Package name updated to reflect monorepo structure
- [ ] Workspaces field added (if using npm/pnpm workspaces feature)
- [ ] Version conflicts resolved with preference for marketplace versions
- [ ] Scripts updated with correct paths for monorepo structure
- [ ] Turborepo listed in devDependencies
- [ ] File format is valid JSON
- [ ] `pnpm install` executes successfully
- [ ] Unit tests cover acceptance criteria
- [ ] All tests pass

---

## Technical Details

### Location

- **Repo:** metasaver-marketplace
- **Package:** root level

### Files to Create

None - this modifies an existing file.

### Files to Modify

| File           | Changes                                          |
| -------------- | ------------------------------------------------ |
| `package.json` | Merge scripts, dependencies, and devDependencies |

---

## Implementation Notes

Merge package.json files from both repositories:

**Source files:**

- `/home/jnightin/code/metasaver-marketplace/package.json` (current)
- `/home/jnightin/code/veenk/package.json` (to merge)

**Merge strategy:**

1. **Scripts**: Merge all scripts, prefix duplicates with namespace (e.g., `veenk:build`)
2. **Dependencies**: Merge dependencies, prefer marketplace version if conflict
3. **DevDependencies**: Merge devDependencies, prefer marketplace version if conflict
4. **Name**: Update to reflect hybrid marketplace + monorepo structure
5. **Workspaces**: Add if using pnpm workspaces (may be redundant with pnpm-workspace.yaml)

### Script Consolidation

Review and merge these script categories:

- Build scripts (build, build:watch, clean)
- Test scripts (test, test:watch, test:coverage)
- Lint scripts (lint, lint:fix, lint:tsc)
- Development scripts (dev, start)
- Utility scripts (format, typecheck)

### Dependency Resolution

When version conflicts occur:

1. Check if versions are compatible (semver range)
2. Prefer marketplace version if in use
3. Upgrade to latest if neither version is critical
4. Document any version changes in commit message

### Dependencies

Depends on:

- MSM-VKM-E01-001: pnpm workspace configuration must exist
- MSM-VKM-E01-002: Turborepo configuration must exist

---

## Architecture

(Added by architect-agent - technical annotations pending)

**Key Files:**

- `package.json` - Root package configuration for monorepo

---

## Definition of Done

- [ ] Implementation complete
- [ ] Unit tests passing
- [ ] TypeScript compiles
- [ ] Lint passes
- [ ] Acceptance criteria verified
- [ ] File validated with `cat package.json | jq`
- [ ] `pnpm install` succeeds without errors
- [ ] All scripts execute without path errors

---

## Notes

- This is a critical file that affects entire repository
- Careful merge required to avoid breaking existing functionality
- Test incrementally: install, build, lint, test
- Does not affect existing plugin structure at plugins/metasaver-core/
- Version bump scripts should exclude /packages/ directory (handled in Epic E07)
