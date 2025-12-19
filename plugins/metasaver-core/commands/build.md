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

Spawn 2 agents in parallel to execute complexity-check and scope-check skills.

**Output:** `complexity_score`, `targets[]`, `references[]`

**Complexity Routing:**

- **< 15**: FAST PATH (skip Requirements, Design, Approval, Standards Audit → jump to Execution)
- **≥ 15**: FULL PATH (all phases)

---

## Phase 2: Requirements

**See:** `/skill requirements-phase`

BA creates PRD and user stories with acceptance criteria through HITL clarification loop.

**SKIPPED for complexity < 15.**

---

## Phase 3: Design

**See:** `/skill architect-phase` → `/skill planning-phase`

Architect enriches stories with implementation details, PM creates execution plan with parallel waves.

**SKIPPED for complexity < 15.**

---

## Phase 4: Approval (HITL)

**See:** `/skill hitl-approval`

User reviews PRD, enriched stories, and execution plan before execution begins.

**SKIPPED for complexity < 15.**

---

## Phase 5: Execution

**See:** `/skill tdd-execution`

Paired TDD structure per story: tester agent runs BEFORE coder agent. PM spawns workers per wave, updates story status.

**For FAST PATH (<15):** Single tester→coder pass without formal stories.

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

## Phase 8: Report

**See:** `/skill report-phase`

BA + PM produce final build report with summary, files modified, tests added, standards audit results, and next steps.

---

## Examples

```bash
/build "add logging to service" (complexity: 8)
→ Analysis → FAST PATH → Execution → Validation → Report

/build "refactor auth module" (complexity: 22)
→ Analysis → Requirements → Design → Approval → Execution → Validation → Standards Audit → Report

/build "multi-tenant SaaS" (complexity: 45)
→ Analysis → Requirements → Design → Approval → TDD waves → Validation → Standards Audit → Report
```

---

## Enforcement

1. ALWAYS run Analysis phase first (complexity-check + scope-check in PARALLEL)
2. Complexity routing after Analysis:
   - **< 15**: FAST PATH (skip Requirements, Design, Approval, Standards Audit)
   - **≥ 15**: FULL PATH (all phases)
3. NO Innovate phase - use /architect if innovation needed
4. NO Vibe Check phase - only /architect has this
5. TDD execution: tester runs BEFORE coder per story
6. Standards Audit runs AFTER Validation passes (≥15 only)
7. Always run build/lint/test after execution
8. Always produce final report
9. If files modified, spawn agent: `subagent_type="general-purpose", model="haiku"` with prompt "Execute /skill repomix-cache-refresh"
