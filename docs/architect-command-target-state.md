# Architect Command Target State

Target workflow architecture for the `/architect` command - the planning command for when you don't know what to build.

**Purpose:** Explore, plan, innovate - creates comprehensive PRD for /build to execute.

**Use when:** You have a vague idea or problem but don't know exactly what to build.

**Output:** PRD file ready for `/build {prd-path}` to execute.

---

## 1. High-Level Workflow (Skills Only)

```mermaid
flowchart TB
    classDef phase fill:#bbdefb,stroke:#1565c0,stroke-width:2px
    classDef skill fill:#fff8e1,stroke:#f57f17,stroke-width:2px
    classDef entry fill:#f3e5f5,stroke:#7b1fa2,stroke-width:2px
    classDef decision fill:#ffe0b2,stroke:#ef6c00,stroke-width:2px

    ENTRY["/architect {idea/problem}"]:::entry

    subgraph P1["Phase 1: Analysis"]
        direction TB
        CC["/skill complexity-check"]:::skill
        SC["/skill scope-check"]:::skill
    end

    DECIDE{{"complexity < 15?"}}:::decision

    subgraph FAST["FAST PATH"]
        direction TB
        subgraph P2F["Requirements"]
            REQF["/skill requirements-phase"]:::skill
        end
        subgraph P5F["Design"]
            PLANF["/skill planning-phase"]:::skill
        end
        subgraph P6F["Approval"]
            HITLF["/skill hitl-approval"]:::skill
        end
        subgraph P7F["Output"]
            SAVEF["/skill save-prd"]:::skill
        end
        P2F --> P5F --> P6F --> P7F
    end

    subgraph FULL["FULL PATH"]
        direction TB
        subgraph P2["Requirements"]
            REQ["/skill requirements-phase"]:::skill
        end
        subgraph P3["Vibe Check"]
            VC["/skill vibe-check"]:::skill
        end
        subgraph P4["Innovation"]
            INN["/skill innovate-phase"]:::skill
        end
        subgraph P5["Design"]
            ARCH["/skill architect-phase"]:::skill
            PLAN["/skill planning-phase"]:::skill
        end
        subgraph P6["Approval"]
            HITL["/skill hitl-approval"]:::skill
        end
        subgraph P7["Output"]
            SAVE["/skill save-prd"]:::skill
        end
        P2 --> P3 --> P4 --> P5 --> P6 --> P7
    end

    ENTRY --> P1 --> DECIDE
    DECIDE -->|Yes| FAST
    DECIDE -->|No| FULL
```

**Legend:**

| Color  | Meaning           |
| ------ | ----------------- |
| Purple | Entry point       |
| Blue   | Phase container   |
| Yellow | Skill (reusable)  |
| Orange | Complexity router |

**Fast Path (<15):** Skip Vibe Check, Innovation, architect-phase. Quick requirements → planning → approve → save.

**Full Path (≥15):** Deep exploration with vibe check, innovation advisor, full architecture.

---

## 2. Phase 1: Analysis (Exploded)

**Execution:** PARALLEL - spawn both skills in single message

```mermaid
flowchart TB
    classDef skill fill:#fff8e1,stroke:#f57f17,stroke-width:2px
    classDef step fill:#f5f5f5,stroke:#616161,stroke-width:1px

    subgraph P1["Phase 1: Analysis"]
        subgraph CC["/skill complexity-check"]
            CC1["Analyze prompt complexity"]:::step
            CC2["Return: score (1-50)"]:::step
            CC1 --> CC2
        end

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

- `complexity` - Score 1-50 (drives model selection)
- `targets[]` - Repos/paths to modify
- `references[]` - Repos/paths to use as patterns

---

## 3. Phase 2: Requirements (Exploded)

**Execution:** Sequential with deep HITL exploration loop

```mermaid
flowchart TB
    classDef skill fill:#fff8e1,stroke:#f57f17,stroke-width:2px
    classDef step fill:#f5f5f5,stroke:#616161,stroke-width:1px
    classDef hitl fill:#ffcdd2,stroke:#c62828,stroke-width:1px

    subgraph P2["Phase 2: Requirements"]
        subgraph REQ["/skill requirements-phase"]
            R1["Parse scope results"]:::step
            R2["BA understands problem space"]:::step
            R3["Research existing solutions"]:::step

            subgraph LOOP["Deep HITL Exploration Loop"]
                R4["HITL: Ask exploration questions"]:::hitl
                R5["User answers"]:::hitl
                R6["BA refines understanding"]:::step
                R7{"More questions?"}
                R4 --> R5 --> R6 --> R7
                R7 -->|Yes| R4
            end

            R8["Create/Update PRD"]:::step
            R9["Create user stories with AC"]:::step

            R1 --> R2 --> R3 --> LOOP
            R7 -->|No| R8 --> R9 --> OUT((To Vibe Check))
        end
    end
```

**Key:** Deep exploration - BA asks many questions to understand vague requirements.

**Output:** Draft PRD + user stories (not yet validated)

---

## 4. Phase 3: Vibe Check (Exploded)

**Execution:** Single MCP tool call

```mermaid
flowchart TB
    classDef skill fill:#fff8e1,stroke:#f57f17,stroke-width:2px
    classDef step fill:#f5f5f5,stroke:#616161,stroke-width:1px
    classDef hitl fill:#ffcdd2,stroke:#c62828,stroke-width:1px

    subgraph P3["Phase 3: Vibe Check"]
        subgraph VC["/skill vibe-check"]
            V1["Analyze PRD for coherence"]:::step
            V2["Check requirements clarity"]:::step
            V3["Validate user stories"]:::step
            V4["Identify gaps"]:::step
            V5{{"PRD coherent?"}}
            V6["Report issues"]:::step

            V1 --> V2 --> V3 --> V4 --> V5
            V5 -->|No| V6 --> BACK((Return to Requirements))
            V5 -->|Yes| OUT((To Innovation))
        end
    end
```

**Key:** Quality gate before innovation phase.

**On failure:** Return to Requirements phase for revision.

---

## 5. Phase 4: Innovation (Exploded)

**Execution:** Sequential with HITL selection per innovation

```mermaid
flowchart TB
    classDef skill fill:#fff8e1,stroke:#f57f17,stroke-width:2px
    classDef step fill:#f5f5f5,stroke:#616161,stroke-width:1px
    classDef hitl fill:#ffcdd2,stroke:#c62828,stroke-width:1px

    subgraph P4["Phase 4: Innovation"]
        subgraph INN["/skill innovate-phase"]
            I1["Analyze PRD for enhancement opportunities"]:::step
            I2["Return structured innovations (JSON)"]:::step

            subgraph INNLOOP["For Each Innovation"]
                I3["Present 1-pager summary"]:::step
                I4["HITL: Implement / Skip / More Details"]:::hitl
                I5{{"User choice"}}
                I6["Add to selections"]:::step
                I7["Show full explanation"]:::step

                I3 --> I4 --> I5
                I5 -->|Implement| I6
                I5 -->|Skip| NEXT((Next))
                I5 -->|More Details| I7 --> I4
            end

            I8["Update PRD with selected innovations"]:::step

            I1 --> I2 --> INNLOOP
            I6 --> NEXT
            INNLOOP --> I8 --> OUT((To Design))
        end
    end
```

**Key:** ALWAYS runs for /architect (unlike /build where it's skipped).

**Output:** PRD updated with user-selected innovations

---

## 6. Phase 5: Design (Exploded)

**Execution:** Sequential - architect first, then planning

```mermaid
flowchart TB
    classDef skill fill:#fff8e1,stroke:#f57f17,stroke-width:2px
    classDef step fill:#f5f5f5,stroke:#616161,stroke-width:1px

    subgraph P5["Phase 5: Design"]
        subgraph ARCH["/skill architect-phase"]
            A1["Check multi-mono for existing solutions"]:::step
            A2["Find example files as reference"]:::step
            A3["Validate against Context7 docs"]:::step
            A4["Enrich stories with implementation details"]:::step
            A5["Add: files to create/modify, imports, patterns"]:::step
            A1 --> A2 --> A3 --> A4 --> A5
        end

        subgraph PLANNING["/skill planning-phase"]
            PL1["Review enriched stories"]:::step
            PL2["Identify dependencies between stories"]:::step
            PL3["Group into execution waves"]:::step
            PL4["Create Gantt chart"]:::step
            PL5["Return: execution_plan"]:::step
            PL1 --> PL2 --> PL3 --> PL4 --> PL5
        end

        ARCH --> PLANNING
    end
```

**Output:** Enriched stories + execution plan with waves

---

## 7. Phase 6: Approval (Exploded)

**Execution:** HITL approval loop

```mermaid
flowchart TB
    classDef skill fill:#fff8e1,stroke:#f57f17,stroke-width:2px
    classDef step fill:#f5f5f5,stroke:#616161,stroke-width:1px
    classDef hitl fill:#ffcdd2,stroke:#c62828,stroke-width:1px

    subgraph P6["Phase 6: Approval"]
        subgraph HITL["/skill hitl-approval"]
            H1["Present PRD summary"]:::step
            H2["Present enriched stories"]:::step
            H3["Present selected innovations"]:::step
            H4["Present execution plan"]:::step
            H5["HITL: User reviews"]:::hitl
            H6{{"User approves?"}}
            H7["Collect feedback"]:::step
            H8["Return to Requirements phase"]:::step

            H1 --> H2 --> H3 --> H4 --> H5 --> H6
            H6 -->|No| H7 --> H8
            H6 -->|Yes| OUT((Approved))
        end
    end
```

**Key:** User reviews complete PRD + plan before finalizing.

**Output:** Approved PRD + execution plan

---

## 8. Phase 7: Output (Exploded)

**Execution:** Sequential

```mermaid
flowchart TB
    classDef skill fill:#fff8e1,stroke:#f57f17,stroke-width:2px
    classDef step fill:#f5f5f5,stroke:#616161,stroke-width:1px

    subgraph P7["Phase 7: Output"]
        subgraph SAVE["/skill save-prd"]
            S1["Create directory: docs/projects/{yyyymmdd}-{name}/"]:::step
            S2["Save prd.md"]:::step
            S3["Save user-stories/ directory"]:::step
            S4["Save execution-plan.md"]:::step
            S5["Save innovations-selected.md"]:::step
            S6["Save architecture-notes.md"]:::step
            S7["Tell user: Run /build {path}/prd.md"]:::step
            S1 --> S2 --> S3 --> S4 --> S5 --> S6 --> S7
        end
    end
```

**Output:** PRD file structure ready for `/build {prd-path}` to execute

**NO EXECUTION** - /architect is planning only.

---

## 9. Quick Reference

| Phase | Skill                       | Agent              | Model  |
| ----- | --------------------------- | ------------------ | ------ |
| 1     | `/skill scope-check`        | scope-check-agent  | sonnet |
| 2     | `/skill requirements-phase` | business-analyst   | opus   |
| 3     | `/skill vibe-check`         | (MCP tool)         | -      |
| 4     | `/skill innovate-phase`     | innovation-advisor | opus   |
| 5     | `/skill architect-phase`    | architect          | sonnet |
| 5     | `/skill planning-phase`     | project-manager    | sonnet |
| 6     | `/skill hitl-approval`      | - (HITL)           | -      |
| 7     | `/skill save-prd`           | -                  | -      |

**Note:** /architect uses opus for BA exploration and innovation because user doesn't know what they want.

---

## 10. Examples

```bash
# Vague problem
/architect "I need to handle user authentication somehow"
→ P1: scope=[current repo]
→ P2: BA explores: OAuth? JWT? Session? What's your user base?
→ P2: Many questions, draft PRD
→ P3: Vibe check passes
→ P4: Innovate: "Consider passwordless auth, SSO, MFA..."
→ P4: User selects innovations
→ P5: Architect validates, PM plans
→ P6: User approves
→ P7: PRD saved
→ "Run /build docs/projects/20251217-user-auth/prd.md"

# Feature idea
/architect "I want to add a dashboard but not sure what should be on it"
→ P1: scope=[current repo]
→ P2: BA explores: Who uses it? What metrics matter? Real-time?
→ P2: Deep exploration, draft PRD
→ P3: Vibe check passes
→ P4: Innovate: "Consider widgets, customization, export..."
→ P4: User selects
→ P5: Architect validates against existing components
→ P5: PM creates phased plan
→ P6: User approves
→ P7: PRD saved

# Integration problem
/architect "need to integrate with Stripe but not sure best approach"
→ P1: scope=[current repo]
→ P2: BA explores: What payments? Subscriptions? One-time?
→ P2: HITL: Payment flows, webhooks, error handling
→ P3: Vibe check passes
→ P4: Innovate: "Consider checkout sessions, payment intents..."
→ P5: Architect checks Context7 for Stripe patterns
→ P6: User approves
→ P7: PRD saved
```

---

## 11. Enforcement Rules

1. ALWAYS run Analysis phase first (scope only, NO complexity-check)
2. BA must do DEEP exploration - ask many questions
3. ALWAYS run Vibe Check on PRD
4. ALWAYS run Innovate phase (unlike /build which skips it)
5. Architect must check multi-mono before enriching stories
6. Architect must validate against Context7 docs
7. Planning must create execution plan with waves
8. Final approval required before saving PRD
9. **NO EXECUTION** - output is PRD only
10. Tell user to run `/build {prd-path}` to execute

---

## 12. Comparison: /architect vs /build

| Aspect         | /architect               | /build                   |
| -------------- | ------------------------ | ------------------------ |
| **When**       | Don't know what to build | Know what to build       |
| **Input**      | Vague idea/problem       | Clear requirement or PRD |
| **BA**         | Deep exploration         | Clarify details          |
| **Vibe Check** | YES                      | NO                       |
| **Innovate**   | ALWAYS                   | NEVER                    |
| **Model**      | opus for BA              | sonnet for BA            |
| **Output**     | PRD                      | Code                     |
| **Execution**  | NO                       | YES                      |

---

## 13. Output Structure

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
