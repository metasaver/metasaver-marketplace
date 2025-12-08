---
name: innovate-phase
description: Optional PRD enhancement with industry best practices. Writes PRD file, links to user, asks "Want to Innovate?" (HITL STOP). If yes, spawns innovation-advisor for numbered suggestions. Use for /build only.
---

# Innovate Phase - PRD Complete & Optional Enhancement

> **ROOT AGENT ONLY** - Called by commands only, never by subagents.

**Purpose:** Write PRD file, ask user about innovation, optionally enhance
**Trigger:** After requirements-phase (/build only, NOT /audit)
**Input:** PRD content from requirements-phase, complexity, scope
**Output:** Final PRD path

---

## Workflow Steps

1. **Write PRD file:**
   - Path: `{scope[0]}/docs/prd/prd-{YYYYMMDD-HHmmss}-{slug}.md`
   - Write PRD content to file

2. **Link PRD to user:**
   - Show file path
   - Brief summary of what's in the PRD

3. **Ask: "Do you want to innovate with industry best practices?" (HARD STOP)**
   - Wait for user response
   - NO → Return PRD path (skip to vibe-check)
   - YES → Continue to step 4

4. **Spawn innovation-advisor agent:**
   - Analyze PRD
   - Return numbered list of suggestions (max 5-7)
   - Format: `1. [Title] - Impact: High/Med/Low, Effort: High/Med/Low`

5. **Present numbered suggestions to user:**
   - User responds: `1:yes, 2:explain, 3:no, 4:yes`
   - Handle "explain" requests inline

6. **If user selected improvements:**
   - Spawn BA agent to update PRD with selections
   - Update PRD file

7. **Return PRD path**

---

## Innovation Advisor Output Format

```
1. Add OpenAPI Documentation
   Impact: High, Effort: Low
   Enables client generation and improves API discoverability

2. Implement Rate Limiting
   Impact: High, Effort: Medium
   Prevents abuse and ensures service stability

3. Add Structured Logging
   Impact: Medium, Effort: Low
   Improves debugging and observability
```

User responds: `1:yes, 2:yes, 3:no`

---

## Output Format

```json
{
  "status": "complete",
  "prdPath": "/docs/prd/prd-20241208-feature.md",
  "innovated": true,
  "innovationsApplied": ["OpenAPI Documentation", "Rate Limiting"]
}
```

---

## Integration

**Called by:** /build, /ms (complexity ≥30)
**NOT called by:** /audit
**Calls:** innovation-advisor agent, business-analyst agent, AskUserQuestion
**Next phase:** vibe-check
