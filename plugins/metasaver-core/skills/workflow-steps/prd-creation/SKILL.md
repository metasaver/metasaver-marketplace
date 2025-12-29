---
name: prd-creation
description: Guide PRD document creation using the standard template. PRD contains REQUIREMENTS ONLY - no user stories (those are extracted separately). Use when EA agent drafts or updates a PRD, or when validating PRD structure.
owner: enterprise-architect-agent
---

# PRD Creation Skill

**Purpose:** Guide PRD document creation following the standard template
**Trigger:** When EA agent creates or updates a PRD document
**Output:** Well-structured PRD ready for story extraction

---

## Template Reference

**ALWAYS read the template before creating a PRD:**

```
templates/docs/prd-template.md
```

The template contains:

- Required YAML frontmatter fields
- All 10 standard sections
- Field placeholders and formatting rules
- Template rules (comments at bottom)

---

## Workflow

1. **Read the template:**
   - Load `templates/docs/prd-template.md`
   - Note all required sections and frontmatter fields

2. **Gather requirements:**
   - Extract goals and scope from user prompt
   - Identify functional and non-functional requirements
   - Clarify ambiguities via HITL loop (AskUserQuestion)

3. **Draft PRD sections:**
   - Follow template section order (1-10)
   - Use tables for structured data (requirements, risks, decisions)
   - Keep descriptions concise (2-3 sentences per section intro)

4. **Validate structure:**
   - Run validation checklist (see below)
   - Fix any missing or malformed sections

5. **Save PRD:**
   - Write to `{projectFolder}/prd.md`
   - Ensure frontmatter is complete

---

## PRD Structure (10 Sections)

| #   | Section             | Purpose                                        |
| --- | ------------------- | ---------------------------------------------- |
| 1   | Executive Summary   | 2-3 sentence overview + goal                   |
| 2   | Problem Statement   | Current state, issues, pain points             |
| 3   | Solution Overview   | Target state, core principles                  |
| 4   | Requirements        | FR/NFR tables with IDs and priority            |
| 5   | Scope               | In scope / out of scope lists                  |
| 6   | Epic Summary        | Epic list with story counts (NO story details) |
| 7   | Success Criteria    | Technical requirements, verification, metrics  |
| 8   | Risks & Mitigations | Risk table with impact/likelihood              |
| 9   | Dependencies        | External and internal dependencies             |
| 10  | Design Decisions    | HITL decisions with rationale                  |

---

## Validation Checklist

Run this checklist before marking PRD complete:

### Frontmatter

- [ ] `project_id` present (format: `{PREFIX}{NNN}`)
- [ ] `title` present
- [ ] `version` present (start at "1.0")
- [ ] `status` present (draft | in-review | approved)
- [ ] `created` date present (YYYY-MM-DD)
- [ ] `updated` date present (YYYY-MM-DD)
- [ ] `owner` set to "enterprise-architect-agent"

### Required Sections

- [ ] Section 1: Executive Summary has overview + goal
- [ ] Section 2: Problem Statement has current state + issues table
- [ ] Section 3: Solution Overview has target state + principles table
- [ ] Section 4: Requirements has FR and NFR tables with IDs
- [ ] Section 5: Scope has both in-scope and out-of-scope lists
- [ ] Section 6: Epic Summary has epic table (NO user story details)
- [ ] Section 7: Success Criteria has technical requirements + verification
- [ ] Section 8: Risks has risk table with mitigations
- [ ] Section 9: Dependencies lists external and internal
- [ ] Section 10: Design Decisions has decision table

### Content Rules

- [ ] Requirements use ID format: FR-001, NFR-001
- [ ] Priority values are P0, P1, or P2 only
- [ ] Epic summary shows counts, NOT story details
- [ ] No user story acceptance criteria in PRD
- [ ] Tables properly formatted with headers

---

## Key Rules

| Rule                       | Reason                                  |
| -------------------------- | --------------------------------------- |
| PRD = requirements only    | Stories extracted in separate phase     |
| Epic summary = counts only | Details live in user-stories/ folder    |
| Frontmatter required       | Enables document tracking and ownership |
| Use tables for lists       | Improves readability and parsing        |

---

## Example

**Input:** User requests "Build authentication API"

**PRD Creation:**

1. EA reads template from `templates/docs/prd-template.md`
2. EA drafts:
   - Section 1: "Implement secure user authentication..."
   - Section 4: FR-001 Login endpoint, FR-002 Logout endpoint...
   - Section 6: "| E01 | Authentication | 5 | 15 |"
3. EA validates against checklist
4. EA saves to `docs/epics/msm007-auth-api/prd.md`

**Output:** Complete PRD with all 10 sections, ready for story extraction

---

## Integration

**Called by:** requirements-phase, /architect command, /build command
**Calls:** Read tool (for template), Write tool (for saving)
**References:**

- `/skill user-story-template` - For story extraction (separate phase)
- `/skill save-prd` - For persisting approved PRD artifacts

**Next step:** Story extraction using `/skill user-story-template`
