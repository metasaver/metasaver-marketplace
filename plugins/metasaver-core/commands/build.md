---
name: build
description: Build features with TDD workflow using sequential-thinking and full agent chain
---

# Build Command

Execute builds through sequential-thinking planning and complete agent chain workflow.

**Use when:** You know what you want to build. For exploration/planning, use `/architect` instead.

---

## Entry Handling

When /build is invoked, ALWAYS proceed to Phase 1 regardless of prompt content.

---

## Phase 1: Planning (Sequential Thinking)

**Use:** sequential-thinking MCP tool

Plan the approach using sequential-thinking MCP tool:

1. Analyze the prompt to understand scope and requirements
2. Identify target repositories and reference patterns
3. Outline high-level implementation strategy
4. Note potential risks and dependencies

This creates the mental model for the full workflow.

---

## Phase 2: Analysis

**Follow:** `/skill analysis-phase`

Spawn scope-check agent to identify target and reference repositories. Use scope-check agent results directly. Proceed with identified targets immediately.

**Output:** `scope: { targets[], references[] }`

---

## Phase 3: Requirements

**Follow:** `/skill requirements-phase`

EA uses AskUserQuestion until 100% understanding, then creates PRD:

```
Enterprise Architect (EA) → AskUserQuestion loop until fully understood
    → Creates PRD (prd-creation skill)
    → Reviewer → validates PRD (document-validation)
    → (fix if needed, loop back to EA)
    → Business Analyst (BA) → extracts epics and story outlines
```

**Skills used internally:**

- `/skill prd-creation` (EA creates PRD)
- `/skill document-validation` (Reviewer validates)

**Output:** PRD + Epics + Story outlines (NO HITL - continues to Design)

---

## Phase 4: Design

**Follow:** `/skill design-phase`

Agents use AskUserQuestion for any clarifications, then create all docs:

```
Architect → annotates PRD with implementation details
    → BA → creates story outlines
    → PM → creates execution plan (execution-plan-creation)
    → Reviewer → validates execution plan (document-validation)
    → (fix if needed, loop back to PM)
    → BA → fills story details (user-story-creation)
    → Architect → adds Architecture sections
    → Reviewer → validates stories (document-validation)
    → (fix if needed, loop back to BA)
```

**Skills used internally:**

- `/skill execution-plan-creation` (PM creates plan)
- `/skill user-story-creation` (BA fills stories)
- `/skill document-validation` (Reviewer validates)

**Output:** Execution plan + Complete user stories (NO HITL - continues to Approval)

---

## Phase 5: HITL Approval

**Follow:** `/skill hitl-approval`

**SINGLE approval gate** for all documentation:

Present to user:

1. PRD summary (from Phase 3)
2. Execution plan summary (waves, dependencies)
3. User stories summary (count, complexity)

Use AskUserQuestion:

- **APPROVE** → Continue to Execution
- **REJECT** → Collect feedback, return to appropriate phase (Requirements or Design)

---

## Phase 6: Execution

**Follow:** `/skill execution-phase`

TDD-paired wave-based execution:

1. Load execution plan (waves with dependencies)
2. For each wave:
   - Update workflow state
   - Run `/compact` to free context
   - Spawn tester agent (writes tests from AC)
   - Spawn implementation agent (passes tests)
   - Production verification (tests pass, AC marked)
3. Waves execute continuously with state persistence

**Wave Checkpoint Flow:**

1. Wave N agents complete their stories
2. **Quick log** - `/skill workflow-postmortem mode=log` (30 seconds max)
3. **Compact context** - Run `/compact` to manage context window
4. Proceed to Wave N+1

---

## Phase 7: Validation

**Follow:** `/skill validation-phase`

1. Verify all acceptance criteria marked complete
2. Run build/lint/test (pnpm build, pnpm lint, pnpm test)
3. Run code quality checks scaled by change size

**On failure:** Return to Execution for fixes.

---

## Phase 8: Standards Audit

**Follow:** `/skill structure-check`, `/skill dry-check`

**Three checks (PARALLEL):**

1. **Structure Check**: Validate files in correct locations per domain
2. **DRY Check**: Scan new code against shared libraries
3. **Config Audit**: For modified config files, spawn appropriate config agents from `agents/config/` in audit mode

**On failure:** Return to Execution for fixes, re-run Validation, re-run Standards Audit, loop until pass.

---

## Phase 9: Final Workflow Postmortem

**Follow:** `/skill workflow-postmortem mode=summary`

Run `/skill workflow-postmortem mode=summary` to generate final summary. This reads the accumulated wave logs from `docs/epics/{project}/post-mortem.md` and presents a summary to the user.

**Output:** Summary of issues logged across waves (count by category, patterns identified).

---

## Phase 10: Report

**Follow:** `/skill report-phase`

BA + PM produce final build report with:

- Summary of changes
- Files modified
- Tests added
- Standards audit results
- Workflow postmortem
- Next steps

---

## Phase 11: Epic Archival

After user approves the final report, archive the epic:

1. Check if `docs/epics/{project}/` exists
2. If exists, move to `docs/epics/completed/{project}/`
3. Confirm archival to user

This preserves the complete epic documentation (PRD, stories, execution plan, post-mortem) for future reference.

---

## Examples

```bash
/build "add logging to service"
→ Planning → Analysis → Requirements (EA asks questions → PRD → Reviewer) → Design (Architect → BA → PM → Reviewer) → HITL (approve all docs) → Execution → Validation → Standards Audit → Postmortem → Report → Epic Archival

/build "refactor auth module"
→ Planning → Analysis → Requirements → Design → HITL → Execution (waves) → Validation → Standards Audit → Postmortem → Report → Epic Archival

/build "multi-tenant SaaS"
→ Planning → Analysis → Requirements → Design → HITL → Wave1 → Wave2 → ... → Validation → Standards Audit → Summary → Report → Epic Archival

# Wave checkpoint flow (no HITL between waves):
Wave1: Task(spawn tester) → Task(spawn coder) → /skill workflow-postmortem mode=log → /compact
Wave2: Task(spawn tester) → Task(spawn coder) → /skill workflow-postmortem mode=log → /compact
End: /skill workflow-postmortem mode=summary → Report

# Spawning agents with Task tool:
Task: subagent_type="core-claude-plugin:generic:tester" prompt="Execute /skill tdd-execution for story X"
→ (tester creates test file)
Task: subagent_type="core-claude-plugin:generic:coder" prompt="Implement against tests from story X"
→ (coder implements feature)
```

---

## Enforcement

1. Frame all instructions positively. State what to do.
2. ALWAYS run sequential-thinking MCP tool first to plan approach.
3. ALWAYS run full workflow: Planning → Analysis → Requirements → Design → HITL → Execution → Validation → Standards Audit → Postmortem → Report → Epic Archival
4. Requirements phase: EA uses AskUserQuestion until fully understood, then creates PRD → Reviewer validates → BA extracts stories (NO HITL)
5. Design phase: Architect → BA → PM → Reviewer validates all docs (NO HITL - continues to single HITL gate)
6. **SINGLE HITL GATE:** After all docs created (PRD, execution plan, stories), present summary and get approval
7. TDD execution: ALWAYS run tester BEFORE coder per story.
8. ALWAYS use Task tool to spawn tester agent first, then coder agent for implementation work.
9. ALWAYS spawn agents for implementation - the orchestrator tracks progress while agents write code.
10. Standards Audit: ALWAYS run AFTER Validation passes.
11. ALWAYS run build/lint/test after execution.
12. **WAVE CHECKPOINT TIMING:** ALWAYS run `/skill workflow-postmortem mode=log` BEFORE compact at each wave checkpoint.
13. **POSTMORTEM LOG ACCUMULATION:** Each wave log appends to `docs/epics/{project}/post-mortem.md`.
14. ALWAYS run `/skill workflow-postmortem mode=summary` AFTER Standards Audit, BEFORE Report.
15. ALWAYS produce final report with workflow postmortem section.
16. When files modified, spawn agent: `subagent_type="general-purpose"` with prompt "Execute /skill repomix-cache-refresh"
17. Use AskUserQuestion tool for clarifications during Requirements and Design phases.
18. Use `/architect` command for innovation or vibe check workflows.
19. ALWAYS archive epic folder after user approves final report: move `docs/epics/{project}/` to `docs/epics/completed/{project}/` if folder exists.
20. Git operations are outside workflow scope. Changes remain uncommitted for user to handle.
