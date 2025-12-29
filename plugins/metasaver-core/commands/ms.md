---
name: ms
description: Simple mini-workflow for quick fixes and small tasks with HITL approval gates
---

# MetaSaver Command

Simple mini-workflow for quick fixes and small tasks. Understand the request, get approval, execute with MetaSaver agents, verify, and confirm completion.

**Use /ms for quick tasks that need agent execution without full PRD workflows.**

---

## Entry Handling

When /ms is invoked, ALWAYS proceed to Phase 1 regardless of prompt content.

---

## Phase 1: Understand

Analyze the user request and clarify intent:

1. Read the user prompt
2. Identify what they want to accomplish
3. Use AskUserQuestion tool if clarification needed
4. Present understanding: "Here's what I understand you want..."

---

## Phase 2: HITL Approval

**See:** `/skill workflow-steps/hitl-approval`

Get user confirmation before proceeding:

1. Present understanding from Phase 1
2. Use AskUserQuestion tool with options: "Yes, proceed" / "No, let me clarify"
3. If clarification needed, return to Phase 1
4. If approved, proceed to Phase 3

---

## Phase 3: Execute

**See:** `/skill workflow-steps/execution-phase` and `/skill agent-selection`

Spawn MetaSaver agents in parallel for the work:

1. Select appropriate agents from core-claude-plugin (see `/skill agent-selection`)
2. Spawn agents in parallel when tasks are independent
3. Use Task tool WITHOUT model parameter
4. ALWAYS use agents from core-claude-plugin for execution

---

## Phase 4: Verify

**See:** `/skill workflow-steps/validation-phase`

Run build validation to ensure changes work:

1. Run: `pnpm build`
2. Run: `pnpm lint`
3. Run: `pnpm test`
4. Report any failures to user

---

## Phase 5: Self-Audit

**See:** `/skill workflow-postmortem mode=summary`

Before confirming with user, audit your own work:

1. **Scope check:** Did we do ONLY what was requested? List any extras added
2. **Completeness check:** Is all requested work done? List anything missing
3. **Side effects:** Did we modify files not related to the request?
4. **Quality check:** Does the implementation follow the approach we got approval for?

If issues found:

- Minor issues: Note them for user in Confirm phase
- Major issues: Return to Phase 3 (Execute) to fix before confirming

This self-audit catches:

- Feature creep (adding things not requested)
- Incomplete work (forgetting parts of the request)
- Scope drift (changing unrelated files)

---

## Phase 6: Confirm

**See:** `/skill workflow-steps/hitl-approval`

Confirm completion with user:

1. Use AskUserQuestion tool: "Did this solve what you asked for?"
2. If yes: workflow complete
3. If no: ask what adjustments needed, return to Phase 3

---

## Examples

```bash
/ms "fix the typo in the README"
→ Understand → Approval → Execute(coder) → Verify → Self-Audit → Confirm

/ms "add validation to the login form"
→ Understand → Approval → Execute(code-explorer, coder, tester) → Verify → Self-Audit → Confirm

/ms "update the eslint config to use our new rules"
→ Understand → Approval → Execute(config agent) → Verify → Self-Audit → Confirm

/ms "refactor the auth module for better error handling"
→ Understand → Approval → Execute(code-explorer, coder, reviewer) → Verify → Self-Audit → Confirm
```

---

## Enforcement

1. ALWAYS use AskUserQuestion tool for all questions to the user
2. ALWAYS get HITL approval before executing (Phase 2)
3. ALWAYS use MetaSaver agents from core-claude-plugin when agents exist for the task
4. ALWAYS spawn agents WITHOUT model parameter on Task calls
5. ALWAYS spawn agents in parallel when tasks are independent
6. ALWAYS verify with build/lint/test after execution (Phase 4)
7. ALWAYS run Self-Audit before confirming (catch feature creep and incomplete work)
8. ALWAYS confirm completion with user (Phase 6)
9. ALWAYS present understanding before getting approval (Phase 1 output required)
10. ALWAYS return to Phase 1 if user provides clarification during approval
11. ALWAYS consult `/skill agent-selection` for appropriate agent mapping
