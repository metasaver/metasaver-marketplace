# Audit Command Target State

Simplified workflow architecture for the `/audit` command.

**Design Principles:**

- No complexity check (audit is deterministic)
- No tools check (agents are determined by scope)
- No cross-repo resolution (paths hardcoded in scope-check)
- No vibe check or innovation (audit is compliance, not creation)
- Shared Requirements phase with `/build` (reusable skill)
- Interactive discrepancy resolution (HITL per finding)
- Two-phase execution: Investigation → Remediation

---

## 1. High-Level Flow Overview

```mermaid
flowchart TB
    subgraph Entry["Phase 1: Entry"]
        A["/audit {prompt}"]
    end

    subgraph Analysis["Phase 1: Analysis (PARALLEL)"]
        SC["Scope Check<br/>(prompt) → repos[], files[]"]
        AC["Agent Check<br/>(scope) → agents[]"]
    end

    subgraph Requirements["Phase 2: Requirements (Shared Skill)"]
        BA1["BA understands task"]
        BA2["BA confirms scope with user"]
        BA3["BA creates PRD"]
        BA4["BA creates user stories<br/>(1 per agent/file combo)"]
        HV{"User approves<br/>scope + stories?"}
    end

    subgraph Planning["Phase 3: Planning"]
        PM["PM batches agents<br/>into execution waves"]
    end

    subgraph Investigation["Phase 4: Investigation"]
        INV1["Spawn agents in waves<br/>(max 10 parallel)"]
        INV2["Each agent:<br/>compare file vs template"]
        INV3["Collect discrepancy reports"]
    end

    subgraph Resolution["Phase 5: Report & Resolution (HITL)"]
        RPT["Present consolidated findings"]
        LOOP["For each discrepancy:"]
        SHOW["Show: file differs from template"]
        ASK["Ask user:<br/>1. Apply template<br/>2. Update template<br/>3. Ignore<br/>4. Custom"]
        UPD["Update story with decision"]
        MORE{"More<br/>discrepancies?"}
    end

    subgraph Remediation["Phase 6: Remediation"]
        REM1["Spawn agents to apply<br/>approved fixes"]
        REM2["Production check<br/>(build, lint, test)"]
        REM3{"Passes?"}
    end

    subgraph Report["Phase 7: Final Report"]
        FINAL["BA consolidates results"]
    end

    A --> SC & AC
    SC & AC --> BA1
    BA1 --> BA2
    BA2 --> BA3
    BA3 --> BA4
    BA4 --> HV
    HV -->|"No"| BA2
    HV -->|"Yes"| PM
    PM --> INV1
    INV1 --> INV2
    INV2 --> INV3
    INV3 --> RPT
    RPT --> LOOP
    LOOP --> SHOW
    SHOW --> ASK
    ASK --> UPD
    UPD --> MORE
    MORE -->|"Yes"| LOOP
    MORE -->|"No"| REM1
    REM1 --> REM2
    REM2 --> REM3
    REM3 -->|"No"| REM1
    REM3 -->|"Yes"| FINAL
```

---

## 2. Complete Sequence Diagram

```mermaid
sequenceDiagram
    participant U as User
    participant CMD as /audit
    participant SC as Scope Check
    participant AC as Agent Check
    participant BA as Business Analyst
    participant PM as Project Manager
    participant W as Config Agents
    participant PC as Production Check

    U->>CMD: /audit {prompt}

    rect rgb(230, 240, 250)
        Note over SC,AC: Phase 1: Analysis (PARALLEL)
        par Parallel Analysis
            CMD->>SC: prompt
            SC->>SC: Identify repos + files
            SC-->>CMD: scope: {repos[], files[]}
        and
            CMD->>AC: prompt + scope
            AC->>AC: Match files to agents
            AC-->>CMD: agents: string[]
        end
        Note over CMD: WAIT for both via TaskOutput
    end

    rect rgb(250, 240, 230)
        Note over BA: Phase 2: Requirements (Shared Skill)
        CMD->>BA: prompt, scope, agents
        BA->>BA: Understand audit task
        BA->>U: "I understand you want to audit X. Confirm?"
        U->>BA: Confirmation/clarification
        BA->>BA: Create PRD in docs/prd
        BA->>BA: Create user stories (1 per agent/file)
        BA->>U: "Here are the stories. Approve?"

        alt User requests changes
            U->>BA: Changes
            BA->>BA: Revise stories
        end
        U->>BA: Approved
    end

    rect rgb(240, 250, 230)
        Note over PM: Phase 3: Planning
        CMD->>PM: stories, agents
        PM->>PM: Batch into waves (max 10)
        PM-->>CMD: execution_plan
    end

    rect rgb(250, 230, 240)
        Note over W: Phase 4: Investigation
        CMD->>W: execution_plan

        loop For each wave
            par Agents in wave (parallel)
                W->>W: Read template from skill
                W->>W: Read actual file
                W->>W: Compare and report
                W-->>CMD: discrepancy_report
            end
        end

        CMD->>CMD: Aggregate all reports
    end

    rect rgb(255, 250, 220)
        Note over U: Phase 5: Report & Resolution (HITL)
        CMD->>U: "Found N discrepancies. Let's review."

        loop For each discrepancy
            CMD->>U: "{file} differs from template"
            CMD->>U: Show diff/comparison
            CMD->>U: AskUserQuestion:<br/>1. Apply template<br/>2. Update template<br/>3. Ignore<br/>4. Custom
            U->>CMD: Decision
            CMD->>CMD: Update story with decision
        end
    end

    rect rgb(230, 255, 230)
        Note over W,PC: Phase 6: Remediation
        CMD->>W: Stories with "apply" decisions

        par Apply fixes (parallel)
            W->>W: Apply template to file
        end

        W-->>PC: Changes applied
        PC->>PC: Run build, lint, test

        alt Checks fail
            PC->>W: Fix errors
            W->>W: Iterate
        end

        PC-->>CMD: All checks pass
    end

    rect rgb(230, 250, 250)
        Note over BA: Phase 7: Final Report
        CMD->>BA: All results + decisions
        BA->>BA: Consolidate
        BA-->>U: Final audit report
    end
```

---

## 3. Analysis Phase Detail

```mermaid
flowchart TB
    subgraph Input["Input"]
        P["prompt: '/audit eslint across all repos'"]
    end

    subgraph ScopeCheck["Scope Check"]
        S1["Parse prompt for targets"]
        S2["Resolve 'all repos' → actual paths"]
        S3["List files matching target type"]
        S4["Return: repos[], files[]"]
    end

    subgraph AgentCheck["Agent Check"]
        A1["For each file type:"]
        A2["Match to config agent"]
        A3["Match to domain agent (if composite)"]
        A4["Return: agents[]"]
    end

    subgraph Output["Output"]
        O1["scope: {<br/>repos: [rugby-crm, resume-builder],<br/>files: [eslint.config.js, eslint.config.js]<br/>}"]
        O2["agents: [eslint-agent]"]
    end

    Input --> ScopeCheck
    Input --> AgentCheck
    S1 --> S2 --> S3 --> S4
    A1 --> A2 --> A3 --> A4
    S4 --> O1
    A4 --> O2
```

**Scope Check Output Examples:**

| Prompt                               | scope.repos                 | scope.files                            | agents                                   |
| ------------------------------------ | --------------------------- | -------------------------------------- | ---------------------------------------- |
| "audit eslint"                       | [current-repo]              | [eslint.config.js]                     | [eslint-agent]                           |
| "audit eslint across consumer repos" | [rugby-crm, resume-builder] | [eslint.config.js, eslint.config.js]   | [eslint-agent]                           |
| "audit monorepo root"                | [current-repo]              | [turbo.json, pnpm-workspace.yaml, ...] | [turbo-agent, pnpm-workspace-agent, ...] |
| "audit data-service"                 | [current-repo]              | [/apps/api/*]                          | [data-service-agent]                     |

**Agent Selection Logic:**

| Target Type        | Single Agent         | Composite Agents                  |
| ------------------ | -------------------- | --------------------------------- |
| eslint.config.js   | eslint-agent         | -                                 |
| docker-compose.yml | docker-compose-agent | -                                 |
| turbo.json         | turbo-agent          | -                                 |
| "monorepo root"    | -                    | All config agents for root        |
| "data-service"     | -                    | data-service-agent (orchestrates) |
| "react-app"        | -                    | react-app-agent (orchestrates)    |

---

## 4. Requirements Phase Detail (Shared Skill)

```mermaid
flowchart TB
    subgraph Input["Input to BA"]
        I1["prompt"]
        I2["scope: {repos[], files[]}"]
        I3["agents: string[]"]
    end

    subgraph Understanding["BA Understanding"]
        U1["Parse what user wants audited"]
        U2["Confirm scope with user"]
        U3{"User confirms?"}
        U4["Adjust scope"]
    end

    subgraph PRD["PRD Creation"]
        P1["Create docs/prd/audit-{date}.md"]
        P2["Define audit objectives"]
        P3["List files to check"]
        P4["Define success criteria"]
    end

    subgraph Stories["User Story Creation"]
        ST1["For each (agent, file) pair:"]
        ST2["Create story with:"]
        ST3["- Agent to use"]
        ST4["- File to audit"]
        ST5["- Template/skill reference"]
        ST6["- AC: report discrepancies"]
    end

    subgraph Approval["User Approval"]
        AP1["Present stories to user"]
        AP2{"User approves?"}
        AP3["Revise stories"]
    end

    Input --> U1
    U1 --> U2 --> U3
    U3 -->|"No"| U4 --> U2
    U3 -->|"Yes"| P1
    P1 --> P2 --> P3 --> P4
    P4 --> ST1
    ST1 --> ST2
    ST2 --> ST3 & ST4 & ST5 & ST6
    ST6 --> AP1
    AP1 --> AP2
    AP2 -->|"No"| AP3 --> AP1
    AP2 -->|"Yes"| OUT((Continue))
```

**User Story Template (Audit):**

```markdown
## Story: Audit {file} in {repo}

**Agent:** {agent-name}
**Scope:** {repo}/{path/to/file}
**Template:** {skill-name}

### Acceptance Criteria

- [ ] Agent reads template from skill
- [ ] Agent reads actual file
- [ ] Agent compares and identifies discrepancies
- [ ] Discrepancies reported with line numbers
- [ ] User decision recorded (apply/update/ignore/custom)

### User Decision

- [ ] Pending investigation
```

---

## 5. Investigation Phase Detail

```mermaid
flowchart TB
    subgraph Input["From PM"]
        EP["execution_plan:<br/>waves of (agent, file) pairs"]
    end

    subgraph Wave["For Each Wave (max 10 parallel)"]
        W1["Spawn agent"]
        W2["Agent reads skill/template"]
        W3["Agent reads actual file"]
        W4["Agent compares"]
        W5["Agent returns discrepancy report"]
    end

    subgraph Report["Discrepancy Report Structure"]
        R1["file: string"]
        R2["agent: string"]
        R3["status: PASS | FAIL"]
        R4["discrepancies: [{<br/>  line: number,<br/>  expected: string,<br/>  actual: string,<br/>  severity: critical|warning|info<br/>}]"]
    end

    subgraph Aggregate["Aggregation"]
        A1["Collect all reports"]
        A2["Sort by severity"]
        A3["Group by repo/file"]
    end

    Input --> Wave
    W1 --> W2 --> W3 --> W4 --> W5
    W5 --> Report
    R1 & R2 & R3 & R4 --> Aggregate
    A1 --> A2 --> A3
```

**Agent Investigation Behavior:**

Each config agent in audit mode:

1. **Reads template** from its skill (e.g., `/skill eslint-config`)
2. **Reads actual file** from target repo
3. **Compares** field-by-field or line-by-line
4. **Reports** discrepancies with:
   - Exact location (line number)
   - Expected value (from template)
   - Actual value (from file)
   - Severity classification

**No changes made during investigation.** Agents only report.

---

## 6. Report & Resolution Phase Detail (HITL)

```mermaid
flowchart TB
    subgraph Present["Present Findings"]
        P1["Summary: X files audited"]
        P2["Y discrepancies found"]
        P3["Z critical, W warnings"]
    end

    subgraph Loop["For Each Discrepancy"]
        L1["Show file path"]
        L2["Show diff/comparison"]
        L3["Show template expectation"]
        L4["Show actual value"]
    end

    subgraph Ask["AskUserQuestion"]
        Q["What would you like to do?"]
        O1["1. Apply template to this file"]
        O2["2. Update template with this change"]
        O3["3. Ignore this discrepancy"]
        O4["4. Custom (enter text)"]
    end

    subgraph Update["Update Story"]
        U1["Record decision in story"]
        U2["If 'apply': mark for remediation"]
        U3["If 'update template': flag for multi-mono PR"]
        U4["If 'ignore': mark as accepted deviation"]
        U5["If 'custom': record custom instruction"]
    end

    Present --> Loop
    L1 --> L2 --> L3 --> L4 --> Ask
    Q --> O1 & O2 & O3 & O4
    O1 & O2 & O3 & O4 --> Update
    U1 --> U2 & U3 & U4 & U5
```

**Resolution Dialog Example:**

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Discrepancy 1 of 5: rugby-crm/eslint.config.js

Template expects:
  "parserOptions": { "ecmaVersion": 2024 }

Actual file has:
  "parserOptions": { "ecmaVersion": 2022 }

What would you like to do?
  [1] Apply template to this file (update to 2024)
  [2] Update template with this change (keep 2022)
  [3] Ignore this discrepancy
  [4] Other (enter text)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## 7. Remediation Phase Detail

```mermaid
flowchart TB
    subgraph Input["From Resolution"]
        I1["Stories with decisions"]
        I2["Filter: only 'apply' decisions"]
    end

    subgraph Spawn["Spawn Remediation Agents"]
        S1["Group by agent type"]
        S2["Spawn agents with fix instructions"]
        S3["Agents apply template to files"]
    end

    subgraph Validate["Production Check"]
        V1["Run: pnpm build"]
        V2["Run: pnpm lint"]
        V3["Run: pnpm test"]
        V4{"All pass?"}
    end

    subgraph Retry["On Failure"]
        R1["Report errors to agents"]
        R2["Agents fix issues"]
    end

    subgraph TemplateUpdates["Template Updates (if any)"]
        T1["Collect 'update template' decisions"]
        T2["Create multi-mono branch"]
        T3["Update skill templates"]
        T4["Open PR for review"]
    end

    Input --> Spawn
    I1 --> I2 --> S1
    S1 --> S2 --> S3
    S3 --> V1
    V1 --> V2 --> V3 --> V4
    V4 -->|"No"| R1
    R1 --> R2 --> V1
    V4 -->|"Yes"| TemplateUpdates
    T1 --> T2 --> T3 --> T4
```

**Remediation Rules:**

1. **Only apply approved fixes** - No changes without user decision
2. **Batch by agent** - All eslint fixes together, all turbo fixes together
3. **Validate after each batch** - Don't accumulate breaking changes
4. **Template updates are separate** - Create PR to multi-mono, don't auto-merge

**Simplified Validation:**

| Check           | Run? | Reason                          |
| --------------- | ---- | ------------------------------- |
| build           | Yes  | Ensure no syntax errors         |
| lint            | Yes  | Ensure code quality             |
| test            | Yes  | Ensure no regressions           |
| Structure check | No   | Config agents already validated |
| DRY check       | No   | Not adding new code             |
| Config agents   | No   | They just ran in investigation  |

---

## 8. Final Report Structure

```mermaid
flowchart TB
    subgraph Input["Aggregated Data"]
        I1["All discrepancy reports"]
        I2["All user decisions"]
        I3["Remediation results"]
        I4["Template update PRs"]
    end

    subgraph Generate["BA Report Generation"]
        G1["Count by status"]
        G2["List applied fixes"]
        G3["List ignored items"]
        G4["List template updates"]
    end

    subgraph Report["Final Report"]
        R1["Executive Summary"]
        R2["Audit Scope"]
        R3["Findings by File"]
        R4["Actions Taken"]
        R5["Template PRs Created"]
        R6["Accepted Deviations"]
    end

    Input --> Generate
    G1 --> G2 --> G3 --> G4
    G4 --> Report
```

**Report Template:**

```markdown
# Audit Report: {scope}

**Date:** {date}
**Repos:** {repo-list}

## Executive Summary

Audited {N} files across {M} repositories.

- {X} discrepancies found
- {Y} fixes applied
- {Z} template updates proposed
- {W} deviations accepted

## Actions Taken

### Fixes Applied

| File                       | Change                | Agent        |
| -------------------------- | --------------------- | ------------ |
| rugby-crm/eslint.config.js | ecmaVersion 2022→2024 | eslint-agent |

### Template Updates (PRs Created)

| Template            | Change         | PR             |
| ------------------- | -------------- | -------------- |
| eslint-config skill | Add new rule X | multi-mono#123 |

### Accepted Deviations

| File                      | Deviation      | Reason                      |
| ------------------------- | -------------- | --------------------------- |
| resume-builder/turbo.json | Missing task Y | Not needed for this project |

## Verification

- Build: PASS
- Lint: PASS
- Tests: PASS
```

---

## 9. Quick Reference

| Phase | Function        | Input                 | Output              | Agent  | Parallel               |
| ----- | --------------- | --------------------- | ------------------- | ------ | ---------------------- |
| 1     | Scope Check     | prompt                | repos[], files[]    | haiku  | Yes (with Agent Check) |
| 1     | Agent Check     | prompt, scope         | agents[]            | haiku  | Yes (with Scope Check) |
| 2     | BA Requirements | prompt, scope, agents | PRD, stories        | sonnet | No                     |
| 2     | User Approval   | stories               | approved            | Human  | No                     |
| 3     | PM Planning     | stories               | execution_plan      | sonnet | No                     |
| 4     | Investigation   | execution_plan        | discrepancy_reports | haiku  | Yes (waves of 10)      |
| 5     | Report          | reports               | summary             | sonnet | No                     |
| 5     | Resolution      | discrepancies         | decisions           | Human  | No (sequential)        |
| 6     | Remediation     | decisions             | fixed_files         | haiku  | Yes (by agent type)    |
| 6     | Validation      | fixed_files           | pass/fail           | Bash   | No                     |
| 7     | Final Report    | all_data              | report              | sonnet | No                     |

---

## 10. Enforcement Rules

1. **NO complexity check** - Audit is deterministic
2. **NO tools check** - Agents determined by scope
3. **NO cross-repo resolution** - Paths hardcoded in scope-check
4. **NO vibe check** - Audit is compliance, not creation
5. **NO innovation phase** - Not applicable to audits
6. **Requirements phase uses shared skill** - Same as /build
7. **Investigation is read-only** - No changes until approved
8. **Every discrepancy gets user decision** - No auto-fixes
9. **Template updates create PRs** - Never auto-merge to multi-mono
10. **Simplified validation** - Just build/lint/test, no config agents

---

## 11. Comparison: /audit vs /build

| Phase        | /audit                            | /build                            |
| ------------ | --------------------------------- | --------------------------------- |
| Analysis     | Scope + Agent check               | Complexity + Tools + Scope        |
| Cross-repo   | Hardcoded in scope                | Hardcoded in scope                |
| Requirements | Shared skill (BA → PRD → Stories) | Shared skill (BA → PRD → Stories) |
| Vibe Check   | Skip                              | Required (≥15)                    |
| Innovation   | Skip                              | Optional (≥30)                    |
| Design       | PM batches agents                 | Architect + PM                    |
| Execution    | Investigation (read-only)         | TDD pairs (write)                 |
| HITL         | Per-discrepancy decisions         | Approval before execution         |
| Remediation  | Apply approved fixes              | N/A (part of execution)           |
| Validation   | build/lint/test only              | Full standards audit              |
| Report       | BA consolidates                   | BA consolidates                   |

---

## 12. Open Questions

1. **Should scope-check and agent-check be one skill or two?**
   - Combined: simpler, single call
   - Separate: more reusable, agent-check could be used elsewhere

2. **How to handle "update template" decisions?**
   - Auto-create PR to multi-mono?
   - Just log for manual action?
   - Create branch but require manual PR?

3. **What if user wants to audit but NOT fix?**
   - Add "report only" mode?
   - Or just let them choose "ignore" for everything?

4. **Batching discrepancy questions:**
   - Ask one-by-one (current design)?
   - Group by file and ask batch decisions?
   - Show all, let user mark multiple?
