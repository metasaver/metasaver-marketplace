# Audit Command Target State

Target workflow architecture for the `/audit` command using Mermaid diagrams.

**Key differences from /build:**

- No Innovate phase - Audit is for compliance checking, not feature improvement
- Human validation (prd-approval) for complexity ≥15 before Architecture

---

## 1. High-Level Flow Overview

```mermaid
flowchart TB
    subgraph Entry["1. Entry Point"]
        A["/audit {prompt}"]
    end

    subgraph Analysis["2-4. Analysis Phase (PARALLEL)"]
        B["Complexity Check<br/>(prompt) → int"]
        C["Tool Check<br/>(prompt) → string[]"]
        D["Scope Check<br/>(prompt) → string[]"]
    end

    subgraph Requirements["5-6. Requirements Phase"]
        E["Business Analyst<br/>(prompt, complexity, tools, scope) → PRD"]
        F{"Vibe Check<br/>(prd) → bool"}
        G["Ask User for Clarification"]
    end

    subgraph HumanVal["7. PRD Approval (if complexity ≥15)"]
        H0["Present PRD Summary"]
        H1{"User Approves?"}
        H2["User Requests Changes"]
        H3["BA Revises PRD"]
    end

    subgraph Design["8-9. Design Phase"]
        H["Architect<br/>(prd, complexity, tools, scope) → arch_docs"]
        I["Project Manager<br/>(prd, arch_docs) → execution_plan"]
    end

    subgraph Execution["10-12. Execution Phase"]
        J["Parallel Workers<br/>(instructions) → new_code"]
        K{"Production Check<br/>build, lint, test"}
        L{"Validate<br/>(prompt, new_code)"}
    end

    subgraph Output["13. Output"]
        M["Business Analyst<br/>Final Report to User"]
    end

    A --> B & C & D
    B & C & D --> E
    E --> F
    F -->|"❌ Fails"| G
    G -->|"Clarification"| E
    F -->|"✅ Pass (complexity ≥15)"| H0
    F -->|"✅ Pass (complexity <15)"| H
    H0 --> H1
    H1 -->|"❌ No"| H2
    H2 --> H3
    H3 --> H0
    H1 -->|"✅ Yes"| H
    H --> I
    I --> J
    J --> K
    K -->|"❌ Fails"| J
    K -->|"✅ Pass"| L
    L -->|"❌ Fails"| J
    L -->|"✅ Pass"| M
```

---

## 2. Complete Sequence Diagram

```mermaid
sequenceDiagram
    participant U as User
    participant CMD as /audit
    participant CC as Complexity Check
    participant TC as Tool Check
    participant SC as Scope Check
    participant BA as Business Analyst
    participant VC as Vibe Check
    participant AR as Architect
    participant PM as Project Manager
    participant W as Workers
    participant PC as Production Check
    participant V as Validator

    U->>CMD: /audit {prompt}

    rect rgb(230, 240, 250)
        Note over CC,SC: Phase 1: Analysis (PARALLEL)
        par Parallel Analysis
            CMD->>CC: prompt
            CC->>CC: Calculate complexity score
            CC-->>CMD: complexity: int
        and
            CMD->>TC: prompt
            TC->>TC: Determine MCP servers
            TC-->>CMD: tools: string[]
        and
            CMD->>SC: prompt
            SC->>SC: Identify repos/files
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
            BA->>BA: Revise PRD
            BA-->>VC: revised_prd
        end
        VC-->>CMD: ✅ PRD validated
    end

    rect rgb(230, 255, 230)
        Note over U: Phase 3: PRD Approval (complexity ≥15)
        CMD->>U: Approve PRD?
        alt User Requests Changes
            U->>CMD: Needs changes
            CMD->>BA: Revise PRD
            BA-->>CMD: Revised PRD
            CMD->>U: Approve revised PRD?
        end
        U->>CMD: ✅ Approved
    end

    rect rgb(240, 250, 230)
        Note over AR,PM: Phase 4: Design
        CMD->>AR: prd, complexity, tools, scope
        AR->>AR: Create architecture docs
        AR-->>PM: arch_docs: string

        PM->>PM: Plan agents + Gantt schedule
        PM-->>CMD: execution_plan: object
    end

    rect rgb(250, 230, 240)
        Note over W,V: Phase 4: Execution
        CMD->>W: execution_plan.instructions

        loop Gantt-style Waves
            W->>W: Execute wave (max 10 parallel)
            W-->>PC: new_code: object

            alt Production Check Fails
                PC->>W: Failed checks + errors
                W->>W: Fix and retry
            end
        end

        PC-->>V: ✅ All checks pass
        V->>V: Compare output vs prompt

        alt Validation Fails
            V->>W: Discrepancy report
            W->>W: Adjust implementation
        end

        V-->>CMD: ✅ Validated
    end

    rect rgb(230, 250, 250)
        Note over BA: Phase 5: Report
        CMD->>BA: All results
        BA->>BA: Generate final report
        BA-->>U: Consolidated report
    end
```

---

## 3. Function Signatures

```mermaid
classDiagram
    class AuditCommand {
        +entry(prompt: string) void
    }

    class ComplexityCheck {
        +calculate(prompt: string) int
        -keywords: Map~string, int~
        -patterns: RegExp[]
        -thresholds: Thresholds
    }

    class ToolCheck {
        +determine(prompt: string) string[]
        -mcpServers: string[]
        -toolMatrix: Map~string, string[]~
    }

    class ScopeCheck {
        +identify(prompt: string) string[]
        -scanRepos() Repository[]
        -filterByPackageJson(repos: Repository[]) Repository[]
        -matchToPrompt(repos: Repository[], prompt: string) string[]
    }

    class BusinessAnalyst {
        +createPRD(prompt: string, complexity: int, tools: string[], scope: string[]) PRD
        +generateReport(results: ExecutionResults) FinalReport
        -analyzeRequirements() Requirements
        -defineSuccessCriteria() Criteria
    }

    class VibeCheck {
        +validate(prd: PRD) ValidationResult
        -checkCompleteness() bool
        -checkFeasibility() bool
        -checkAlignment() bool
        -identifyGaps() string[]
    }

    class Architect {
        +design(prd: PRD, complexity: int, tools: string[], scope: string[]) ArchDocs
        -selectPatterns() Pattern[]
        -defineInterfaces() Interface[]
        -planIntegration() IntegrationPlan
    }

    class ProjectManager {
        +plan(prd: PRD, archDocs: ArchDocs) ExecutionPlan
        -selectAgents() Agent[]
        -createGantt() GanttSchedule
        -assignWaves() Wave[]
    }

    class Workers {
        +execute(instructions: Instructions) NewCode
        -processWave(wave: Wave) WaveResult
        -runParallel(agents: Agent[]) AgentResult[]
    }

    class ProductionCheck {
        +validate(newCode: NewCode) CheckResult
        -runBuild() bool
        -runEslint() bool
        -runPrettier() bool
        -runTsc() bool
        -runTests() bool
    }

    class Validator {
        +compare(prompt: string, newCode: NewCode) ValidationResult
        -checkRequirementsCovered() bool
        -identifyDiscrepancies() Discrepancy[]
    }

    AuditCommand --> ComplexityCheck
    AuditCommand --> ToolCheck
    AuditCommand --> ScopeCheck
    AuditCommand --> BusinessAnalyst
    BusinessAnalyst --> VibeCheck
    VibeCheck --> Architect
    Architect --> ProjectManager
    ProjectManager --> Workers
    Workers --> ProductionCheck
    ProductionCheck --> Validator
    Validator --> BusinessAnalyst
```

---

## 4. Feedback Loops Detail

```mermaid
flowchart TD
    subgraph Loop1["Vibe Check Loop"]
        BA1["Business Analyst<br/>Creates PRD"]
        VC1{"Vibe Check<br/>Validates PRD"}
        U1["User<br/>Provides Clarification"]

        BA1 --> VC1
        VC1 -->|"❌ Gaps Found"| U1
        U1 -->|"Context"| BA1
        VC1 -->|"✅ Valid"| OUT1((Continue))
    end

    subgraph Loop2["Production Check Loop"]
        W2["Worker Agent<br/>Generates Code"]
        PC2{"Production Check<br/>build, lint, test"}

        W2 --> PC2
        PC2 -->|"❌ Fails"| W2
        PC2 -->|"✅ Pass"| OUT2((Continue))
    end

    subgraph Loop3["Validation Loop"]
        W3["Worker Agent<br/>Implementation"]
        V3{"Validator<br/>Compares to Requirements"}

        W3 --> V3
        V3 -->|"❌ Mismatch"| W3
        V3 -->|"✅ Match"| OUT3((Continue))
    end
```

---

## 5. Analysis Phase Detail (Parallel Execution)

```mermaid
flowchart TB
    subgraph Input["Input"]
        P["prompt: string"]
    end

    subgraph Parallel["PARALLEL EXECUTION"]
        subgraph Complexity["Complexity Check"]
            C1["Keyword Detection"]
            C2["Pattern Matching"]
            C3["Scope Analysis"]
            C4["Score Calculation"]

            C1 --> C4
            C2 --> C4
            C3 --> C4
        end

        subgraph Tools["Tool Check"]
            T1["Analyze prompt keywords"]
            T2["Match to tool matrix"]
            T3["Return required MCP servers"]

            T1 --> T2 --> T3
        end

        subgraph Scope["Scope Check"]
            S1["Scan /mnt/f/code/"]
            S2["Read package.json"]
            S3{"@metasaver?"}
            S4["Classify: lib/consumer"]
            S5["Match to prompt"]

            S1 --> S2 --> S3
            S3 -->|"Yes"| S4 --> S5
        end
    end

    subgraph Output["Aggregated Output"]
        O1["complexity: int"]
        O2["tools: string[]"]
        O3["scope: string[]"]
    end

    P --> Complexity & Tools & Scope
    C4 --> O1
    T3 --> O2
    S5 --> O3
```

---

## 6. Requirements Phase Detail

```mermaid
flowchart TB
    subgraph Inputs["Inputs to BA"]
        I1["prompt: string"]
        I2["complexity: int"]
        I3["tools: string[]"]
        I4["scope: string[]"]
    end

    subgraph BA["Business Analyst"]
        BA1["Analyze Requirements"]
        BA2["Define Success Criteria"]
        BA3["Set Compliance Metrics"]
        BA4["Generate PRD"]
    end

    subgraph PRD["PRD Structure"]
        P1["scope: full | partial | specific"]
        P2["domains: string[]"]
        P3["criteria: string"]
        P4["successMetrics: object"]
    end

    subgraph Vibe["Vibe Check (MCP Tool)"]
        V1["✅ No duplicate work (25%)"]
        V2["✅ Pattern compliance known (25%)"]
        V3["✅ Architecture verified (20%)"]
        V4["✅ Examples found (15%)"]
        V5["✅ Requirements clear (15%)"]
        VR{"Score?"}
    end

    subgraph Decision["Decision"]
        D1["≥90%: PROCEED"]
        D2["70-89%: CLARIFY"]
        D3["<70%: STOP"]
    end

    Inputs --> BA
    BA1 --> BA2 --> BA3 --> BA4
    BA4 --> PRD
    PRD --> Vibe
    V1 & V2 & V3 & V4 & V5 --> VR
    VR -->|"≥90%"| D1
    VR -->|"70-89%"| D2
    VR -->|"<70%"| D3
    D2 -->|"User clarifies"| BA
```

---

## 7. Design Phase Detail

```mermaid
flowchart TB
    subgraph Architect["Architect Phase"]
        A1["Receive PRD"]
        A2["Select Design Patterns"]
        A3["Define Component Interfaces"]
        A4["Plan Integration Points"]
        A5["Document Architecture"]
    end

    subgraph ArchDocs["Architecture Documents"]
        AD1["Component Diagram"]
        AD2["Interface Definitions"]
        AD3["Data Flow"]
        AD4["Integration Plan"]
    end

    subgraph PM["Project Manager Phase"]
        PM1["Analyze Architecture"]
        PM2["Select Sub-Agents"]
        PM3["Create Dependencies Graph"]
        PM4["Build Gantt Schedule"]
        PM5["Organize Waves"]
    end

    subgraph Plan["Execution Plan"]
        EP1["agents: Agent[]"]
        EP2["waves: Wave[]"]
        EP3["dependencies: Graph"]
        EP4["schedule: Gantt"]
    end

    A1 --> A2 --> A3 --> A4 --> A5
    A5 --> ArchDocs
    ArchDocs --> PM1
    PM1 --> PM2 --> PM3 --> PM4 --> PM5
    PM5 --> Plan
```

---

## 8. Execution Phase - Gantt-Style Waves

```mermaid
gantt
    title Parallel Worker Execution
    dateFormat X
    axisFormat %s

    section Wave 1
    eslint-agent       :w1a, 0, 3
    prettier-agent     :w1b, 0, 2
    typescript-agent   :w1c, 0, 4
    editorconfig-agent :w1d, 0, 2
    turbo-agent        :w1e, 0, 3
    pnpm-workspace-agent :w1f, 0, 2
    vite-agent         :w1g, 0, 3
    vitest-agent       :w1h, 0, 3
    postcss-agent      :w1i, 0, 2
    tailwind-agent     :w1j, 0, 3

    section Wave 2
    gitignore-agent    :w2a, after w1a, 2
    gitattributes-agent :w2b, after w1a, 2
    husky-agent        :w2c, after w1a, 3
    commitlint-agent   :w2d, after w1a, 2
    github-workflow-agent :w2e, after w1a, 4
    nvmrc-agent        :w2f, after w1a, 1
    readme-agent       :w2g, after w1a, 3
    vscode-agent       :w2h, after w1a, 2
    scripts-agent      :w2i, after w1a, 2
    claude-md-agent    :w2j, after w1a, 2

    section Wave 3
    env-example-agent  :w3a, after w2a, 2
    nodemon-agent      :w3b, after w2a, 2
    npmrc-template-agent :w3c, after w2a, 1
    repomix-config-agent :w3d, after w2a, 2
    root-package-json-agent :w3e, after w2a, 3
    monorepo-structure-agent :w3f, after w2a, 2

    section Quality Gates
    Production Check   :crit, pc, after w3f, 2
    Validation         :crit, val, after pc, 2
```

---

## 9. Production Check Detail

```mermaid
flowchart TB
    subgraph Input["Input"]
        NC["new_code: object"]
    end

    subgraph Checks["Production Checks"]
        C1["pnpm build"]
        C2["pnpm lint (eslint)"]
        C3["pnpm format:check (prettier)"]
        C4["pnpm tsc --noEmit"]
        C5["pnpm test:unit"]
    end

    subgraph Results["Results"]
        R1{"All Pass?"}
        PASS["✅ Continue to Validation"]
        FAIL["❌ Return to Worker"]
    end

    subgraph ErrorReport["Error Report"]
        E1["failing_check: string"]
        E2["error_output: string"]
        E3["affected_files: string[]"]
        E4["suggested_fix: string"]
    end

    NC --> C1 & C2 & C3 & C4 & C5
    C1 & C2 & C3 & C4 & C5 --> R1
    R1 -->|"Yes"| PASS
    R1 -->|"No"| ErrorReport
    ErrorReport --> FAIL
```

---

## 10. Validation Phase Detail

```mermaid
flowchart TB
    subgraph Inputs["Inputs"]
        P["Original prompt"]
        NC["new_code: object"]
        PRD["PRD from BA"]
    end

    subgraph Validator["Validation Process"]
        V1["Extract Requirements<br/>from PRD"]
        V2["Map Code Changes<br/>to Requirements"]
        V3["Check Coverage"]
        V4["Identify Gaps"]
    end

    subgraph Checks["Validation Checks"]
        CH1["All requirements addressed?"]
        CH2["No scope creep?"]
        CH3["Matches original intent?"]
        CH4["Quality standards met?"]
    end

    subgraph Decision["Decision"]
        D{"All Checks Pass?"}
        PASS["✅ Proceed to BA Report"]
        FAIL["❌ Return to Worker"]
    end

    subgraph Discrepancy["Discrepancy Report"]
        DR1["missing_requirements: string[]"]
        DR2["unmatched_code: string[]"]
        DR3["quality_issues: string[]"]
        DR4["recommended_fixes: string[]"]
    end

    Inputs --> Validator
    V1 --> V2 --> V3 --> V4
    V4 --> Checks
    CH1 & CH2 & CH3 & CH4 --> D
    D -->|"Yes"| PASS
    D -->|"No"| Discrepancy
    Discrepancy --> FAIL
```

---

## 11. Final Report Flow

```mermaid
flowchart TB
    subgraph Inputs["Aggregated Results"]
        I1["All worker outputs"]
        I2["Production check results"]
        I3["Validation results"]
        I4["Original PRD"]
    end

    subgraph BA["Business Analyst - Report Generation"]
        BA1["Aggregate Results"]
        BA2["Calculate Metrics"]
        BA3["Compare to Success Criteria"]
        BA4["Generate Recommendations"]
        BA5["Format Report"]
    end

    subgraph Report["Final Report Structure"]
        R1["Executive Summary"]
        R2["Status by Domain"]
        R3["Metrics Dashboard"]
        R4["Prioritized Findings"]
        R5["Remediation Options"]
        R6["Next Steps"]
    end

    subgraph Output["User Output"]
        O["Formatted Report<br/>to User"]
    end

    Inputs --> BA
    BA1 --> BA2 --> BA3 --> BA4 --> BA5
    BA5 --> Report
    Report --> O
```

---

## 12. Complete State Machine

```mermaid
stateDiagram-v2
    [*] --> Entry: /audit {prompt}

    state Analysis {
        Entry --> ParallelAnalysis: prompt
        state ParallelAnalysis {
            [*] --> ComplexityCheck
            [*] --> ToolCheck
            [*] --> ScopeCheck
            ComplexityCheck --> [*]
            ToolCheck --> [*]
            ScopeCheck --> [*]
        }
    }

    state Requirements {
        ParallelAnalysis --> BusinessAnalyst: complexity, tools, scope
        BusinessAnalyst --> VibeCheck: PRD
        VibeCheck --> UserClarify: <70% or gaps
        UserClarify --> BusinessAnalyst: clarification
        VibeCheck --> Design: ≥90%
    }

    state Design {
        VibeCheck --> Architect: validated PRD
        Architect --> ProjectManager: arch_docs
        ProjectManager --> Execution: execution_plan
    }

    state Execution {
        ProjectManager --> Workers: waves
        Workers --> ProductionCheck: new_code
        ProductionCheck --> Workers: ❌ fix errors
        ProductionCheck --> Validator: ✅ pass
        Validator --> Workers: ❌ discrepancies
        Validator --> Report: ✅ validated
    }

    state Report {
        Validator --> FinalBA: all results
        FinalBA --> [*]: report to user
    }
```

---

## Quick Reference

| Step | Function         | Input                            | Output           | Model       | Parallel | Condition     |
| ---- | ---------------- | -------------------------------- | ---------------- | ----------- | -------- | ------------- |
| 1    | Entry            | prompt                           | -                | -           | -        | -             |
| 2    | Complexity Check | prompt                           | int              | haiku       | ✅ 2-4   | -             |
| 3    | Tool Check       | prompt                           | string[]         | haiku       | ✅ 2-4   | -             |
| 4    | Scope Check      | prompt                           | string[]         | haiku       | ✅ 2-4   | -             |
| 5    | Business Analyst | prompt, complexity, tools, scope | PRD              | sonnet/opus | -        | -             |
| 6    | Vibe Check       | prd                              | bool \| string[] | MCP Tool    | -        | -             |
| 7    | PRD Approval     | prd                              | approval         | Human       | -        | complexity≥15 |
| 8    | Architect        | prd, complexity, tools, scope    | arch_docs        | sonnet      | -        | -             |
| 9    | Project Manager  | prd, arch_docs                   | execution_plan   | sonnet      | -        | -             |
| 10   | Workers          | instructions                     | new_code         | haiku       | ✅ waves | -             |
| 11   | Production Check | new_code                         | bool             | Bash        | -        | -             |
| 12   | Validate         | prompt, new_code                 | bool             | sonnet      | -        | -             |
| 13   | Business Analyst | results                          | report           | sonnet      | -        | -             |

| Feedback Loop       | Trigger               | Target             | Resolution                 |
| ------------------- | --------------------- | ------------------ | -------------------------- |
| Vibe Check → BA     | PRD validation fails  | Business Analyst   | User clarifies, BA revises |
| PRD Approval → BA   | User requests changes | Business Analyst   | BA revises PRD             |
| Production → Worker | Build/lint/test fails | Originating worker | Fix code, re-run checks    |
| Validate → Worker   | Requirements mismatch | Originating worker | Adjust implementation      |
