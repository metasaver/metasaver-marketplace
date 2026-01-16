---
story_id: "MSM-VKM-E01-002"
epic_id: "MSM-VKM-E01"
title: "Add Turborepo configuration"
status: "pending"
complexity: 3
wave: 0
agent: "core-claude-plugin:config:build-tools:turbo-config-agent"
dependencies: ["MSM-VKM-E01-001"]
created: "2026-01-16"
updated: "2026-01-16"
---

# MSM-VKM-E01-002: Add Turborepo configuration

## User Story

**As a** developer building packages in the monorepo
**I want** Turborepo configuration for task orchestration and caching
**So that** builds are fast, parallelized, and benefit from intelligent caching

---

## Acceptance Criteria

- [ ] File `turbo.json` created at repository root
- [ ] Configuration includes build task with dependency tracking
- [ ] Configuration includes lint task
- [ ] Configuration includes test task
- [ ] Configuration includes dev task
- [ ] Cache configuration specified for task outputs
- [ ] Pipeline dependencies defined correctly
- [ ] File format is valid JSON
- [ ] Unit tests cover acceptance criteria
- [ ] All tests pass

---

## Technical Details

### Location

- **Repo:** metasaver-marketplace
- **Package:** root level

### Files to Create

| File         | Purpose                            |
| ------------ | ---------------------------------- |
| `turbo.json` | Define Turborepo tasks and caching |

### Files to Modify

None - this is a new file.

---

## Implementation Notes

Copy `turbo.json` from veenk repository and ensure it includes standard monorepo task definitions.

**Source location:** `/home/jnightin/code/veenk/turbo.json`
**Target location:** `/home/jnightin/code/metasaver-marketplace/turbo.json`

### Expected Configuration Structure

```json
{
  "$schema": "https://turbo.build/schema.json",
  "pipeline": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": ["dist/**", ".next/**"]
    },
    "lint": {},
    "test": {
      "dependsOn": ["build"]
    },
    "dev": {
      "cache": false,
      "persistent": true
    }
  }
}
```

### Dependencies

Depends on MSM-VKM-E01-001 (pnpm workspace configuration must exist first).

---

## Architecture

(Added by architect-agent - technical annotations pending)

**Key Files:**

- `turbo.json` - Turborepo pipeline configuration

---

## Definition of Done

- [ ] Implementation complete
- [ ] Unit tests passing
- [ ] TypeScript compiles
- [ ] Lint passes
- [ ] Acceptance criteria verified
- [ ] File validated with `cat turbo.json | jq`
- [ ] Turborepo dry-run succeeds: `turbo build --dry-run`

---

## Notes

- Turborepo provides intelligent caching for faster builds
- Pipeline dependencies ensure tasks run in correct order
- Cache configuration reduces rebuild time significantly
- Does not affect existing plugin structure at plugins/metasaver-core/
