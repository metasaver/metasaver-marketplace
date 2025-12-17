---
id: US-006
title: Update domain skills with no-barrel import examples
status: pending
assignee: null
---

# US-006: Update Domain Skills with No-Barrel Import Examples

## User Story

As a domain skill that provides code examples, I want to demonstrate no-barrel import patterns in my documentation so that developers learn the correct approach through examples.

## Acceptance Criteria

- [ ] All domain skills use `#/` for internal import examples
- [ ] All domain skills use direct export paths for external package examples
- [ ] Domain skills never show `export *` in examples
- [ ] Domain skills never show barrel index.ts files in examples
- [ ] Domain skills demonstrate correct file naming (types.ts, validation.ts, constants.ts)
- [ ] Domain skills show named exports only (no default exports)
- [ ] Import order follows standard: Node built-ins → external packages → workspace packages → internal imports

## Technical Notes

**Standard import order to demonstrate:**

```typescript
// 1. Node.js built-ins
import { resolve } from "path";
import { readFile } from "fs/promises";

// 2. External packages
import { z } from "zod";
import express from "express";

// 3. Workspace packages (external imports)
import type { User } from "@metasaver/contracts/users/types";
import { prisma } from "@metasaver/database/client";

// 4. Internal imports (same package)
import type { Config } from "#/config/types.js";
import { validateInput } from "#/utils/validation.js";
```

**File examples to update:**

- Backend domain skills (API, database, authentication)
- Frontend domain skills (React components, hooks)
- Shared/utility domain skills

**Key principle:** Be exhaustive in examples. If showing a module structure, list every file that would exist and show the complete import pattern for each.

## Files

- `skills/domain/**/*.md` (all domain skills with code examples)
- Focus on skills that demonstrate TypeScript module patterns
- Prioritize skills referenced by code generation agents

## Architecture

### Key Modifications

**Primary domain skills to update (referenced by agents):**

**File: `skills/domain/react-app-structure/SKILL.md`**

- Update "File Organization" section to remove barrel exports
- Replace any `index.ts` barrel file references with direct file imports
- Add import pattern section showing `#/` for internal React imports
- Update component import examples: `import { Button } from "#/components/Button.tsx"`
- Update hook import examples: `import { useAuth } from "#/hooks/useAuth.ts"`
- Base modifications on existing structure in SKILL.md

**File: `skills/domain/react-app-structure/TEMPLATES.md`**

- Update all code examples to use `#/` imports
- Remove default exports, use named exports only
- Update component examples with proper import order
- Add `.tsx`/`.ts` extensions to import paths

**File: `skills/domain/contracts-package/SKILL.md`**

- Update export examples to show direct path exports in package.json
- Remove any barrel file references
- Show correct exports structure: `./users/types`, `./positions/hierarchy`
- Update import examples for consumers: `from "@metasaver/contracts/users/types"`

**File: `skills/domain/prisma-database/SKILL.md`**

- Update import examples for Prisma client usage
- Show `#/` pattern for internal database utilities
- Update service layer examples with correct imports

**File: `skills/domain/data-service/SKILL.md`**

- Update all TypeScript examples with `#/` imports
- Remove barrel patterns from examples
- Add import order comments to code examples

**Additional domain skills (if they contain code examples):**

- Search `skills/domain/` for files containing `import` or `export` keywords
- Update systematically: replace relative imports, remove barrels, add `#/` pattern
- Focus on skills with TEMPLATES.md files (contain most code examples)

### Dependencies

- Depends on: None (can execute in parallel with US-002, US-003, US-004, US-005)
- Blocks: US-002 (agents reference these skills for patterns)
