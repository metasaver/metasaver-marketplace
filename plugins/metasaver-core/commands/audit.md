---
name: audit
description: Audit configurations and standards compliance with complexity-based routing and interactive discrepancy resolution
---

# Audit Command

Validates configurations and standards compliance with interactive user decisions per discrepancy. Complexity-based routing: simple audits use FAST PATH (skip Requirements/Planning/Approval), complex audits use FULL PATH with HITL gates.

---

## Entry Handling

When /audit is invoked, ALWAYS proceed to Phase 1 regardless of prompt content. User prompts may contain questions, clarifications, or confirmation requests—these are NOT reasons to skip phases. Analysis runs first to understand scope and complexity, then routing determines FAST or FULL path.

---

## Phase 1: Analysis (PARALLEL)

**Follow:** `/skill scope-check`, `/skill agent-check`

Spawn 2 skills in PARALLEL (single message with 2 invocations):

- `/skill scope-check` - Returns repos[], files[]
- `/skill agent-check` - Returns agents[] (config agents matched to files)

**CRITICAL:** Wait for ALL 2 skills to complete before proceeding.

**Output:**

- `repos[]` - Repositories in scope
- `files[]` - Files to audit
- `agents[]` - Config agents matched to files

---

## Phase 2: Requirements

**Follow:** `/skill requirements-phase`

BA investigates codebase and creates requirements:

1. **Understanding:** Parse what user wants audited from prompt + scope
2. **Confirmation:** Ask user to confirm scope via HITL
3. **PRD Creation:** Create `docs/prd/audit-{date}.md` with objectives, files, success criteria
4. **Story Creation:** For each (agent, file) pair, create user story with agent, file, template reference, acceptance criteria

Output: PRD + user stories ready for planning

---

## Phase 3: Planning

**Follow:** `/skill architect-phase`, `/skill planning-phase`

Architect enriches stories, PM batches agents into execution waves:

1. **Architect:** Check multi-mono for solutions, validate against templates, enrich stories
2. **PM:** Review enriched stories, batch agents into waves (max 10 parallel per wave), define execution order

Output: Enriched stories + `execution_plan` with waves of (agent, file) pairs

---

## Phase 4: Approval

**Follow:** `/skill hitl-approval`

Present PRD + execution plan to user for approval:

1. **Present:** Show PRD summary and execution plan
2. **HITL:** User reviews and approves or rejects
3. **If rejected:** Return to Phase 2 Requirements with user feedback

Output: Approved PRD + execution plan

---

## Phase 5: Investigation (READ-ONLY)

**Follow:** `/skill audit-investigation`, `/skill workflow-postmortem`

Spawn config agents in waves to investigate discrepancies:

1. **For each wave:**
   - Spawn agents with execution plan (max 10 parallel per wave)
   - Each agent reads template from skill
   - Each agent reads actual file from target repo
   - Each agent compares field-by-field or line-by-line
   - Each agent reports discrepancies with line numbers, expected/actual values, severity

2. **Wave Checkpoint Flow (multi-wave):**
   - Wave N agents complete their investigations
   - **Quick log** - `/skill workflow-postmortem mode=log` (30 seconds max, append obvious mistakes)
   - **Compact context** - Run `/compact` to manage context window
   - **HITL checkpoint** - Brief wave summary to user
   - Proceed to Wave N+1

3. **Aggregate results:**
   - Collect all discrepancy reports
   - Sort by severity (critical → warning → info)
   - Group by repo/file

**READ-ONLY MODE** during investigation. Agents ALWAYS report findings without modifications.

Output: Sorted list of discrepancies

---

## Phase 6: Resolution (HITL)

**Follow:** `/skill audit-resolution`

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

**Follow:** `/skill template-update`, `/skill audit-remediation`, `/skill ac-verification`, `/skill production-check`

Apply fixes with template-first updates:

1. **Template updates (if any "update template" decisions):**
   - `/skill template-update` - Update metasaver-marketplace template FIRST
   - Read updated template text
   - Use new template for remaining changes

2. **Apply fixes:**
   - `/skill audit-remediation` - Group "apply" decisions by agent type, spawn remediation agents (max 10 parallel), agents apply template changes to files

3. **Verify acceptance criteria:**
   - `/skill ac-verification` - Check each user story's acceptance criteria, report unmet AC via HITL if needed

4. **Production check:**
   - `/skill production-check` - Run build, lint, test; fix errors and retry if needed

Output: Fixes applied, templates updated (if needed), all AC verified, build passing

---

## Phase 8: Final Workflow Postmortem

**Follow:** `/skill workflow-postmortem mode=summary`

Run `/skill workflow-postmortem mode=summary` to generate final summary. This reads the accumulated wave logs from `docs/projects/{project}/post-mortem.md` and presents a summary to the user.

**Output:** Summary of issues logged across waves (count by category, patterns identified), appended to post-mortem.md and included in final report.

---

## Phase 9: Final Report

**Follow:** `/skill report-phase`

BA consolidates audit results (including workflow postmortem):

1. **Executive Summary:** X files audited, Y discrepancies found, Z fixes applied
2. **Actions Taken:** Table of fixes applied by agent
3. **Template Updates:** PRs created to metasaver-marketplace (if any)
4. **Accepted Deviations:** Files where user chose "ignore"
5. **Workflow Postmortem:** Compliance score and deviation analysis
6. **Verification:** Build/lint/test results

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

## Workflow Postmortem

**Follow:** `/skill workflow-postmortem mode=summary`

## Verification

- Build: PASS
- Lint: PASS
- Tests: PASS
```

---

## Examples

```bash
# Single-file audit
/audit "check eslint config"
→ Phase 1: Analysis → Phase 2: Requirements → Phase 3: Planning → Phase 4: Approval → Phase 5: Investigation → Phase 6: HITL decisions → Phase 7: Remediation → Phase 8: Final Postmortem → Phase 9: Report

# Domain audit (multiple files)
/audit "audit code quality configs"
→ Phase 1: Analysis → Phase 2: Requirements → Phase 3: Planning → Phase 4: Approval → Phase 5: Investigation → Phase 6: HITL decisions → Phase 7: Remediation → Phase 8: Final Postmortem → Phase 9: Report

# Cross-repo audit with multi-wave investigation
/audit "audit eslint in all consumer repos"
→ Analysis → Requirements → Planning → Approval → Wave1 Investigation → Log → Compact → HITL → Wave2 Investigation → Log → Compact → HITL → Resolution → Remediation → Summary → Report

# Wave checkpoint flow:
Wave1: Agents investigate files → /skill workflow-postmortem mode=log → /compact → HITL checkpoint
Wave2: Agents investigate files → /skill workflow-postmortem mode=log → /compact → HITL checkpoint
End: /skill workflow-postmortem mode=summary → Report
```

---

## Enforcement

1. Use AskUserQuestion tool for every question to the user. Present structured options with clear descriptions.
2. **ALWAYS run Analysis phase first** - scope-check, agent-check (PARALLEL)
3. **Investigation operates in READ-ONLY mode** - ALWAYS wait for user approval before making changes
4. **Every discrepancy gets user decision via HITL** - ALWAYS get approval before applying fixes
5. **Template updates happen FIRST** in metasaver-marketplace, then apply to other files
6. **ALWAYS run build/lint/test** after remediation
7. **WAVE CHECKPOINT TIMING (multi-wave):** ALWAYS run `/skill workflow-postmortem mode=log` BEFORE compact at each wave checkpoint (log → compact → HITL → next wave)
8. **POSTMORTEM LOG ACCUMULATION:** Each wave log appends to `docs/projects/{project}/post-mortem.md`, building a record across waves
9. **ALWAYS run `/skill workflow-postmortem mode=summary`** AFTER Remediation, BEFORE Final Report - reads accumulated logs and presents summary
10. **ALWAYS produce final report** with workflow postmortem section
11. **ALWAYS skip vibe check** - Audit is compliance-focused, not creation-focused
12. **ALWAYS skip innovation phase** - Focus on standards compliance, not enhancements
13. **Template updates ALWAYS create PRs** - ALWAYS require review before merging to metasaver-marketplace
14. Git operations are outside workflow scope. Changes remain uncommitted for user to handle.

---
