# PRD: No-Barrel Module Architecture Standard

**Version:** 1.0
**Created:** 2024-12-16
**Status:** Draft
**Scope:** core-claude-plugin (all commands, agents, skills, templates)

---

## 1. Executive Summary

This PRD defines the **No-Barrel Module Architecture** standard for all MetaSaver TypeScript packages. This methodology eliminates barrel files (index.ts re-exports), uses Node.js native subpath imports (`#/`), and defines public APIs via package.json `exports` field.

**Goal:** Update all core-claude-plugin artifacts to generate code following this standard.

---

## 2. Problem Statement

### Current Issues with Barrel Files

1. **Tree-shaking failures** - Bundlers cannot eliminate unused code when imports go through barrels
2. **Circular dependencies** - Barrel files create hidden dependency cycles
3. **Slow builds** - TypeScript must resolve entire barrel chains
4. **IDE performance degradation** - Auto-import suggestions slow down
5. **Hidden coupling** - Impossible to see what's actually used
6. **Inconsistent patterns** - Mix of `export *` and named exports

### Current State

```typescript
// ❌ Current pattern - barrel files everywhere
// packages/contracts/src/users/index.ts
export * from "./types.js";
export * from "./validation.js";

// packages/contracts/src/index.ts
export * from "./users/index.js";
export * from "./roles/index.js";

// Consumer
import { User, CreateUserRequest } from "@metasaver/contracts";
```

---

## 3. Solution: No-Barrel Module Architecture

### 3.1 Core Principles

| #   | Principle                   | Description                                    |
| --- | --------------------------- | ---------------------------------------------- |
| 1   | **No barrel files**         | Delete all index.ts files that only re-export  |
| 2   | **Direct source imports**   | Import from the actual file, not a directory   |
| 3   | **Package.json exports**    | Public API defined in exports field only       |
| 4   | **Node.js subpath imports** | Use `#/` for internal cross-module imports     |
| 5   | **Named exports only**      | Never use `export *` or `export default`       |
| 6   | **One concern per file**    | Types, validation, functions in separate files |

### 3.2 Target State

```typescript
// ✅ Target pattern - no barrels, direct imports

// Internal imports (within same package) use #/
import type { User } from "#/users/types.js";
import { CreateUserRequest } from "#/users/validation.js";

// External imports (from other packages) use exports paths
import type { User } from "@metasaver/rugby-crm-contracts/users/types";
import { POSITION_HIERARCHY } from "@metasaver/rugby-crm-contracts/positions/hierarchy";
```

---

## 4. Technical Specification

### 4.1 Package Structure

```
packages/example-package/
├── package.json              # exports + imports fields
├── tsconfig.json             # paths for #/ alias
└── src/
    ├── feature-a/
    │   ├── types.ts          # Type definitions
    │   ├── validation.ts     # Zod schemas
    │   └── functions.ts      # Implementation
    ├── feature-b/
    │   ├── types.ts
    │   └── constants.ts
    └── shared/
        └── enums.ts
```

**NO index.ts files for re-exports.**

### 4.2 Package.json Configuration

```json
{
  "name": "@metasaver/example-package",
  "version": "1.0.0",
  "type": "module",
  "imports": {
    "#/*": "./src/*.js"
  },
  "exports": {
    "./*": {
      "types": "./dist/*.d.ts",
      "import": "./dist/*.js"
    }
  }
}
```

**Wildcard Exports Rationale:**

- Single entry covers all modules (zero maintenance)
- Same import paths work: `@metasaver/example-package/users/types`
- Private monorepo = "everything public" is not a concern
- Tree-shaking benefits preserved

### 4.3 TSConfig Configuration

```json
{
  "extends": "@metasaver/core-typescript-config/base",
  "compilerOptions": {
    "rootDir": "./src",
    "outDir": "./dist",
    "baseUrl": ".",
    "paths": {
      "#/*": ["./src/*"]
    }
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist", "**/*.test.ts"]
}
```

### 4.4 Vitest Configuration

```typescript
import { defineConfig } from "vitest/config";
import { resolve } from "path";

export default defineConfig({
  test: {
    environment: "node",
    globals: true,
  },
  resolve: {
    alias: {
      "#": resolve(__dirname, "./src"),
    },
  },
});
```

---

## 5. Import Rules

### 5.1 Internal Imports (Within Same Package)

Use Node.js native subpath imports with `#/` prefix:

```typescript
// ✅ CORRECT - #/ for internal imports
import type { User } from "#/users/types.js";
import { validateUser } from "#/users/validation.js";
import { AdmissionStatus } from "#/shared/enums.js";

// ❌ WRONG - relative paths
import type { User } from "../users/types.js";
import type { User } from "../../users/types.js";

// ❌ WRONG - barrel imports
import type { User } from "#/users/index.js";
import type { User } from "../users/index.js";

// ❌ WRONG - custom @ alias (not Node native)
import type { User } from "@/users/types.js";
```

### 5.2 External Imports (From Other Packages)

Use the package's exports paths:

```typescript
// ✅ CORRECT - direct to exported module
import type { User } from "@metasaver/rugby-crm-contracts/users/types";
import { CreateUserRequest } from "@metasaver/rugby-crm-contracts/users/validation";
import { POSITION_HIERARCHY } from "@metasaver/rugby-crm-contracts/positions/hierarchy";

// ❌ WRONG - package root (no barrel)
import type { User } from "@metasaver/rugby-crm-contracts";

// ❌ WRONG - directory without file
import type { User } from "@metasaver/rugby-crm-contracts/users";
```

### 5.3 Import Order

```typescript
// 1. Node.js built-ins
import { resolve } from "path";
import { readFile } from "fs/promises";

// 2. External packages
import { z } from "zod";
import express from "express";

// 3. Workspace packages (external imports)
import type { User } from "@metasaver/rugby-crm-contracts/users/types";
import { prisma } from "@metasaver/rugby-crm-database/client";

// 4. Internal imports (same package)
import type { Config } from "#/config/types.js";
import { validateInput } from "#/utils/validation.js";
```

---

## 6. File Naming Conventions

| Content Type                 | Filename                      | Export Style                               |
| ---------------------------- | ----------------------------- | ------------------------------------------ |
| Types/Interfaces             | `types.ts`                    | `export type`, `export interface`          |
| Zod schemas + inferred types | `validation.ts`               | `export const Schema`, `export type Input` |
| Constants/Configuration      | `constants.ts`                | `export const`                             |
| Enums                        | `enums.ts`                    | `export enum`                              |
| Functions/Implementation     | `{feature}.ts` or descriptive | `export function`                          |
| React Components             | `{ComponentName}.tsx`         | `export function ComponentName`            |
| Hooks                        | `use-{name}.ts`               | `export function use{Name}`                |

### 6.1 File Content Rules

```typescript
// types.ts - ONLY type definitions
export type User = {
  id: string;
  email: string;
};

export interface CreateUserResponse {
  user: User;
  token: string;
}

// validation.ts - Zod schemas and inferred types
import { z } from "zod";

export const CreateUserRequest = z.object({
  email: z.string().email(),
  name: z.string().min(1),
});

export type CreateUserInput = z.infer<typeof CreateUserRequest>;

// constants.ts - constant values
export const MAX_USERS = 100;
export const DEFAULT_ROLE = "user";

export const USER_ROLES = ["admin", "user", "guest"] as const;
```

---

## 7. Prohibited Patterns

### 7.1 Never Do This

```typescript
// ❌ NEVER - Star exports
export * from "./types.js";

// ❌ NEVER - Re-export barrel files
export { User, Role } from "./index.js";

// ❌ NEVER - index.ts that only re-exports
// src/users/index.ts
export { User } from "./types.js";
export { validateUser } from "./validation.js";

// ❌ NEVER - Default exports
export default function createUser() {}

// ❌ NEVER - Mixed default and named
export default User;
export { CreateUserRequest };

// ❌ NEVER - Import from directory
import { User } from "./users";
import { User } from "@metasaver/contracts";

// ❌ NEVER - Relative cross-module imports
import { User } from "../users/types.js";
```

### 7.2 Exceptions

The ONLY valid `index.ts` is one with **actual implementation code**, not re-exports:

```typescript
// ✅ ALLOWED - index.ts with implementation
// src/server/index.ts
import express from "express";
import { configureRoutes } from "#/routes/config.js";

export function createServer() {
  const app = express();
  configureRoutes(app);
  return app;
}
```

---

## 8. Migration Guide

### 8.1 Steps to Migrate Existing Package

1. **Audit barrel files**

   ```bash
   find src -name "index.ts" -exec grep -l "export \* from\|export {" {} \;
   ```

2. **Update all imports to use `#/` for internal, direct paths for external**

3. **Add `imports` field to package.json**

   ```json
   {
     "imports": {
       "#/*": "./src/*.js"
     }
   }
   ```

4. **Add `paths` to tsconfig.json**

   ```json
   {
     "compilerOptions": {
       "baseUrl": ".",
       "paths": {
         "#/*": ["./src/*"]
       }
     }
   }
   ```

5. **Add `exports` field with wildcard pattern**

   ```json
   {
     "exports": {
       "./*": {
         "types": "./dist/*.d.ts",
         "import": "./dist/*.js"
       }
     }
   }
   ```

6. **Delete all barrel index.ts files**

7. **Update vitest/jest config with alias**

8. **Verify build passes**
   ```bash
   pnpm build && pnpm lint:tsc
   ```

---

## 9. Plugin Artifacts to Update

### 9.1 Commands

| Command  | Changes Required                          |
| -------- | ----------------------------------------- |
| `/build` | Generate code following no-barrel pattern |
| `/audit` | Add barrel file detection to audits       |
| `/ms`    | Route to updated agents                   |

### 9.2 Agents

| Agent                            | Changes Required                         |
| -------------------------------- | ---------------------------------------- |
| `backend-dev`                    | Generate no-barrel code, use #/ imports  |
| `coder`                          | Generate no-barrel code, use #/ imports  |
| `react-component-agent`          | Use #/ for internal, direct for external |
| `typescript-configuration-agent` | Add paths config for #/                  |
| `root-package-json-agent`        | Add imports/exports fields               |

### 9.3 Skills

| Skill                      | Changes Required            |
| -------------------------- | --------------------------- |
| `typescript-configuration` | Include paths for #/ alias  |
| `vitest-config`            | Include #/ alias in resolve |

### 9.4 Templates

All package templates need:

- `package.json` with `imports` and `exports` fields
- `tsconfig.json` with `paths` for `#/`
- No index.ts barrel files
- Example files showing correct import patterns

---

## 10. Acceptance Criteria

### 10.1 Code Generation

- [ ] All generated code uses `#/` for internal imports
- [ ] All generated code uses direct export paths for external imports
- [ ] No generated code contains `export *`
- [ ] No generated code contains barrel index.ts files
- [ ] All generated package.json files have `imports` and `exports` fields
- [ ] All generated tsconfig.json files have `paths` for `#/`

### 10.2 Audit Detection

- [ ] `/audit` detects barrel files as violations
- [ ] `/audit` detects `export *` as violations
- [ ] `/audit` detects relative `../` imports as violations (should use `#/`)
- [ ] `/audit` detects missing `imports` field in package.json
- [ ] `/audit` detects missing `exports` field in package.json

### 10.3 Documentation

- [ ] All agent instructions updated with no-barrel methodology
- [ ] All skill documentation updated
- [ ] CLAUDE.md templates updated with import rules
- [ ] Example code in templates follows standard

---

## 11. Success Metrics

| Metric                          | Target              |
| ------------------------------- | ------------------- |
| New packages following standard | 100%                |
| Existing packages migrated      | 100% within 30 days |
| Build time improvement          | 20%+ reduction      |
| Bundle size reduction           | 10%+ reduction      |
| Circular dependency issues      | 0                   |

---

## 12. Appendix

### 12.1 Quick Reference Card

```
IMPORTS:
  #/path/file.js        = Internal (same package)
  @metasaver/pkg/path   = External (other package)

EXPORTS:
  export type X         = ✅ Named type export
  export function x     = ✅ Named function export
  export const X        = ✅ Named const export
  export *              = ❌ NEVER
  export default        = ❌ NEVER

FILES:
  types.ts              = Type definitions
  validation.ts         = Zod schemas
  constants.ts          = Constant values
  index.ts              = ❌ NO RE-EXPORTS

PACKAGE.JSON:
  "imports": { "#/*": "./src/*.js" }
  "exports": { "./*": { "types": "./dist/*.d.ts", "import": "./dist/*.js" } }
```

### 12.2 ESLint Rules (Future)

Consider adding these rules:

- `no-restricted-imports` - Block barrel imports
- `import/no-internal-modules` - Enforce export boundaries
- Custom rule for `#/` enforcement

---

**Document Owner:** MetaSaver Architecture Team
**Review Cycle:** Quarterly
