---
name: build
description: Build features with TDD workflow using sequential-thinking and full agent chain
---

# Build Command

Execute builds through sequential-thinking planning and complete agent chain workflow.

**Use when:** You know what you want to build. For exploration/planning, use `/architect` instead.

**IMPORTANT:** ALWAYS get user approval before git operations.

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

Full agent chain for PRD and story creation:

```
Enterprise Architect (EA) → creates PRD
    → Reviewer → validates PRD (document-validation)
    → HITL → user approves PRD
    → Business Analyst (BA) → extracts epics and story outlines
```

**Skills used internally:**

- `/skill prd-creation` (EA creates PRD)
- `/skill document-validation` (Reviewer validates)
- `/skill hitl-approval` (user approves)

**Output:** Approved PRD + Epics + Story outlines

---

## Phase 4: Design

**Follow:** `/skill design-phase`

Full agent chain for execution planning and story completion:

```
Architect → annotates PRD with implementation details
    → BA → creates story outlines
    → PM → creates execution plan (execution-plan-creation)
    → Reviewer → validates execution plan (document-validation)
    → HITL → user approves execution plan
    → BA → fills story details (user-story-creation)
    → Architect → adds Architecture sections
    → Reviewer → validates stories (document-validation)
    → HITL → user approves stories
```

**Skills used internally:**

- `/skill execution-plan-creation` (PM creates plan)
- `/skill user-story-creation` (BA fills stories)
- `/skill document-validation` (Reviewer validates)
- `/skill hitl-approval` (user approves)

**Output:** Execution plan + Complete user stories

---

## Phase 5: Execution

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
4. **HITL checkpoint** - Brief wave summary to user
5. Proceed to Wave N+1

---

## Phase 6: Validation

**Follow:** `/skill validation-phase`

1. Verify all acceptance criteria marked complete
2. Run build/lint/test (pnpm build, pnpm lint, pnpm test)
3. Run code quality checks scaled by change size

**On failure:** Return to Execution for fixes.

---

## Phase 7: Standards Audit

**Follow:** `/skill structure-check`, `/skill dry-check`, `/skill config-audit`

**Three checks (PARALLEL):**

1. **Structure Check**: Validate files in correct locations per domain
2. **DRY Check**: Scan new code against shared libraries
3. **Config Audit**: Spawn config agents in audit mode for modified files

**On failure:** Return to Execution for fixes, re-run Validation, re-run Standards Audit, loop until pass.

---

## Phase 8: Final Workflow Postmortem

**Follow:** `/skill workflow-postmortem mode=summary`

Run `/skill workflow-postmortem mode=summary` to generate final summary. This reads the accumulated wave logs from `docs/epics/{project}/post-mortem.md` and presents a summary to the user.

**Output:** Summary of issues logged across waves (count by category, patterns identified).

---

## Phase 9: Report

**Follow:** `/skill report-phase`

BA + PM produce final build report with:

- Summary of changes
- Files modified
- Tests added
- Standards audit results
- Workflow postmortem
- Next steps

---

## Examples

```bash
/build "add logging to service"
→ sequential-thinking → Analysis → Requirements (EA→Reviewer→HITL→BA) → Design (Architect→PM→Reviewer→HITL→BA→Reviewer→HITL) → Execution → Validation → Standards Audit → Postmortem → Report

/build "refactor auth module"
→ sequential-thinking → Analysis → Requirements → Design → Execution (waves) → Validation → Standards Audit → Postmortem → Report

/build "multi-tenant SaaS"
→ sequential-thinking → Analysis → Requirements → Design → Wave1 → Log → Compact → HITL → Wave2 → ... → Validation → Standards Audit → Summary → Report

# Wave checkpoint flow:
Wave1: Task(spawn tester) → Task(spawn coder) → /skill workflow-postmortem mode=log → /compact → HITL checkpoint
Wave2: Task(spawn tester) → Task(spawn coder) → /skill workflow-postmortem mode=log → /compact → HITL checkpoint
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
3. ALWAYS run full workflow: Planning → Analysis → Requirements → Design → Execution → Validation → Standards Audit → Postmortem → Report
4. Requirements phase uses full agent chain: EA → Reviewer → HITL → BA
5. Design phase uses full agent chain: Architect → PM → Reviewer → HITL → BA → Architect → Reviewer → HITL
6. TDD execution: ALWAYS run tester BEFORE coder per story.
7. ALWAYS use Task tool to spawn tester agent first, then coder agent for implementation work.
8. ALWAYS spawn agents for implementation - the orchestrator tracks progress while agents write code.
9. Standards Audit: ALWAYS run AFTER Validation passes.
10. ALWAYS run build/lint/test after execution.
11. **WAVE CHECKPOINT TIMING:** ALWAYS run `/skill workflow-postmortem mode=log` BEFORE compact at each wave checkpoint.
12. **POSTMORTEM LOG ACCUMULATION:** Each wave log appends to `docs/epics/{project}/post-mortem.md`.
13. ALWAYS run `/skill workflow-postmortem mode=summary` AFTER Standards Audit, BEFORE Report.
14. ALWAYS produce final report with workflow postmortem section.
15. When files modified, spawn agent: `subagent_type="general-purpose"` with prompt "Execute /skill repomix-cache-refresh"
16. Use AskUserQuestion tool for all user questions. Present structured options with clear descriptions.
17. Use `/architect` command for innovation or vibe check workflows.
