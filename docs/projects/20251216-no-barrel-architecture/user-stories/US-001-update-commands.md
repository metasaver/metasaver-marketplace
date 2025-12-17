---
id: US-001
title: Update commands to support no-barrel architecture
status: pending
assignee: null
---

# US-001: Update Commands to Support No-Barrel Architecture

## User Story

As a MetaSaver user, I want the `/build`, `/audit`, and `/ms` commands to generate and validate no-barrel architecture code so that all new projects follow the no-barrel standard.

## Acceptance Criteria

- [ ] `/build` command generates code using `#/` for internal imports
- [ ] `/build` command generates code using direct export paths for external imports
- [ ] `/build` command generates package.json with `imports` and `exports` fields
- [ ] `/build` command generates tsconfig.json with `paths` for `#/` alias
- [ ] `/audit` command detects barrel files (index.ts with re-exports) as CRITICAL violations
- [ ] `/audit` command detects `export *` statements as CRITICAL violations
- [ ] `/audit` command detects relative `../` imports (should use `#/`) as CRITICAL violations
- [ ] `/audit` command detects missing `imports` field in package.json as CRITICAL violations
- [ ] `/audit` command detects missing `exports` field in package.json as CRITICAL violations
- [ ] `/ms` command routes to updated agents that follow no-barrel patterns

## Technical Notes

**Hard-cut approach:** No backward compatibility or dual-pattern support. Only generate no-barrel code going forward.

**Strict audit mode:** All barrel-related violations are CRITICAL, not warnings.

## Files

- `commands/build.md`
- `commands/audit.md`
- `commands/ms.md`

## Architecture

### Key Modifications

**File: `commands/build.md`**

- Add "No-Barrel Architecture Standards" section after Phase 4 (Design)
- Include import pattern requirements (`#/` for internal, direct paths for external)
- Add package.json structure requirements (imports/exports fields)
- Add tsconfig.json requirements (paths for `#/` alias)
- Reference skills: `/skill root-package-json-config`, `/skill typescript-configuration`

**File: `commands/audit.md`**

- Add "No-Barrel Architecture Violations" section after Phase 5 (Audit Execution)
- Define CRITICAL violations:
  - Barrel files (index.ts with re-exports)
  - `export *` statements
  - Relative `../` imports (should use `#/`)
  - Missing `imports` field in package.json
  - Missing `exports` field in package.json
- Add detection patterns and remediation guidance

**File: `commands/ms.md`**

- Update Phase 2 (BA Clarification) agent routing logic
- Add no-barrel pattern awareness to agent selection
- Ensure routed agents (backend-dev, coder, react-app-agent) follow no-barrel standards
- Update validation criteria in Phase 5

### Dependencies

- Depends on: US-002 (agents must be updated before commands route to them)
- Depends on: US-004 (skills must be updated before commands reference them)
- Blocks: None (commands are terminal nodes in workflow)
