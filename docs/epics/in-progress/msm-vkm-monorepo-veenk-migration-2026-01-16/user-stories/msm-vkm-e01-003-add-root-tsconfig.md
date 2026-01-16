---
story_id: "MSM-VKM-E01-003"
epic_id: "MSM-VKM-E01"
title: "Add root TypeScript configuration"
status: "pending"
complexity: 3
wave: 0
agent: "core-claude-plugin:config:workspace:typescript-configuration-agent"
dependencies: []
created: "2026-01-16"
updated: "2026-01-16"
---

# MSM-VKM-E01-003: Add root TypeScript configuration

## User Story

**As a** TypeScript developer working in the monorepo
**I want** a root TypeScript configuration with shared compiler options
**So that** all packages share consistent TypeScript settings and type checking

---

## Acceptance Criteria

- [ ] File `tsconfig.json` created at repository root
- [ ] Configuration uses strict TypeScript settings
- [ ] Module resolution set to "bundler" or "node16"
- [ ] Target set to ES2020 or higher
- [ ] Path mappings configured for workspace packages (if needed)
- [ ] Exclude patterns include node_modules, dist, .turbo
- [ ] File format is valid JSON
- [ ] TypeScript compiler accepts configuration without errors
- [ ] Unit tests cover acceptance criteria
- [ ] All tests pass

---

## Technical Details

### Location

- **Repo:** metasaver-marketplace
- **Package:** root level

### Files to Create

| File            | Purpose                       |
| --------------- | ----------------------------- |
| `tsconfig.json` | Root TypeScript configuration |

### Files to Modify

None - this is a new file.

---

## Implementation Notes

Copy `tsconfig.json` from veenk repository and ensure it provides shared settings for all packages.

**Source location:** `/home/jnightin/code/veenk/tsconfig.json`
**Target location:** `/home/jnightin/code/metasaver-marketplace/tsconfig.json`

### Expected Configuration Elements

```json
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "ESNext",
    "moduleResolution": "bundler",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true
  },
  "exclude": ["node_modules", "dist", ".turbo", "build"]
}
```

Individual packages can extend this root configuration with their own `tsconfig.json`.

### Dependencies

None - this is a standalone configuration file.

---

## Architecture

(Added by architect-agent - technical annotations pending)

**Key Files:**

- `tsconfig.json` - Root TypeScript compiler configuration

---

## Definition of Done

- [ ] Implementation complete
- [ ] Unit tests passing
- [ ] TypeScript compiles
- [ ] Lint passes
- [ ] Acceptance criteria verified
- [ ] File validated with `cat tsconfig.json | jq`
- [ ] TypeScript compilation succeeds: `pnpm lint:tsc`

---

## Notes

- Root tsconfig provides shared settings for all packages
- Individual packages extend this configuration as needed
- Does not affect existing plugin structure at plugins/metasaver-core/
- Strict mode ensures type safety across all TypeScript packages
