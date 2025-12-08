---
name: requirements-phase
description: PRD creation and validation with clarification loops. Spawns BA agent (analyze → create → revise), validates via vibe_check, handles uncertainties with user questions (max 2 iterations). Use when creating requirements documents from prompts.
---

# Requirements Phase - PRD Creation & Validation

> **ROOT AGENT ONLY** - Called by commands only, never by subagents.

**Purpose:** Create and validate a PRD document
**Trigger:** After analysis-phase completes
**Input:** prompt, complexity, tools, scope (from previous phases)
**Output:** Validated PRD path OR escalation message

---

## Workflow Steps

1. **Spawn BA agent (analyze mode):**
   - Analyze requirements, identify uncertainties
   - Return analysis (clear requirements + uncertain items)

2. **If uncertainties exist:** Ask user for clarification via AskUserQuestion

3. **Spawn BA agent (create-prd mode):**
   - Create PRD with clarifications incorporated
   - Write to `{scope[0]}/docs/prd/prd-{YYYYMMDD-HHmmss}-{slug}.md`

4. **Call vibe_check MCP tool** on PRD content

5. **If PASS (≥90%):** Return success (PRD path, iterations: 0)

6. **If FAIL (<90%):** Enter clarification loop (max 2 iterations)
   - Extract concerns from vibe_check
   - Ask user: "Provide details?" / "Simplify scope?" / "Proceed anyway?"
   - Spawn BA (revise mode) with response
   - Update PRD file
   - Re-run vibe_check
   - Increment iteration counter

7. **If max iterations reached:** Return escalation message with blockers + recommendation

---

## BA Agent Modes

| Mode       | Input                             | Output             |
| ---------- | --------------------------------- | ------------------ |
| analyze    | prompt, complexity, scope         | uncertainties list |
| create-prd | analysis, clarifications          | PRD document       |
| revise-prd | PRD, concerns, user clarification | updated PRD        |

---

## Vibe Check

```
mcp__vibe_check__vibe_check({
  goal: "Validate PRD for: {prompt}",
  plan: prdContent,
  taskContext: "Repo: {scope}, Complexity: {complexity}",
  uncertainties: extractedUncertainties
})
```

Result: ≥90% score = PASS, <90% = FAIL

---

## Output Format

| Scenario         | Status    | Iterations |
| ---------------- | --------- | ---------- |
| No uncertainties | success   | 0          |
| Clarified once   | success   | 1          |
| User overrides   | override  | 1-2        |
| Max iterations   | escalated | 2          |

---

## Integration

**Called by:** /audit, /build, /ms (complexity ≥15)
**Calls:** business-analyst agent, vibe_check MCP, AskUserQuestion
**Next phase:**

- /audit → design (no innovate)
- /build, /ms → innovate-phase

---

## Example

```
/audit monorepo root

Analysis Phase: complexity=28, tools=[serena], scope=[/mnt/f/code/resume-builder]

Requirements Phase (this skill):
  → BA (analyze): "Uncertainties: None"
  → BA (create-prd): Generates PRD
  → Write to /docs/prd/prd-20241203-143022-monorepo-audit.md
  → vibe_check: "No significant risks"
  → Return: {status: "success", prdPath: "..."}

Next: Design Phase
```
