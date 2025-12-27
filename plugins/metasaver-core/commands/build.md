---
name: build
description: Build features with TDD workflow and standards compliance
---

# Build Command

Execute known requirements through TDD workflow with standards compliance.

**Use when:** You know what you want to build. For exploration/planning, use `/architect` instead.

**IMPORTANT:** ALWAYS get user approval before git operations.

---

## Entry Handling

When /build is invoked, ALWAYS proceed to Phase 1 regardless of prompt content.

---

## Phase 1: Analysis (PARALLEL)

**See:** `/skill complexity-check`, `/skill scope-check`

Spawn 2 agents in parallel to execute complexity-check and scope-check skills. Use scope-check agent results directly. Proceed with identified targets immediately.

**Output:** `complexity_score`, `targets[]`, `references[]`

**Complexity Routing:**

- **< 15**: FAST PATH (skip Requirements, Design, Approval, Standards Audit → jump to Execution)
- **≥ 15**: FULL PATH (all phases)

---

## Phase 2: Requirements

**See:** `/skill requirements-phase`

BA creates PRD and user stories with acceptance criteria through HITL clarification loop. Structure stories around features, each with tester-first execution. Each story = tester agent writes tests, then coder agent implements.

**Standard AC Items:** See `/skill user-story-template` for required AC items in every story.

After incorporating user feedback into PRD, re-present the full summary and use AskUserQuestion tool to obtain explicit sign-off before proceeding to execution.

**SKIPPED for complexity < 15.**

---

## Phase 3: Design

**See:** `/skill architect-phase` → `/skill planning-phase`

Architect enriches stories with implementation details, PM creates execution plan with parallel waves.

**SKIPPED for complexity < 15.**

---

## Phase 4: Approval (HITL)

**See:** `/skill hitl-approval`

**Single approval gate** - User reviews PRD, enriched stories, and execution plan. Use AskUserQuestion tool for all user questions. Present structured options with clear descriptions. After approval, execution proceeds continuously.

After approval, waves execute with postmortem-then-compact between waves:

1. Wave N completes
2. Run postmortem (capture issues while context is fresh)
3. Compact context
4. HITL checkpoint (brief wave summary)
5. Wave N+1 starts

**SKIPPED for complexity < 15.**

---

## Phase 5: Execution

**See:** `/skill tdd-execution`, `/skill workflow-postmortem`

ALWAYS spawn agents for all implementation work. Paired TDD structure per story: spawn tester agent to write tests BEFORE spawning coder agent for implementation. PM spawns workers per wave, updates story status.

**Wave Checkpoint Flow (FULL PATH, multi-wave):**

1. Wave N agents complete their stories
2. **Quick log** - `/skill workflow-postmortem mode=log` (30 seconds max, append obvious mistakes)
3. **Compact context** - Run `/compact` to manage context window
4. **HITL checkpoint** - Brief wave summary to user
5. Proceed to Wave N+1

**For FAST PATH (<15):** Spawn tester agent to write tests, then spawn coder agent for implementation. Single wave, no intermediate logging.

---

## Phase 6: Validation

**See:** `/skill ac-verification`, `/skill production-check`

1. Verify all acceptance criteria met
2. Run build/lint/test (pnpm build, pnpm lint, pnpm test)

**On failure:** Return to Execution for fixes.

---

## Phase 7: Standards Audit

**See:** `/skill structure-check`, `/skill dry-check`, `/skill config-audit`

**Three checks (PARALLEL):**

1. **Structure Check**: Validate files in correct locations per domain
2. **DRY Check**: Scan new code against multi-mono shared libraries
3. **Config Audit**: Spawn config agents in audit mode for modified files

**On failure:** Return to Execution for fixes → Re-run Validation → Re-run Standards Audit → Loop until pass.

**SKIPPED for complexity < 15.**

---

## Phase 8: Final Workflow Postmortem

**See:** `/skill workflow-postmortem mode=summary`

Run `/skill workflow-postmortem mode=summary` to generate final summary. This reads the accumulated wave logs from `docs/projects/{project}/post-mortem.md` and presents a summary to the user.

**Output:** Summary of issues logged across waves (count by category, patterns identified), appended to post-mortem.md and included in final report.

---

## Phase 9: Report

**See:** `/skill report-phase`

BA + PM produce final build report with summary, files modified, tests added, standards audit results, workflow postmortem, and next steps.

---

## Examples

```bash
/build "add logging to service" (complexity: 8)
→ Analysis → FAST PATH → Task(spawn tester) → Task(spawn coder) → Validation → Final Postmortem → Report

/build "refactor auth module" (complexity: 22)
→ Analysis → Requirements → Design → Approval → Task(spawn tester) → Task(spawn coder) → Validation → Standards Audit → Final Postmortem → Report

/build "multi-tenant SaaS" (complexity: 45)
→ Analysis → Requirements → Design → Approval → Wave1 → Log → Compact → HITL → Wave2 → Log → Compact → HITL → Validation → Standards Audit → Summary → Report

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
2. ALWAYS run Analysis phase first (complexity-check + scope-check in PARALLEL). Use agent results directly and proceed with identified targets.
3. Complexity routing after Analysis:
   - **< 15**: FAST PATH (skip Requirements, Design, Approval, Standards Audit)
   - **≥ 15**: FULL PATH (all phases)
4. Include these phases only: Analysis → Requirements/Design/Approval (conditional) → Execution → Validation → Standards Audit (conditional) → Final Workflow Postmortem → Report
5. Use /architect command for innovation or vibe check workflows
6. TDD execution: ALWAYS run tester BEFORE coder per story. Structure stories around features with tester-first execution.
7. ALWAYS use Task tool to spawn tester agent first, then coder agent for implementation work
8. For FAST PATH (<15 complexity): ALWAYS spawn tester agent to write tests BEFORE spawning coder agent
9. ALWAYS spawn agents for implementation - the orchestrator tracks progress while agents write code
10. Standards Audit: ALWAYS run AFTER Validation passes (≥15 complexity only)
11. ALWAYS run build/lint/test after execution
12. **WAVE CHECKPOINT TIMING (FULL PATH, multi-wave):** ALWAYS run `/skill workflow-postmortem mode=log` BEFORE compact at each wave checkpoint (log → compact → HITL → next wave)
13. **POSTMORTEM LOG ACCUMULATION:** Each wave log appends to `docs/projects/{project}/post-mortem.md`, building a record across waves
14. ALWAYS run `/skill workflow-postmortem mode=summary` AFTER Standards Audit (or Validation for FAST PATH), BEFORE Report - reads accumulated logs and presents summary
15. ALWAYS produce final report with workflow postmortem section
16. When files modified, spawn agent: `subagent_type="general-purpose"` with prompt "Execute /skill repomix-cache-refresh"
17. Use AskUserQuestion tool for all user questions. Present structured options with clear descriptions.
18. After incorporating user feedback into PRD, re-present the full summary and obtain explicit sign-off before proceeding.
19. BA includes standard AC items in every story per `/skill user-story-template`
