# Template Files Reference

This skill includes template files for scaffolding MetaSaver Prisma database packages. All templates are in the `templates/` directory.

## Configuration Templates

### package.json.template

**Purpose:** Package metadata, dependencies, and database scripts
**Location:** `packages/database/{project}-database/package.json`
**Key Exports:**

- scripts: build, clean, db:generate, db:migrate, db:migrate:dev, db:seed, db:studio, db:push, lint, prettier, test:unit
- dependencies: @prisma/client
- devDependencies: @metasaver config packages, Prisma, tsx, dotenv-cli

**Use when:** Creating new database package or updating dependencies

**Key Features:**

- ESM package configuration (`"type": "module"`)
- @metasaver scope for package name
- All required Prisma database scripts
- dotenv-cli for environment variable injection
- Proper TypeScript and tooling setup

### tsconfig.json.template

**Purpose:** TypeScript configuration for database package
**Location:** `packages/database/{project}-database/tsconfig.json`
**Extends:** `@metasaver/core-typescript-config/base`

**Use when:** Setting up TypeScript compilation

**Key Features:**

- Base configuration from core
- ESM module resolution
- Proper rootDir and outDir setup
- Type declaration generation

### .env.example.template

**Purpose:** Environment variable template (documentation)
**Location:** `packages/database/{project}-database/.env.example`

**Use when:** Creating new database package or documenting env vars

**Key Variables:**

```
{PROJECT_UPPER}_DATABASE_URL=postgresql://user:password@localhost:5432/database_name
```

---

## Schema Template

### schema.prisma.template

**Purpose:** Prisma database schema definition
**Location:** `packages/database/{project}-database/prisma/schema.prisma`

**Use when:** Setting up database schema or adding new models

**Key Features:**

- PostgreSQL datasource with environment variable
- Prisma client generator
- UUID primary keys with @default(uuid())
- Standard timestamps: createdAt (default), updatedAt (updatedAt)
- Snake_case database naming with @map()
- Model table names mapped with @@map()

**Example Model:**

```prisma
model User {
  id        String   @id @default(uuid())
  email     String   @unique
  name      String
  status    String   @default("active")
  createdAt DateTime @default(now()) @map("created_at")
  updatedAt DateTime @updatedAt @map("updated_at")

  @@map("users")
}
```

---

## Client & Types Templates

### client.ts.template

**Purpose:** Database client singleton with lifecycle management
**Location:** `src/client.ts`
**Exports:**

- `export const prisma` - Singleton instance
- `export default prisma` - Default export

**Use when:** Setting up database client initialization

**Key Features:**

- Simple singleton pattern
- Development reuse of global instance
- ESM compatible
- Type-safe client access

**Pattern:**

```typescript
import pkg from "@prisma/client";
const { PrismaClient } = pkg;

declare global {
  var prisma: InstanceType<typeof PrismaClient> | undefined;
}

export const prisma = global.prisma || new PrismaClient();

if (process.env.NODE_ENV !== "production") {
  global.prisma = prisma;
}

export default prisma;
```

### types.ts.template

**Purpose:** Type definitions re-export from Prisma
**Location:** `src/types.ts`
**Exports:**

- All types from `@prisma/client`

**Use when:** Setting up type infrastructure

**Key Features:**

- Simple re-export of Prisma types
- No custom infrastructure types
- Single file (not a folder)

```typescript
export type * from "@prisma/client";
```

---

## Main Export Template

### index.ts.template

**Purpose:** Main barrel export and public API
**Location:** `src/index.ts`
**Exports:**

- Client: `prisma`, `default`
- All types from `src/types.js`

**Use when:** Setting up package public API

**Key Features:**

- Single import point for consumers
- Client and Prisma types accessible
- .js extensions for ESM compatibility
- Clean, minimal public API

```typescript
export { prisma, default } from "./client.js";
export * from "./types.js";
```

---

## Seed Templates

### seed-index.ts.template

**Purpose:** Seed script orchestrator
**Location:** `prisma/seed/index.ts`

**Use when:** Setting up database seeding

**Key Features:**

- Calls all entity seed functions
- Proper error handling
- Graceful database disconnect
- Process exit codes

**Pattern:**

```typescript
import { prisma } from "../../src/client.js";
import { seedUsers } from "./user.js";
import { seedTeams } from "./team.js";

async function seed() {
  try {
    console.log("Starting seed...");
    await seedUsers(prisma);
    await seedTeams(prisma);
    console.log("Seed completed successfully");
  } catch (error) {
    console.error("Seed failed:", error);
    process.exit(1);
  } finally {
    await prisma.$disconnect();
  }
}

seed();
```

### seed-entity.ts.template

**Purpose:** Entity-specific seed data
**Location:** `prisma/seed/{entity}.ts`

**Use when:** Creating entity seed data

**Key Features:**

- Named export: `async function seed{Entity}(prisma: PrismaClient)`
- Idempotent using upsert pattern
- Clear seed data
- Error handling

**Pattern:**

```typescript
import type { PrismaClient } from "@prisma/client";

export async function seedUsers(prisma: PrismaClient) {
  const users = [
    { id: "user-1", email: "alice@example.com", name: "Alice" },
    { id: "user-2", email: "bob@example.com", name: "Bob" },
  ];

  for (const user of users) {
    await prisma.user.upsert({
      where: { id: user.id },
      update: { name: user.name },
      create: user,
    });
  }

  console.log(`Seeded ${users.length} users`);
}
```

---

## Template Usage Guide

### Step 1: Create Directory Structure

```bash
mkdir -p packages/database/{project}-database/{src,prisma/seed}
```

### Step 2: Copy Configuration Templates

```bash
cp templates/package.json.template \
   packages/database/{project}-database/package.json

cp templates/tsconfig.json.template \
   packages/database/{project}-database/tsconfig.json

cp templates/.env.example.template \
   packages/database/{project}-database/.env.example
```

### Step 3: Copy Prisma Schema

```bash
cp templates/schema.prisma.template \
   packages/database/{project}-database/prisma/schema.prisma
```

### Step 4: Copy Source Templates

```bash
cp templates/client.ts.template \
   packages/database/{project}-database/src/client.ts

cp templates/types-index.ts.template \
   packages/database/{project}-database/src/types.ts

cp templates/index.ts.template \
   packages/database/{project}-database/src/index.ts
```

### Step 5: Copy Seed Templates

```bash
cp templates/seed-index.ts.template \
   packages/database/{project}-database/prisma/seed/index.ts

cp templates/seed-entity.ts.template \
   packages/database/{project}-database/prisma/seed/user.ts
```

### Step 6: Customize All Files

For each template file, replace:

- `{project}` with actual project name (lowercase with hyphens)
- `{projectCamel}` with camelCase version
- `{Project}` with Title case
- `{PROJECT_UPPER}` with UPPERCASE_WITH_UNDERSCORES

Example substitutions:

```bash
# For rugby-crm project:
sed -i 's/{project}/rugby-crm/g' package.json
sed -i 's/{PROJECT_UPPER}/RUGBY_CRM/g' prisma/schema.prisma
sed -i 's/{project_lower}/rugby_crm/g' .env.example
```

### Step 7: Create Entity Seed Files

For each entity (User, Team, etc.):

```bash
cp templates/seed-entity.ts.template \
   packages/database/{project}-database/prisma/seed/{entity}.ts

# Customize with entity name, seed data
```

### Step 8: Update Seed Index

Edit `prisma/seed/index.ts` and add import and call for each seed function

### Step 9: Build and Test

```bash
pnpm --filter @metasaver/{project}-database build
pnpm --filter @metasaver/{project}-database db:migrate:dev
pnpm --filter @metasaver/{project}-database db:seed
```

---

## Quick Scaffolding Sequence

For a new project (rugby-crm-database):

1. **Setup**: Create directories and copy core templates
2. **Configuration**: Customize package.json, tsconfig.json, .env.example
3. **Schema**: Define models in schema.prisma
4. **Client**: Customize client.ts (usually just `{project}` naming)
5. **Types**: Copy types.ts (minimal customization needed)
6. **Exports**: Copy index.ts (minimal customization needed)
7. **Seeds**: Create seed/index.ts and entity seed files
8. **Build**: Run build, migrate, and seed

Total time: ~10-15 minutes for a new database package

---

## Template Customization Tips

### Naming Conventions

Use consistent substitution across all files:

| Placeholder       | Example (rugby-crm) | Format          |
| ----------------- | ------------------- | --------------- |
| `{project}`       | `rugby-crm`         | kebab-case      |
| `{projectCamel}`  | `rugbyCrm`          | camelCase       |
| `{Project}`       | `RugbyCrm`          | PascalCase      |
| `{PROJECT_UPPER}` | `RUGBY_CRM`         | UPPERCASE_SNAKE |

### File References

- Use `.js` extension in imports (ESM)
- Use `@/` path aliases sparingly
- Relative imports with `./` for same-package
- Absolute imports from `@prisma/client`

### Entity References

- Entity model: PascalCase (User, Team)
- Seed function: seed{Entity} (seedUsers)
- Seed file: {entity}.ts (user.ts)

### Environment Variables

- Keep the pattern: `{PROJECT_UPPER}_DATABASE_URL`
- Use `process.env` in runtime code
- Document in .env.example
- Never hardcode values

---

## Template Statistics

- **Total templates:** 6
- **Configuration files:** 3 (package.json, tsconfig.json, .env.example)
- **Schema files:** 1 (schema.prisma)
- **Client & types:** 2 (client.ts, types.ts)
- **Main export:** 1 (index.ts)
- **Seed files:** 2 (orchestrator, entity)

All templates are ready to use with minimal customization for MetaSaver database packages.

---

## Related Documentation

- **SKILL.md** - Complete skill documentation and audit checklist
- **INDEX.md** - Navigation guide
- **TEMPLATES.md** - This file

---

Last updated: 2025-12-14
Template version: 2.0
