---
name: requirements-phase
description: Workflow orchestration for Requirements Phase - spawns BA agent, validates PRD via vibe_check, handles clarification loop (max 2 iterations), writes PRD to /docs/prd/. Use after Analysis Phase completes. Returns validated PRD path or escalation message.
---

# Requirements Phase - PRD Creation & Validation Workflow

> **ROOT AGENT ONLY** - This workflow step spawns agents and can only be called by the root Claude Code agent (commands), never by subagents.

**Purpose:** Orchestrate the Requirements Phase of the audit workflow
**Trigger:** Called by command after Analysis Phase completes (complexity, tools, scope available)
**Output:** Validated PRD path OR escalation message
**Compliance Target:** 100%

## Workflow Overview

```
┌─────────────────────────────────────────────────────────────┐
│ REQUIREMENTS PHASE                                          │
│                                                             │
│  1. Spawn BA agent (create-prd mode)                        │
│  2. BA returns PRD with uncertainties                       │
│  3. Write PRD to /docs/prd/                                 │
│  4. Call vibe_check MCP tool                                │
│  5. If PASS (≥90%): Return PRD path                         │
│  6. If FAIL (<90%): Extract concerns                        │
│  7. Ask user for clarification (AskUserQuestion)            │
│  8. Spawn BA agent with clarification (revise mode)         │
│  9. Loop back to step 4 (max 2 iterations)                  │
│ 10. If still failing: Escalate to user                      │
└─────────────────────────────────────────────────────────────┘
```

---

## Inputs

| Input        | Type     | Source                         |
| ------------ | -------- | ------------------------------ |
| `prompt`     | string   | Original user request          |
| `complexity` | int      | From `/skill complexity-check` |
| `tools`      | string[] | From `/skill tool-check`       |
| `scope`      | string[] | From `/skill scope-check`      |

---

## Step 1: Spawn BA Agent (Create PRD)

```
Task("business-analyst", `
  MODE: create-prd

  INPUTS:
  - prompt: "{prompt}"
  - complexity: {complexity}
  - tools: {tools}
  - scope: {scope}

  Create a PRD following your output format.
  Include an "Uncertainties" section listing any assumptions or unclear requirements.

  READ YOUR INSTRUCTIONS at .claude/agents/generic/business-analyst.md
`, model: "sonnet", subagent_type: "core-claude-plugin:generic:business-analyst")
```

**Expected Output:** PRD document with Uncertainties section

---

## Step 2: Write PRD to File

**Location:** `{scope[0]}/docs/prd/`
**Filename:** `prd-{YYYYMMDD-HHmmss}-{slug}.md`

```typescript
// Generate filename
const timestamp = new Date().toISOString().replace(/[-:T]/g, "").slice(0, 15);
const slug = prompt
  .toLowerCase()
  .replace(/[^a-z0-9]+/g, "-")
  .slice(0, 30);
const filename = `prd-${timestamp}-${slug}.md`;
const path = `${scope[0]}/docs/prd/${filename}`;

// Write PRD
Write(path, prdContent);
```

---

## Step 3: Call Vibe Check

```typescript
mcp__vibe -
  check__vibe_check({
    goal: `Validate PRD for: ${prompt}`,
    plan: prdContent,
    taskContext: `Repository: ${scope[0]}, Complexity: ${complexity}`,
    uncertainties: extractedUncertainties,
  });
```

**Evaluate Response:**

| Result                          | Action                                  |
| ------------------------------- | --------------------------------------- |
| No significant risks            | ✅ **PASS** - Return PRD path           |
| Risks or assumptions identified | ⚠️ **FAIL** - Continue to clarification |

---

## Step 4: Handle Clarification (Max 2 Loops)

### Loop Counter

```
iteration = 0
maxIterations = 2
```

### On Vibe Check Failure

**Extract concerns from vibe_check response:**

- What assumptions are being questioned?
- What risks were identified?
- What simpler alternatives were suggested?

**Ask User:**

```typescript
AskUserQuestion({
  questions: [
    {
      question:
        "The PRD has some concerns that need clarification: {extractedConcerns}. Can you clarify?",
      header: "Clarify",
      options: [
        { label: "Provide details", description: "I'll give more context" },
        { label: "Simplify scope", description: "Reduce what we're doing" },
        { label: "Proceed anyway", description: "Accept the assumptions" },
      ],
      multiSelect: false,
    },
  ],
});
```

### On User Response

**If "Provide details" or custom text:**

- Spawn BA agent in revise mode with clarification
- Update PRD file
- Re-run vibe_check
- Increment iteration

**If "Simplify scope":**

- Spawn BA agent in revise mode asking to simplify
- Update PRD file
- Re-run vibe_check
- Increment iteration

**If "Proceed anyway":**

- Log user override
- Return PRD path (with warning)

---

## Step 5: Revise PRD (On Clarification)

```
Task("business-analyst", `
  MODE: revise-prd

  ORIGINAL PRD: {prdContent}

  CLARIFICATION FROM USER: {userClarification}

  VIBE CHECK CONCERNS: {vibeCheckConcerns}

  Revise the PRD to address:
  1. User's clarification
  2. Concerns raised by vibe check

  Return updated PRD.

  READ YOUR INSTRUCTIONS at .claude/agents/generic/business-analyst.md
`, model: "sonnet", subagent_type: "core-claude-plugin:generic:business-analyst")
```

---

## Step 6: Escalation (After 2 Failures)

If vibe_check fails after 2 clarification loops:

```markdown
## Requirements Phase Escalation

Unable to create validated PRD after 2 clarification attempts.

**Blockers:**
{list specific concerns from last vibe_check}

**Attempts:**

1. {first iteration summary}
2. {second iteration summary}

**Recommendation:**
Please rephrase your request with more specific scope or provide additional context about:
{specific questions}
```

**Return:** Escalation message (not PRD path)

---

## Output

### On Success

```typescript
{
  status: "success",
  prdPath: "/mnt/f/code/resume-builder/docs/prd/prd-20241203-143022-monorepo-audit.md",
  iterations: 1,
  vibeCheckPassed: true
}
```

### On User Override

```typescript
{
  status: "override",
  prdPath: "/mnt/f/code/resume-builder/docs/prd/prd-20241203-143022-monorepo-audit.md",
  iterations: 1,
  vibeCheckPassed: false,
  warning: "User chose to proceed despite vibe check concerns"
}
```

### On Escalation

```typescript
{
  status: "escalated",
  prdPath: null,
  iterations: 2,
  blockers: ["list of concerns"],
  recommendation: "Rephrase request"
}
```

---

## Configuration

| Setting              | Value      | Rationale                        |
| -------------------- | ---------- | -------------------------------- |
| Max iterations       | 2          | Prevent infinite loops           |
| Vibe check threshold | 90%        | High bar for PRD quality         |
| BA model             | sonnet     | Needs reasoning for PRD creation |
| PRD storage          | /docs/prd/ | Persistent record                |

---

## Integration

This skill is called by:

- `/audit` command (after Analysis Phase)
- `/build` command (after Analysis Phase)
- `/ms` command (for complexity ≥15)

This skill calls:

- `business-analyst` agent (SME for PRD creation)
- `vibe_check` MCP tool (metacognitive validation)
- `AskUserQuestion` tool (user clarification)

---

## Example Execution

```
Command: /audit monorepo root

Phase 1 (Analysis):
  complexity: 28
  tools: ["serena", "semgrep"]
  scope: ["/mnt/f/code/resume-builder"]

Phase 2 (Requirements - this skill):
  → Spawn BA agent (create-prd)
  → BA returns PRD with "Uncertainties: None"
  → Write to /docs/prd/prd-20241203-143022-monorepo-audit.md
  → Call vibe_check
  → vibe_check: "No significant risks identified"
  → Return: { status: "success", prdPath: "...", iterations: 0 }

Phase 3 (Design):
  → Continue with validated PRD
```
