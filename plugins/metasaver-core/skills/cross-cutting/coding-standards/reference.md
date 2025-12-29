# Coding Standards Reference

Comprehensive reference for MetaSaver coding principles and patterns.

## Quick Checklist

Before committing code, verify:

- [ ] Each class has single responsibility
- [ ] No duplicate logic (DRY)
- [ ] Simplest solution used (KISS)
- [ ] No speculative features (YAGNI)
- [ ] Dependencies injected (not instantiated)
- [ ] Errors use AppError hierarchy
- [ ] Logging includes action + context
- [ ] Functions under 50 lines
- [ ] Files under 200 lines
- [ ] No `any` types
- [ ] All inputs validated with Zod

## Code Organization

### File Length Guidelines

| Type       | Ideal      | Max       | Action if exceeded    |
| ---------- | ---------- | --------- | --------------------- |
| Service    | ~100 lines | 200 lines | Split by domain       |
| Controller | ~50 lines  | 100 lines | Move logic to service |
| Utility    | ~50 lines  | 100 lines | Split by function     |
| Type file  | ~50 lines  | 150 lines | Group by entity       |

### Function Guidelines

- Max 50 lines per function
- Max 3 parameters (use object for more)
- Single level of abstraction
- Early returns for guards

**Example: Proper function design**

```typescript
async function processOrder(orderId: string): Promise<OrderResult> {
  const order = await getOrder(orderId);
  if (!order) return { success: false, error: "Order not found" };

  if (order.status !== "pending")
    return { success: false, error: "Already processed" };

  const payment = await processPayment(order);
  if (!payment.success) return { success: false, error: payment.error };

  await updateOrderStatus(orderId, "completed");
  await sendConfirmation(order);

  return { success: true, orderId };
}
```

## DRY - Don't Repeat Yourself

Applies to:

- **Validation logic** - Extract to functions/schemas
- **Business rules** - Single function, not duplicated
- **Configuration values** - Constants, env vars
- **Type definitions** - Reuse interfaces
- **Error messages** - Define once

## KISS - Keep It Simple, Stupid

Guidelines:

- Avoid premature abstraction
- Use built-in language features
- Prefer composition over inheritance
- Don't add layers without clear benefit
- Simple solution that works beats complex "elegant" solution

## YAGNI - You Aren't Gonna Need It

Guidelines:

- Build for current requirements only
- Don't add "just in case" code
- Delete unused code immediately
- Configuration over speculation
- Add fields/features when there's an actual requirement

## SOLID Principles

### Single Responsibility Principle (S)

> A class should have one reason to change.

Split concerns:

- `UserService` - User CRUD only
- `EmailService` - Email sending only
- `UserReportService` - Reporting only

### Open/Closed Principle (O)

> Open for extension, closed for modification.

Use interfaces and strategies:

- Define `PaymentStrategy` interface
- Implement concrete strategies (`CreditCardPayment`, `CryptoPayment`)
- Add new types without modifying existing code

### Liskov Substitution Principle (L)

> Subtypes must be substitutable for their base types.

Proper abstraction:

- `Bird` interface with `move()` method
- `Sparrow` flies, `Penguin` swims
- Both properly implement the contract

### Interface Segregation Principle (I)

> Clients should not depend on interfaces they don't use.

Segregate interfaces:

- `Workable` for work-related methods
- `Eatable` for eating methods
- `MeetingAttendee` for meetings
- Implement only what's needed

### Dependency Inversion Principle (D)

> Depend on abstractions, not concretions.

Inject dependencies:

```typescript
interface Database {
  query<T>(sql: string, params: unknown[]): Promise<T>;
}

class UserService {
  constructor(private database: Database) {} // Injected, not instantiated
}
```

## Error Handling

### AppError Hierarchy

Base class for all application errors:

```typescript
export class AppError extends Error {
  constructor(
    message: string,
    public readonly code: string,
    public readonly statusCode: number = 500,
    public readonly isOperational: boolean = true,
  ) {
    super(message);
    this.name = this.constructor.name;
    Error.captureStackTrace(this, this.constructor);
  }
}
```

Specific error types:

- `ValidationError` - Invalid input (400)
- `NotFoundError` - Resource not found (404)
- `UnauthorizedError` - Missing authentication (401)
- `ForbiddenError` - Missing authorization (403)

### Service Error Handling

**Logging pattern:**

```typescript
export class UserService {
  private readonly log = logger.child({ service: "UserService" });

  async getUser(id: string): Promise<User> {
    this.log.debug({ action: "getUser", userId: id });

    const user = await this.userRepository.findById(id);
    if (!user) {
      throw new NotFoundError("User", id);
    }

    return user;
  }
}
```

### Express Error Middleware

Centralized error handling:

```typescript
export function errorHandler(
  error: Error,
  req: Request,
  res: Response,
  _next: NextFunction,
): void {
  if (error instanceof AppError) {
    res.status(error.statusCode).json({
      success: false,
      error: {
        code: error.code,
        message: error.message,
      },
    });
    return;
  }

  // Unexpected error
  res.status(500).json({
    success: false,
    error: {
      code: "INTERNAL_ERROR",
      message: "An unexpected error occurred",
    },
  });
}
```

## Structured Logging

### Pino Logger Setup

```typescript
export const logger = pino({
  level: process.env.LOG_LEVEL || "info",
  transport:
    process.env.NODE_ENV === "development"
      ? { target: "pino-pretty", options: { colorize: true } }
      : undefined,
  base: {
    env: process.env.NODE_ENV,
    service: process.env.SERVICE_NAME,
  },
});
```

### Logging Patterns

**Always include:**

- `action` - What happened (required)
- `relevant IDs` - userId, orderId, requestId
- `error` object - For error level logs
- `correlationId` - For request tracing

**Log levels:**

- `debug` - Development flow tracing
- `info` - Business events
- `warn` - Recoverable issues
- `error` - Failures

**Pattern:**

```typescript
const log = logger.child({ service: "UserService", correlationId: req.id });

log.info({ action: "userCreated", userId: "123", correlationId: req.id });
```

## Template Files

See `templates/` directory for complete examples:

- `solid-examples.ts.template` - SOLID principles with all 5 principles
- `dry-kiss-yagni.ts.template` - DRY, KISS, YAGNI patterns
- `error-handling.ts.template` - Error hierarchy and handling
- `logging.ts.template` - Pino setup and logging patterns

## Related Skills

- `/skill domain/monorepo-audit` - Monorepo structure validation
- `/skill cross-cutting/serena-code-reading` - Progressive code analysis

## Further Reading

- SOLID Principles: https://en.wikipedia.org/wiki/SOLID
- Pino Logger: https://getpino.io/
- Zod Validation: https://zod.dev/
