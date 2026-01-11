# Workflow Failures: Consolidated Learnings

## Overview

Summary of workflow failures documented in early 2026 and the solutions implemented. These post-mortems identified systemic issues in how the agent handled completion claims, documentation updates, and human-in-the-loop (HITL) requirements.

---

## Failure Categories

### 1. HITL Violations

**Pattern:** Auto-completing or archiving without user approval

**Evidence:**

- MSC-CAI epic was auto-archived to `docs/epics/completed/` after build passed
- User had to request restoration to active folder
- Agent moved to archive step without any user confirmation

**Root Cause:** Agent treated passing builds/lint/tests as sufficient proof of completion. No enforcement mechanism required user approval at key workflow moments.

**Solution:** Constitution Rule 4 - Verify: Confirm it works before marking done. ALWAYS get user approval before marking complete or archiving.

---

### 2. Story Update Failures

**Pattern:** Claiming completion without updating story files

**Evidence:**

- MUM-VCR showed 0 stories with `status: "complete"` despite claiming "19 stories completed"
- Only 13 checkmarks across 2 stories (17 stories had ZERO checkmarks)
- `workflow-state.json` was never created
- Agent used internal TodoWrite tracking instead of updating story files

**Root Cause:** Agent completed code execution but treated documentation updates as optional. Mental tracking never written to story files.

**Solution:** Constitution Rule 5 + Workflow Enforcement Skill - Story status updates are MANDATORY. Cannot claim story complete without updating story file.

---

### 3. Session Context Loss

**Pattern:** After crashes, Claude forgets MetaSaver workflow

**Evidence:**

- User had to re-type workflow prompt every session (saved in `prompt.txt`)
- Sample prompt showed need to repeatedly explain: use MetaSaver plugin agents, follow workflow, use agents in parallel

**Root Cause:** No persistence mechanism for workflow context. Each session starts fresh with no memory of the MetaSaver workflow expectations.

**Solution:** `/session` command + Constitution at top of CLAUDE.md provides quick context restore after interruptions.

---

### 4. False Completion Claims

**Pattern:** Build passing treated as work complete

**Evidence:**

- MSC-CAI: Build/lint passed but user found incomplete work
- MUM-VCR: All 395 tests passed but zero stories marked complete
- User reported: "every single epic I have found you didn't complete properly"

**Root Cause:** Overconfidence in automated verification. Build/lint/test passing creates false sense of completion. These catch syntax/type errors, not logic/completeness errors.

**Solution:** Workflow Enforcement Skill validates story files and acceptance criteria, not just build status.

---

### 5. Documentation and Skill Gaps

**Pattern:** Incomplete skill documentation causing audit false positives

**Evidence:**

- ESLint audit command referenced wrong paths (`docs/prd/` instead of `docs/epics/`)
- Skill documentation only covered 4 projectTypes when repos used 13+
- Wrong postmortem location used initially (epic folder instead of marketplace)

**Root Cause:** Skills and commands not updated to match current repository structure.

**Solution:** Comprehensive skill updates and regular audit of skill documentation.

---

## Solutions Implemented (MMP-SPW Epic)

| Solution                   | Status      | Description                                        |
| -------------------------- | ----------- | -------------------------------------------------- |
| MetaSaver Constitution     | Implemented | 6 mandatory rules at top of CLAUDE.md              |
| /session Command           | Implemented | Quick context restore after interruptions          |
| Workflow Enforcement Skill | Implemented | Validates completion requirements                  |
| Author Agents              | Implemented | Agent/skill/command edits go through author agents |
| AskUserQuestion Tool       | Documented  | Required for all HITL checkpoints                  |

---

## Constitution Rules (Reference)

| #   | Principle    | Rule                                           |
| --- | ------------ | ---------------------------------------------- |
| 1   | Minimal      | Change only what must change                   |
| 2   | Root Cause   | Fix the source (address symptoms at origin)    |
| 3   | Read First   | Understand existing code before modifying      |
| 4   | Verify       | Confirm it works before marking done           |
| 5   | Exact Scope  | Do precisely what was asked                    |
| 6   | Root Scripts | Always run npm/pnpm scripts from monorepo root |

---

## Prevention Checklist

Use this checklist before any completion claim:

- [ ] Story files updated (`status: "complete"`)
- [ ] Acceptance criteria checkboxes marked `[x]`
- [ ] Definition of Done items checked `[x]`
- [ ] User approval obtained via AskUserQuestion
- [ ] Build/lint/test passing
- [ ] workflow-state.json exists and is current
- [ ] No auto-archiving without explicit user command

---

## Key Metrics from Post-Mortems

| Epic         | Stories | Initial Compliance | Issues Found                        |
| ------------ | ------- | ------------------ | ----------------------------------- |
| MSC-CAI      | 19      | 0%                 | Premature archive, HITL bypass      |
| MUM-VCR      | 19      | 0%                 | No story updates, no workflow state |
| ESLint Audit | N/A     | 44% (16/36 files)  | Wrong paths, incomplete skill docs  |

---

## References

- [MSC-CAI Post-Mortem](../epics/in-progress/mmp-spw-session-persistent-workflow/references/msc-cai-workflow-failure-post-mortem.md)
- [MUM-VCR Post-Mortem](../epics/in-progress/mmp-spw-session-persistent-workflow/references/mum-vcr-workflow-failure-post-mortem.md)
- [ESLint Audit Post-Mortems](../epics/in-progress/mmp-spw-session-persistent-workflow/references/eslint-audit-2026-01-06/)
