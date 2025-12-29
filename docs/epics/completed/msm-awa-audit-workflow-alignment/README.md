# Audit Workflow Alignment Project

**Created:** 2025-12-17
**Status:** Awaiting Approval

---

## Project Overview

This project aligns the `/audit` command implementation with the new simplified target state that eliminates complexity routing and introduces a two-phase workflow (Investigation + Remediation) with HITL per-discrepancy resolution.

**Key Documents:**

- **PRD:** `prd.md`
- **Target State:** `/home/jnightin/code/metasaver-marketplace/docs/audit-command-target-state.md`
- **User Stories:** `user-stories/US-001` through `US-006`

---

## Summary of Changes

### High-Level Transformation

| Aspect                | OLD                                     | NEW                                                    |
| --------------------- | --------------------------------------- | ------------------------------------------------------ |
| Analysis Phase        | 3 agents (complexity, tools, scope)     | 2 agents (scope-check, agent-check)                    |
| Scope Output          | `{ targets[], references[] }`           | `{ repos[], files[] }`                                 |
| Agent Selection       | Derived from complexity + manual lookup | Automatic mapping from files via agent-check           |
| Requirements          | PRD only                                | PRD + user stories (1 per agent/file)                  |
| Execution             | Single phase (audit + fix)              | Split: Investigation (read-only) + Remediation (apply) |
| User Interaction      | Approve before execution                | HITL per-discrepancy (4 options each)                  |
| Validation            | Full standards audit                    | Simplified (build/lint/test only)                      |
| Cross-Repo Resolution | Phase 1.5 with path questions           | Removed (hardcoded in scope-check)                     |
| Vibe Check            | After PRD                               | Removed                                                |

---

## Files Affected

### Updates Required (4 files)

1. **US-001:** `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/commands/audit.md`
   - Priority: Critical
   - Effort: High
   - Major restructuring of all phases

2. **US-002:** `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/cross-cutting/scope-check/SKILL.md`
   - Priority: Critical
   - Effort: High
   - Output format change + file detection logic

3. **US-003:** `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/generic/scope-check-agent.md`
   - Priority: Medium
   - Effort: Low
   - Documentation alignment only

4. **US-004:** `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/workflow-steps/requirements-phase/SKILL.md`
   - Priority: Critical
   - Effort: Medium
   - Add user story creation step

### New Files Required (2 files)

5. **US-005:** `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/cross-cutting/agent-check/SKILL.md`
   - Priority: Critical
   - Effort: High
   - NEW skill for file-to-agent mapping

6. **US-006:** `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/generic/agent-check-agent.md`
   - Priority: Critical
   - Effort: Low
   - NEW agent wrapper for agent-check skill

---

## Recommended Implementation Order

### Phase 1: Foundation (New Components)

1. **US-005** - Create agent-check skill (file-to-agent mapping logic)
2. **US-006** - Create agent-check-agent (skill wrapper)

### Phase 2: Analysis Updates (Scope Changes)

3. **US-002** - Update scope-check skill (output format + file detection)
4. **US-003** - Update scope-check-agent (documentation alignment)

### Phase 3: Requirements Enhancement

5. **US-004** - Update requirements-phase skill (add user story creation)

### Phase 4: Integration (Command Updates)

6. **US-001** - Update audit.md command (integrate everything)

---

## Key Success Criteria

- [ ] No complexity-check or tool-check in Analysis phase
- [ ] Scope-check returns `{ repos[], files[] }` format
- [ ] Agent-check correctly maps files to agents
- [ ] Requirements phase creates user stories (1 per agent/file combo)
- [ ] Investigation phase is read-only (no changes until approved)
- [ ] Phase 5 implements HITL with 4 options per discrepancy
- [ ] Remediation only applies approved fixes
- [ ] Validation runs build/lint/test only
- [ ] All removed features have no orphaned references
- [ ] All new phases properly documented with examples

---

## Dependencies Graph

```
US-005 (agent-check skill)
  └─> US-006 (agent-check-agent)

US-002 (scope-check skill)
  └─> US-003 (scope-check-agent)

US-004 (requirements-phase skill) [independent]

US-001 (audit.md command)
  ├─> DEPENDS ON: US-002, US-003 (scope output)
  ├─> DEPENDS ON: US-005, US-006 (agent-check)
  └─> SHOULD FOLLOW: US-004 (requirements phase)
```

---

## Breaking Changes

This is a **BREAKING CHANGE** to the `/audit` workflow:

- Output format of scope-check changes
- Phase structure completely redesigned
- No gradual migration possible
- All changes must be deployed together

---

## Testing Plan

### Unit Testing

- [ ] Test scope-check with various prompts (verify files[] output)
- [ ] Test agent-check with scope output (verify correct agent mapping)
- [ ] Test requirements-phase story creation (verify 1 story per agent/file)

### Integration Testing

- [ ] Test full /audit workflow end-to-end
- [ ] Verify Investigation phase is read-only
- [ ] Verify HITL resolution with all 4 options
- [ ] Verify Remediation only applies approved fixes

### Validation Testing

- [ ] Run "audit eslint" (single file)
- [ ] Run "audit monorepo root" (multiple files)
- [ ] Run "audit across all repos" (cross-repo)
- [ ] Verify no complexity or tools checks occur
- [ ] Verify validation runs build/lint/test only

---

## Open Questions for Review

1. **Agent-check scope:** Should we include domain agents (data-service-agent) or only config agents?
   - **Recommendation:** Config agents only for MVP

2. **Template updates:** How to handle "update template" decisions in HITL?
   - **Per target state:** Create branch in multi-mono, update skill templates, open PR
   - **Needs:** Implementation details for which agent handles this

3. **Phase skills:** Should Investigation and Remediation be separate skills?
   - **Recommendation:** Yes, for clarity and reusability

4. **Decision storage:** How to store user decisions during HITL loop?
   - **Recommendation:** Update user story markdown files with decision

---

## Next Steps

1. **Review PRD and user stories**
2. **Approve scope and approach**
3. **Begin implementation in recommended order**
4. **Test each story as completed**
5. **Deploy all changes together (breaking change)**

---

## Project Structure

```
docs/projects/20251217-audit-workflow-alignment/
├── README.md          # This file
├── prd.md             # Product Requirements Document
└── user-stories/
    ├── US-001-update-audit-command.md
    ├── US-002-update-scope-check-skill.md
    ├── US-003-update-scope-check-agent.md
    ├── US-004-update-requirements-phase-skill.md
    ├── US-005-create-agent-check-skill.md
    └── US-006-create-agent-check-agent.md
```
