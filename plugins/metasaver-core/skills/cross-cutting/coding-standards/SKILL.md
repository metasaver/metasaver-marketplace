---
name: coding-standards
description: Comprehensive coding standards for MetaSaver TypeScript projects including SOLID principles, DRY/KISS/YAGNI guidelines, error handling with AppError hierarchy, structured logging with Pino, and code organization rules. Use when implementing features, refactoring code, or establishing coding patterns.
---

# Coding Standards Skill

Single source of truth for MetaSaver coding principles and patterns.

**Use when:**

- Implementing new features or services
- Refactoring code for quality
- Establishing patterns in new modules
- Reviewing code for standards compliance
- Teaching or documenting best practices

## Core Principles at a Glance

| Principle   | Application                                             |
| ----------- | ------------------------------------------------------- |
| **SOLID**   | OOP design principles for class/module design           |
| **DRY**     | Extract shared logic; single source of truth            |
| **KISS**    | Simplest working solution; no premature abstraction     |
| **YAGNI**   | Build for current requirements only; delete unused code |
| **Errors**  | AppError hierarchy with proper status codes             |
| **Logging** | Structured Pino logs with action + context              |

## Workflow

### 1. SOLID Principles Review

Verify each component follows one SOLID principle:

- **S** - Single Responsibility: One reason to change
- **O** - Open/Closed: Extend via interfaces, not modification
- **L** - Liskov Substitution: Subtypes properly substitute base
- **I** - Interface Segregation: No fat interfaces
- **D** - Dependency Inversion: Inject abstractions, not concretions

See `templates/solid-examples.ts.template` for examples of all 5.

### 2. DRY, KISS, YAGNI Check

- **DRY**: Extract validation schemas, constants, business rules to single location
- **KISS**: Use simplest solution; avoid unnecessary layers or patterns
- **YAGNI**: Implement only current requirements; delete speculative code

See `templates/dry-kiss-yagni.ts.template` for patterns.

### 3. Error Handling Setup

Implement AppError hierarchy:

- Base: `AppError(message, code, statusCode)`
- Extend: `ValidationError`, `NotFoundError`, `UnauthorizedError`, `ForbiddenError`
- Middleware: Centralized error handler catches and formats responses

See `templates/error-handling.ts.template` for complete setup.

### 4. Structured Logging

Configure Pino logger with:

- Development: pretty-printed output with colors
- Production: JSON output for parsing
- Child loggers with context (service name, correlationId)
- Consistent log pattern: `{ action, userId, error, correlationId }`

See `templates/logging.ts.template` for setup and patterns.

### 5. Import & Module Standards

| Standard                    | Pattern                           | Example                                           |
| --------------------------- | --------------------------------- | ------------------------------------------------- |
| **Explicit barrel exports** | List each export by name          | `export { UserService } from './user.service.js'` |
| **Current library APIs**    | Use latest non-deprecated methods | `router.get()` not `router.addRoute()`            |
| **Path alias imports**      | Use `@/` for src-relative paths   | `import { User } from '@/types'`                  |

**Barrel files (index.ts):**

```typescript
// ✅ GOOD: Explicit exports
export { UserService } from "./user.service.js";
export { UserRepository } from "./user.repository.js";
export type { User, CreateUserDto } from "./user.types.js";

// ✅ ENSURE: Use explicit exports for tree-shaking and clarity (not wildcard re-exports)
// Wildcard re-exports make tree-shaking harder and hide what's exported
// export * from './user.service.js'; // ❌ Only use if absolutely necessary
```

**Import paths:**

```typescript
// ✅ GOOD: Use path aliases for clean imports
import { UserService } from "@/services/user.service.js";
import { validateUser } from "@/utils/validation.js";

// ✅ ENSURE: Use path aliases instead of deep relative paths for maintainability
// Relative paths beyond parent directory are harder to maintain
// import { UserService } from '../../../services/user.service.js'; // ❌ Use @/ alias instead
```

**Library APIs:**

```typescript
// ✅ GOOD: Use current, non-deprecated APIs
const response = await fetch(url, { signal: controller.signal });

// ✅ ENSURE: Use modern fetch API instead of deprecated patterns
// Older patterns like on() callbacks are no longer recommended
// request.on('response', callback); // ❌ Use fetch API instead
```

### 6. Code Organization Rules

| Type       | Ideal      | Max       | If exceeded           |
| ---------- | ---------- | --------- | --------------------- |
| Service    | ~100 lines | 200 lines | Split by domain       |
| Controller | ~50 lines  | 100 lines | Move logic to service |
| Utility    | ~50 lines  | 100 lines | Split by function     |
| Type file  | ~50 lines  | 150 lines | Group by entity       |

Function guidelines:

- Max 50 lines per function
- Max 3 parameters (use objects for more)
- Single level of abstraction
- Early returns for guard clauses

## Quick Reference Checklist

Before committing code:

- [ ] Each class has single responsibility
- [ ] No duplicate logic (DRY)
- [ ] Simplest solution used (KISS)
- [ ] No speculative features (YAGNI)
- [ ] Dependencies injected (not instantiated)
- [ ] Errors use AppError hierarchy
- [ ] Logging includes action + context
- [ ] Functions under 50 lines
- [ ] Files under max line count
- [ ] All types are explicit (use specific types instead of `any`)
- [ ] All inputs validated with Zod
- [ ] Barrel files use explicit exports (not `export *`)
- [ ] Library APIs are current (use non-deprecated methods)
- [ ] Imports use `@/` alias (instead of deep relative paths)

## Examples

### Example 1: Service with Error Handling + Logging

```typescript
import { NotFoundError } from "../errors/index.js";
import { logger } from "../utils/logger.js";

export class UserService {
  private readonly log = logger.child({ service: "UserService" });

  async getUser(id: string): Promise<User> {
    this.log.debug({ action: "getUser", userId: id });

    const user = await this.userRepository.findById(id);
    if (!user) throw new NotFoundError("User", id);

    return user;
  }

  async createUser(data: CreateUserDto): Promise<User> {
    this.log.info({ action: "createUser", email: data.email });

    const existing = await this.userRepository.findByEmail(data.email);
    if (existing) throw new ValidationError("Email in use", "email");

    try {
      const user = await this.userRepository.create(data);
      this.log.info({ action: "userCreated", userId: user.id });
      return user;
    } catch (error) {
      this.log.error({ action: "createUser", error, email: data.email });
      throw error;
    }
  }
}
```

### Example 2: Interface Segregation (SOLID I)

```typescript
// BAD: Fat interface
interface Worker {
  work(): void;
  eat(): void;
  attendMeeting(): void;
}

// GOOD: Segregated interfaces
interface Workable {
  work(): void;
}

class Developer implements Workable, Eatable, MeetingAttendee {
  work(): void {}
  eat(): void {}
  attendMeeting(): void {}
}

class Robot implements Workable {
  work(): void {} // Only needs work
}
```

### Example 3: DRY with Zod Schema

```typescript
const emailSchema = z.string().email();

function validateEmail(email: unknown): string {
  return emailSchema.parse(email);
}

async function createUser(data: CreateUserDto): Promise<User> {
  const email = validateEmail(data.email);
  return db.users.create({ ...data, email });
}

async function updateUser(id: string, data: UpdateUserDto): Promise<User> {
  const email = validateEmail(data.email); // Reuse validation
  return db.users.update(id, { ...data, email });
}
```

## Template Files

Complete, copy-paste-ready code examples:

- `templates/solid-examples.ts.template` - All 5 SOLID principles
- `templates/dry-kiss-yagni.ts.template` - DRY, KISS, YAGNI patterns
- `templates/error-handling.ts.template` - AppError hierarchy + middleware
- `templates/logging.ts.template` - Pino setup + logging patterns

## Detailed Reference

See `reference.md` for:

- Extended explanation of each principle
- Advanced error handling patterns
- Comprehensive logging strategies
- Code organization guidelines
- Related skills and resources

## Related Skills

- `/skill cross-cutting/tool-check` - Tool discovery and usage
- `/skill domain/monorepo-audit` - Monorepo structure validation
- `/skill cross-cutting/serena-code-reading` - Progressive code analysis
