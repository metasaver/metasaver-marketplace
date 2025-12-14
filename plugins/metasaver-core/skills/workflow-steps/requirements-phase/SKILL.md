---
name: requirements-phase
description: PRD creation with HITL clarification loop. BA drafts PRD, asks user questions until requirements are clear. NO approval here—approval happens after design phase when user can see full plan.
---

# Requirements Phase - PRD Creation (HITL)

> **ROOT AGENT ONLY** - Called by commands only, never by subagents.

**Purpose:** Create PRD with human-in-the-loop clarification (Q&A only, no approval)
**Trigger:** After analysis-phase completes
**Input:** prompt, complexity, tools, scope (from analysis-phase)
**Output:** Completed PRD content (not yet written to file)

---

## Important: No Approval Here

This phase is for **clarification only**, not approval. The user can ask questions, provide context, and clarify requirements interactively. Formal approval happens later in **plan-approval** phase after:

- PRD is written
- Stories are extracted
- Architect has annotated stories
- PM has created execution plan

This way the user sees the full picture before approving.

---

## Workflow Steps

1. **Create project folder:**
   - Format: `docs/projects/{yyyymmdd}-{descriptive-name}/`
   - Example: `docs/projects/20251208-applications-feature/`
   - BA creates this folder before drafting PRD

2. **Spawn BA agent (draft mode):**
   - Analyze prompt and context
   - Draft initial PRD
   - Identify questions/uncertainties

3. **HITL Clarification Loop:**

   ```
   WHILE BA has questions:
     → Ask user via AskUserQuestion
     → User provides answers
     → BA incorporates answers, may have follow-up questions
   ```

4. **BA completes PRD:**
   - All questions resolved
   - Save to `{projectFolder}/prd.md`
   - Return completed PRD content and project folder path
   - **Continue to next phase** (no approval stop here)

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
  "projectFolder": "docs/projects/20251208-applications-feature",
  "prdPath": "docs/projects/20251208-applications-feature/prd.md",
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
- All → design-phase → **plan-approval** (where formal approval happens)
