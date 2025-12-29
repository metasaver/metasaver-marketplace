---
name: requirements-phase
description: PRD creation with EA agent, validation with reviewer, HITL approval, then BA extracts stories. EA creates PRD, reviewer validates, user approves, BA creates epics and user stories. Formal PRD approval happens in THIS phase.
---

# Requirements Phase - PRD + Epic/Story Creation (HITL)

> **ROOT AGENT ONLY** - Called by commands only, always invoked at root level.

**Purpose:** Create PRD (EA), validate (reviewer), HITL approve, extract stories (BA)
**Trigger:** After analysis-phase completes
**Input:** prompt, complexity, tools, scope
**Output:** Approved PRD + Epics + User Stories

---

## Workflow

```
1. Check/Create Project Folder
         │
         ▼
2. Spawn EA Agent ──► Creates PRD (prd-creation skill)
         │
         ▼
3. Spawn Reviewer ──► Validates PRD (document-validation)
         │
         ▼
4. HITL Gate ──► User approves/rejects PRD
    │         │
    │ REJECT ──► Return to EA with feedback
    │
    │ APPROVE
         │
         ▼
5. Spawn BA Agent ──► Creates story outlines
         │
         ▼
6. Continue to design-phase
```

### Step 1: Project Folder

- Glob `docs/epics/*` for existing folders
- Reuse or create: `docs/epics/{PREFIX}{NNN}-{name}/`

### Step 2: EA Agent (PRD)

Spawn: `core-claude-plugin:generic:enterprise-architect`

- Analyze prompt; investigate codebase (audits)
- Draft PRD using `/skill prd-creation`
- Clarification loop (AskUserQuestion) if uncertainties exist
- Save to `{projectFolder}/prd.md`

### Step 3: Reviewer (Validation)

Spawn: `core-claude-plugin:generic:reviewer`

- Use `/skill document-validation` to validate PRD
- If invalid: return to EA with issues

### Step 4: HITL Approval

Use `/skill hitl-approval`:

- **APPROVE** -> Continue to BA
- **REJECT** -> Return to EA with feedback

### Step 5: BA Agent (Stories)

Spawn: `core-claude-plugin:generic:business-analyst`

**Precondition:** PRD MUST be approved first.

- Mode: `extract-stories`
- Create `{projectFolder}/user-stories/`
- Create epics then stories (ALWAYS at least 1 epic)

| Complexity | Epics |
| ---------- | ----- |
| < 15       | 1     |
| 15-29      | 1-2   |
| 30-44      | 2-3   |
| >= 45      | 3+    |

---

## Agent Summary

| Step | Agent                | Mode            | Output          |
| ---- | -------------------- | --------------- | --------------- |
| 2    | enterprise-architect | create-prd      | PRD draft       |
| 3    | reviewer             | validate        | Validation      |
| 5    | business-analyst     | extract-stories | Epics + Stories |

---

## Story Consolidation

**ONE story per target file.** Consolidate multiple requirements for same file.

---

## Audit Mode

EA prioritizes codebase investigation before questions:

- Use Serena tools (package.json, configs, structure)
- Classify repos via `metasaver.projectType`
- Minimize clarification questions

---

## Output Format

```json
{
  "status": "complete",
  "projectFolder": "docs/epics/msm007-feature",
  "prdPath": "docs/epics/msm007-feature/prd.md",
  "prdApproved": true,
  "epics": [{ "id": "EPIC-001", "title": "...", "stories": ["US-001"] }],
  "stories": [{ "id": "US-001", "epic": "EPIC-001", "agent": "..." }]
}
```

---

## Integration

**Called by:** /audit, /build, /architect, /ms
**Spawns:** enterprise-architect, reviewer, business-analyst
**Calls:** `/skill hitl-approval`, `/skill prd-creation`, `/skill document-validation`, `/skill user-story-template`
**Next:** design-phase (architect enriches stories)
