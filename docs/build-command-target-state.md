# Build Command Target State

Target workflow architecture for the `/build` command using Mermaid diagrams.

**Key difference from /audit:** Includes Innovate phase for PRD enhancement before Architecture.

---

## 1. High-Level Flow Overview

```mermaid
flowchart TB
    subgraph Entry["1. Entry Point"]
        A["/build {prompt}"]
    end

    subgraph Analysis["2-4. Analysis Phase (PARALLEL)"]
        B["Complexity Check<br/>(prompt) → int"]
        C["Tool Check<br/>(prompt) → string[]"]
        D["Scope Check<br/>(prompt) → string[]"]
    end

    subgraph Requirements["5-7. Requirements Phase"]
        E["Business Analyst<br/>Drafts PRD"]
        E2{"BA has questions?"}
        G["Ask User for Clarification"]
        E3["BA completes PRD"]
        F{"Vibe Check<br/>(prd) → bool"}
    end

    subgraph Innovate["7-8. Innovate Phase (OPTIONAL)"]
        H["User Reviews PRD"]
        I{"Want to Innovate?"}
        J["Innovation Advisor<br/>Suggests improvements"]
        K["User Selects<br/>(1:yes, 2:explain, rest:no)"]
        L["BA Updates PRD"]
        M{"Vibe Check<br/>(updated prd)"}
    end

    subgraph Validate["9. Human Validation"]
        N["User Validates<br/>Final PRD"]
    end

    subgraph Design["10-11. Design Phase"]
        O["Architect<br/>(prd, complexity, tools, scope) → arch_docs"]
        P["Project Manager<br/>(prd, arch_docs) → execution_plan"]
    end

    subgraph Execution["12-14. Execution Phase"]
        Q["Parallel Workers<br/>(instructions) → new_code"]
        R{"Production Check<br/>build, lint, test"}
        S{"Validate<br/>(prompt, new_code)"}
    end

    subgraph Output["15. Output"]
        T["Business Analyst<br/>Final Report to User"]
    end

    A --> B & C & D
    B & C & D --> E
    E --> F
    F -->|"❌ Fails"| G
    G -->|"Clarification"| E
    F -->|"✅ Pass"| H
    H --> I
    I -->|"No"| N
    I -->|"Yes"| J
    J --> K
    K --> L
    L --> M
    M -->|"❌ Fails"| L
    M -->|"✅ Pass"| N
    N --> O
    O --> P
    P --> Q
    Q --> R
    R -->|"❌ Fails"| Q
    R -->|"✅ Pass"| S
    S -->|"❌ Fails"| Q
    S -->|"✅ Pass"| T
```

---

## 2. Innovate Phase Detail

```mermaid
flowchart TB
    subgraph Input["From Requirements Phase"]
        PRD["Validated PRD"]
    end

    subgraph UserReview["Step 7: User Reviews PRD"]
        U1["Present PRD to User"]
        U2{"User confirms understanding"}
    end

    subgraph AskInnovate["Step 7b: Ask Innovation Question"]
        Q1["Do you want to innovate<br/>with industry best practices?"]
        Q2{"User Response"}
    end

    subgraph Innovation["Step 8: Innovation Sub-Workflow"]
        I1["Spawn Innovation Advisor"]
        I2["Analyze PRD for improvements"]
        I3["Present Numbered List:<br/>1. Add caching (High/Low)<br/>2. Add rate limiting (High/Low)<br/>3. Add observability (Med/Med)"]
        I4["User Responds:<br/>1: yes<br/>2: explain more<br/>3: no"]
        I5{"Explain Request?"}
        I6["Provide detailed explanation"]
        I7["BA Updates PRD<br/>with selected innovations"]
        I8{"Vibe Check<br/>Updated PRD"}
    end

    subgraph Output["To Human Validation"]
        OUT["Final PRD<br/>(original or enhanced)"]
    end

    PRD --> U1
    U1 --> U2
    U2 --> Q1
    Q1 --> Q2
    Q2 -->|"No"| OUT
    Q2 -->|"Yes"| I1
    I1 --> I2
    I2 --> I3
    I3 --> I4
    I4 --> I5
    I5 -->|"Yes"| I6
    I6 --> I4
    I5 -->|"No"| I7
    I7 --> I8
    I8 -->|"❌ Fails"| I7
    I8 -->|"✅ Pass"| OUT
```

---

## 3. Innovation Advisor Output Format

```mermaid
classDiagram
    class InnovationSuggestion {
        +number: int
        +title: string
        +category: Category
        +impact: Level
        +effort: Level
        +currentApproach: string
        +suggestedImprovement: string
        +rationale: string
        +implementationHint: string
    }

    class Category {
        <<enumeration>>
        Performance
        Security
        Maintainability
        Scalability
        DX
        Testing
        Accessibility
    }

    class Level {
        <<enumeration>>
        High
        Medium
        Low
    }

    class UserResponse {
        +suggestionNumber: int
        +response: ResponseType
    }

    class ResponseType {
        <<enumeration>>
        Yes
        No
        ExplainMore
    }

    InnovationSuggestion --> Category
    InnovationSuggestion --> Level
    UserResponse --> ResponseType
```

---

## 4. Human Validation Phase

```mermaid
flowchart TB
    subgraph Input["From Innovate Phase"]
        PRD["Final PRD<br/>(original or enhanced)"]
    end

    subgraph Validation["Step 9: Human Validates PRD"]
        V1["Present Final PRD"]
        V2["Summarize:<br/>- Requirements<br/>- Success Criteria<br/>- Deliverables<br/>- Innovations Applied (if any)"]
        V3{"User Approves?"}
        V4["User Requests Changes"]
        V5["BA Revises PRD"]
    end

    subgraph Output["To Design Phase"]
        OUT["Approved PRD"]
    end

    PRD --> V1
    V1 --> V2
    V2 --> V3
    V3 -->|"No"| V4
    V4 --> V5
    V5 --> V2
    V3 -->|"Yes"| OUT
```

---

## 5. Complete Sequence Diagram

```mermaid
sequenceDiagram
    participant U as User
    participant CMD as /build
    participant CC as Complexity Check
    participant TC as Tool Check
    participant SC as Scope Check
    participant BA as Business Analyst
    participant VC as Vibe Check
    participant IA as Innovation Advisor
    participant AR as Architect
    participant PM as Project Manager
    participant W as Workers
    participant PC as Production Check
    participant V as Validator

    U->>CMD: /build {prompt}

    rect rgb(230, 240, 250)
        Note over CC,SC: Phase 1: Analysis (PARALLEL)
        par Parallel Analysis
            CMD->>CC: prompt
            CC-->>CMD: complexity: int
        and
            CMD->>TC: prompt
            TC-->>CMD: tools: string[]
        and
            CMD->>SC: prompt
            SC-->>CMD: scope: string[]
        end
    end

    rect rgb(250, 240, 230)
        Note over BA,VC: Phase 2: Requirements
        CMD->>BA: prompt, complexity, tools, scope
        BA->>BA: Create PRD
        BA-->>VC: prd: string

        alt Vibe Check Fails
            VC->>U: Clarification questions
            U->>BA: Additional context
            BA-->>VC: revised_prd
        end
        VC-->>CMD: ✅ PRD validated
    end

    rect rgb(255, 250, 230)
        Note over U,IA: Phase 3: Innovate (OPTIONAL)
        CMD->>U: Review PRD - Want to innovate?

        alt User wants innovation
            U->>CMD: Yes, suggest improvements
            CMD->>IA: Analyze PRD
            IA-->>CMD: Numbered suggestions
            CMD->>U: Select improvements (1:yes, 2:explain, etc.)
            U->>CMD: 1:yes, 3:yes, rest:no
            CMD->>BA: Update PRD with selections
            BA-->>VC: updated_prd
            VC-->>CMD: ✅ Enhanced PRD validated
        else User skips innovation
            U->>CMD: No, proceed as-is
        end
    end

    rect rgb(230, 255, 230)
        Note over U: Phase 4: Human Validation
        CMD->>U: Validate final PRD
        U->>CMD: ✅ Approved
    end

    rect rgb(240, 250, 230)
        Note over AR,PM: Phase 5: Design
        CMD->>AR: prd, complexity, tools, scope
        AR-->>PM: arch_docs
        PM-->>CMD: execution_plan
    end

    rect rgb(250, 230, 240)
        Note over W,V: Phase 6: Execution
        CMD->>W: execution_plan.instructions

        loop Gantt-style Waves
            W->>W: Execute wave
            W-->>PC: new_code

            alt Production Check Fails
                PC->>W: Failed checks
            end
        end

        PC-->>V: ✅ All checks pass

        alt Validation Fails
            V->>W: Discrepancy report
        end

        V-->>CMD: ✅ Validated
    end

    rect rgb(230, 250, 250)
        Note over BA: Phase 7: Report
        CMD->>BA: All results
        BA-->>U: Final report
    end
```

---

## 6. Quick Reference

| Step | Function           | Input                            | Output           | Model        | Parallel |
| ---- | ------------------ | -------------------------------- | ---------------- | ------------ | -------- |
| 1    | Entry              | prompt                           | -                | -            | -        |
| 2    | Complexity Check   | prompt                           | int              | haiku        | ✅ 2-4   |
| 3    | Tool Check         | prompt                           | string[]         | haiku        | ✅ 2-4   |
| 4    | Scope Check        | prompt                           | string[]         | haiku        | ✅ 2-4   |
| 5    | Business Analyst   | prompt, complexity, tools, scope | PRD              | sonnet       | -        |
| 6    | Vibe Check         | prd                              | bool \| string[] | MCP Tool     | -        |
| 7    | User Review        | prd                              | approval         | Human        | -        |
| 8    | Innovation Advisor | prd                              | suggestions[]    | sonnet       | -        |
| 9    | User Selection     | suggestions                      | selections       | Human        | -        |
| 10   | BA Update PRD      | prd, selections                  | enhanced_prd     | sonnet       | -        |
| 11   | Vibe Check         | enhanced_prd                     | bool             | MCP Tool     | -        |
| 12   | Human Validation   | final_prd                        | approval         | Human        | -        |
| 13   | Architect          | prd, complexity, tools, scope    | arch_docs        | sonnet       | -        |
| 14   | Project Manager    | prd, arch_docs                   | execution_plan   | sonnet       | -        |
| 15   | Workers            | instructions                     | new_code         | haiku/sonnet | ✅ waves |
| 16   | Production Check   | new_code                         | bool             | Bash         | -        |
| 17   | Validate           | prompt, new_code                 | bool             | sonnet       | -        |
| 18   | Business Analyst   | results                          | report           | sonnet       | -        |

---

## 7. Phase Comparison: /build vs /audit

| Phase               | /audit              | /build              |
| ------------------- | ------------------- | ------------------- |
| 1. Analysis         | ✅ Same             | ✅ Same             |
| 2. Requirements     | ✅ BA + Vibe Check  | ✅ BA + Vibe Check  |
| 3. Innovate         | ❌ Skip             | ✅ Optional         |
| 4. Human Validation | ❌ Skip             | ✅ Required         |
| 5. Design           | ✅ Architect + PM   | ✅ Architect + PM   |
| 6. Execution        | ✅ Workers + Checks | ✅ Workers + Checks |
| 7. Report           | ✅ BA Report        | ✅ BA Report        |

**Why /audit skips Innovate:**

- Audit is for compliance checking against existing standards
- Innovation would change requirements, not validate them
- Audit PRDs define "what to check", not "what to build"

**Why /build has Innovate:**

- Build creates new features that benefit from best practices
- Innovation advisor catches missing patterns early
- PRDs can be enhanced before architecture locks decisions
