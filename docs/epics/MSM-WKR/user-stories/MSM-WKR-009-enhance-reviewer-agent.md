---
story_id: "MSM-WKR-009"
epic_id: "MSM-WKR"
title: "Enhance reviewer agent"
status: "pending"
wave: 4
agent: "core-claude-plugin:generic:agent-author"
dependencies: ["MSM-WKR-005"]
priority: "P1"
created: "2024-12-29"
updated: "2024-12-29"
---

# MSM-WKR-009: Enhance reviewer agent

## User Story

As a workflow orchestrator, I want the reviewer agent enhanced to validate documents before HITL so that users only see properly formatted documents.

---

## Acceptance Criteria

- [ ] Reviewer agent gains document validation capability
- [ ] Reviewer invokes `document-validation-skill`
- [ ] Reviewer is called before each HITL gate
- [ ] Reviewer returns PASS/FAIL with violations
- [ ] On FAIL, workflow returns to creating agent for fixes

### Standard AC Items (Required)

- [ ] Follows established template/pattern
- [ ] Format validated

---

## Technical Details

### Location

- **Repo:** metasaver-marketplace
- **Package:** plugins/metasaver-core/agents/generic/

### Files to Modify

| File                         | Changes                            |
| ---------------------------- | ---------------------------------- |
| `agents/generic/reviewer.md` | Add document validation capability |

---

## Architecture

**Validation Flow:**

```
EA creates PRD → Reviewer validates → HITL (if PASS)
                                   → Back to EA (if FAIL)

PM creates plan → Reviewer validates → HITL (if PASS)
                                    → Back to PM (if FAIL)

BA creates stories → Reviewer validates → HITL (if PASS)
                                       → Back to BA (if FAIL)
```

**Reviewer Tools:**

- Read (read documents)
- Glob, Grep (find files)
- document-validation-skill (validation logic)

---

## Definition of Done

- [ ] Reviewer agent updated
- [ ] References document-validation-skill
- [ ] Can validate PRD, execution plan, user stories
- [ ] Returns structured PASS/FAIL result
