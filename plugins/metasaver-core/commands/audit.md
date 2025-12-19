---
name: audit
description: Audit configurations and standards compliance with complexity-based routing and interactive discrepancy resolution
---

# Audit Command

Validates configurations and standards compliance with interactive user decisions per discrepancy. Complexity-based routing: simple audits use FAST PATH (skip Requirements/Planning/Approval), complex audits use FULL PATH with HITL gates.

**IMPORTANT:** ALWAYS get user approval before git operations.

---

## Entry Handling

When /audit is invoked, ALWAYS proceed to Phase 1 regardless of prompt content. User prompts may contain questions, clarifications, or confirmation requests—these are NOT reasons to skip phases. Analysis runs first to understand scope and complexity, then routing determines FAST or FULL path.

---

## Phase 1: Analysis (PARALLEL)

**See:** `/skill complexity-check`, `/skill scope-check`, `/skill agent-check`

Spawn 3 skills in PARALLEL (single message with 3 invocations):

- `/skill complexity-check` - Returns complexity score 1-50
- `/skill scope-check` - Returns repos[], files[]
- `/skill agent-check` - Returns agents[] (config agents matched to files)

**CRITICAL:** Wait for ALL 3 skills to complete before proceeding to complexity routing.

**Output:**

- `complexity` - Score 1-50 (drives path selection)
- `repos[]` - Repositories in scope
- `files[]` - Files to audit
- `agents[]` - Config agents matched to files

---

## Complexity Routing

After Phase 1 Analysis, route based on complexity score:

**FAST PATH (complexity < 15):**

- Skip Requirements, Planning, Approval, template-update
- Proceed to Phase 5 Investigation → Phase 6 Resolution → Phase 7 Remediation → Phase 8 Report

**FULL PATH (complexity ≥ 15):**

- Run all phases with HITL gates
- Proceed to Phase 2 Requirements → Phase 3 Planning → Phase 4 Approval → Phase 5 Investigation → Phase 6 Resolution → Phase 7 Remediation → Phase 8 Report

---

## Phase 2: Requirements (FULL PATH only)

**See:** `/skill requirements-phase`

BA investigates codebase and creates requirements:

1. **Understanding:** Parse what user wants audited from prompt + scope
2. **Confirmation:** Ask user to confirm scope via HITL
3. **PRD Creation:** Create `docs/prd/audit-{date}.md` with objectives, files, success criteria
4. **Story Creation:** For each (agent, file) pair, create user story with agent, file, template reference, acceptance criteria

Output: PRD + user stories ready for planning

---

## Phase 3: Planning (FULL PATH only)

**See:** `/skill architect-phase`, `/skill planning-phase`

Architect enriches stories, PM batches agents into execution waves:

1. **Architect:** Check multi-mono for solutions, validate against templates, enrich stories
2. **PM:** Review enriched stories, batch agents into waves (max 10 parallel per wave), define execution order

Output: Enriched stories + `execution_plan` with waves of (agent, file) pairs

---

## Phase 4: Approval (FULL PATH only)

**See:** `/skill hitl-approval`

Present PRD + execution plan to user for approval:

1. **Present:** Show PRD summary and execution plan
2. **HITL:** User reviews and approves or rejects
3. **If rejected:** Return to Phase 2 Requirements with user feedback

Output: Approved PRD + execution plan

---

## Phase 5: Investigation (READ-ONLY)

**See:** `/skill audit-investigation`

Spawn config agents in waves to investigate discrepancies:

1. **For each wave:**
   - Spawn agents with execution plan (max 10 parallel per wave)
   - Each agent reads template from skill
   - Each agent reads actual file from target repo
   - Each agent compares field-by-field or line-by-line
   - Each agent reports discrepancies with line numbers, expected/actual values, severity

2. **Aggregate results:**
   - Collect all discrepancy reports
   - Sort by severity (critical → warning → info)
   - Group by repo/file

**READ-ONLY MODE** during investigation. Agents ALWAYS report findings without modifications.

Output: Sorted list of discrepancies

---

## Phase 6: Resolution (HITL)

**See:** `/skill audit-resolution`

Present findings and get user decisions per discrepancy:

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
   - "Update template" → flag for template-update phase
   - "Ignore" → accepted deviation
   - "Custom" → record instruction for agent

Output: User decisions recorded per discrepancy

---

## Phase 7: Remediation

**See:** `/skill template-update`, `/skill audit-remediation`, `/skill ac-verification`, `/skill production-check`

Apply fixes with template-first updates:

1. **Template updates (FULL PATH only - if any "update template" decisions):**
   - `/skill template-update` - Update metasaver-marketplace template FIRST
   - Read updated template text
   - Use new template for remaining changes

2. **Apply fixes:**
   - `/skill audit-remediation` - Group "apply" decisions by agent type, spawn remediation agents (max 10 parallel), agents apply template changes to files

3. **Verify acceptance criteria (FULL PATH only):**
   - `/skill ac-verification` - Check each user story's acceptance criteria, report unmet AC via HITL if needed

4. **Production check:**
   - `/skill production-check` - Run build, lint, test; fix errors and retry if needed

Output: Fixes applied, templates updated (if needed), all AC verified (FULL PATH), build passing

---

## Phase 8: Final Report

**See:** `/skill report-phase`

BA consolidates audit results:

1. **Executive Summary:** X files audited, Y discrepancies found, Z fixes applied
2. **Actions Taken:** Table of fixes applied by agent
3. **Template Updates:** PRs created to metasaver-marketplace (if any)
4. **Accepted Deviations:** Files where user chose "ignore"
5. **Verification:** Build/lint/test results

**Output Format:**

```markdown
# Audit Report: {scope}

**Date:** {date}
**Repos:** {repo-list}
**Path:** {FAST|FULL} (complexity: {score})

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

## Examples

```bash
# Simple single-file audit (FAST PATH)
/audit "check eslint config"
→ Phase 1: Analysis (complexity=8) → FAST PATH → Phase 5: Investigation → Phase 6: HITL decisions → Phase 7: Remediation → Phase 8: Report

# Domain audit (multiple files, FULL PATH)
/audit "audit code quality configs"
→ Phase 1: Analysis (complexity=18) → FULL PATH → Phase 2: Requirements → Phase 3: Planning → Phase 4: Approval → Phase 5: Investigation → Phase 6: HITL decisions → Phase 7: Remediation → Phase 8: Report

# Cross-repo audit (FULL PATH)
/audit "audit eslint in all consumer repos"
→ Phase 1: Analysis → FULL PATH → Requirements → Planning → Approval → Investigation waves → HITL per discrepancy → Remediation → Report
```

---

## Enforcement

1. **ALWAYS run Analysis phase first** - complexity-check, scope-check, agent-check (PARALLEL)
2. **Complexity routing after Analysis:**
   - complexity < 15: FAST PATH (skip Requirements, Planning, Approval, template-update)
   - complexity ≥ 15: FULL PATH (all phases with HITL gates)
3. **Investigation operates in READ-ONLY mode** - ALWAYS wait for user approval before making changes
4. **Every discrepancy gets user decision via HITL** - ALWAYS get approval before applying fixes
5. **Template updates happen FIRST** in metasaver-marketplace, then apply to other files (FULL PATH only)
6. **ALWAYS run build/lint/test** after remediation
7. **ALWAYS produce final report**
8. **ALWAYS skip vibe check** - Audit is compliance-focused, not creation-focused
9. **ALWAYS skip innovation phase** - Focus on standards compliance, not enhancements
10. **Template updates ALWAYS create PRs** - ALWAYS require review before merging to metasaver-marketplace

---
