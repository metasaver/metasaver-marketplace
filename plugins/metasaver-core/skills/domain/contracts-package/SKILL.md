---
name: contracts-package
description: Use when creating, auditing, or validating MetaSaver contracts packages. Includes Zod validation schemas, TypeScript types, barrel exports, and database type re-exports. File types: .ts, package.json, tsconfig.json.
allowed-tools: Read, Write, Edit, Bash, Glob
---

# Contracts Package Structure for MetaSaver

## Purpose

This skill documents the complete structure for MetaSaver contracts packages. Contracts packages provide:

- Zod validation schemas for API request/response validation
- TypeScript types re-exported from database packages
- Shared type definitions between frontend and backend
- Single source of truth for entity shapes

**Use when:**

- Creating a new contracts package for a domain
- Adding a new entity to an existing contracts package
- Auditing contracts package structure for compliance
- Validating type exports and barrel patterns

## Directory Structure

```
packages/contracts/{domain}-contracts/
├── src/
│   ├── index.ts                    # Root barrel export
│   ├── shared/                     # (optional) Shared enums/types used by multiple entities
│   │   └── index.ts                # Exports all shared types
│   └── {entity}/                   # One folder per entity
│       ├── index.ts                # Entity barrel export
│       ├── types.ts                # TypeScript types and interfaces
│       └── validation.ts           # Zod schemas and inferred types
├── eslint.config.js                # ESLint flat config (required)
├── package.json
└── tsconfig.json
```

**IMPORTANT - Files NOT to create at package level:**

- NO `.gitignore` - handled by monorepo root
- NO `.eslintrc.cjs` - use `eslint.config.js` (flat config) only

## Templates

See `TEMPLATES.md` for all available templates. Key templates:

| Template                    | Purpose                 | Location                     |
| --------------------------- | ----------------------- | ---------------------------- |
| `types.ts.template`         | Entity type definitions | `src/{entity}/types.ts`      |
| `validation.ts.template`    | Zod validation schemas  | `src/{entity}/validation.ts` |
| `entity-index.ts.template`  | Entity barrel export    | `src/{entity}/index.ts`      |
| `root-index.ts.template`    | Root barrel export      | `src/index.ts`               |
| `shared-index.ts.template`  | Shared enums            | `src/shared/index.ts`        |
| `package.json.template`     | Package configuration   | `package.json`               |
| `tsconfig.json.template`    | TypeScript config       | `tsconfig.json`              |
| `eslint.config.js.template` | ESLint flat config      | `eslint.config.js`           |

## File Rules

### Types File Rules

- Re-export Prisma types from database package (single source of truth)
- Define API response wrapper types (Create, Update, Get, Delete)
- DO NOT duplicate Prisma model fields
- Use `type` imports for Prisma types

### Validation File Rules

- Use Zod for all validation
- Export base fields for frontend reuse (e.g., ZDataTable)
- Create request uses full schema
- Update request uses `.partial()` for optional fields
- Export inferred types with `z.infer<>`
- Add helpful error messages to validators

### Barrel Export Rules

- Use `.js` extension in all imports (ESM)
- Export from entity `index.ts`, not individual files
- Alphabetical order preferred
- Shared exports first, then entities

### Enum Organization Rules (Industry Standard)

| Scenario                         | Location                        |
| -------------------------------- | ------------------------------- |
| Enum used by **one entity only** | Colocate in `{entity}/types.ts` |
| Enum used by **2+ entities**     | Place in `/shared/index.ts`     |

All enums should have a corresponding `Labels` object for UI display.

### tsconfig.json Rules

- Extends `@metasaver/core-typescript-config/base`
- Only `rootDir` and `outDir` in compilerOptions
- NO duplicate settings from base (`composite`, `declarationMap`, `sourceMap` are inherited)

### package.json Rules

- Include `metasaver.projectType: "contracts"`
- Use `test:unit` NOT `test`
- Include database package as dependency (for Prisma types)
- Zod as both dependency and peerDependency
- Include vitest for testing

## Workflow: Adding New Entity

1. Create entity folder: `mkdir -p src/{entity}`
2. Copy `types.ts.template` → `src/{entity}/types.ts`, replace variables
3. Copy `validation.ts.template` → `src/{entity}/validation.ts`, replace variables
4. Copy `entity-index.ts.template` → `src/{entity}/index.ts`
5. Update `src/index.ts` to export new entity

## Workflow: Adding Shared Enum

1. Verify enum is used by 2+ entities (if not, colocate)
2. Create `/shared/` if doesn't exist
3. Add enum with Labels object to `src/shared/index.ts`
4. Export from root `src/index.ts` (if not already)

## Audit Checklist

### Directory Structure

- [ ] Package at `packages/contracts/{domain}-contracts/`
- [ ] `src/index.ts` exists with barrel exports
- [ ] Each entity has its own folder under `src/`
- [ ] Each entity folder has `index.ts`, `types.ts`, `validation.ts`
- [ ] NO `.gitignore` at package level (handled by root)
- [ ] NO `.eslintrc.cjs` (old format - use `eslint.config.js`)
- [ ] Has `eslint.config.js` (flat config)

### Types Files

- [ ] Entity type re-exported from database package
- [ ] API response interfaces defined (Create, Update, Get, Delete)
- [ ] No duplicate Prisma model field definitions
- [ ] Uses `type` imports for Prisma types

### Validation Files

- [ ] Uses Zod for all schemas
- [ ] Base fields exported for frontend reuse
- [ ] Create schema uses full fields
- [ ] Update schema uses `.partial()`
- [ ] Inferred types exported with `z.infer<>`
- [ ] Error messages included in validators

### Barrel Exports

- [ ] Root `index.ts` exports all entities
- [ ] Entity `index.ts` exports types and validation
- [ ] Uses `.js` extension in all imports

### Enum Organization

- [ ] Entity-specific enums colocated in entity folder
- [ ] Shared enums (2+ entities) in `/shared/` folder
- [ ] All enums have corresponding Labels object

### package.json

- [ ] Name follows `@metasaver/{domain}-contracts` pattern
- [ ] Has `metasaver.projectType: "contracts"`
- [ ] Uses `test:unit` NOT `test`
- [ ] Includes database package dependency
- [ ] Has Zod as dependency and peerDependency
- [ ] Has vitest in devDependencies

### tsconfig.json

- [ ] Extends `@metasaver/core-typescript-config/base`
- [ ] Only has `rootDir` and `outDir` in compilerOptions
- [ ] NO duplicate settings from base (`composite`, `declarationMap`, `sourceMap`)

## Common Violations & Fixes

| Violation                                     | Fix                                 |
| --------------------------------------------- | ----------------------------------- |
| Duplicating Prisma model fields               | Re-export from database package     |
| Using `test` instead of `test:unit`           | Change to `test:unit`               |
| Missing `.js` extension                       | Add `.js` to all imports            |
| Duplicate tsconfig settings                   | Remove settings inherited from base |
| Package-level `.gitignore` or `.eslintrc.cjs` | Delete these files                  |
| Entity-specific enum in `/shared/`            | Move to entity folder               |

## Related Agents

- **prisma-database-agent** - Prisma schema (source of entity types)
- **data-service-agent** - Services consuming contracts
- **react-app-agent** - Frontend apps importing contracts
