---
name: prd-approval
description: Human-in-the-loop PRD validation before architecture phase. Presents PRD summary, asks for approval, handles change requests. Required for complexity ≥15.
---

# PRD Approval Skill

> **ROOT AGENT ONLY** - Uses AskUserQuestion, runs only from root Claude Code agent.

**Purpose:** Get human approval of PRD before architecture phase
**Trigger:** After requirements-phase (for /audit) or innovate-phase validation fails
**Input:** `prdPath` (string), `prompt` (string), `complexity` (int)
**Output:** `{status, prdPath, iterations}`

---

## When to Use

| Complexity | Use PRD Approval? | Rationale                                     |
| ---------- | ----------------- | --------------------------------------------- |
| ≤14        | No                | Quick workflows, vibe_check sufficient        |
| ≥15        | **Yes**           | Full workflow, human gate before architecture |

**Calls:** `/audit` (≥15 complexity), `/ms` (≥15 complexity)
**Skips:** `/build` (uses innovate-phase validation)

---

## Workflow

**1. Read PRD and extract sections** (requirements, success criteria, deliverables, uncertainties)

**2. Present PRD summary to user** with original request, complexity, and extracted sections

**3. Ask for approval:**

- Option A: "Yes, proceed" → Return approved PRD path (done)
- Option B: "No, needs changes" → Go to step 4

**4. Ask what changes needed** (add requirement, remove requirement, modify scope, clarify uncertainty)

**5. Spawn BA agent** to revise PRD with change request

**6. Loop:** Return to step 2 (max 2 iterations)

**7. Escalate if needed:** After 2 revision attempts, return escalation message

---

## Configuration

| Setting              | Value  | Rationale                             |
| -------------------- | ------ | ------------------------------------- |
| Max iterations       | 2      | Prevent infinite revision loops       |
| Complexity threshold | ≥15    | Align with confidence-check threshold |
| BA model             | sonnet | Needs reasoning for PRD revisions     |

---

## Output Examples

**On Approval (0 iterations):**

```json
{
  "status": "approved",
  "prdPath": "/mnt/f/code/resume-builder/docs/prd/prd-20241203-143022-audit.md",
  "iterations": 0
}
```

**On Approval After 1 Revision:**

```json
{
  "status": "approved",
  "prdPath": "/mnt/f/code/resume-builder/docs/prd/prd-20241203-143022-audit.md",
  "iterations": 1,
  "changesApplied": ["Added rate limiting requirement"]
}
```

---

## Integration

**Called by:**

- `/audit` command (after requirements-phase, before design-phase)
- `/ms` command (for complexity ≥15)

**Calls:**

- `business-analyst` agent (for PRD revisions)
- `AskUserQuestion` tool (user interaction)

**Next step:** design-phase (Architect + PM)
