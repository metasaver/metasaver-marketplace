---
story_id: "MSM-VKM-E01-001"
epic_id: "MSM-VKM-E01"
title: "Create pnpm workspace configuration"
status: "pending"
complexity: 2
wave: 0
agent: "core-claude-plugin:config:build-tools:pnpm-workspace-agent"
dependencies: []
created: "2026-01-16"
updated: "2026-01-16"
---

# MSM-VKM-E01-001: Create pnpm workspace configuration

## User Story

**As a** developer working in the metasaver-marketplace repository
**I want** pnpm workspace configuration that defines package locations
**So that** pnpm recognizes and manages multiple packages in the monorepo

---

## Acceptance Criteria

- [ ] File `pnpm-workspace.yaml` created at repository root
- [ ] Configuration includes `packages/*` workspace pattern
- [ ] Configuration includes `apps/*` workspace pattern (for future use)
- [ ] Configuration includes `services/*` workspace pattern (for future use)
- [ ] File format is valid YAML
- [ ] Configuration follows pnpm workspace conventions
- [ ] Unit tests cover acceptance criteria
- [ ] All tests pass

---

## Technical Details

### Location

- **Repo:** metasaver-marketplace
- **Package:** root level

### Files to Create

| File                  | Purpose                           |
| --------------------- | --------------------------------- |
| `pnpm-workspace.yaml` | Define pnpm workspace directories |

### Files to Modify

None - this is a new file.

---

## Implementation Notes

Copy `pnpm-workspace.yaml` from veenk repository and ensure it includes standard monorepo patterns for packages, apps, and services directories.

**Source location:** `/home/jnightin/code/veenk/pnpm-workspace.yaml`
**Target location:** `/home/jnightin/code/metasaver-marketplace/pnpm-workspace.yaml`

### Expected Configuration

```yaml
packages:
  - "packages/*"
  - "apps/*"
  - "services/*"
```

### Dependencies

None - this is a configuration file only.

---

## Architecture

(Added by architect-agent - technical annotations pending)

**Key Files:**

- `pnpm-workspace.yaml` - Workspace configuration for monorepo

---

## Definition of Done

- [ ] Implementation complete
- [ ] Unit tests passing
- [ ] TypeScript compiles
- [ ] Lint passes
- [ ] Acceptance criteria verified
- [ ] File validated with `cat pnpm-workspace.yaml | yq`

---

## Notes

- This is the foundation file for pnpm workspace management
- Must be at repository root for pnpm to detect it
- Does not affect existing plugin structure at plugins/metasaver-core/
