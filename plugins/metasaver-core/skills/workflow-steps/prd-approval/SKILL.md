---
name: prd-approval
description: Human validation of PRD before design phase. Presents PRD, user approves or requests changes. Required for complexity ≥15.
---

# PRD Approval Skill

> **ROOT AGENT ONLY** - Uses AskUserQuestion, runs only from root agent.

**Purpose:** Get human approval of PRD before architecture phase
**Trigger:** After vibe-check passes
**Input:** prdPath, complexity
**Output:** Approval status

---

## When to Use

| Complexity | Use PRD Approval? |
| ---------- | ----------------- |
| <15        | No (skip)         |
| ≥15        | **Yes**           |

---

## Workflow

1. **Present PRD to user** (summary + link)

2. **Ask for approval:**
   - YES → Return approved, continue to design-phase
   - NO → Ask what changes needed

3. **If changes requested:**
   - Spawn BA to revise PRD
   - Update PRD file
   - Loop back to step 1 (max 2 iterations)

---

## Integration

**Called by:** /audit, /build, /ms (complexity ≥15)
**Calls:** business-analyst agent, AskUserQuestion
**Next phase:** design-phase
