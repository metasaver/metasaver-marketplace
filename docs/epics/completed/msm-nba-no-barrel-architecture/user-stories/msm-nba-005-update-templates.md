---
id: US-005
title: Update templates to include no-barrel patterns
status: pending
assignee: null
---

# US-005: Update Templates to Include No-Barrel Patterns

## User Story

As a template used for code generation, I want to include no-barrel architecture patterns in my examples so that developers see correct import/export patterns from the start.

## Acceptance Criteria

- [ ] All `tsconfig-*.template.json` files include `paths: { "#/*": ["./src/*"] }`
- [ ] All `tsconfig-*.template.json` files include `baseUrl: "."`
- [ ] Domain templates remove any barrel file examples (index.ts with re-exports)
- [ ] Domain templates show `#/` import pattern examples
- [ ] Domain templates show direct export path examples for external packages
- [ ] Domain templates demonstrate file naming conventions (types.ts, validation.ts, etc.)
- [ ] Domain templates show only named exports (no `export *`, no `export default`)
- [ ] Package templates include `imports` and `exports` fields in package.json

## Technical Notes

**TSConfig template updates:**
All tsconfig templates should include:

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

**Import pattern examples to add:**

```typescript
// Internal imports (same package)
import type { User } from "#/users/types.js";
import { validateUser } from "#/users/validation.js";

// External imports (other packages)
import type { Role } from "@metasaver/contracts/roles/types";
```

**Patterns to remove:**

- Any `index.ts` files that only contain `export * from` or `export { X } from`
- Any `export default` examples
- Any relative `../` import examples

## Files

- `templates/common/tsconfig-*.template.json` (all tsconfig templates)
- Domain-specific templates that show import/export patterns
- Package templates with package.json examples

## Architecture

### Key Modifications

**Files: All `templates/common/tsconfig-*.template.json`**

- Add to compilerOptions:
  - `"baseUrl": "."`
  - `"paths": { "#/*": ["./src/*"] }`
- Files to update:
  - `tsconfig-base.template.json`
  - `tsconfig-vite-app.template.json`
  - `tsconfig-vite-node.template.json`
  - `tsconfig-vite-root.template.json`
- Base on existing structure, only add compilerOptions fields

**Files: Domain templates with import/export examples**

- Identify templates with code examples (search for `import`, `export` in templates/)
- Remove any barrel file examples (index.ts with re-exports)
- Replace relative `../` imports with `#/` pattern examples
- Replace `export *` with named export examples
- Replace `export default` with named export examples
- Add import order comments (Node built-ins → external → workspace → internal)

**Files: Package templates with package.json examples**

- Add `imports` field example: `{ "#/*": "./src/*.js" }`
- Add `exports` field example with structure:
  ```json
  {
    "./feature/types": {
      "types": "./dist/feature/types.d.ts",
      "import": "./dist/feature/types.js"
    }
  }
  ```
- If templates/root-package.json.template exists, update it

### Dependencies

- Depends on: None (can execute in parallel with US-002, US-003, US-004, US-006)
- Blocks: US-004 (skills reference templates)
