# Template Files Reference

This skill includes the following template files for scaffolding MetaSaver contracts packages. All templates are in the `templates/` directory.

## Entity Templates

### types.ts.template

**Purpose:** TypeScript type definitions for an entity
**Location:** `src/{entity}/types.ts`
**Exports:**

- Re-exported Prisma type from database package
- API response interfaces (Create, Update, Get, Delete)

**Variables:**

- `{{ENTITY_PASCAL}}` - PascalCase entity name (e.g., "User")
- `{{DOMAIN}}` - Domain name for database package (e.g., "rugby-crm")

**Use when:** Adding a new entity to contracts package

### validation.ts.template

**Purpose:** Zod validation schemas for an entity
**Location:** `src/{entity}/validation.ts`
**Exports:**

- `base{Entity}Fields` - Base field definitions for frontend reuse
- `Create{Entity}Request` - Full schema for create operations
- `Update{Entity}Request` - Partial schema for update operations
- `Get{Entity}ParamsRequest` - ID validation schema
- Inferred TypeScript types

**Variables:**

- `{{ENTITY_PASCAL}}` - PascalCase entity name

**Use when:** Adding a new entity to contracts package

### entity-index.ts.template

**Purpose:** Barrel export for entity folder
**Location:** `src/{entity}/index.ts`
**Exports:**

- All types from `./types.js`
- All validation from `./validation.js`

**Use when:** Adding a new entity to contracts package

---

## Root Templates

### root-index.ts.template

**Purpose:** Root barrel export for the package
**Location:** `src/index.ts`
**Exports:**

- Shared types and enums from `./shared/`
- All entity exports

**Variables:**

- `{{ENTITY_KEBAB}}` - kebab-case entity name

**Use when:** Scaffolding new contracts package or adding entities

### shared-index.ts.template

**Purpose:** Shared enums and types used by multiple entities
**Location:** `src/shared/index.ts`
**Exports:**

- Enums with corresponding Labels objects

**Use when:** Adding enums that are used by 2+ entities

---

## Configuration Templates

### package.json.template

**Purpose:** Package configuration for contracts package
**Location:** `package.json`
**Key fields:**

- `metasaver.projectType: "contracts"`
- `test:unit` script (NOT `test`)
- Database package dependency
- Vitest for testing

**Variables:**

- `{{DOMAIN}}` - Domain name (e.g., "rugby-crm")

**Use when:** Scaffolding new contracts package

### tsconfig.json.template

**Purpose:** TypeScript configuration
**Location:** `tsconfig.json`
**Key rules:**

- Extends `@metasaver/core-typescript-config/base`
- Only `rootDir` and `outDir` in compilerOptions
- NO duplicate settings from base

**Use when:** Scaffolding new contracts package

### eslint.config.js.template

**Purpose:** ESLint flat config
**Location:** `eslint.config.js`
**Key rules:**

- Uses flat config format (NOT `.eslintrc.cjs`)
- Extends base config

**Use when:** Scaffolding new contracts package

---

## Template Variables

| Variable            | Format     | Example               |
| ------------------- | ---------- | --------------------- |
| `{{DOMAIN}}`        | kebab-case | `rugby-crm`           |
| `{{ENTITY_PASCAL}}` | PascalCase | `User`, `TeamMember`  |
| `{{ENTITY_KEBAB}}`  | kebab-case | `user`, `team-member` |
| `{{ENTITY_CAMEL}}`  | camelCase  | `user`, `teamMember`  |
