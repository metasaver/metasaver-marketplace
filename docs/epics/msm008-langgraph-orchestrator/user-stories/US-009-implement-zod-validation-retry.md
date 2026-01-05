---
story_id: "MSM008-009"
title: "Implement Zod validation with retry loop"
epic: "Epic 1: Foundation"
status: "pending"
priority: "P0"
agent: "core-claude-plugin:generic:coder"
dependencies: ["MSM008-002"]
---

# Story: Implement Zod Validation with Retry Loop

## Description

As a workflow system, I need LLM output validation with automatic retry so that agent responses are guaranteed to match expected schemas before use (FR-010, FR-011).

## Acceptance Criteria

- [ ] `validateWithRetry<T>()` function accepts Zod schema and executor
- [ ] Maximum 3 retries before failing to HITL
- [ ] Validation errors fed back to agent with specific field issues
- [ ] Returns `ValidationResult<T>` with success, data, errors, retryCount
- [ ] Supports any Zod schema type

## Architecture

- **Files to create:**
  - `packages/langgraph-orchestrator/src/lib/validation.ts`
- **Files to modify:** None
- **Database:** None
- **Components:** None
- **Libraries:**
  - `zod` - Already installed in MSM008-002

## Implementation Notes

**Validation module (src/lib/validation.ts):**

```typescript
import { z } from "zod";

const MAX_RETRIES = 3;

export interface ValidationResult<T> {
  success: boolean;
  data?: T;
  errors?: string[];
  retryCount: number;
}

export async function validateWithRetry<T>(schema: z.ZodSchema<T>, executeAgent: (feedback?: string) => Promise<unknown>): Promise<ValidationResult<T>> {
  let lastErrors: string[] = [];

  for (let attempt = 1; attempt <= MAX_RETRIES; attempt++) {
    const feedback = attempt > 1 ? `Previous response failed validation. Errors: ${lastErrors.join(", ")}. Please fix and retry.` : undefined;

    const response = await executeAgent(feedback);
    const result = schema.safeParse(response);

    if (result.success) {
      return {
        success: true,
        data: result.data,
        retryCount: attempt,
      };
    }

    lastErrors = result.error.errors.map((e) => `${e.path.join(".")}: ${e.message}`);
  }

  return {
    success: false,
    errors: lastErrors,
    retryCount: MAX_RETRIES,
  };
}

// Type helper for node output validation
export function createOutputValidator<T>(schema: z.ZodSchema<T>) {
  return (data: unknown): T => {
    const result = schema.safeParse(data);
    if (!result.success) {
      throw new Error(`Output validation failed: ${result.error.errors.map((e) => e.message).join(", ")}`);
    }
    return result.data;
  };
}
```

**Usage in workflow nodes:**

```typescript
const PlanningOutputSchema = z.object({
  scope: z.string(),
  strategy: z.string(),
  risks: z.array(z.string()),
});

const result = await validateWithRetry(PlanningOutputSchema, async (feedback) => {
  return spawnClaudeCode({
    prompt: feedback ? `${basePrompt}\n\nFeedback: ${feedback}` : basePrompt,
  });
});

if (!result.success) {
  // Transition to HITL state
  return { ...state, status: "hitl_waiting", hitlQuestion: result.errors.join("\n") };
}
```

## Dependencies

- MSM008-002: Zod must be installed

## Estimated Effort

Medium (2-3 hours)
