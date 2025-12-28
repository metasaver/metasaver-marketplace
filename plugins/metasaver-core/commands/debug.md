---
name: debug
description: Browser debugging and E2E testing workflow using Chrome DevTools MCP
---

# /debug Command

Debug web applications, test UI interactions, and capture visual evidence using Chrome DevTools MCP integration.

---

## Entry Handling

When `/debug` is invoked, ALWAYS proceed to Phase 1 regardless of prompt content.

---

## Prerequisites

**Chrome Setup:**

```bash
# Start Chrome with remote debugging
google-chrome --remote-debugging-port=9222 --user-data-dir=/tmp/chrome-debug
```

**Dev Server:**

```bash
# Ensure dev server uses host 0.0.0.0 for container access
pnpm dev --host 0.0.0.0
```

**MCP Configuration:**

- Chrome DevTools MCP server must be configured in `.mcp.json`
- See `/skill chrome-devtools-testing` for setup details

---

## Phase 1: Plan

**Follow:** `/skill workflow-steps/debug-plan`

Parse prompt for URL/target, identify what to test, confirm with user (quick HITL), create debug steps.

---

## Phase 2: Setup

**Follow:** `/skill cross-cutting/chrome-devtools-testing`

Check Chrome DevTools MCP connection, verify Chrome is accessible, check dev server status for localhost targets, start dev server if needed (HITL).

---

## Phase 3: Execution

**Follow:** `/skill workflow-steps/debug-execution`

Navigate to target URL, capture baseline DOM and screenshots, execute planned interactions with MCP tools (click, fill, hover, press_key), capture state after each interaction, collect console messages and network requests, validate results.

---

## Phase 4: Workflow Postmortem

**Follow:** `/skill workflow-postmortem mode=summary`

Run `/skill workflow-postmortem mode=summary` to generate final summary. This checks if the debug workflow followed expected phases and logs any issues.

**Output:** Summary of issues logged during workflow (if any), included in final report.

---

## Phase 5: Report

**Follow:** `/skill workflow-steps/report-phase`

Generate complete debug report with executive summary, steps executed with screenshots, findings (console errors, network issues, visual problems), and recommendations.

---

## Examples

```bash
/debug "check if the login form works"
→ Plan → Setup → Execute (navigate, fill, submit, capture) → Postmortem → Report

/debug "the modal isn't centered on mobile"
→ Plan → Setup → Execute (resize, open modal, capture) → Postmortem → Report

/debug "test the checkout flow"
→ Plan → Setup → Execute full flow with screenshots → Postmortem → Report

/debug "there's a React error on the settings page"
→ Plan → Setup → Execute, capture console → Postmortem → Report: Error details + location
```

---

## Enforcement

1. Use AskUserQuestion tool for every question to the user. Present structured options with clear descriptions.
2. Plan phase confirms URL + test steps with user (quick HITL)
3. Verify Chrome DevTools MCP connection before execution
4. Capture screenshots at each step
5. Always capture console messages
6. Always capture network requests (for debugging)
7. Report must include all evidence
8. Always report findings; implementation decisions belong to the user
9. Use MCP tools exclusively for browser interactions
10. Execute sequentially - one interaction at a time
11. Require Chrome DevTools MCP accessibility before proceeding
12. ALWAYS run `/skill workflow-postmortem mode=summary` AFTER Execution, BEFORE Report phase
