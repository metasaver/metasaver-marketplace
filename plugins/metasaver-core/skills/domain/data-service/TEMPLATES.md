# Data Service Templates Reference

## Overview

This document catalogs all templates available in the data-service skill for scaffolding MetaSaver data service packages.

## Core Application Templates

### Entry Point

- **File:** `index.ts.template`
- **Purpose:** Service startup and graceful shutdown
- **Use:** Replace placeholders, no customization needed
- **Destination:** `src/index.ts`

### Environment Configuration

- **File:** `env.ts.template`
- **Purpose:** Centralized environment variable management
- **Use:** Replace `{PROJECT_UPPER}` with project name (e.g., RUGBY_CRM)
- **Destination:** `src/env.ts`

### Server Factory

- **File:** `server.ts.template`
- **Purpose:** Express app creation with middleware stack
- **Use:** No customization needed
- **Destination:** `src/server.ts`

## Middleware Templates

### Authentication

- **File:** `auth.ts.template`
- **Purpose:** JWT token verification and user extraction
- **Use:** Customize token payload structure if needed
- **Destination:** `src/middleware/auth.ts`

### Error Handling

- **File:** `error.ts.template`
- **Purpose:** Centralized error response formatting
- **Use:** Extend with custom error types if needed
- **Destination:** `src/middleware/error.ts`

### Request Logging

- **File:** `logging.ts.template`
- **Purpose:** HTTP request/response logging
- **Use:** Customize log levels and formats if needed
- **Destination:** `src/middleware/logging.ts`

## Route Management

### Route Registration

- **File:** `register.ts.template`
- **Purpose:** Centralized route mounting and versioning
- **Use:** Replace `{feature-plural}` with actual feature names (e.g., users, teams)
- **Destination:** `src/routes/register.ts`

## Feature Templates

### Service Class

- **File:** `feature-service.ts.template`
- **Purpose:** Prisma database operations
- **Use:**
  - Replace `{Feature}` with CamelCase feature name (e.g., Users)
  - Replace `{feature}` with kebab-case feature name (e.g., users)
  - Replace `{entity}` with singular lowercase (e.g., user)
  - Replace `{Entity}` with singular PascalCase (e.g., User)
  - Replace `{project}` with project package name (e.g., rugby-crm)
  - Add `include` relations as needed
- **Destination:** `src/features/{feature}/{feature}.service.ts`

### Controller

- **File:** `feature-controller.ts.template`
- **Purpose:** HTTP request handling and validation
- **Use:** Same replacements as service template
- **Destination:** `src/features/{feature}/{feature}.controller.ts`

### Feature Index (Barrel Export)

- **File:** `feature-index.ts.template`
- **Purpose:** Feature service and routes export
- **Use:** Same replacements as service template
- **Destination:** `src/features/{feature}/index.ts`

### Features Index (Aggregation)

- **File:** `features-index.ts.template`
- **Purpose:** Aggregates all feature exports
- **Use:** Add `export * from "./{feature}/index.js"` for each feature
- **Destination:** `src/features/index.ts`

## Configuration Templates

### Package Configuration

- **File:** `package.json.template`
- **Purpose:** NPM package metadata and scripts
- **Use:**
  - Replace `{project}` with project name (e.g., rugby-crm)
  - Replace `{Description}` with project description
- **Destination:** `package.json`

### TypeScript Configuration

- **File:** `tsconfig.json.template`
- **Purpose:** TypeScript compiler settings
- **Use:** No customization needed
- **Destination:** `tsconfig.json`

### ESLint Configuration

- **File:** `eslint.config.js.template`
- **Purpose:** Code quality rules (flat config)
- **Use:** No customization needed
- **Destination:** `eslint.config.js`

### Environment Template

- **File:** `.env.example.template`
- **Purpose:** Environment variable documentation
- **Use:** Replace `{PROJECT_UPPER}` with project name (e.g., RUGBY_CRM)
- **Destination:** `.env.example`

## Docker Templates

### Dockerfile

- **File:** `Dockerfile.template`
- **Purpose:** Production container image
- **Use:** No customization needed
- **Destination:** `Dockerfile`

## Template Variable Reference

| Variable           | Example   | Description                       |
| ------------------ | --------- | --------------------------------- |
| `{Feature}`        | Users     | CamelCase feature name            |
| `{feature}`        | users     | kebab-case/lowercase feature name |
| `{entity}`         | user      | singular lowercase entity         |
| `{Entity}`         | User      | singular PascalCase entity        |
| `{entities}`       | users     | plural lowercase entities         |
| `{project}`        | rugby-crm | project name (hyphenated)         |
| `{PROJECT_UPPER}`  | RUGBY_CRM | project name (UPPER_SNAKE)        |
| `{Description}`    | Rugby CRM | human-readable description        |
| `{feature-plural}` | users     | plural feature name for routes    |

## Usage Workflow

### 1. Scaffold New Service Package

```bash
mkdir -p packages/services/{project}-service/src/{features,middleware,routes}
```

Copy these configuration files (minimal customization):

- `package.json.template` -> `package.json`
- `tsconfig.json.template` -> `tsconfig.json`
- `.env.example.template` -> `.env.example`
- `eslint.config.js.template` -> `eslint.config.js`
- `Dockerfile.template` -> `Dockerfile`

### 2. Create Core Application Files

Copy with no customization needed:

- `index.ts.template` -> `src/index.ts`
- `server.ts.template` -> `src/server.ts`

Copy with simple variable replacement:

- `env.ts.template` -> `src/env.ts`

### 3. Create Middleware

Copy with optional customization:

- `auth.ts.template` -> `src/middleware/auth.ts`
- `error.ts.template` -> `src/middleware/error.ts`
- `logging.ts.template` -> `src/middleware/logging.ts`

### 4. Setup Routes

Copy with feature name replacement:

- `register.ts.template` -> `src/routes/register.ts`

### 5. Add Features

For each feature, copy and customize:

- `feature-service.ts.template` -> `src/features/{feature}/{feature}.service.ts`
- `feature-controller.ts.template` -> `src/features/{feature}/{feature}.controller.ts`
- `feature-index.ts.template` -> `src/features/{feature}/index.ts`

Then update:

- `features-index.ts.template` -> `src/features/index.ts` (add feature exports)
- `register.ts.template` -> `src/routes/register.ts` (mount feature routes)

## Key Patterns in Templates

### asyncHandler Pattern

Controllers wrap async functions to automatically catch errors:

```typescript
router.post(
  "/",
  asyncHandler(async (req, res) => {
    // Errors thrown here are caught and formatted by errorMiddleware
    const validated = CreateSchema.parse(req.body);
    const item = await service.create(validated);
    res.status(201).json({ data: item });
  }),
);
```

### Zod Validation Pattern

All input validation uses Zod schemas from contracts package:

```typescript
const validated = CreateUserSchema.parse(req.body);
```

### Service Class Pattern

Services only handle data operations (no HTTP concerns):

```typescript
export class UsersService {
  async getById(id: string): Promise<User | null> {
    return prisma.user.findUnique({ where: { id } });
  }
}
```

### Feature Export Pattern

Features export service and routes via barrel export:

```typescript
export { UsersService } from "./users.service.js";
export { router as UsersRoutes } from "./users.controller.js";
```

### Middleware Stack Pattern

Middleware applied in order: JSON parsing -> Logging -> Routes -> Error handling

```typescript
app.use(express.json());
app.use(loggingMiddleware);
registerRoutes(app);
app.use(errorMiddleware);
```

## Related Skills

- **prisma-database** - Database models and client
- **contracts-package** - Zod validation schemas
- **typescript-configuration** - TypeScript settings
