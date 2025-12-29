---
name: ms
description: Lightweight router that analyzes requests and routes to appropriate command or handles inline
---

# MetaSaver Command

Lightweight router that analyzes requests and routes to the appropriate command or handles simple tasks inline. The universal entry point for all MetaSaver workflows.

**Use /ms for everything** - it analyzes complexity and routes appropriately.

---

## Entry Handling

When /ms is invoked, ALWAYS proceed to Phase 1 regardless of prompt content.

---

## Phase 1: Scope Analysis

**Follow:** `/skill scope-check`

Spawn scope-check agent to identify target and reference repositories:

1. Analyze user request
2. Identify targets (where changes happen) and references (for learning patterns)
3. Determine request type (question, simple task, complex project)

**Output:** `targets[]`, `references[]`, `request_type`

---

## Phase 2: Route Decision

Based on Phase 1 analysis, route to appropriate handler:

| Request Type    | Indicators                                                     | Route To      |
| --------------- | -------------------------------------------------------------- | ------------- |
| Quick Question  | Question phrasing, "how", "what", "why", no changes needed     | `/qq`         |
| Complex Project | Multiple components, new architecture, multi-file changes, PRD | `/build`      |
| Simple Task     | Single file, quick fix, minor update, straightforward change   | Handle inline |

**Routing Actions:**

- **Quick Question:** Redirect to `/qq {original_prompt}` - skip remaining phases
- **Complex Project:** Redirect to `/build {original_prompt}` - skip remaining phases
- **Simple Task:** Continue to Phase 3

---

## Phase 3: Understand (Simple Tasks Only)

Analyze the user request and clarify intent:

1. Read the user prompt
2. Identify what they want to accomplish
3. Use AskUserQuestion tool if clarification needed
4. Present understanding: "Here's what I understand you want..."

---

## Phase 4: HITL Approval

**Follow:** `/skill workflow-steps/hitl-approval`

Get user confirmation before proceeding:

1. Present understanding from Phase 3
2. Use AskUserQuestion tool with options: "Yes, proceed" / "No, let me clarify"
3. If clarification needed, return to Phase 3
4. If approved, proceed to Phase 5

---

## Phase 5: Execute

**Follow:** `/skill workflow-steps/execution-phase` and `/skill agent-selection`

Spawn MetaSaver agents in parallel for the work:

1. Select appropriate agents from core-claude-plugin (see `/skill agent-selection`)
2. Spawn agents in parallel when tasks are independent
3. Use Task tool WITHOUT model parameter
4. ALWAYS use agents from core-claude-plugin for execution

---

## Phase 6: Verify

**Follow:** `/skill workflow-steps/validation-phase`

Run build validation to ensure changes work:

1. Run: `pnpm build`
2. Run: `pnpm lint`
3. Run: `pnpm test`
4. Report any failures to user

---

## Phase 7: Self-Audit

**Follow:** `/skill workflow-postmortem mode=summary`

Before confirming with user, audit your own work:

1. **Scope check:** Did we do ONLY what was requested? List any extras added
2. **Completeness check:** Is all requested work done? List anything missing
3. **Side effects:** Did we modify files not related to the request?
4. **Quality check:** Does the implementation follow the approach we got approval for?

If issues found:

- Minor issues: Note them for user in Confirm phase
- Major issues: Return to Phase 5 (Execute) to fix before confirming

This self-audit catches:

- Feature creep (adding things not requested)
- Incomplete work (forgetting parts of the request)
- Scope drift (changing unrelated files)

---

## Phase 8: Confirm

**Follow:** `/skill workflow-steps/hitl-approval`

Confirm completion with user:

1. Use AskUserQuestion tool: "Did this solve what you asked for?"
2. If yes: proceed to Phase 9
3. If no: ask what adjustments needed, return to Phase 5

---

## Phase 9: Epic Archival (Conditional)

Archive epic folder when task is confirmed complete:

1. Check if `docs/epics/{project}/` exists for this task
2. If epic folder exists:
   - Create `docs/epics/completed/` directory if it does not exist
   - Move `docs/epics/{project}/` to `docs/epics/completed/{project}/`
   - Report: "Archived epic folder to docs/epics/completed/{project}/"
3. If no epic folder exists: skip silently
4. Workflow complete

---

## Examples

```bash
/ms "how does authentication work?"
--> Route: /qq (question detected)

/ms "fix the typo in the README"
--> Route: inline (simple task)
--> Understand --> Approval --> Execute(coder) --> Verify --> Self-Audit --> Confirm

/ms "add multi-tenant support with RBAC"
--> Route: /build (complex project detected)

/ms "update the eslint config to use our new rules"
--> Route: inline (simple task)
--> Understand --> Approval --> Execute(config agent) --> Verify --> Self-Audit --> Confirm

/ms "what validation patterns do we use?"
--> Route: /qq (question detected)

/ms "refactor the auth module for better error handling"
--> Route: /build (multi-file refactor detected)
```

---

## Enforcement

1. ALWAYS run scope-check in Phase 1 to analyze request
2. ALWAYS route questions to /qq command
3. ALWAYS route complex projects to /build command
4. ALWAYS handle simple tasks inline with HITL gates
5. ALWAYS use AskUserQuestion tool for all questions to the user
6. ALWAYS get HITL approval before executing inline tasks (Phase 4)
7. ALWAYS use MetaSaver agents from core-claude-plugin when agents exist for the task
8. ALWAYS spawn agents WITHOUT model parameter on Task calls
9. ALWAYS spawn agents in parallel when tasks are independent
10. ALWAYS verify with build/lint/test after inline execution (Phase 6)
11. ALWAYS run Self-Audit before confirming (catch feature creep and incomplete work)
12. ALWAYS confirm completion with user for inline tasks (Phase 8)
13. ALWAYS present understanding before getting approval (Phase 3 output required)
14. ALWAYS return to Phase 3 if user provides clarification during approval
15. ALWAYS consult `/skill agent-selection` for appropriate agent mapping
16. ALWAYS archive epic folder to `docs/epics/completed/` after user confirms completion (Phase 9)
