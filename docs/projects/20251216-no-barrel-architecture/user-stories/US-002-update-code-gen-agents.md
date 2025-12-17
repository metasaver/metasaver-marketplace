---
id: US-002
title: Update code generation agents for no-barrel pattern
status: pending
assignee: null
---

# US-002: Update Code Generation Agents for No-Barrel Pattern

## User Story

As a developer using MetaSaver agents, I want backend-dev, coder, and react-app-agent to generate code following the no-barrel architecture so that all generated code uses `#/` imports and explicit exports.

## Acceptance Criteria

- [ ] `backend-dev` agent generates internal imports using `#/` prefix (e.g., `import { User } from "#/users/types.js"`)
- [ ] `backend-dev` agent generates external imports using direct export paths (e.g., `import { User } from "@metasaver/pkg/users/types"`)
- [ ] `backend-dev` agent never generates `export *` statements
- [ ] `backend-dev` agent never generates barrel index.ts files
- [ ] `coder` agent follows same no-barrel patterns as backend-dev
- [ ] `coder` agent generates only named exports (no default exports)
- [ ] `react-app-agent` uses `#/` for internal component/hook imports
- [ ] `react-app-agent` uses direct paths for external package imports
- [ ] All agents follow file naming conventions (types.ts, validation.ts, constants.ts, etc.)

## Technical Notes

**Internal imports pattern:**

```typescript
import type { User } from "#/users/types.js";
import { validateUser } from "#/users/validation.js";
```

**External imports pattern:**

```typescript
import type { User } from "@metasaver/contracts/users/types";
import { POSITION_HIERARCHY } from "@metasaver/contracts/positions/hierarchy";
```

**Prohibited patterns:**

- `export * from "./types.js"` (NEVER)
- `export default function() { ... }` (NEVER)
- `import { X } from "../users/types.js"` (use `#/` instead)
- `index.ts` files with re-exports (NEVER)

## Files

- `agents/generic/backend-dev.md`
- `agents/generic/coder.md`
- `agents/domain/frontend/react-app-agent.md`

## Architecture

### Key Modifications

**File: `agents/generic/backend-dev.md`**

- Add "No-Barrel Import Standards" section after "Technology Stack"
- Update "Build Mode - API Development" section with import examples:
  - Internal imports: `import { User } from "#/users/types.js"`
  - External imports: `import { User } from "@metasaver/contracts/users/types"`
- Add "Prohibited Patterns" subsection listing `export *`, default exports, relative `../` imports, barrel files
- Update skill reference: `/skill backend-api-development` (will need updating in US-006)

**File: `agents/generic/coder.md`**

- Add "Import/Export Standards" section after "Code Reading (MANDATORY)"
- Include import pattern table (internal `#/`, external direct paths)
- Add export pattern rules (named exports only, no `export *`)
- Update "Code Organization" section to reference updated domain skills
- Remove any barrel file examples or references

**File: `agents/domain/frontend/react-app-agent.md`**

- Update "Skill Reference" section to note no-barrel patterns in skill
- Add "Import Conventions" section before "Core Responsibilities"
- Include React-specific import order:
  - React/React Router
  - External packages
  - Workspace packages (direct paths)
  - Internal components/hooks (`#/`)
- Update references to `/skill domain/react-app-structure` (will be updated in US-006)

### Dependencies

- Depends on: None (can execute in parallel with US-003, US-004, US-005, US-006)
- Blocks: US-001 (commands reference these agents)
