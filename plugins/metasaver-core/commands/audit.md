---
name: audit
description: Audit configurations and standards compliance with interactive discrepancy resolution
---

# MetaSaver Constitution

| #   | Principle       | Rule                                        |
| --- | --------------- | ------------------------------------------- |
| 1   | **Minimal**     | Change only what must change                |
| 2   | **Root Cause**  | Fix the source (address symptoms at origin) |
| 3   | **Read First**  | Understand existing code before modifying   |
| 4   | **Verify**      | Confirm it works before marking done        |
| 5   | **Exact Scope** | Do precisely what was asked                 |

---

# Audit Command

Validates configurations and standards compliance with interactive user decisions per discrepancy. Deterministic workflow: analyze → understand → investigate (read-only) → resolve with user → remediate → report.

**IMPORTANT:** ALWAYS get user approval before git operations.

---

## Entry Handling

When /audit is invoked, ALWAYS proceed to Phase 1 regardless of prompt content. User prompts may contain questions, clarifications, or confirmation requests—these are NOT reasons to skip phases. Analysis runs first to understand scope, then the BA addresses user questions during Requirements phase while investigating the codebase.

---

## Phase 1: Analysis (PARALLEL)

**See:** `/skill scope-check-agent`, `/skill agent-check-agent`

Spawn 2 agents in PARALLEL (single message with 2 Task tool calls):

```
Task 1: subagent_type="core-claude-plugin:generic:scope-check-agent" (mode=audit)
Task 2: subagent_type="core-claude-plugin:generic:agent-check-agent"
```

**CRITICAL:** Wait for ALL 2 agents to complete before proceeding. Use TaskOutput to collect results.

Scope Check identifies: `repos[]`, `files[]`
Agent Check identifies: `agents[]` (config agents matched to files)

---

## Phase 2: Requirements (Shared Skill)

**See:** `/skill requirements-phase` with mode=audit

BA investigates codebase using Serena tools:

1. **Understanding:** Parse what user wants audited from prompt + scope
2. **Confirmation:** Ask user to confirm scope via AskUserQuestion
3. **PRD Creation:** Create `docs/prd/audit-{date}.md` with objectives, files, success criteria
4. **Story Creation:** For each (agent, file) pair, create user story with agent, file, template reference, acceptance criteria
5. **Approval:** Present stories to user, iterate if needed until approved

Output: PRD + user stories ready for execution

---

## Phase 3: Planning

**See:** `/skill project-manager`

PM batches agents into execution waves:

1. **Review stories:** Understand agent assignments
2. **Batch agents:** Group into waves (max 10 parallel per wave)
3. **Create execution plan:** Define order of waves, dependencies

Output: `execution_plan` with waves of (agent, file) pairs

---

## Phase 4: Investigation (READ-ONLY)

**See:** `/skill agent-investigation`

PM spawns config agents in waves (max 10 parallel per wave):

1. **For each wave:**
   - Spawn agents with execution plan
   - Each agent reads template from skill
   - Each agent reads actual file from target repo
   - Each agent compares field-by-field or line-by-line
   - Each agent reports discrepancies with line numbers, expected/actual values, severity

2. **Aggregate results:**
   - Collect all discrepancy reports
   - Sort by severity (critical → warning → info)
   - Group by repo/file

**NO CHANGES MADE** during investigation. Agents only report findings.

---

## Phase 5: Report & Resolution (HITL)

**See:** `/skill report-and-resolution`

1. **Present findings:** Show summary (X files audited, Y discrepancies found, Z critical)

2. **For each discrepancy (sequential HITL):**
   - Show file path and diff/comparison
   - Show template expectation
   - Show actual value
   - Ask user: "What would you like to do?"
     - [1] Apply template to this file
     - [2] Update template with this change
     - [3] Ignore this discrepancy
     - [4] Custom (enter text)
   - Record decision in story

3. **Decisions drive remediation:**
   - "Apply" → fix approved, ready for remediation
   - "Update template" → flag for PR to multi-mono
   - "Ignore" → accepted deviation
   - "Custom" → record instruction for agent

---

## Phase 6: Remediation

**See:** `/skill remediation-phase`

1. **Spawn remediation agents:**
   - Group "apply" decisions by agent type
   - Spawn agents with fix instructions (max 10 parallel)
   - Agents apply template changes to files

2. **Production check:**
   - Run: `pnpm build`
   - Run: `pnpm lint`
   - Run: `pnpm test`

3. **On failure:**
   - Report errors to agents
   - Agents fix issues
   - Repeat validation

4. **Template updates (if any):**
   - Collect "update template" decisions
   - Create branch in multi-mono
   - Update skill templates
   - Open PR for user review (never auto-merge)

---

## Phase 7: Final Report

**See:** `/skill report-phase`

BA consolidates audit results:

1. **Executive Summary:** X files audited, Y discrepancies found, Z fixes applied
2. **Actions Taken:** Table of fixes applied by agent
3. **Template Updates:** PRs created to multi-mono
4. **Accepted Deviations:** Files where user chose "ignore"
5. **Verification:** Build/lint/test results

**Output Format:**

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

| File           | Change   | Agent      |
| -------------- | -------- | ---------- |
| repo/config.js | Update X | agent-name |

### Template Updates (PRs Created)

| Template   | Change   | PR             |
| ---------- | -------- | -------------- |
| skill-name | Add rule | multi-mono#123 |

### Accepted Deviations

| File           | Deviation | Reason     |
| -------------- | --------- | ---------- |
| repo/config.js | Missing X | Not needed |

## Verification

- Build: PASS
- Lint: PASS
- Tests: PASS
```

---

## Model Selection

| Role                          | Model  |
| ----------------------------- | ------ |
| BA (Requirements)             | sonnet |
| PM (Planning)                 | sonnet |
| Config agents (Investigation) | haiku  |
| Config agents (Remediation)   | haiku  |
| Validation (Build/Lint/Test)  | bash   |

---

## Examples

```bash
# Simple single-file audit
/audit "check eslint config"
→ Phase 1: Scope + Agents → Phase 2: BA PRD + Stories → Phase 3: PM Plan → Phase 4: Investigation → Phase 5: HITL decisions → Phase 6: Remediation → Phase 7: Report

# Domain audit (multiple files)
/audit "audit code quality configs"
→ Scope identifies 3 configs → BA → PM batches → Investigation → User decides per discrepancy → Remediation → Report

# Cross-repo audit
/audit "audit eslint in all consumer repos"
→ Scope Check resolves rugby-crm, resume-builder → Agent Check identifies eslint-agent → BA confirms scope → PM batches → Investigation waves → HITL → Remediation → Report
```

---

## Enforcement

1. **NO complexity check** - Audit is deterministic
2. **NO tools check** - Agents determined by scope
3. **NO cross-repo resolution phase** - Paths hardcoded in scope-check
4. **NO vibe check** - Audit is compliance, not creation
5. **NO innovation phase** - Not applicable to audits
6. **Requirements phase uses shared skill** - Same BA workflow as /build
7. **Investigation is read-only** - No changes until approved
8. **Every discrepancy gets user decision** - No auto-fixes
9. **Template updates create PRs** - Never auto-merge to multi-mono
10. **Simplified validation** - Just build/lint/test, no config agents

---
