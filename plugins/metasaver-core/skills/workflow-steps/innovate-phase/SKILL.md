---
name: innovate-phase
description: Optional PRD enhancement with industry best practices. Spawns innovation-advisor for suggestions (max 5-7), user selects improvements, BA updates PRD, vibe_check validates. Use when enhancing requirements before architecture design.
---

# Innovate Phase - PRD Enhancement Workflow

> **ROOT AGENT ONLY** - Called by commands only, never by subagents.

**Purpose:** Enhance validated PRD with industry best practices
**Trigger:** After requirements-phase (used by /build and /ms, NOT /audit)
**Input:** PRD path from requirements-phase, complexity, scope
**Output:** Final PRD path + human validation

---

## Workflow Steps

1. **Present PRD to user** for review (full content)

2. **Ask:** "Would you like improvement suggestions based on industry standards?"
   - NO → Skip to Human Validation
   - YES → Continue

3. **Spawn innovation-advisor agent:**
   - Analyze PRD, suggest 5-7 improvements
   - Prioritize by impact-to-effort ratio
   - Include category, impact, effort, rationale for each

4. **Present suggestions to user:**
   - Format: "1. [Title] (Category, Impact/Effort)"
   - Ask: "For each, respond with: yes | no | explain"
   - Example: "1:yes, 2:explain, 3:no, 4:yes, 5:no"

5. **Handle "explain more" requests:**
   - Show detailed rationale, implementation hints, industry examples
   - Re-ask for approval of that suggestion

6. **If user selected improvements:**
   - Spawn BA agent (revise-prd mode) with selected items
   - Update PRD file

7. **Vibe check updated PRD** (no clarification loop, log warning if fail)

8. **Human validates final PRD:**
   - Present summary: requirements, success criteria, deliverables
   - Ask: "Approve to proceed to Architecture?"
   - NO → Ask what changes needed, loop back to BA
   - YES → Return PRD path (done)

---

## Innovation Advisor Output

```
1. OpenAPI Documentation
   Category: DX, Impact: High, Effort: Low
   Rationale: Enables client generation, improves adoption

2. Rate Limiting
   Category: Security, Impact: High, Effort: Medium
   Rationale: Prevents abuse, ensures stability
```

---

## Configuration

| Setting          | Value            | Rationale                |
| ---------------- | ---------------- | ------------------------ |
| Max suggestions  | 7                | Prevent decision fatigue |
| Innovation model | sonnet           | Needs research           |
| Human validation | Required         | Must approve before arch |
| Explain loops    | 1 per suggestion | Not unlimited            |

---

## Output Format

```
{
  status: "success",
  prdPath: "/docs/prd/prd-20241204-feature.md",
  innovated: true,
  innovationsApplied: ["OpenAPI docs", "Rate limiting"],
  humanValidated: true
}
```

---

## Integration

**Called by:** /build, /ms (complexity ≥15)
**NOT called by:** /audit
**Calls:** innovation-advisor agent, business-analyst agent, vibe_check MCP, AskUserQuestion
**Next phase:** design-phase

---

## Example

```
/build JWT authentication API

After Requirements Phase:
  PRD: /docs/prd/prd-20241204-jwt-auth-api.md

Innovate Phase:
  → Present PRD to user
  → User: "Yes, suggest improvements"
  → innovation-advisor returns 5 suggestions
  → User: "1:yes, 2:yes, 3:explain, 4:yes, 5:no"
  → Explain refresh token rotation
  → User: "3:yes"
  → BA updates PRD (4 improvements applied)
  → vibe_check: PASS
  → Human validates: "Yes, proceed"
  → Return: {innovated: true, innovationsApplied: [1,2,3,4]}

Next: Design Phase
```
