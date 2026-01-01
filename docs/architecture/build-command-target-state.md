# Build Command Target State

Target workflow architecture for the `/build` command - building features when you know what you want.

**Purpose:** Execute known requirements through TDD workflow with standards compliance.

**Use when:** You know what you want to build. For exploration/planning, use `/architect` instead.

---

## 1. High-Level Workflow (Skills Only)

```mermaid
flowchart TB
    classDef phase fill:#bbdefb,stroke:#1565c0,stroke-width:2px
    classDef skill fill:#fff8e1,stroke:#f57f17,stroke-width:2px
    classDef entry fill:#f3e5f5,stroke:#7b1fa2,stroke-width:2px
    classDef hitl fill:#ffcdd2,stroke:#c62828,stroke-width:2px

    ENTRY["/build {requirement}"]:::entry

    subgraph P1["Phase 1: Planning"]
        SEQ["sequential-thinking MCP"]:::skill
    end

    subgraph P2["Phase 2: Analysis"]
        SC["/skill scope-check"]:::skill
    end

    subgraph P3["Phase 3: Requirements"]
        REQ["/skill requirements-phase"]:::skill
    end

    subgraph P4["Phase 4: Design"]
        DES["/skill design-phase"]:::skill
    end

    subgraph P5["Phase 5: HITL Approval"]
        HITL["/skill hitl-approval"]:::hitl
    end

    subgraph P6["Phase 6: Execution"]
        TDD["/skill tdd-execution"]:::skill
    end

    subgraph P7["Phase 7: Validation"]
        VAL["/skill validation-phase"]:::skill
    end

    subgraph P8["Phase 8: Standards Audit"]
        STRUCT["/skill structure-check"]:::skill
        DRY["/skill dry-check"]:::skill
    end

    subgraph P9["Phase 9: Postmortem"]
        POST["/skill workflow-postmortem"]:::skill
    end

    subgraph P10["Phase 10: Report"]
        RPT["/skill report-phase"]:::skill
    end

    subgraph P11["Phase 11: Archival"]
        ARCH["Archive epic folder"]:::skill
    end

    ENTRY --> P1 --> P2 --> P3 --> P4 --> P5 --> P6 --> P7 --> P8 --> P9 --> P10 --> P11
```

**Legend:**

| Color  | Meaning            |
| ------ | ------------------ |
| Purple | Entry point        |
| Blue   | Phase container    |
| Yellow | Skill (reusable)   |
| Red    | HITL approval gate |

**/build is ALWAYS full workflow.** No complexity routing - use `/ms` for simple tasks.

---

## 2. Phase 1: Planning + Phase 2: Analysis (Exploded)

**Execution:** Sequential - planning first, then scope analysis

```mermaid
flowchart TB
    classDef skill fill:#fff8e1,stroke:#f57f17,stroke-width:2px
    classDef step fill:#f5f5f5,stroke:#616161,stroke-width:1px

    subgraph P1["Phase 1: Planning"]
        SEQ1["Use sequential-thinking MCP tool"]:::step
        SEQ2["Analyze prompt scope and requirements"]:::step
        SEQ3["Outline high-level implementation strategy"]:::step
        SEQ1 --> SEQ2 --> SEQ3
    end

    subgraph P2["Phase 2: Analysis"]
        subgraph SC["/skill scope-check"]
            SC1["Parse prompt for repo/file references"]:::step
            SC2["Identify target repos"]:::step
            SC3["Identify reference repos (patterns to follow)"]:::step
            SC4["Return: targets[], references[]"]:::step
            SC1 --> SC2 --> SC3 --> SC4
        end
    end

    P1 --> P2
```

**Output:**

- `targets[]` - Repos/paths to modify
- `references[]` - Repos/paths to use as patterns

---

## 3. Phase 2: Requirements (Exploded)

**Execution:** Sequential with AskUserQuestion clarification loop (NOT HITL)

```mermaid
flowchart TB
    classDef skill fill:#fff8e1,stroke:#f57f17,stroke-width:2px
    classDef step fill:#f5f5f5,stroke:#616161,stroke-width:1px
    classDef ask fill:#e8f5e9,stroke:#2e7d32,stroke-width:1px

    subgraph P2["Phase 2: Requirements"]
        subgraph REQ["/skill requirements-phase"]
            R1["Parse scope + complexity results"]:::step
            R2["EA analyzes task"]:::step

            subgraph LOOP["AskUserQuestion Clarification Loop"]
                R3["AskUserQuestion: clarifying questions"]:::ask
                R4["User answers"]:::ask
                R5["EA updates understanding"]:::step
                R6{"100% understood?"}
                R3 --> R4 --> R5 --> R6
                R6 -->|No| R3
            end

            R7["Create PRD: docs/epics/{project}/prd.md"]:::step
            R8["Reviewer validates PRD"]:::step
            R9["BA extracts user stories"]:::step

            R1 --> R2 --> LOOP
            R6 -->|Yes| R7 --> R8 --> R9 --> OUT((To Design))
        end
    end
```

**Key:** EA uses AskUserQuestion until 100% understanding, then creates PRD. NO HITL in this phase.

**Output:** PRD + user stories (continues to Design, NOT approval)

---

## 4. Phase 3: Design (Exploded)

**Execution:** Sequential - architect, BA, PM, reviewer (NO HITL)

```mermaid
flowchart TB
    classDef skill fill:#fff8e1,stroke:#f57f17,stroke-width:2px
    classDef step fill:#f5f5f5,stroke:#616161,stroke-width:1px
    classDef validate fill:#e3f2fd,stroke:#1565c0,stroke-width:1px

    subgraph P3["Phase 3: Design (NO HITL)"]
        subgraph ARCH["/skill architect-phase"]
            A1["Annotate PRD with implementation details"]:::step
            A2["Add: API endpoints, key files, patterns"]:::step
            A1 --> A2
        end

        subgraph BA1["BA: Story Outlines"]
            B1["Create story outlines from annotated PRD"]:::step
        end

        subgraph PM["/skill planning-phase"]
            PL1["Review story outlines"]:::step
            PL2["Identify dependencies between stories"]:::step
            PL3["Group into execution waves"]:::step
            PL4["Create execution-plan.md"]:::step
            PL1 --> PL2 --> PL3 --> PL4
        end

        subgraph REV1["Reviewer: Validate Plan"]
            V1["Validate execution plan"]:::validate
            V2{"Valid?"}
            V1 --> V2
        end

        subgraph BA2["BA: Fill Story Details"]
            B2["Fill complete story format"]:::step
            B3["Add acceptance criteria"]:::step
            B2 --> B3
        end

        subgraph ARCH2["Architect: Architecture Section"]
            A3["Add Architecture section to each story"]:::step
        end

        subgraph REV2["Reviewer: Validate Stories"]
            V3["Validate all stories"]:::validate
            V4{"Valid?"}
            V3 --> V4
        end

        ARCH --> BA1 --> PM --> REV1
        V2 -->|No| PM
        V2 -->|Yes| BA2 --> ARCH2 --> REV2
        V4 -->|No| BA2
        V4 -->|Yes| OUT((To HITL Approval))
    end
```

**Output:** Enriched stories + execution plan with waves (continues to SINGLE HITL)

---

## 5. Phase 4: Approval (Exploded)

**Execution:** SINGLE HITL approval for all documentation

```mermaid
flowchart TB
    classDef skill fill:#fff8e1,stroke:#f57f17,stroke-width:2px
    classDef step fill:#f5f5f5,stroke:#616161,stroke-width:1px
    classDef hitl fill:#ffcdd2,stroke:#c62828,stroke-width:2px

    subgraph P4["Phase 4: SINGLE HITL Approval"]
        subgraph HITL["/skill hitl-approval"]
            H1["Present PRD summary"]:::step
            H2["Present execution plan (waves, dependencies)"]:::step
            H3["Present user stories (count, complexity)"]:::step
            H4["HITL: User reviews ALL docs"]:::hitl
            H5{"User approves?"}
            H6["Collect feedback"]:::step
            H7["Return to Requirements or Design phase"]:::step

            H1 --> H2 --> H3 --> H4 --> H5
            H5 -->|No| H6 --> H7
            H5 -->|Yes| OUT((Approved - Start Execution))
        end
    end
```

**Key:** This is the ONLY HITL gate. User reviews PRD + execution plan + stories before any code is written.

**Output:** All docs approved → proceed to execution

---

## 6. Phase 5: Execution (Exploded)

**Execution:** TDD pairs - sequential within story, parallel across stories

```mermaid
flowchart TB
    classDef skill fill:#fff8e1,stroke:#f57f17,stroke-width:2px
    classDef step fill:#f5f5f5,stroke:#616161,stroke-width:1px
    classDef tester fill:#e8f5e9,stroke:#2e7d32,stroke-width:1px
    classDef coder fill:#e3f2fd,stroke:#1565c0,stroke-width:1px

    subgraph P5["Phase 5: Execution"]
        subgraph TDD["/skill tdd-execution"]
            T1["Load execution_plan"]:::step
            T2["For each wave:"]:::step

            subgraph WAVE["Wave (parallel stories)"]
                subgraph SA["Story A (sequential)"]
                    SA1["Spawn tester agent"]:::tester
                    SA2["Write tests for acceptance criteria"]:::tester
                    SA3["Spawn coder agent"]:::coder
                    SA4["Implement to pass tests"]:::coder
                    SA1 --> SA2 --> SA3 --> SA4
                end

                subgraph SB["Story B (sequential)"]
                    SB1["Spawn tester agent"]:::tester
                    SB2["Write tests for acceptance criteria"]:::tester
                    SB3["Spawn coder agent"]:::coder
                    SB4["Implement to pass tests"]:::coder
                    SB1 --> SB2 --> SB3 --> SB4
                end
            end

            T3["Update story files with progress"]:::step
            T4{{"More waves?"}}

            T1 --> T2 --> WAVE --> T3 --> T4
            T4 -->|Yes| T2
            T4 -->|No| OUT((To Validation))
        end
    end
```

**Key:** Per story: tester writes tests first, then coder implements. Multiple stories run in parallel.

**Output:** Code + tests for all stories

---

## 7. Phase 6: Validation (Exploded)

**Execution:** Sequential - AC verification then production check

```mermaid
flowchart TB
    classDef skill fill:#fff8e1,stroke:#f57f17,stroke-width:2px
    classDef step fill:#f5f5f5,stroke:#616161,stroke-width:1px
    classDef validate fill:#e3f2fd,stroke:#1565c0,stroke-width:1px

    subgraph P6["Phase 6: Validation"]
        subgraph ACV["/skill ac-verification"]
            V1["For each user story:"]:::step
            V2["Check acceptance criteria met"]:::step
            V3{"All AC pass?"}
            V4["Report unmet AC"]:::step
            V5["Return to Execution for fixes"]:::step
            V1 --> V2 --> V3
            V3 -->|No| V4 --> V5
        end

        subgraph PROD["/skill production-check"]
            PC1["Run: pnpm build"]:::validate
            PC2["Run: pnpm lint"]:::validate
            PC3["Run: pnpm test"]:::validate
            PC4{{"All pass?"}}
            PC5["Report failures"]:::step
            PC6["Return to Execution for fixes"]:::step
            PC1 --> PC2 --> PC3 --> PC4
            PC4 -->|No| PC5 --> PC6
        end

        V3 -->|Yes| PROD
        PC4 -->|Yes| OUT((To Standards Audit))
    end
```

**Output:** All AC verified, build/lint/test passing

---

## 8. Phase 7: Standards Audit (Exploded)

**Execution:** Parallel checks, then fix loop if needed

```mermaid
flowchart TB
    classDef skill fill:#fff8e1,stroke:#f57f17,stroke-width:2px
    classDef step fill:#f5f5f5,stroke:#616161,stroke-width:1px

    subgraph P7["Phase 7: Standards Audit"]
        subgraph STRUCT["/skill structure-check"]
            S1["Validate files in correct locations"]:::step
            S2["Check domain structure (features/, routes/, etc.)"]:::step
            S3["Report structure violations"]:::step
            S1 --> S2 --> S3
        end

        subgraph DRY["/skill dry-check"]
            D1["Scan new code against multi-mono libs"]:::step
            D2["Check for duplicate utilities"]:::step
            D3["Check for duplicate components"]:::step
            D4["Report DRY violations"]:::step
            D1 --> D2 --> D3 --> D4
        end

        subgraph CFG["/skill config-audit"]
            C1["Identify modified config files"]:::step
            C2["Spawn config/domain agents in audit mode"]:::step
            C3["Compare against templates"]:::step
            C4["Report config violations"]:::step
            C1 --> C2 --> C3 --> C4
        end

        AGG["Aggregate all violations"]:::step
        FIX{"Violations found?"}
        REPAIR["Return to Execution for fixes"]:::step

        STRUCT --> AGG
        DRY --> AGG
        CFG --> AGG
        AGG --> FIX
        FIX -->|Yes| REPAIR
        FIX -->|No| OUT((To Report))
    end
```

**Key:** Ensures new code follows MetaSaver standards before completion.

**Output:** All standards pass (or fixes applied)

---

## 9. Phase 8: Report (Exploded)

**Execution:** Sequential

```mermaid
flowchart TB
    classDef skill fill:#fff8e1,stroke:#f57f17,stroke-width:2px
    classDef step fill:#f5f5f5,stroke:#616161,stroke-width:1px

    subgraph P8["Phase 8: Report"]
        subgraph RPT["/skill report-phase"]
            RP1["Executive Summary: X stories completed"]:::step
            RP2["Files Created/Modified: list with paths"]:::step
            RP3["Tests Added: count and coverage"]:::step
            RP4["Standards Audit: results"]:::step
            RP5["Next Steps: recommendations"]:::step
            RP1 --> RP2 --> RP3 --> RP4 --> RP5
        end
    end
```

**Output:** Complete build report in markdown

---

## 10. Quick Reference

| Phase | Skill                       | Agent                  |
| ----- | --------------------------- | ---------------------- |
| 1     | `/skill scope-check`        | scope-check-agent      |
| 2     | `/skill requirements-phase` | business-analyst       |
| 3     | `/skill architect-phase`    | architect              |
| 3     | `/skill planning-phase`     | project-manager        |
| 4     | `/skill hitl-approval`      | - (HITL)               |
| 5     | `/skill tdd-execution`      | tester + coder         |
| 6     | `/skill ac-verification`    | reviewer               |
| 6     | `/skill production-check`   | - (bash)               |
| 7     | `/skill structure-check`    | code-quality-validator |
| 7     | `/skill dry-check`          | code-quality-validator |
| 7     | `/skill config-audit`       | config/domain agents   |
| 8     | `/skill report-phase`       | business-analyst       |

---

## 11. Examples

```bash
# Feature build
/build "Add user profile page to metasaver-com"
→ P1: scope=[metasaver-com], complexity=25
→ P2: BA creates PRD + stories
→ P3: Architect enriches, PM plans 2 waves
→ P4: User approves
→ P5: TDD execution (wave 1, wave 2)
→ P6: All AC pass, build/lint/test pass
→ P7: Structure OK, DRY OK, configs OK
→ P8: Report

# API endpoint
/build "Add GET /api/applications endpoint, follow rugby-crm patterns"
→ P1: scope=[metasaver-com], references=[rugby-crm]
→ P2-P8: Full workflow

# Component build
/build "Create ZApplicationCard component using ZCard from core-components"
→ P1: scope=[metasaver-com]
→ P2: BA creates PRD for component
→ P3: Architect notes ZCard dependency
→ P4-P8: Full workflow
```

---

## 12. Enforcement Rules

1. **NO tool-check** - Removed from analysis
2. **NO vibe-check** - Only /architect has this
3. **NO innovation phase** - Only /architect has this
4. **ALWAYS create PRD** - Even for simple builds
5. **TDD execution** - Tests first, then implementation
6. **Sequential within story** - Tester → Coder
7. **Parallel across stories** - Multiple pairs per wave
8. **Standards audit AFTER build passes** - structure + DRY + configs
9. **Always produce report**

---

## 13. Comparison: /build vs /audit vs /architect

| Aspect              | /build               | /audit                      | /architect           |
| ------------------- | -------------------- | --------------------------- | -------------------- |
| **Purpose**         | Build features       | Validate compliance         | Explore & plan       |
| **Analysis**        | scope                | scope + agent               | scope                |
| **PRD**             | Always               | Always                      | Always               |
| **Vibe Check**      | NO                   | NO                          | YES                  |
| **Innovation**      | NO                   | NO                          | YES (always)         |
| **Design**          | architect + planning | planning only               | architect + planning |
| **Execution**       | TDD pairs            | Investigation → Remediation | NO (PRD only)        |
| **Standards Audit** | YES                  | NO                          | NO                   |
| **Output**          | Code + tests         | Fixes + report              | PRD for /build       |

---

## 14. Reusable Skills Summary

Skills shared with other commands:

| Skill                       | /build | /audit | /architect | /debug | /qq |
| --------------------------- | ------ | ------ | ---------- | ------ | --- |
| `/skill scope-check`        | ✅     | ✅     | ✅         | ✅     | ✅  |
| `/skill agent-check`        | -      | ✅     | -          | ✅     | ✅  |
| `/skill requirements-phase` | ✅     | ✅     | ✅         | ✅     | -   |
| `/skill planning-phase`     | ✅     | ✅     | ✅         | -      | -   |
| `/skill architect-phase`    | ✅     | -      | ✅         | -      | -   |
| `/skill hitl-approval`      | ✅     | ✅     | ✅         | ✅     | -   |
| `/skill ac-verification`    | ✅     | ✅     | -          | -      | -   |
| `/skill production-check`   | ✅     | ✅     | -          | -      | -   |
| `/skill report-phase`       | ✅     | ✅     | -          | ✅     | -   |
