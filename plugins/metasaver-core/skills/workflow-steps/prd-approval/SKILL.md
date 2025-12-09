---
name: prd-approval
description: Human validation of PRD before design phase. Presents PRD, user approves or requests changes, extracts user stories. Required for complexity ≥15.
---

# PRD Approval Skill

> **ROOT AGENT ONLY** - Uses AskUserQuestion, runs only from root agent.

**Purpose:** Get human approval of PRD, extract user stories before architecture phase
**Trigger:** After vibe-check passes
**Input:** prdPath, complexity
**Output:** Approval status + story files

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
   - YES → Continue to step 4
   - NO → Ask what changes needed → Go to step 3

3. **If changes requested:**
   - Spawn BA to revise PRD
   - Update PRD file
   - Loop back to step 1 (max 2 iterations)

4. **Extract user stories (after approval):**
   - Spawn BA agent in "extract-stories" mode
   - BA reads approved PRD
   - BA creates `user-stories/` folder in project folder
   - BA creates individual story files: `US-001-{slug}.md`, `US-002-{slug}.md`, etc.
   - BA uses template from `/skill user-story-template`
   - Return paths to all story files

5. **Continue to design-phase** with story files

---

## Output Format

```json
{
  "status": "approved",
  "prdPath": "docs/projects/20251208-feature/prd.md",
  "storiesFolder": "docs/projects/20251208-feature/user-stories/",
  "storyFiles": [
    "US-001-view-list.md",
    "US-002-add-item.md",
    "US-003-edit-item.md"
  ]
}
```

---

## Integration

**Called by:** /audit, /build, /ms (complexity ≥15)
**Calls:** business-analyst agent (revise/extract-stories), AskUserQuestion
**References:** `/skill user-story-template` (for BA story extraction)
**Next phase:** design-phase
