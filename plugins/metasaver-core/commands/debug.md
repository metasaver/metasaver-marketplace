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

**See:** `/skill workflow-steps/debug-plan`

Parse prompt for URL/target, identify what to test, confirm with user (quick HITL), create debug steps.

---

## Phase 2: Setup

**See:** `/skill cross-cutting/chrome-devtools-testing`

Check Chrome DevTools MCP connection, verify Chrome is accessible, check dev server status for localhost targets, start dev server if needed (HITL).

---

## Phase 3: Execution

**See:** `/skill workflow-steps/debug-execution`

Navigate to target URL, capture baseline DOM and screenshots, execute planned interactions with MCP tools (click, fill, hover, press_key), capture state after each interaction, collect console messages and network requests, validate results.

---

## Phase 4: Report

**See:** `/skill workflow-steps/report-phase`

Generate complete debug report with executive summary, steps executed with screenshots, findings (console errors, network issues, visual problems), and recommendations.

---

## Examples

```bash
/debug "check if the login form works"
→ Plan → Setup → Execute (navigate, fill, submit, capture) → Report

/debug "the modal isn't centered on mobile"
→ Plan → Setup → Execute (resize, open modal, capture) → Report

/debug "test the checkout flow"
→ Plan → Setup → Execute full flow with screenshots → Report

/debug "there's a React error on the settings page"
→ Plan → Setup → Execute, capture console → Report: Error details + location
```

---

## Enforcement

1. Plan phase confirms URL + test steps with user (quick HITL)
2. Verify Chrome DevTools MCP connection before execution
3. Capture screenshots at each step
4. Always capture console messages
5. Always capture network requests (for debugging)
6. Report must include all evidence
7. Always report findings; implementation decisions belong to the user
8. Use MCP tools exclusively for browser interactions
9. Execute sequentially - one interaction at a time
10. Require Chrome DevTools MCP accessibility before proceeding
