# Execution Plan: Positive Reinforcement & Hook Enforcement

## Summary

- Total Stories: 24
- Total Tasks: 45 (after US-007, US-008 breakdown)
- Total Waves: 8
- Estimated Duration: 8 waves × ~5-10 min per wave = 40-80 minutes

## Dependency Analysis

### Independent Foundations (Wave 1)

- US-001 (positive-framing-patterns) - foundation for all EPIC-001
- US-006 (file-audit-checklist) - foundation for US-007, US-008
- US-009 (hook-activation-logic) - foundation for US-010
- US-012 (hook-message-templates) - foundation for US-010
- US-015 (workflow-state-schema) - foundation for US-016
- US-024 (migration-guide) - can draft early

### Sequential Dependencies

- US-001 → US-002, US-003, US-004, US-005 (author updates need pattern library)
- US-006 → US-007 → US-008 (checklist → high-priority → medium-priority)
- US-009 + US-012 → US-010 → US-011, US-013, US-014 (hook chain)
- US-015 → US-016 → US-017, US-023 (state management chain)
- US-016, US-017 → US-018, US-019 (resume/analyze phases)
- US-019 → US-020 (routing needs analysis)
- US-016, US-023 → US-021 (execution tracking)
- US-021 → US-022 (validation needs execution)

## Wave Execution

### Wave 1: Foundational Components

| Task  | Story  | Description                            | Agent        | Status     |
| ----- | ------ | -------------------------------------- | ------------ | ---------- |
| T-001 | US-001 | Create positive-framing-patterns skill | skill-author | 🔵 Pending |
| T-002 | US-006 | Create file audit checklist            | coder        | 🔵 Pending |
| T-003 | US-009 | Design hook activation logic spec      | coder        | 🔵 Pending |
| T-004 | US-012 | Create hook message templates          | coder        | 🔵 Pending |
| T-005 | US-015 | Define workflow-state.json schema      | coder        | 🔵 Pending |
| T-006 | US-024 | Create migration guide documentation   | coder        | 🔵 Pending |

**Dependencies:** None (all independent)
**Estimated Duration:** 10-15 minutes

---

### Wave 2: Author Updates + State Management

| Task  | Story  | Description                                 | Agent          | Status     |
| ----- | ------ | ------------------------------------------- | -------------- | ---------- |
| T-007 | US-002 | Update agent-author with positive framing   | agent-author   | 🔵 Pending |
| T-008 | US-003 | Update skill-author with positive framing   | skill-author   | 🔵 Pending |
| T-009 | US-004 | Update command-author with positive framing | command-author | 🔵 Pending |
| T-010 | US-005 | Update CLAUDE.md /ms routing section        | coder          | 🔵 Pending |
| T-011 | US-016 | Create PM state management skill            | skill-author   | 🔵 Pending |

**Dependencies:**

- T-007, T-008, T-009, T-010 depend on T-001 (US-001)
- T-011 depends on T-005 (US-015)

**Estimated Duration:** 10-15 minutes

---

### Wave 3: Hook Implementation + /ms Phase Updates (Part 1)

| Task  | Story  | Description                                 | Agent          | Status     |
| ----- | ------ | ------------------------------------------- | -------------- | ---------- |
| T-012 | US-010 | Implement UserPromptSubmit hook handler     | coder          | 🔵 Pending |
| T-013 | US-017 | Implement /ms Phase 1 (Entry + State Check) | command-author | 🔵 Pending |
| T-014 | US-023 | Update execution-phase for state tracking   | skill-author   | 🔵 Pending |

**Dependencies:**

- T-012 depends on T-003, T-004 (US-009, US-012)
- T-013 depends on T-011 (US-016)
- T-014 depends on T-011 (US-016)

**Estimated Duration:** 15-20 minutes

---

### Wave 4: Hook Registration + /ms Phase Updates (Part 2)

| Task  | Story  | Description                                    | Agent          | Status     |
| ----- | ------ | ---------------------------------------------- | -------------- | ---------- |
| T-015 | US-011 | Register hook in plugin.json                   | coder          | 🔵 Pending |
| T-016 | US-013 | Add hook testing scenarios                     | coder          | 🔵 Pending |
| T-017 | US-014 | Document hook behavior                         | coder          | 🔵 Pending |
| T-018 | US-018 | Implement /ms Phase 2a (Resume Workflow)       | command-author | 🔵 Pending |
| T-019 | US-019 | Implement /ms Phase 2b (New Workflow Analysis) | command-author | 🔵 Pending |

**Dependencies:**

- T-015, T-016, T-017 depend on T-012 (US-010)
- T-018 depends on T-011, T-013 (US-016, US-017)
- T-019 depends on T-013 (US-017)

**Estimated Duration:** 15-20 minutes

---

### Wave 5: /ms Phase Completion + File Review (High-Priority Commands - Part 1)

| Task  | Story     | Description                              | Agent          | Status     |
| ----- | --------- | ---------------------------------------- | -------------- | ---------- |
| T-020 | US-020    | Implement /ms Phase 3 (Route to Command) | command-author | 🔵 Pending |
| T-021 | US-007-01 | Review /ms command                       | command-author | 🔵 Pending |
| T-022 | US-007-02 | Review /build command                    | command-author | 🔵 Pending |
| T-023 | US-007-03 | Review /audit command                    | command-author | 🔵 Pending |
| T-024 | US-007-04 | Review /debug command                    | command-author | 🔵 Pending |
| T-025 | US-007-05 | Review /architect command                | command-author | 🔵 Pending |
| T-026 | US-007-06 | Review /qq command                       | command-author | 🔵 Pending |

**Dependencies:**

- T-020 depends on T-019 (US-019)
- T-021-T-026 depend on T-001, T-002 (US-001, US-006)

**Estimated Duration:** 10-15 minutes

---

### Wave 6: /ms Phase 4-5 + File Review (High-Priority Agents)

| Task  | Story     | Description                                | Agent          | Status     |
| ----- | --------- | ------------------------------------------ | -------------- | ---------- |
| T-027 | US-021    | Implement /ms Phase 4 (Execution Tracking) | command-author | 🔵 Pending |
| T-028 | US-007-07 | Review agent-author agent                  | agent-author   | 🔵 Pending |
| T-029 | US-007-08 | Review skill-author agent                  | agent-author   | 🔵 Pending |
| T-030 | US-007-09 | Review command-author agent                | agent-author   | 🔵 Pending |
| T-031 | US-007-10 | Review architect agent                     | agent-author   | 🔵 Pending |
| T-032 | US-007-11 | Review coder agent                         | agent-author   | 🔵 Pending |
| T-033 | US-007-12 | Review tester agent                        | agent-author   | 🔵 Pending |
| T-034 | US-007-13 | Review reviewer agent                      | agent-author   | 🔵 Pending |

**Dependencies:**

- T-027 depends on T-011, T-014 (US-016, US-023)
- T-028-T-034 depend on T-001, T-002 (US-001, US-006)

**Estimated Duration:** 10-15 minutes

---

### Wave 7: /ms Phase 5 Complete + File Review (Medium-Priority Skills - Part 1)

| Task  | Story     | Description                        | Agent          | Status     |
| ----- | --------- | ---------------------------------- | -------------- | ---------- |
| T-035 | US-022    | Implement /ms Phase 5 (Validation) | command-author | 🔵 Pending |
| T-036 | US-008-01 | Review execution-phase skill       | skill-author   | 🔵 Pending |
| T-037 | US-008-02 | Review planning-phase skill        | skill-author   | 🔵 Pending |
| T-038 | US-008-03 | Review complexity-check skill      | skill-author   | 🔵 Pending |
| T-039 | US-008-04 | Review scope-check skill           | skill-author   | 🔵 Pending |
| T-040 | US-008-05 | Review tool-check skill            | skill-author   | 🔵 Pending |
| T-041 | US-008-06 | Review production-check skill      | skill-author   | 🔵 Pending |
| T-042 | US-008-07 | Review repomix-cache-refresh skill | skill-author   | 🔵 Pending |

**Dependencies:**

- T-035 depends on T-027 (US-021)
- T-036-T-042 depend on T-001, T-002, T-021-T-027 (US-001, US-006, US-007)

**Estimated Duration:** 10-15 minutes

---

### Wave 8: File Review (Medium-Priority Config Agents + Remaining Skills)

| Task  | Story     | Description           | Agent        | Status     |
| ----- | --------- | --------------------- | ------------ | ---------- |
| T-043 | US-008-08 | Review eslint-agent   | agent-author | 🔵 Pending |
| T-044 | US-008-09 | Review vite-agent     | agent-author | 🔵 Pending |
| T-045 | US-008-10 | Review prettier-agent | agent-author | 🔵 Pending |

**Dependencies:**

- T-043-T-045 depend on T-001, T-002, T-036-T-042 (US-001, US-006, US-008 part 1)

**Estimated Duration:** 5-10 minutes

---

## Critical Path

The critical path for core functionality:

1. US-001 (positive-framing-patterns) → US-002, US-003, US-004, US-005 (author updates)
2. US-015 (workflow-state-schema) → US-016 (state-management) → US-017, US-023 (Phase 1 + execution-phase)
3. US-017 → US-018, US-019 (Phase 2a/2b) → US-020 (Phase 3) → US-021 (Phase 4) → US-022 (Phase 5)
4. US-009, US-012 → US-010 (hook implementation) → US-011, US-013, US-014 (hook registration + docs)

## US-007 Breakdown (High-Priority Files)

Based on file-audit-checklist.md (to be created in Wave 1), US-007 breaks down into:

**Commands (6 files):**

- T-021: /ms command
- T-022: /build command
- T-023: /audit command
- T-024: /debug command
- T-025: /architect command
- T-026: /qq command

**Core Agents (7 files):**

- T-028: agent-author
- T-029: skill-author
- T-030: command-author
- T-031: architect
- T-032: coder
- T-033: tester
- T-034: reviewer

**Total:** 13 high-priority tasks

## US-008 Breakdown (Medium-Priority Files)

**Workflow Skills (7 files):**

- T-036: execution-phase
- T-037: planning-phase
- T-038: complexity-check
- T-039: scope-check
- T-040: tool-check
- T-041: production-check
- T-042: repomix-cache-refresh

**Config Agents (3 files):**

- T-043: eslint-agent
- T-044: vite-agent
- T-045: prettier-agent

**Total:** 10 medium-priority tasks

## Parallelization Strategy

- **Wave 1:** 6 tasks in parallel (all independent foundations)
- **Wave 2:** 5 tasks in parallel (author updates + state management)
- **Wave 3:** 3 tasks in parallel (hook + /ms phases)
- **Wave 4:** 5 tasks in parallel (hook finalization + /ms Phase 2)
- **Wave 5:** 7 tasks in parallel (Phase 3 + high-priority commands)
- **Wave 6:** 8 tasks in parallel (Phase 4 + high-priority agents)
- **Wave 7:** 8 tasks in parallel (Phase 5 + medium-priority skills)
- **Wave 8:** 3 tasks in parallel (medium-priority config agents)

**Max Wave Size:** 8 tasks (Wave 6, 7) - within 10 agent limit

## Notes

1. **US-007 and US-008 breakdown:** Large stories broken down by file type to enable parallel review within agent specialization.
2. **Agent selection:** Matched to file type for self-referential updates (e.g., agent-author reviews agents).
3. **Dependencies respected:** Sequential waves for dependent work, parallel within waves.
4. **Critical path optimized:** Workflow state tracking (EPIC-003) and positive reinforcement (EPIC-001) can progress in parallel.
5. **Hook enforcement:** EPIC-002 completes by Wave 4, enabling hook behavior before file reviews.
6. **File review staged:** High-priority (commands, core agents) before medium-priority (skills, config agents).

## Risk Mitigation

- **Large waves:** Waves 6-7 have 8 tasks each. If agent spawn limit issues occur, split into 2 sub-waves of 4 tasks each.
- **Self-referential updates:** Agent-author updating agent-author (T-028) may require careful review to avoid breaking changes.
- **State file conflicts:** Execution-phase update (T-014) must coordinate with /ms Phase 4 (T-027) to avoid duplicate state writes.
- **File review quality:** Automated review tasks (T-021-T-045) should be spot-checked for correct positive framing transformations.

## Success Metrics

- All 24 stories completed
- All 45 tasks executed
- workflow-state.json schema implemented and tested
- UserPromptSubmit hook registered and functional
- /ms command matches target state 5-phase workflow
- File review complete for high-priority (13 files) and medium-priority (10 files) content

## Next Steps

After execution plan approval:

1. Spawn Wave 1 agents (6 tasks in parallel)
2. Collect Wave 1 results
3. Spawn Wave 2 agents (5 tasks in parallel)
4. Continue through Wave 8
5. Consolidate results and validate completion
