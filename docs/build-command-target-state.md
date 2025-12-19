# Build Command Target State

Target workflow architecture for the `/build` command - building features when you know what you want.

**Purpose:** Execute known requirements through TDD workflow with standards compliance.

**Use when:** You know what you want to build. For exploration/planning, use `/architect` instead.

---

## 1. High-Level Workflow (Skills Only)

```mermaid
flowchart LR
    classDef phase fill:#e3f2fd,stroke:#1565c0,stroke-width:2px
    classDef skill fill:#fff8e1,stroke:#f57f17,stroke-width:2px
    classDef entry fill:#f3e5f5,stroke:#7b1fa2,stroke-width:2px

    ENTRY["/build {requirement}"]:::entry

    subgraph P1["Phase 1: Analysis"]
        direction TB
        SC["/skill scope-check"]:::skill
    end

    subgraph P2["Phase 2: Requirements"]
        direction TB
        REQ["/skill requirements-phase"]:::sSkill
    end

    subgraph P3["Phase 3: Design"]
        direction TB
        ARCH["/skill architect-phase"]:::skill
        PLAN["/skill planning-phase"]:::skill
    end

    subgraph P4["Phase 4: Approval"]
        direction TB
        HITL["/skill hitl-approval"]:::skill
    end

    subgraph P5["Phase 5: Execution"]
        direction TB
        TDD["/skill tdd-execution"]:::skill
    end

    subgraph P6["Phase 6: Validation"]
        direction TB
        ACV["/skill ac-verification"]:::skill
        PRD["/skill production-check"]:::skill
    end

    subgraph P7["Phase 7: Standards Audit"]
        direction TB
        STRUCT["/skill structure-check"]:::skill
        DRY["/skill dry-check"]:::skill
        CFG["/skill config-audit"]:::skill
    end

    subgraph P8["Phase 8: Report"]
        direction TB
        RPT["/skill report-phase"]:::skill
    end

    ENTRY --> P1
    P1 --> P2 --> P3 --> P4 --> P5 --> P6 --> P7 --> P8
```

**Legend:**

| Color  | Meaning         |
| ------ | --------------- |
| Purple | Entry point     |
| Blue   | Phase container |
| Yellow | Skill           |

---

## 2. Phase 1: Analysis (Exploded)

**Execution:** Single skill

```mermaid
flowchart TB
    classDef skill fill:#fff8e1,stroke:#f57f17,stroke-width:2px
    classDef step fill:#f5f5f5,stroke:#616161,stroke-width:1px

    subgraph P1["Phase 1: Analysis"]
        subgraph SC["/skill scope-check"]
            SC1["Parse prompt for repo/file references"]:::step
            SC2["Identify target repos"]:::step
            SC3["Identify reference repos (patterns to follow)"]:::step
            SC4["Return: targets[], references[]"]:::step
            SC1 --> SC2 --> SC3 --> SC4
        end
    end
```

**Output:**

- `targets[]` - Repos/paths to modify
- `references[]` - Repos/paths to use as patterns

---

## 3. Phase 2: Requirements (Exploded)

**Execution:** Sequential with HITL clarification loop

```mermaid
flowchart TB
    classDef skill fill:#fff8e1,stroke:#f57f17,stroke-width:2px
    classDef step fill:#f5f5f5,stroke:#616161,stroke-width:1px
    classDef hitl fill:#ffcdd2,stroke:#c62828,stroke-width:1px

    subgraph P2["Phase 2: Requirements"]
        subgraph REQ["/skill requirements-phase"]
            R1["Parse scope + complexity results"]:::step
            R2["BA understands task"]:::step

            subgraph LOOP["HITL Clarification Loop"]
                R3["HITL: Ask clarifying questions"]:::hitl
                R4["User answers"]:::hitl
                R5["BA updates understanding"]:::step
                R6{"More questions?"}
                R3 --> R4 --> R5 --> R6
                R6 -->|Yes| R3
            end

            R7["Create PRD: docs/prd/build-{date}.md"]:::step
            R8["Create user stories with acceptance criteria"]:::step

            R1 --> R2 --> LOOP
            R6 -->|No| R7 --> R8 --> OUT((To Design))
        end
    end
```

**Key:** Always creates PRD for /build. BA gathers requirements, creates PRD + stories.

**Output:** PRD + user stories (not yet approved)

---

## 4. Phase 3: Design (Exploded)

**Execution:** Sequential - architect first, then planning

```mermaid
flowchart TB
    classDef skill fill:#fff8e1,stroke:#f57f17,stroke-width:2px
    classDef step fill:#f5f5f5,stroke:#616161,stroke-width:1px

    subgraph P3["Phase 3: Design"]
        subgraph ARCH["/skill architect-phase"]
            A1["Check multi-mono for existing solutions"]:::step
            A2["Search reference repos for patterns"]:::step
            A3["Validate against Context7 docs"]:::step
            A4["Enrich stories with implementation details"]:::step
            A5["Add: files to create/modify, imports, patterns"]:::step
            A1 --> A2 --> A3 --> A4 --> A5
        end

        subgraph PLANNING["/skill planning-phase"]
            PL1["Review enriched stories"]:::step
            PL2["Identify dependencies between stories"]:::step
            PL3["Group into execution waves"]:::step
            PL4["Define parallel pairs per wave"]:::step
            PL5["Return: execution_plan"]:::step
            PL1 --> PL2 --> PL3 --> PL4 --> PL5
        end

        ARCH --> PLANNING
    end
```

**Output:** Enriched stories + execution plan with waves

---

## 5. Phase 4: Approval (Exploded)

**Execution:** HITL approval loop

```mermaid
flowchart TB
    classDef skill fill:#fff8e1,stroke:#f57f17,stroke-width:2px
    classDef step fill:#f5f5f5,stroke:#616161,stroke-width:1px
    classDef hitl fill:#ffcdd2,stroke:#c62828,stroke-width:1px

    subgraph P4["Phase 4: Approval"]
        subgraph HITL["/skill hitl-approval"]
            H1["Present PRD summary"]:::step
            H2["Present enriched stories"]:::step
            H3["Present execution plan"]:::step
            H4["HITL: User reviews"]:::hitl
            H5{"User approves?"}
            H6["Collect feedback"]:::step
            H7["Return to Requirements phase"]:::step

            H1 --> H2 --> H3 --> H4 --> H5
            H5 -->|No| H6 --> H7
            H5 -->|Yes| OUT((Approved))
        end
    end
```

**Key:** User reviews PRD + stories + execution plan before any code is written.

**Output:** Approved PRD + execution plan

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

| Phase | Skill                       | Agent                  | Model  |
| ----- | --------------------------- | ---------------------- | ------ |
| 1     | `/skill scope-check`        | scope-check-agent      | sonnet |
| 2     | `/skill requirements-phase` | business-analyst       | opus   |
| 3     | `/skill architect-phase`    | architect              | sonnet |
| 3     | `/skill planning-phase`     | project-manager        | sonnet |
| 4     | `/skill hitl-approval`      | - (HITL)               | -      |
| 5     | `/skill tdd-execution`      | tester + coder         | sonnet |
| 6     | `/skill ac-verification`    | reviewer               | sonnet |
| 6     | `/skill production-check`   | - (bash)               | -      |
| 7     | `/skill structure-check`    | code-quality-validator | sonnet |
| 7     | `/skill dry-check`          | code-quality-validator | sonnet |
| 7     | `/skill config-audit`       | config/domain agents   | sonnet |
| 8     | `/skill report-phase`       | business-analyst       | sonnet |

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
