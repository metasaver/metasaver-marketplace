---
name: architect
description: Explore, plan, and innovate to create comprehensive PRD for /build execution
---

# Architect Command

Creates comprehensive PRD through deep exploration and innovation. Planning-only command - produces PRD for `/build` to execute.

**Use when:** You have a vague idea or problem but don't know exactly what to build.

**Output:** PRD file ready for `/build {prd-path}` to execute.

---

## Entry Handling

When /architect is invoked, ALWAYS proceed to Phase 1 regardless of prompt content. User prompts may contain questions, clarifications, or vague problems - these are handled during the Requirements exploration phase.

---

## Phase 1: Analysis

**See:** `/skill analysis-phase`

Spawn scope-check agent to identify target and reference repositories.

**Note:** Scope-check only (no complexity evaluation) - all requests follow FULL PATH workflow.

---

## Phase 2: Requirements (Deep Exploration)

**See:** `/skill requirements-phase`

BA performs DEEP exploration with many HITL questions to understand vague requirements.

**ALWAYS uses sequential-thinking MCP tool** to structure analysis.

Creates draft PRD + user stories based on exploration results.

---

## Phase 3: Vibe Check

**See:** `/skill vibe-check`

Single vibe check validates PRD coherence and requirements clarity.

If revision needed: Return to Requirements phase to refine PRD.

**ALWAYS runs for /architect** (unlike /build where it's optional).

---

## Phase 4: Innovation

**See:** `/skill innovate-phase`

Innovation advisor analyzes PRD for enhancement opportunities. For EACH innovation: show 1-pager, ask user (Implement/Skip/More Details). BA updates PRD with selected innovations.

**ALWAYS runs for /architect** (unlike /build where it's optional).

---

## Phase 5: Design

**See:** `/skill design-phase`

### Step 1: Architect Annotations

**See:** `/skill architect-phase`

Architect checks multi-mono for existing solutions, validates against Context7 docs, enriches stories with implementation details.

### Step 2: Execution Planning

**See:** `/skill planning-phase`

PM reviews enriched stories, identifies dependencies, groups into execution waves, creates Gantt chart.

---

## Phase 6: Human Validation (HITL)

**See:** `/skill hitl-approval`

User reviews complete PRD package: PRD summary, enriched stories, selected innovations, execution plan.

User approves or requests revisions. On revision: Return to Requirements phase.

---

## Phase 7: Output

**See:** `/skill save-prd`

Save PRD package to `docs/projects/{yyyymmdd}-{name}/` with all artifacts.

Tell user: "Run `/build {path}/prd.md` to execute this plan."

**Planning-only scope** - /architect produces PRD package, does not execute implementation.

---

## Project Folder Structure

After /architect completes:

```
docs/projects/{yyyymmdd}-{name}/
├── prd.md                    # Main PRD document
├── user-stories/
│   ├── US-001-{slug}.md      # Individual stories (enriched)
│   ├── US-002-{slug}.md
│   └── ...
├── execution-plan.md         # PM's Gantt chart
├── innovations-selected.md   # Innovations chosen by user
└── architecture-notes.md     # Architect's validation notes
```

---

## Examples

```bash
/architect "need user authentication somehow"
→ P1: scope=[current repo]
→ P2: BA explores: OAuth? JWT? Session? User base? Many questions
→ P3: Vibe check passes
→ P4: Innovate: passwordless auth, SSO, MFA - user selects
→ P5: Architect validates, PM plans waves
→ P6: User approves
→ P7: PRD saved → "Run /build docs/projects/20251217-user-auth/prd.md"

/architect "dashboard but not sure what's on it"
→ P1: scope=[current repo]
→ P2: BA explores: Who uses it? Metrics? Real-time? Deep HITL
→ P3: Vibe check passes
→ P4: Innovate: widgets, customization, export - user selects
→ P5: Architect checks existing components, PM creates phased plan
→ P6: User approves
→ P7: PRD saved

/architect "integrate Stripe but not sure best approach"
→ P1: scope=[current repo]
→ P2: BA explores: Payment types? Subscriptions? One-time? Webhooks?
→ P3: Vibe check passes
→ P4: Innovate: checkout sessions, payment intents - user selects
→ P5: Architect checks Context7 for Stripe patterns
→ P6: User approves
→ P7: PRD saved
```

---

## Enforcement

1. ALWAYS run Analysis phase first (scope-check only, NO complexity-check)
2. ALWAYS follow FULL PATH workflow (no fast path for /architect)
3. BA must perform deep exploration
4. BA must use sequential-thinking MCP tool for requirements analysis
5. BA must ask many questions to understand vague requirements
6. ALWAYS run Vibe Check on PRD (quality gate before innovation)
7. ALWAYS run Innovate phase with HITL per innovation
8. Architect must check multi-mono BEFORE enriching stories
9. Architect must validate against Context7 docs for external libraries
10. Planning must create execution plan with parallel waves
11. Final HITL approval required before saving PRD
12. Output is PRD package only - execution via `/build {prd-path}`
13. Tell user to run `/build {prd-path}` to execute the plan
14. If Vibe Check requires revision, return to Requirements phase to refine PRD
15. Save all artifacts to `docs/projects/{yyyymmdd}-{name}/`
