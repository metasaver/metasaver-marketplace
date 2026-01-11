# PRD: Session-Persistent Workflow Enforcement

## Epic Info

| Field       | Value                                          |
| ----------- | ---------------------------------------------- |
| Epic Code   | MMP-SPW                                        |
| Project     | metasaver-marketplace                          |
| Description | Make MetaSaver workflow the persistent default |
| Status      | In Progress                                    |
| Created     | 2026-01-09                                     |

---

## Problem Statement

Every time a Claude Code session starts or restarts (due to crash, reboot, or new conversation), the user must manually re-type a detailed prompt to get Claude to use the MetaSaver workflow (agents, skills, templates, parallel execution). Without this prompt, Claude reverts to default sequential behavior, ignoring the entire MetaSaver ecosystem.

### User Pain Point (from `prompt.txt`)

The user currently has to type something like:

> "remember to always use metasaver plugin agents, skills, templates and follow the workflow using agents in parallel"

This is required every single session, and forgetting it causes workflow failures documented in the backlog.

---

## Root Cause Analysis

### Evidence from Post-Mortems

| Post-Mortem  | Root Cause                                     | Impact                                      |
| ------------ | ---------------------------------------------- | ------------------------------------------- |
| MSC-CAI      | Auto-archived without HITL, didn't use skills  | Premature completion, user had to restore   |
| MUM-VCR      | Stories never updated, false completion claims | 19 stories marked done without any updates  |
| ESLint Audit | Workflow worked when explicitly invoked        | Proves the system works when used correctly |

### Pattern Identified

1. **Session context loss**: CLAUDE.md is read but its workflow instructions aren't prioritized
2. **Default behavior dominance**: Claude's default (sequential, no agents) overrides custom workflow
3. **No enforcement mechanism**: Instructions are advisory, not mandatory
4. **Recovery burden on user**: After any interruption, user must re-establish context manually

---

## Success Criteria

1. Claude uses MetaSaver agents, skills, and templates by default without manual prompting
2. After any session interruption, workflow context is restored without user intervention
3. Workflow compliance is enforced, not just documented
4. User never has to type the "remember to use metasaver..." prompt again

---

## Proposed Solution

### 1. Enhanced CLAUDE.md with Constitutional Section

Add a "Constitution" section at the very top of CLAUDE.md with non-negotiable rules:

```markdown
## MetaSaver Constitution (MANDATORY)

These rules MUST be followed in EVERY response:

1. ALWAYS use MetaSaver agents for implementation (never raw tools alone)
2. ALWAYS spawn agents in parallel when tasks are independent
3. ALWAYS follow /build or /ms workflow for any code changes
4. NEVER mark work complete without user approval (HITL)
5. NEVER skip story file updates during execution
6. ALWAYS use AskUserQuestion for user interactions
```

### 2. Session Restore Command (`/session` or `/restore`)

Create a lightweight command that:

- Re-reads and asserts CLAUDE.md instructions
- Confirms MetaSaver workflow is active
- Can be typed after any crash/interruption: `/session`

### 3. Workflow Enforcement Skill

Create a pre-completion validation skill that checks:

- Story files are updated (status, checkboxes)
- HITL was performed (user approved)
- Acceptance criteria verified against implementation
- Blocks completion claims until validation passes

---

## Out of Scope

- Changes to Claude Code's core behavior (can't modify the model itself)
- Persistence mechanisms that require external systems
- Automatic crash recovery (Claude doesn't know it crashed)

---

## User Stories

| ID      | Story                           | Priority |
| ------- | ------------------------------- | -------- |
| SPW-001 | Enhanced CLAUDE.md Constitution | P0       |
| SPW-002 | Session Restore Command         | P1       |
| SPW-003 | Workflow Enforcement Skill      | P2       |
| SPW-004 | Post-Mortem Consolidation Doc   | P2       |

---

## Consolidated Learnings (from all backlog post-mortems)

### What MUST Change

| Current Behavior             | Required Behavior                       |
| ---------------------------- | --------------------------------------- |
| CLAUDE.md is advisory        | CLAUDE.md is constitutional (mandatory) |
| Agents are optional          | Agents are required for implementation  |
| HITL is skippable            | HITL is enforced at key gates           |
| Story updates are optional   | Story updates are mandatory             |
| User re-prompts each session | Workflow is default without prompting   |

### Key Enforcement Points

1. **Before any code change**: Must be using /build or /ms workflow
2. **Before completion claim**: Must have updated story files
3. **Before archive**: Must have explicit user approval
4. **After any interruption**: Workflow must be restorable with one command

---

## Technical Approach

### Files to Create/Modify

| File                                                                  | Action | Description                     |
| --------------------------------------------------------------------- | ------ | ------------------------------- |
| `CLAUDE.md` (marketplace)                                             | Modify | Add Constitution section at top |
| `plugins/metasaver-core/commands/session.md`                          | Create | Session restore command         |
| `plugins/metasaver-core/skills/cross-cutting/workflow-enforcement.md` | Create | Pre-completion validation       |
| `docs/architecture/workflow-failures-consolidated.md`                 | Create | Consolidated learnings doc      |

### Implementation Order

1. CLAUDE.md changes (immediate impact, no new files)
2. Session restore command (quick win for crash recovery)
3. Workflow enforcement skill (prevents future failures)
4. Documentation consolidation (captures learnings)

---

## Risks and Mitigations

| Risk                                            | Mitigation                                      |
| ----------------------------------------------- | ----------------------------------------------- |
| CLAUDE.md changes might still be ignored        | Make instructions more forceful, use repetition |
| Session command might not fully restore context | Include re-reading of key instructions          |
| Enforcement skill might be bypassed             | Integrate into /build and /ms commands          |

---

## Acceptance Criteria

- [ ] CLAUDE.md has Constitution section at top with mandatory workflow rules
- [ ] `/session` command exists and restores MetaSaver workflow context
- [ ] Workflow enforcement skill validates before completion claims
- [ ] All backlog items are consolidated and archived
- [ ] User can start a new session without typing the manual prompt
