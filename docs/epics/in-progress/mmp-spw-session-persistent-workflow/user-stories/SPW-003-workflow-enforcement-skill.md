# SPW-003: Workflow Enforcement Skill

## Story Info

| Field      | Value                                   |
| ---------- | --------------------------------------- |
| Story ID   | SPW-003                                 |
| Epic       | MMP-SPW                                 |
| Priority   | P2 (Medium)                             |
| Status     | complete                                |
| Complexity | Medium                                  |
| Agent      | core-claude-plugin:generic:skill-author |

---

## User Story

**As a** MetaSaver developer
**I want** a workflow enforcement skill that validates completion requirements
**So that** Claude cannot claim work is complete without meeting all criteria

---

## Acceptance Criteria

- [ ] Skill exists at `plugins/metasaver-core/skills/cross-cutting/workflow-enforcement.md`
- [ ] Skill checks: story files updated (status changed from pending)
- [ ] Skill checks: acceptance criteria checkboxes marked
- [ ] Skill checks: HITL was performed (user approval obtained)
- [ ] Skill returns PASS/FAIL with specific missing items
- [ ] Skill integrates with /build and /ms completion phases

---

## Definition of Done

- [ ] Skill file created
- [ ] Skill registered in marketplace skills array
- [ ] /build command updated to use skill before completion claims
- [ ] /ms command updated to use skill before completion claims
- [ ] Tested with mock story files

---

## Technical Notes

### Validation Checks

1. **Story Status**: Verify story file has `status: "complete"` (not pending)
2. **Acceptance Criteria**: Count `[x]` vs `[ ]` checkboxes - require all checked
3. **Definition of Done**: Similar checkbox validation
4. **HITL Record**: Verify user approval was obtained (may need to track in workflow state)

### Skill Output Format

```
WORKFLOW ENFORCEMENT CHECK
--------------------------
Story Files Updated: PASS/FAIL (X of Y stories updated)
Acceptance Criteria: PASS/FAIL (X of Y checked)
Definition of Done:  PASS/FAIL (X of Y checked)
HITL Approval:       PASS/FAIL

Overall: PASS/FAIL
```

### Integration Points

- `/build` Phase 6 (Execution) - validate before each wave completion
- `/build` Phase 7 (Validation) - final check before completion claim
- `/ms` Phase 5 (Self-Audit) - validate before confirm phase

---

## Dependencies

- SPW-001 (CLAUDE.md Constitution) provides the rules to enforce
