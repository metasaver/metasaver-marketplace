# Audit Command Target State

Target workflow architecture for the `/audit` command - configuration and standards compliance validation.

**Purpose:** Validate configurations against templates with interactive user decisions per discrepancy.

**Use when:** You need to check if configs match standards or audit compliance across repos.

---

## 1. High-Level Workflow (Skills Only)

```mermaid
flowchart LR
    classDef phase fill:#bbdefb,stroke:#1565c0,stroke-width:2px
    classDef skill fill:#fff8e1,stroke:#f57f17,stroke-width:2px
    classDef entry fill:#f3e5f5,stroke:#7b1fa2,stroke-width:2px

    ENTRY["/audit {target}"]:::entry

    subgraph P1["Phase 1: Analysis"]
        direction TB
        SC["/skill scope-check"]:::skill
        AC["/skill agent-check"]:::skill
    end

    subgraph P2["Phase 2: Requirements"]
        direction TB
        REQ["/skill requirements-phase"]:::skill
    end

    subgraph P3["Phase 3: Planning"]
        direction TB
        PLAN["/skill planning-phase"]:::skill
    end

    subgraph P4["Phase 4: Approval"]
        direction TB
        HITL["/skill hitl-approval"]:::skill
    end

    subgraph P5["Phase 5: Investigation"]
        direction TB
        INV["/skill audit-investigation"]:::skill
    end

    subgraph P6["Phase 6: Resolution"]
        direction TB
        RES["/skill audit-resolution"]:::skill
    end

    subgraph P7["Phase 7: Remediation"]
        direction TB
        TPL["/skill template-update"]:::skill
        REM["/skill audit-remediation"]:::skill
        ACV["/skill ac-verification"]:::skill
        PRD["/skill production-check"]:::skill
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

**Execution:** PARALLEL - spawn both skills in single message

```mermaid
flowchart TB
    classDef skill fill:#fff8e1,stroke:#f57f17,stroke-width:2px
    classDef step fill:#f5f5f5,stroke:#616161,stroke-width:1px

    subgraph P1["Phase 1: Analysis"]
        subgraph SC["/skill scope-check"]
            SC1["Parse prompt for file/config references"]:::step
            SC2["Identify repos in scope"]:::step
            SC3["Identify files to audit"]:::step
            SC4["Return: repos[], files[]"]:::step
            SC1 --> SC2 --> SC3 --> SC4
        end

        subgraph AC["/skill agent-check"]
            AC1["Match files to config agents"]:::step
            AC2["Map: file → agent type"]:::step
            AC3["Return: agents[]"]:::step
            AC1 --> AC2 --> AC3
        end
    end
```

**Output:**

- `repos[]` - Repositories in scope
- `files[]` - Files to audit
- `agents[]` - Config agents matched to files

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
            R1["Parse scope + agent results"]:::step
            R2["BA understands task"]:::step

            subgraph LOOP["HITL Clarification Loop"]
                R3["HITL: Ask clarifying questions"]:::hitl
                R4["User answers"]:::hitl
                R5["BA updates understanding"]:::step
                R6{"More questions?"}
                R3 --> R4 --> R5 --> R6
                R6 -->|Yes| R3
            end

            R7["Create/Update PRD"]:::step
            R8["Create user stories"]:::step

            R1 --> R2 --> LOOP
            R6 -->|No| R7 --> R8 --> OUT((To Approval))
        end
    end
```

**Key:** Same skill for all commands - no mode parameter. BA gathers requirements, creates PRD + stories. Approval is separate phase.

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
            A3["Validate against templates"]:::step
            A4["Enrich stories with implementation details"]:::step
            A1 --> A2 --> A3 --> A4
        end

        subgraph PM["/skill planning-phase"]
            PM1["Review enriched stories"]:::step
            PM2["Group agents into waves (max 10 parallel)"]:::step
            PM3["Define execution order"]:::step
            PM4["Return: execution_plan with waves"]:::step
            PM1 --> PM2 --> PM3 --> PM4
        end

        ARCH --> PM
    end
```

**Output:** Enriched stories + `execution_plan` with waves of (agent, file) pairs

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
            H2["Present execution plan"]:::step
            H3["HITL: User reviews"]:::hitl
            H4{"User approves?"}
            H5["Collect feedback"]:::step
            H6["Return to Requirements phase"]:::step

            H1 --> H2 --> H3 --> H4
            H4 -->|No| H5 --> H6
            H4 -->|Yes| OUT((Approved))
        end
    end
```

**Key:** Separate phase for approval. User reviews PRD + execution plan. If rejected, returns to Requirements phase.

**Output:** Approved PRD + execution plan

---

## 6. Phase 5: Investigation (Exploded)

**Execution:** Parallel waves (max 10 per wave), READ-ONLY

```mermaid
flowchart TB
    classDef skill fill:#fff8e1,stroke:#f57f17,stroke-width:2px
    classDef step fill:#f5f5f5,stroke:#616161,stroke-width:1px
    classDef readonly fill:#e8f5e9,stroke:#2e7d32,stroke-width:1px

    subgraph P4["Phase 4: Investigation"]
        subgraph INV["/skill audit-investigation"]
            I1["For each wave, spawn config agents"]:::step
            I2["Agent reads template from skill"]:::readonly
            I3["Agent reads actual file from repo"]:::readonly
            I4["Agent compares field-by-field"]:::readonly
            I5["Agent reports discrepancies"]:::step
            I6["Aggregate all results"]:::step
            I7["Sort by severity: critical → warning → info"]:::step
            I1 --> I2 --> I3 --> I4 --> I5 --> I6 --> I7
        end
    end
```

**Key:** NO CHANGES MADE - agents only report findings

**Output:** Sorted list of discrepancies with line numbers, expected/actual values, severity

---

## 7. Phase 6: Resolution (Exploded)

**Execution:** Sequential HITL - one decision per discrepancy

```mermaid
flowchart TB
    classDef skill fill:#fff8e1,stroke:#f57f17,stroke-width:2px
    classDef step fill:#f5f5f5,stroke:#616161,stroke-width:1px
    classDef hitl fill:#ffcdd2,stroke:#c62828,stroke-width:1px

    subgraph P5["Phase 5: Resolution"]
        subgraph RES["/skill audit-resolution"]
            RS1["Present summary: X files, Y discrepancies"]:::step
            RS2["For each discrepancy:"]:::step
            RS3["Show file path, diff, template vs actual"]:::step
            RS4["HITL: What to do?"]:::hitl
            RS5["[1] Apply template"]:::step
            RS6["[2] Update template (PR to multi-mono)"]:::step
            RS7["[3] Ignore discrepancy"]:::step
            RS8["[4] Custom instruction"]:::step
            RS9["Record decision in story"]:::step
            RS1 --> RS2 --> RS3 --> RS4
            RS4 --> RS5 & RS6 & RS7 & RS8
            RS5 & RS6 & RS7 & RS8 --> RS9
        end
    end
```

**Output:** User decisions recorded per discrepancy

---

## 8. Phase 7: Remediation (Exploded)

**Execution:** Multiple skills, template-first updates

```mermaid
flowchart TB
    classDef skill fill:#fff8e1,stroke:#f57f17,stroke-width:2px
    classDef step fill:#f5f5f5,stroke:#616161,stroke-width:1px
    classDef validate fill:#e3f2fd,stroke:#1565c0,stroke-width:1px
    classDef hitl fill:#ffcdd2,stroke:#c62828,stroke-width:1px

    subgraph P6["Phase 6: Remediation"]

        subgraph TPLFIRST["/skill template-update (if any 'update template' decisions)"]
            T1["Update metasaver-marketplace template FIRST"]:::step
            T2["Read updated template text"]:::step
            T3["Use new template for remaining changes"]:::step
            T1 --> T2 --> T3
        end

        subgraph APPLY["/skill audit-remediation"]
            A1["Group 'apply' decisions by agent type"]:::step
            A2["Spawn remediation agents (max 10 parallel)"]:::step
            A3["Agents apply template to target files"]:::step
            A1 --> A2 --> A3
        end

        subgraph VERIFY["/skill ac-verification"]
            V1["For each user story:"]:::step
            V2["Check acceptance criteria met"]:::step
            V3{"All AC pass?"}
            V4["HITL: Report unmet AC"]:::hitl
            V1 --> V2 --> V3
            V3 -->|No| V4
        end

        subgraph VALIDATE["/skill production-check"]
            P1["Run: pnpm build"]:::validate
            P2["Run: pnpm lint"]:::validate
            P3["Run: pnpm test"]:::validate
            P4{"All pass?"}
            P5["Fix errors and retry"]:::step
            P1 --> P2 --> P3 --> P4
            P4 -->|No| P5 --> P1
        end

        TPLFIRST --> APPLY --> VERIFY
        V3 -->|Yes| VALIDATE
        P4 -->|Yes| OUT((Done))
    end
```

**Key:** Template updates happen FIRST in metasaver-marketplace, then that new text is used for all other changes.

**Skills in this phase:**
| Skill | Purpose |
| ----- | ------- |
| `/skill template-update` | Update source template in metasaver-marketplace |
| `/skill audit-remediation` | Apply templates to target files |
| `/skill ac-verification` | Verify user story acceptance criteria |
| `/skill production-check` | Build, lint, test validation |

**Output:** Fixes applied, templates updated, all AC verified, build passing

---

## 9. Phase 8: Report (Exploded)

**Execution:** Sequential

```mermaid
flowchart TB
    classDef skill fill:#fff8e1,stroke:#f57f17,stroke-width:2px
    classDef step fill:#f5f5f5,stroke:#616161,stroke-width:1px

    subgraph P7["Phase 7: Report"]
        subgraph RPT["/skill report-phase"]
            RP1["Executive Summary: X files, Y discrepancies, Z fixes"]:::step
            RP2["Actions Taken: Table of fixes by agent"]:::step
            RP3["Template Updates: PRs created"]:::step
            RP4["Accepted Deviations: Files where user chose ignore"]:::step
            RP5["Verification: Build/lint/test results"]:::step
            RP1 --> RP2 --> RP3 --> RP4 --> RP5
        end
    end
```

**Output:** Complete audit report in markdown

---

## 10. Quick Reference

| Phase | Skill                        | Agent                | Model  |
| ----- | ---------------------------- | -------------------- | ------ |
| 1     | `/skill scope-check`         | scope-check-agent    | sonnet |
| 1     | `/skill agent-check`         | agent-check-agent    | sonnet |
| 2     | `/skill requirements-phase`  | business-analyst     | opus   |
| 3     | `/skill architect-phase`     | architect            | sonnet |
| 3     | `/skill planning-phase`      | project-manager      | sonnet |
| 4     | `/skill hitl-approval`       | - (HITL)             | -      |
| 5     | `/skill audit-investigation` | config/domain agents | sonnet |
| 6     | `/skill audit-resolution`    | - (HITL)             | -      |
| 7     | `/skill template-update`     | coder                | sonnet |
| 7     | `/skill audit-remediation`   | config/domain agents | sonnet |
| 7     | `/skill ac-verification`     | reviewer             | sonnet |
| 7     | `/skill production-check`    | - (bash)             | -      |
| 8     | `/skill report-phase`        | business-analyst     | sonnet |

---

## 11. Examples

```bash
# Simple single-file audit
/audit "check eslint config"
→ P1: scope=[eslint.config.js], agents=[eslint-agent]
→ P2: BA confirms, creates story
→ P3: PM plans (1 wave)
→ P4: eslint-agent investigates
→ P5: User decides per discrepancy
→ P6: Apply fixes
→ P7: Report

# Domain audit (multiple files)
/audit "audit code quality configs"
→ P1: scope=[eslint, prettier, editorconfig], agents=[3 config agents]
→ P2-P7: Full workflow

# Cross-repo audit
/audit "audit eslint in all consumer repos"
→ P1: scope=[rugby-crm, resume-builder], agents=[eslint-agent x2]
→ P2-P7: Full workflow with wave execution
```

---

## 12. Enforcement Rules

1. **NO complexity check** - Audit is deterministic
2. **NO tool check** - Agents determined by scope
3. **NO vibe check** - Audit is compliance, not creation
4. **NO innovation phase** - Not applicable to audits
5. Investigation is **READ-ONLY** - No changes until approved
6. **Every discrepancy gets user decision** - No auto-fixes
7. Template updates create **PRs** - Never auto-merge
8. Always run **build/lint/test** after remediation
9. Always produce **final report**
