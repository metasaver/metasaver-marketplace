# Prisma Database Skill - Complete Index

This skill documents the complete file and folder structure for MetaSaver Prisma database packages. It provides guidelines for scaffolding, auditing, and maintaining consistent database architecture across packages like rugby-crm-database and other data persistence layers.

## Skill Files Overview

### Core Documentation

**1. SKILL.md** - Primary skill specification

- YAML frontmatter with name, description, allowed tools
- Purpose and use cases
- Complete directory structure reference
- File organization rules for each component
- Audit checklist (comprehensive)
- Common violations and fixes
- Examples (audit, scaffold, add model)
- Related skills

**2. TEMPLATES.md** - Template file reference guide

- Purpose and location of each template
- Key features of each template
- Quick scaffolding sequence
- Template customization tips
- Template statistics

**3. INDEX.md** - This file

- Navigation guide for all skill files
- Quick reference section

---

## Templates Directory

### Configuration Templates

- **package.json.template** - Package metadata and scripts
  - Location: `packages/database/{project}-database/package.json`
  - Contains: @metasaver scope, ESM config, all db:\* scripts
  - Use: Package creation and setup

- **tsconfig.json.template** - TypeScript configuration
  - Location: `packages/database/{project}-database/tsconfig.json`
  - Extends: @metasaver/core-typescript-config/base
  - Use: TypeScript build configuration

- **.env.example.template** - Environment variables template
  - Location: `packages/database/{project}-database/.env.example`
  - Contains: DATABASE_URL pattern
  - Use: Environment setup documentation

### Schema Templates

- **schema.prisma.template** - Prisma database schema
  - Location: `packages/database/{project}-database/prisma/schema.prisma`
  - Features: PostgreSQL datasource, UUID IDs, timestamps
  - Use: Database model definition

### Client & Types Templates

- **client.ts.template** - Database client singleton
  - Location: `src/client.ts`
  - Exports: `prisma`, `default`
  - Use: Client initialization

- **types.ts.template** - Type re-exports from Prisma
  - Location: `src/types.ts`
  - Exports: All Prisma types via re-export
  - Use: Type infrastructure setup

### Main Export Template

- **index.ts.template** - Main barrel export
  - Location: `src/index.ts`
  - Exports: Client, all Prisma types
  - Use: Package public API

### Seed Templates

- **seed-index.ts.template** - Seed orchestration
  - Location: `prisma/seed/index.ts`
  - Pattern: Calls all entity seed functions
  - Use: Seed entry point

- **seed-entity.ts.template** - Entity-specific seed data
  - Location: `prisma/seed/{entity}.ts`
  - Pattern: Export async seedEntity() function
  - Use: Entity seed implementation

---

## Quick Reference

### Directory Structure Summary

```
packages/database/{project}-database/
├── package.json                 (ESM, @metasaver scope)
├── tsconfig.json                (extends core config)
├── eslint.config.js             (flat config)
├── .env.example                 (DATABASE_URL)
├── prisma/
│   ├── schema.prisma            (PostgreSQL, UUID, timestamps)
│   └── seed/
│       ├── index.ts             (orchestrator)
│       └── {entity}.ts          (per-entity seed)
├── src/
│   ├── index.ts                 (barrel export)
│   ├── client.ts                (singleton pattern)
│   └── types.ts                 (Prisma re-export)
└── dist/                        (compiled output)
```

### Key Principles Summary

1. **Singleton Pattern**: Use simple `export const prisma = ...` singleton
2. **Type Re-export**: All types come from `export type * from "@prisma/client"`
3. **Standard Fields**: id (UUID), createdAt, updatedAt on all models
4. **Idempotent Seeds**: Use upsert pattern for re-runnable seeds
5. **Environment Variables**: `{PROJECT_UPPER}_DATABASE_URL` format
6. **Simple Structure**: No repository pattern, no custom infrastructure types
7. **Minimal Client**: Just singleton export, no factory or disconnect functions

### Common Operations

**Create new database package:**

```bash
# 1. Create directory structure
mkdir -p packages/database/{project}-database/src
mkdir -p packages/database/{project}-database/prisma/seed

# 2. Use templates from templates/ directory
cp templates/package.json.template packages/database/{project}-database/package.json
cp templates/prisma/schema.prisma.template packages/database/{project}-database/prisma/schema.prisma

# 3. Build and test
pnpm --filter @metasaver/{project}-database build
```

**Add new model:**

```bash
# 1. Add model to schema.prisma
# 2. Create migration: pnpm db:migrate:dev
# 3. Add seed in prisma/seed/{entity}.ts
# 4. Update prisma/seed/index.ts to call seed function
# 5. Test: pnpm db:seed
```

**Audit database package:**

```bash
# Follow SKILL.md audit checklist sections:
# - Package Structure
# - package.json
# - TypeScript Configuration
# - Prisma Schema
# - Database Client
# - Types
# - Exports
# - Seed Scripts
# - Environment Configuration
# - Build & Compilation
```

---

## File Navigation Guide

### By Task

**"I need to create a new database package"**

1. Start: SKILL.md - "Directory Structure Reference"
2. Follow: SKILL.md - "Workflow: Scaffolding New Database Package"
3. Copy templates from: templates/ directory
4. Customize: TEMPLATES.md - "Template Customization Tips"
5. Validate: SKILL.md - "Audit Checklist"

**"I need to audit an existing database package"**

1. Start: SKILL.md - "Audit Checklist"
2. Check each section in order (Package Structure → Build & Compilation)
3. Fix issues: SKILL.md - "Common Violations & Fixes"
4. Verify build: Run `pnpm --filter @metasaver/{project}-database build`

**"I need to add a new model to database package"**

1. Start: SKILL.md - "Examples" → "Example 3: Add New Model to Schema"
2. Reference schema patterns: SKILL.md - "File Organization Rules" → "Prisma Schema Pattern"
3. Update seed: SKILL.md - "File Organization Rules" → "Seed Script Pattern"

**"I need to understand the directory structure"**

1. Overview: SKILL.md - "Directory Structure Reference"
2. File organization: SKILL.md - "File Organization Rules"
3. Examples: SKILL.md - "Examples" section

**"I need to understand database client setup"**

1. Pattern: SKILL.md - "File Organization Rules" → "Client Initialization Pattern"
2. Template: templates/client.ts.template
3. Rules: SKILL.md description of singleton pattern

**"I need to understand seed scripts"**

1. Pattern: SKILL.md - "File Organization Rules" → "Seed Script Pattern"
2. Entry point: templates/seed-index.ts.template
3. Entity seeds: templates/seed-entity.ts.template
4. Idempotency: SKILL.md - "File Organization Rules" → "Rule 3"

**"I need naming convention guidelines"**

1. Package naming: SKILL.md - "File Organization Rules" → "Package.json Structure"
2. Schema naming: SKILL.md - "File Organization Rules" → "Prisma Schema Pattern"
3. Seed naming: SKILL.md - "File Organization Rules" → "Seed Script Pattern"

**"I need to understand type patterns"**

1. Type re-export: SKILL.md - "File Organization Rules" → "Types Organization"
2. Type barrel export: templates/types.ts.template
3. No custom types: SKILL.md - "Common Violations & Fixes"

---

## Validation Checklist

Before using this skill, ensure:

- [ ] You have a TypeScript project with Prisma ORM
- [ ] PostgreSQL database is available
- [ ] Prisma CLI installed (@prisma/client)
- [ ] pnpm as package manager
- [ ] ESLint and Prettier configured
- [ ] TypeScript 5.6+ installed

---

## Skills Dependencies

This skill references and integrates with:

- **typescript-configuration** - TypeScript configuration
- **eslint-agent** - ESLint configuration
- **monorepo-structure** - Monorepo organization and workspace setup
- **database-migrations** - Prisma migration strategies (referenced but not required)

---

## Document Statistics

- **Total files**: 8 (3 docs + 6 templates)
- **Total documentation pages**: 3
- **Total template files**: 6
- **Template code examples**: 12+
- **Audit checklist items**: 38+
- **Pattern examples**: 8+
- **Command examples**: 15+

---

## Version History

- **v2.0** - Simplified to rugby-crm gold standard
  - Removed repository pattern entirely
  - Changed from factory to singleton pattern
  - Simplified types to just Prisma re-export
  - Reduced templates from 9 to 6
  - Focused on minimal structure

- **v1.0** - Initial skill creation
  - Complete directory structure documentation
  - 9+ reusable templates
  - Comprehensive audit checklist
  - 4 documentation files
  - Pattern library and examples

---

## How to Use This Skill

1. **Discovery**: Start with SKILL.md description
2. **Planning**: Read the relevant section of SKILL.md
3. **Implementation**: Use templates from templates/ directory
4. **Validation**: Follow SKILL.md "Audit Checklist"
5. **Reference**: Use TEMPLATES.md for customization tips

---

## Quick Links Summary

| Task                 | File         | Section                       |
| -------------------- | ------------ | ----------------------------- |
| Overview             | SKILL.md     | Top of file                   |
| Directory structure  | SKILL.md     | Directory Structure Reference |
| File organization    | SKILL.md     | File Organization Rules       |
| Scaffolding workflow | SKILL.md     | Workflow: Scaffolding New Db  |
| Audit checklist      | SKILL.md     | Audit Checklist               |
| Common violations    | SKILL.md     | Common Violations & Fixes     |
| Client setup         | TEMPLATES.md | Client & Types Templates      |
| Types setup          | TEMPLATES.md | Client & Types Templates      |
| Seed scripts         | TEMPLATES.md | Seed Templates                |
| Template usage       | TEMPLATES.md | Template Usage Guide          |
| Audit commands       | SKILL.md     | Examples → Example 1          |
| Scaffold new package | SKILL.md     | Examples → Example 2          |
| Add new model        | SKILL.md     | Examples → Example 3          |

---

## Support

For questions or issues related to:

- **File structure**: See SKILL.md - "Directory Structure Reference"
- **Organization**: See SKILL.md - "File Organization Rules"
- **Templates**: See TEMPLATES.md - "Template Files Reference"
- **Auditing**: See SKILL.md - "Audit Checklist"
- **Patterns**: See SKILL.md - "File Organization Rules"
- **Violations**: See SKILL.md - "Common Violations & Fixes"

---

Last updated: 2025-12-14
Skill version: 2.0
