---
project_id: "MSM-WFE"
title: "Workflow Enforcement - Mandatory Validation Gates"
version: "3.0"
status: "draft"
created: "2026-01-02"
updated: "2026-01-02"
owner: "enterprise-architect-agent"
---

# PRD: Workflow Enforcement - Mandatory Validation Gates

## 1. Executive Summary

Analysis of 9 postmortems revealed agents consistently bypass templates and skip workflow phases despite having full template content loaded into context. **The problem isn't missing templates—skills already inject templates. The problem is no enforcement.**

**Goal:** Add 3 simple enforcement checkpoints that block progression on violations.

---

## 2. Problem Statement

### Root Cause Analysis

Skills load full SKILL.md content into agent context when invoked. Templates ARE there. Agents ignore them anyway by rationalizing "this is simple" or "I know the format."

| Evidence from Postmortems | Count | What Actually Happened                                 |
| ------------------------- | ----- | ------------------------------------------------------ |
| Template Non-Compliance   | 5/9   | Agent had template in context, wrote different format  |
| Workflow Phase Skips      | 4/9   | Agent decided phases were "unnecessary" for task       |
| Invalid Agent Names       | 2/9   | Agent guessed names like "backend-dev" (doesn't exist) |
| HITL Bypassed             | 3/9   | Prose question instead of AskUserQuestion tool         |

### Key Insight

> "Skills are model-invoked: Claude decides which Skills to use based on your request."
> — Claude Code Documentation

Skills load templates. Agents decide to follow them (or not). **No enforcement exists.**

---

## 3. Solution: 3 Enforcement Points

### E1: Mandatory Document Validation

**Problem:** Documents written without validation, errors caught in postmortem.

**Fix:** Reviewer agent MUST validate BEFORE phase transitions. Blocking PASS/FAIL.

**Implementation:**

- Modify `document-validation` skill to return structured `{result: "PASS"|"FAIL", issues: []}`
- Add validation checkpoints after PRD creation, after execution plan, after stories
- Workflow cannot progress until validation PASS
- On FAIL: loop back to authoring agent with specific issues

### E2: Phase Transition Gates

**Problem:** Phases skipped because nothing prevents it.

**Fix:** Check required artifacts exist before allowing phase change.

**Implementation:**

- Add `checkPhaseRequirements(phase)` to state-management skill
- Phase 3 requires: prd.md exists, validation PASS
- Phase 5 requires: execution-plan.md exists, validation PASS
- Phase 6 requires: user-stories/ populated, validation PASS
- Return error if requirements not met

### E3: Agent Name Validation

**Problem:** Stories assigned to invalid agents like "backend-dev" or "frontend-dev".

**Fix:** Validate agent names against agent-selection skill at story creation.

**Implementation:**

- Add `validateAgentName(name)` function to user-story-creation skill
- Parse valid names from agent-selection skill tables
- Reject immediately on invalid name with suggestion

---

## 4. Requirements

| ID     | Requirement                                                    | Priority |
| ------ | -------------------------------------------------------------- | -------- |
| FR-001 | Reviewer validation MUST be called after PRD creation          | P0       |
| FR-002 | Reviewer validation MUST be called after execution plan        | P0       |
| FR-003 | Reviewer validation MUST be called after story creation        | P0       |
| FR-004 | Validation FAIL MUST block phase progression                   | P0       |
| FR-005 | Phase transitions MUST check required artifacts exist          | P0       |
| FR-006 | Agent names in stories MUST be validated against registry      | P0       |
| FR-007 | Invalid agent names MUST cause immediate error with suggestion | P0       |
| FR-008 | HITL gates MUST use AskUserQuestion tool, not prose            | P0       |

---

## 5. Scope

### In Scope

1. Add validation checkpoint calls to `document-validation` skill
2. Add `checkPhaseRequirements()` to state-management skill
3. Add `validateAgentName()` to user-story-creation skill
4. Update `/build` and `/architect` commands to call validation gates

### Out of Scope

- JSON schemas for documents (templates are sufficient)
- Complex audit logging system (simple pass/fail is enough)
- Template injection changes (templates already load via skills)
- Phase state machine (simple artifact checks are enough)

---

## 6. Stories

| ID  | Title                                     | Agent          | Estimate |
| --- | ----------------------------------------- | -------------- | -------- |
| 001 | Add mandatory reviewer gate after PRD     | skill-author   | 15 min   |
| 002 | Add mandatory reviewer gate after plan    | skill-author   | 15 min   |
| 003 | Add mandatory reviewer gate after stories | skill-author   | 15 min   |
| 004 | Add checkPhaseRequirements to state-mgmt  | skill-author   | 20 min   |
| 005 | Add validateAgentName to story creation   | skill-author   | 15 min   |
| 006 | Update /build command with gate calls     | command-author | 20 min   |
| 007 | Update /architect command with gate calls | command-author | 15 min   |
| 008 | Enforce AskUserQuestion for HITL gates    | skill-author   | 15 min   |

**Total: 8 stories, ~2 hours work**

---

## 7. Success Criteria

- [ ] PRD creation triggers mandatory reviewer validation
- [ ] Execution plan triggers mandatory reviewer validation
- [ ] Story creation triggers mandatory reviewer validation
- [ ] Validation FAIL blocks phase progression
- [ ] Invalid agent name "backend-dev" causes immediate error
- [ ] HITL gates require AskUserQuestion tool call

### Verification

Run `/build` on a test feature. Verify:

1. Reviewer called after PRD (check agent spawn)
2. Reviewer called after plan (check agent spawn)
3. Reviewer called after stories (check agent spawn)
4. Manually create story with "backend-dev" agent, verify rejection

---

## 8. Risks

| Risk                              | Mitigation                                      |
| --------------------------------- | ----------------------------------------------- |
| Validation adds workflow friction | Gates are lightweight (reviewer already exists) |
| Agent name registry gets stale    | Parse agent-selection skill dynamically         |
| Agents find new bypass methods    | Gates block progression, not warn               |

---

## 9. Dependencies

- `document-validation` skill (add blocking PASS/FAIL return)
- `state-management` skill (add checkPhaseRequirements)
- `user-story-creation` skill (add validateAgentName)
- `agent-selection` skill (source of valid agent names)
- `/build`, `/architect` commands (add gate calls)

---

## 10. Design Decisions

| Decision                | Choice                 | Rationale                                       |
| ----------------------- | ---------------------- | ----------------------------------------------- |
| Validation approach     | Reviewer agent gates   | Reviewer exists, just needs mandatory calling   |
| Schema validation       | Not needed             | Templates in skills are sufficient              |
| Audit logging           | Not needed             | Pass/fail is enough, postmortems capture issues |
| State machine           | Simple artifact checks | Phase order is linear, complex FSM overkill     |
| Agent validation timing | Story creation         | Earliest point agent is assigned                |

---

**Document Owner:** enterprise-architect-agent
**Simplified from v2.0 (25 stories) to v3.0 (8 stories)**
