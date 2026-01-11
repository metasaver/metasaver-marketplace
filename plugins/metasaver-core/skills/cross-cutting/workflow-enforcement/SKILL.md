---
name: workflow-enforcement
description: Validate workflow completion requirements before marking work done. Use when completing stories, closing epics, or claiming work is finished. Checks story file updates, acceptance criteria completion, and HITL approval. Triggers before any completion claim.
---

# Workflow Enforcement

**Purpose:** Validate that all completion requirements are met before allowing completion claims.

**Use when:**

- Completing a user story
- Marking work as done
- Archiving an epic
- Claiming implementation is finished
- Running pre-completion validation

---

## Validation Checks

Run these checks in order. All checks MUST pass before completion proceeds.

### 1. Story File Updates

Verify story files reflect completed work:

| Check                       | Pattern                             | Tool |
| --------------------------- | ----------------------------------- | ---- |
| Status field updated        | `status: complete`                  | Grep |
| At least one story complete | `status.*complete` in user-stories/ | Grep |

**Validation command:**

```bash
# Find completed stories in epic
grep -r 'status.*complete' docs/epics/in-progress/*/user-stories/

# Verify specific story status
grep 'status:' docs/epics/in-progress/[epic]/user-stories/[story].md
```

### 2. Acceptance Criteria

Verify all acceptance criteria checkboxes are marked complete:

| Check            | Pattern         | Requirement  |
| ---------------- | --------------- | ------------ |
| Completed items  | `[x]` or `[X]`  | Count these  |
| Incomplete items | `[ ]`           | Must be zero |
| Completion rate  | checked / total | Must be 100% |

**Validation command:**

```bash
# Count completed checkboxes
grep -c '\[x\]' [story-file].md

# Count incomplete checkboxes
grep -c '\[ \]' [story-file].md

# Both counts - completion requires second count = 0
```

### 3. HITL Approval

Verify user approval was obtained for completion:

| Check               | Evidence                     | Source               |
| ------------------- | ---------------------------- | -------------------- |
| Approval requested  | AskUserQuestion tool invoked | Conversation history |
| Approval received   | User responded affirmatively | Conversation history |
| Approval documented | Noted in story file          | Story file updates   |

**Verification approach:**

1. Review conversation history for HITL approval request
2. Confirm user response indicates approval
3. Document approval in story file or completion report

---

## Output Format

```
WORKFLOW ENFORCEMENT CHECK
==========================
Story Files Updated: PASS/FAIL
  - Stories complete: X of Y
  - Files updated: [list]

Acceptance Criteria: PASS/FAIL
  - Checked: X of Y checkboxes
  - Remaining: [list of unchecked items]

HITL Approval: PASS/FAIL
  - User approval obtained: Yes/No
  - Approval method: [AskUserQuestion/explicit confirmation]

--------------------------
Overall: PASS/FAIL
```

---

## Integration Points

This skill is invoked by:

| Workflow          | Phase                | Purpose                  |
| ----------------- | -------------------- | ------------------------ |
| `/build`          | Phase 7 (Validation) | Before completion report |
| `/ms`             | Phase 5 (Self-Audit) | Before confirm phase     |
| Manual completion | Any                  | Before claiming done     |

---

## Workflow

### 1. Identify Target Story/Epic

Determine which story or epic is being completed:

```bash
# Find current epic
ls docs/epics/in-progress/

# List stories in epic
ls docs/epics/in-progress/[epic]/user-stories/
```

### 2. Run Story File Check

Verify story status field is updated:

```bash
# Check story status
grep -E '^status:' docs/epics/in-progress/[epic]/user-stories/[story].md
```

Expected: `status: complete`

### 3. Run Acceptance Criteria Check

Count checkbox completion:

```bash
# Get completion stats
CHECKED=$(grep -c '\[x\]' [story-file].md)
UNCHECKED=$(grep -c '\[ \]' [story-file].md)
TOTAL=$((CHECKED + UNCHECKED))
echo "Completion: $CHECKED of $TOTAL"
```

Expected: UNCHECKED = 0

### 4. Verify HITL Approval

Confirm user approved completion:

1. Check conversation history for AskUserQuestion call
2. Verify user response was affirmative
3. Log approval status

### 5. Generate Report

Output enforcement check results using format above.

---

## Enforcement Rules

| Rule            | Requirement                                             |
| --------------- | ------------------------------------------------------- |
| Invocation      | MUST invoke before any completion claim                 |
| All checks pass | MUST show PASS for all three checks                     |
| On failure      | Return to execution phase to resolve issues             |
| User override   | Explicit "skip enforcement" allowed (logged as warning) |

---

## Examples

### Example 1: All Checks Pass

**Input:** Story SPW-001 being marked complete

**Output:**

```
WORKFLOW ENFORCEMENT CHECK
==========================
Story Files Updated: PASS
  - Stories complete: 1 of 1
  - Files updated: SPW-001-session-context-skill.md

Acceptance Criteria: PASS
  - Checked: 5 of 5 checkboxes
  - Remaining: none

HITL Approval: PASS
  - User approval obtained: Yes
  - Approval method: AskUserQuestion

--------------------------
Overall: PASS
```

### Example 2: Incomplete Acceptance Criteria

**Input:** Story with unchecked acceptance criteria

**Output:**

```
WORKFLOW ENFORCEMENT CHECK
==========================
Story Files Updated: PASS
  - Stories complete: 1 of 1
  - Files updated: SPW-002-workflow-agent.md

Acceptance Criteria: FAIL
  - Checked: 3 of 5 checkboxes
  - Remaining:
    - [ ] Integration tests pass
    - [ ] Documentation updated

HITL Approval: PASS
  - User approval obtained: Yes
  - Approval method: explicit confirmation

--------------------------
Overall: FAIL

ACTION REQUIRED: Complete remaining acceptance criteria before marking done.
```

### Example 3: Missing HITL Approval

**Input:** Work claimed complete without user approval

**Output:**

```
WORKFLOW ENFORCEMENT CHECK
==========================
Story Files Updated: PASS
  - Stories complete: 1 of 1
  - Files updated: SPW-003-enforcement-skill.md

Acceptance Criteria: PASS
  - Checked: 4 of 4 checkboxes
  - Remaining: none

HITL Approval: FAIL
  - User approval obtained: No
  - Approval method: none found

--------------------------
Overall: FAIL

ACTION REQUIRED: Obtain user approval via AskUserQuestion before claiming completion.
```

---

## Tool Usage

| Step | Tool          | Purpose                  |
| ---- | ------------- | ------------------------ |
| 1    | Glob          | Find story files in epic |
| 2    | Grep          | Check status fields      |
| 3    | Grep          | Count checkboxes         |
| 4    | Read          | Review story content     |
| 5    | Direct output | Generate report          |

---

## Related Skills

- `/skill cross-cutting/scope-check` - Verify scope boundaries
- `/skill workflow-steps/epic-postmortem` - Epic completion documentation
- `/skill domain/spw-session-context` - Session state tracking
