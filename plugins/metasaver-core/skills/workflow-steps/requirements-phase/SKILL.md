---
name: requirements-phase
description: PRD creation with HITL clarification loop. BA drafts PRD, asks user questions until complete. Use when creating requirements documents from prompts.
---

# Requirements Phase - PRD Creation (HITL)

> **ROOT AGENT ONLY** - Called by commands only, never by subagents.

**Purpose:** Create PRD with human-in-the-loop clarification
**Trigger:** After analysis-phase completes
**Input:** prompt, complexity, tools, scope (from analysis-phase)
**Output:** Completed PRD content (not yet written to file)

---

## Workflow Steps

1. **Spawn BA agent (draft mode):**
   - Analyze prompt and context
   - Draft initial PRD
   - Identify questions/uncertainties

2. **HITL Clarification Loop:**

   ```
   WHILE BA has questions:
     → Ask user via AskUserQuestion
     → User provides answers
     → BA incorporates answers, may have follow-up questions
   ```

3. **BA completes PRD:**
   - All questions resolved
   - Return completed PRD content

---

## BA Agent Modes

| Mode  | Input                     | Output                |
| ----- | ------------------------- | --------------------- |
| draft | prompt, complexity, scope | PRD draft + questions |

---

## Output Format

```json
{
  "status": "complete",
  "prdContent": "# PRD...",
  "clarificationsProvided": 2
}
```

---

## Integration

**Called by:** /audit, /build, /ms (all complexity levels that need PRD)
**Calls:** business-analyst agent, AskUserQuestion
**Next phase:**

- /build → innovate-phase (ask user)
- /audit → vibe-check (skip innovate)
