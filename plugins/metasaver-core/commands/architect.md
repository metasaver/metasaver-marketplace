---
name: architect
description: Create comprehensive PRD through strategic analysis with optional innovation exploration
---

# Architect Command

Creates comprehensive PRD through strategic analysis. Planning-only command - produces PRD for `/build` to execute.

**Use when:** You have a vague idea or problem and need structured requirements.

**Output:** PRD file ready for `/build {prd-path}` to execute.

---

## Entry Handling

When /architect is invoked, ALWAYS proceed to Phase 1 regardless of prompt content. User prompts may contain questions, clarifications, or vague problems - these are handled during the Requirements exploration phase.

---

## Phase 1: Analysis

**Follow:** `/skill analysis-phase`

Spawn scope-check agent to identify target and reference repositories.

**Note:** Scope-check only - all requests follow FULL PATH workflow.

---

## Phase 2: Planning (Sequential Thinking)

**Use:** `sequential-thinking` MCP tool

Before requirements exploration, structure the approach using sequential-thinking:

1. Break down the problem space
2. Identify key stakeholders and concerns
3. Map dependencies and constraints
4. Plan exploration questions

**Output:** Structured analysis plan for EA agent.

---

## Phase 3: Requirements (PRD Creation)

**Follow:** `/skill prd-creation`

**Spawn:** `core-claude-plugin:generic:enterprise-architect`

EA agent performs deep exploration with HITL questions to understand requirements:

1. Investigates codebase using Serena tools
2. Applies sequential-thinking for complex analysis
3. Drafts PRD following `/skill prd-creation` template
4. Identifies uncertainties for clarification

**Output:** Draft PRD document with all 10 sections.

---

## Phase 4: PRD Review

**Spawn:** `core-claude-plugin:generic:reviewer` (document validation mode)

Reviewer validates PRD structure before HITL:

- Validates frontmatter fields
- Checks all 10 required sections present
- Verifies requirements have IDs and priorities
- Confirms scope boundaries defined

### Enforcement Gate (MANDATORY)

1. Reviewer validates PRD structure against `/skill prd-creation` template
2. **On FAIL:** Return to EA agent with violations list - EA MUST fix all violations before retry
3. **On PASS:** Continue to Innovation Decision (Phase 5)

Gate is BLOCKING - workflow cannot proceed until PRD passes validation.

---

## Phase 5: Innovation Decision (HITL)

**Use AskUserQuestion to ask user:**

```
"Run innovation analysis to discover enhancement opportunities?"

Options:
- Yes - Analyze PRD for recommended enhancements
- No - Skip innovation analysis and proceed to final review
```

**User controls whether innovation runs.** Innovation is OPTIONAL.

---

## Phase 6: Innovation (Conditional)

**IF user selected "Yes" in Phase 5:**

**Follow:** `/skill innovate-phase`

Innovation advisor analyzes PRD for enhancement opportunities. For EACH innovation: show 1-pager, ask user (Implement/Skip/More Details). EA updates PRD with selected innovations.

**IF user selected "No":** Skip directly to Phase 7.

---

## Phase 7: Design

**Follow:** `/skill design-phase`

### Step 1: Architect Annotations

**Follow:** `/skill architect-phase`

Architect checks multi-mono for existing solutions, validates against Context7 docs, enriches stories with implementation details.

### Step 2: Execution Planning

**Follow:** `/skill planning-phase`

PM reviews enriched stories, identifies dependencies, groups into execution waves, creates Gantt chart.

### Enforcement Gate (MANDATORY)

**Spawn:** `core-claude-plugin:generic:reviewer` (design artifacts validation mode)

1. Verify enriched stories exist in `docs/epics/{project-id}/user-stories/`
2. Verify execution plan exists with wave assignments
3. Validate story format: each story has acceptance criteria, implementation notes, and dependencies
4. **On FAIL:** Loop back to Design phase - fix missing/invalid artifacts before retry
5. **On PASS:** Continue to HITL (Phase 8)

Gate is BLOCKING - workflow cannot proceed until design artifacts pass validation.

---

## Phase 8: Human Validation (HITL)

**Follow:** `/skill hitl-approval`

User reviews complete PRD package: PRD summary, enriched stories, selected innovations (if any), execution plan.

User approves or requests revisions. On revision: Return to Requirements phase.

---

## Phase 9: Workflow Postmortem

**Follow:** `/skill workflow-postmortem mode=summary`

Run `/skill workflow-postmortem mode=summary` to generate final summary. This reads any accumulated logs from `docs/epics/{project}/post-mortem.md` and presents a summary to the user.

**Output:** Summary of issues logged during workflow (count by category, patterns identified), included in final artifacts.

---

## Phase 10: Output

**Follow:** `/skill save-prd`

Save PRD package to `docs/epics/{project-id}/` with all artifacts.

Tell user: "Run `/build {path}/prd.md` to execute this plan."

**Planning-only scope** - /architect produces PRD package, execution handled by `/build`.

---

## Project Folder Structure

After /architect completes:

```
docs/epics/{project-id}/
├── prd.md                    # Main PRD document
├── user-stories/
│   ├── US-001-{slug}.md      # Individual stories (enriched)
│   ├── US-002-{slug}.md
│   └── ...
├── execution-plan.md         # PM's Gantt chart
├── innovations-selected.md   # Innovations chosen by user (if any)
└── architecture-notes.md     # Architect's validation notes
```

---

## Examples

```bash
/architect "need user authentication somehow"
→ P1: scope=[current repo]
→ P2: sequential-thinking structures approach
→ P3: EA explores: OAuth? JWT? Session? User base? Creates PRD
→ P4: Reviewer validates PRD structure
→ P5: User asked: "Run innovation?" → Yes
→ P6: Innovate: passwordless auth, SSO, MFA - user selects
→ P7: Architect validates, PM plans waves
→ P8: User approves
→ P9: Postmortem summary
→ P10: PRD saved → "Run /build docs/epics/msm007-user-auth/prd.md"

/architect "dashboard but not sure what's on it"
→ P1: scope=[current repo]
→ P2: sequential-thinking analyzes stakeholders, metrics
→ P3: EA explores: Who uses it? Metrics? Real-time? Creates PRD
→ P4: Reviewer validates
→ P5: User asked: "Run innovation?" → No (skip)
→ P6: [skipped]
→ P7: Architect checks existing components, PM creates phased plan
→ P8: User approves
→ P9: Postmortem summary
→ P10: PRD saved

/architect "integrate Stripe but not sure best approach"
→ P1: scope=[current repo]
→ P2: sequential-thinking maps integration patterns
→ P3: EA explores: Payment types? Subscriptions? Webhooks? Creates PRD
→ P4: Reviewer validates
→ P5: User asked: "Run innovation?" → Yes
→ P6: Innovate: checkout sessions, payment intents - user selects
→ P7: Architect checks Context7 for Stripe patterns
→ P8: User approves
→ P9: Postmortem summary
→ P10: PRD saved
```

---

## Enforcement

1. Use AskUserQuestion tool for every question to the user. Present structured options with clear descriptions.
2. ALWAYS run Analysis phase first (scope-check only)
3. ALWAYS follow FULL PATH workflow (no fast path for /architect)
4. ALWAYS use sequential-thinking MCP tool in Phase 2 to structure the approach
5. EA agent MUST use `/skill prd-creation` for PRD output
6. EA agent MUST ask clarifying questions to understand vague requirements
7. Reviewer MUST validate PRD structure before innovation decision
8. ALWAYS ask user about innovation using AskUserQuestion (innovation is OPTIONAL)
9. Innovation phase runs ONLY if user selects "Yes"
10. Architect must check multi-mono BEFORE enriching stories
11. Architect must validate against Context7 docs for external libraries
12. Planning must create execution plan with parallel waves
13. Final HITL approval required before saving PRD
14. Output is PRD package only - execution via `/build {prd-path}`
15. Tell user to run `/build {prd-path}` to execute the plan
16. Save all artifacts to `docs/epics/{project-id}/`
17. ALWAYS run `/skill workflow-postmortem mode=summary` AFTER HITL approval, BEFORE Output phase
18. Phase 4 enforcement gate is MANDATORY - PRD validation MUST pass before Phase 5
19. Phase 7 enforcement gate is MANDATORY - design artifacts validation MUST pass before Phase 8
20. Enforcement gates are BLOCKING - workflow halts until validation passes
21. On gate failure, return to originating phase with explicit violation list
