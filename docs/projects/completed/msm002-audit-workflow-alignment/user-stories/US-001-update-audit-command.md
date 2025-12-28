# US-001: Update audit.md Command File

**Status:** 🔵 Pending
**Priority:** Critical
**Estimated Effort:** High
**File:** `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/commands/audit.md`

---

## Story

As a command orchestrator, I need the audit.md command file to reflect the simplified two-phase workflow (Investigation + Remediation) so that audits follow the new HITL per-discrepancy resolution pattern defined in the target state.

---

## Acceptance Criteria

### Removals

- [ ] Remove complexity-check-agent spawning from Phase 1
- [ ] Remove tool-check-agent spawning from Phase 1
- [ ] Remove Phase 1.5: Cross-Repo Resolution section (lines 36-56)
- [ ] Remove Phase 3: Vibe Check section (lines 83-87)
- [ ] Remove complexity-based routing in Human Validation (lines 96-98)
- [ ] Remove all references to `scope.targets` and `scope.references`

### Additions

- [ ] Add agent-check-agent to Phase 1 (spawn only scope-check and agent-check in parallel)
- [ ] Add Phase 4: Investigation (read-only agent spawning, discrepancy collection)
- [ ] Add Phase 5: Report & Resolution (HITL per-discrepancy with 4 options)
- [ ] Add Phase 6: Remediation (apply approved fixes with validation loop)
- [ ] Add mermaid diagrams for new phases
- [ ] Update model selection table (remove complexity routing)

### Updates

- [ ] Update Phase 1 to spawn only 2 agents in parallel
- [ ] Update Phase 2: Requirements - document user story creation (1 per agent/file combo)
- [ ] Rename Phase 4 from "Execution" to "Investigation"
- [ ] Update Phase 7: Validation - simplify to build/lint/test only (no config agents)
- [ ] Update Phase 8: Report - reflect new phases and BA consolidation
- [ ] Update Enforcement rules (14 rules reflecting new phase structure)
- [ ] Update Examples section with new workflow examples
- [ ] Update Common Failure Modes table

### Validation

- [ ] No references to complexity or tools checks remain
- [ ] No references to targets/references format remain
- [ ] All phases numbered correctly (1-8)
- [ ] Examples demonstrate new HITL workflow
- [ ] Integration notes reference correct agent outputs

---

## Dependencies

- **Depends on:** US-002 (scope-check updates), US-003 (scope-check-agent updates), US-005 (agent-check skill), US-006 (agent-check-agent)
- **Blocks:** None (final integration story)

---

## Technical Notes

### Key Sections to Update

**Phase 1 - Current:**

```markdown
Spawn 3 agents in PARALLEL (single message with 3 Task tool calls):

- Task 1: complexity-check-agent
- Task 2: tool-check-agent
- Task 3: scope-check-agent
```

**Phase 1 - Target:**

```markdown
Spawn 2 agents in PARALLEL (single message with 2 Task tool calls):

- Task 1: scope-check-agent → returns { repos[], files[] }
- Task 2: agent-check-agent → returns { agents: [] }
```

**New Phase 5 Structure:**

- Present consolidated findings (X files, Y discrepancies, Z critical/warnings)
- Loop through each discrepancy
- Show: file path, diff, template expectation, actual value
- AskUserQuestion with 4 options:
  1. Apply template to this file
  2. Update template with this change
  3. Ignore this discrepancy
  4. Custom (enter text)
- Record decision in user story

**New Phase 6 Structure:**

- Filter stories for "apply" decisions
- Spawn agents to apply fixes (batched by agent type)
- Run production check: build, lint, test
- If fails: report errors, agents fix, retry
- If passes: proceed to report

### Model Selection Removed

Model selection removed - use default model for all agents.

---

## Definition of Done

- [ ] All removals completed (no orphaned sections)
- [ ] All additions completed with proper documentation
- [ ] All updates completed with consistent formatting
- [ ] Examples reflect new workflow end-to-end
- [ ] Enforcement rules comprehensive (14 rules)
- [ ] Mermaid diagrams added for new phases
- [ ] No broken references to removed features
- [ ] File validates as proper markdown
