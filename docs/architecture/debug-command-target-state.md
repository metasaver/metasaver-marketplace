# Debug Command Target State

Target workflow architecture for the `/debug` command - browser debugging and E2E testing with Chrome DevTools MCP.

**Purpose:** Debug web applications, test UI interactions, capture visual evidence.

**Prerequisite:** Chrome DevTools MCP server configured and Chrome running with remote debugging.

---

## 1. High-Level Workflow (Skills Only)

```mermaid
flowchart LR
    classDef phase fill:#bbdefb,stroke:#1565c0,stroke-width:2px
    classDef skill fill:#fff8e1,stroke:#f57f17,stroke-width:2px
    classDef entry fill:#f3e5f5,stroke:#7b1fa2,stroke-width:2px

    ENTRY["/debug {target/task}"]:::entry

    subgraph P1["Phase 1: Plan"]
        direction TB
        PLAN["/skill debug-plan"]:::skill
    end

    subgraph P2["Phase 2: Setup"]
        direction TB
        CDT["/skill chrome-devtools-testing"]:::skill
    end

    subgraph P3["Phase 3: Execution"]
        direction TB
        DBG["/skill debug-execution"]:::skill
    end

    subgraph P4["Phase 4: Report"]
        direction TB
        RPT["/skill report-phase"]:::skill
    end

    ENTRY --> P1 --> P2 --> P3 --> P4
```

**Legend:**

| Color  | Meaning         |
| ------ | --------------- |
| Purple | Entry point     |
| Blue   | Phase container |
| Yellow | Skill           |

---

## 2. Phase 1: Plan (Exploded)

**Execution:** Quick planning - extract URL and create simple test plan

```mermaid
flowchart TB
    classDef skill fill:#fff8e1,stroke:#f57f17,stroke-width:2px
    classDef step fill:#f5f5f5,stroke:#616161,stroke-width:1px
    classDef hitl fill:#ffcdd2,stroke:#c62828,stroke-width:1px

    subgraph P1["Phase 1: Plan"]
        subgraph PLAN["/skill debug-plan"]
            D1["Parse prompt for URL/target"]:::step
            D2["Identify what to test"]:::step
            D3["HITL: Confirm target + test plan"]:::hitl
            D4["Create debug steps"]:::step
            D1 --> D2 --> D3 --> D4 --> OUT((To Setup))
        end
    end
```

**Output:** URL + simple test plan (what to click, what to check)

---

## 3. Phase 2: Setup (Exploded)

**Execution:** Sequential

```mermaid
flowchart TB
    classDef skill fill:#fff8e1,stroke:#f57f17,stroke-width:2px
    classDef step fill:#f5f5f5,stroke:#616161,stroke-width:1px
    classDef hitl fill:#ffcdd2,stroke:#c62828,stroke-width:1px

    subgraph P2["Phase 2: Setup"]
        subgraph CDT["/skill chrome-devtools-testing"]
            S1["Check Chrome DevTools MCP connection"]:::step
            S2["Verify Chrome is accessible"]:::step
            S3{{"Target is localhost?"}}
            S4["Check if dev server running"]:::step
            S5["HITL: Start dev server?"]:::hitl
            S6["Start dev server"]:::step

            S1 --> S2 --> S3
            S3 -->|Yes| S4 --> S5
            S5 -->|Yes| S6 --> OUT((Ready))
            S5 -->|No| FAIL((Abort))
            S3 -->|No| OUT
        end
    end
```

**Output:** Chrome DevTools MCP connected, dev server running (if needed)

---

## 4. Phase 3: Execution (Exploded)

**Execution:** Sequential - MCP tool calls

```mermaid
flowchart TB
    classDef skill fill:#fff8e1,stroke:#f57f17,stroke-width:2px
    classDef step fill:#f5f5f5,stroke:#616161,stroke-width:1px
    classDef mcp fill:#e8f5e9,stroke:#2e7d32,stroke-width:1px

    subgraph P3["Phase 3: Execution"]
        subgraph DBG["/skill debug-execution"]
            E1["navigate_page(url)"]:::mcp
            E2["take_snapshot() - baseline DOM"]:::mcp
            E3["take_screenshot() - baseline visual"]:::mcp

            subgraph INTLOOP["For Each Interaction in Plan"]
                E4["click/fill/hover/press_key(element)"]:::mcp
                E5["take_screenshot() - after interaction"]:::mcp
                E6["take_snapshot() - DOM state"]:::mcp
            end

            E7["list_console_messages()"]:::mcp
            E8["list_network_requests()"]:::mcp
            E9["Validate results against expectations"]:::step

            E1 --> E2 --> E3 --> INTLOOP
            INTLOOP --> E7 --> E8 --> E9 --> OUT((To Report))
        end
    end
```

**MCP Tools Used:**

| Tool                    | Purpose              |
| ----------------------- | -------------------- |
| `navigate_page`         | Navigate to URL      |
| `take_snapshot`         | Get DOM snapshot     |
| `take_screenshot`       | Capture visual state |
| `click`                 | Click element        |
| `fill`                  | Input text           |
| `hover`                 | Hover over element   |
| `press_key`             | Keyboard input       |
| `list_console_messages` | Get console logs     |
| `list_network_requests` | Get network activity |

**Output:** All evidence captured

---

## 5. Phase 4: Report (Exploded)

**Execution:** Sequential

```mermaid
flowchart TB
    classDef skill fill:#fff8e1,stroke:#f57f17,stroke-width:2px
    classDef step fill:#f5f5f5,stroke:#616161,stroke-width:1px

    subgraph P4["Phase 4: Report"]
        subgraph RPT["/skill report-phase"]
            RP1["Executive Summary: What was tested, Pass/Fail"]:::step
            RP2["Steps Executed: Each interaction with screenshots"]:::step
            RP3["Findings: Console errors, network issues, visual problems"]:::step
            RP4["Recommendations: Fixes needed, further investigation"]:::step
            RP1 --> RP2 --> RP3 --> RP4
        end
    end
```

**Output:** Complete debug report in markdown with screenshots

---

## 6. Quick Reference

| Phase | Skill                            | Agent         | Model  |
| ----- | -------------------------------- | ------------- | ------ |
| 1     | `/skill debug-plan`              | -             | sonnet |
| 2     | `/skill chrome-devtools-testing` | -             | -      |
| 3     | `/skill debug-execution`         | - (MCP tools) | -      |
| 4     | `/skill report-phase`            | -             | sonnet |

---

## 7. Examples

```bash
# Debug specific page
/debug "check if the login form works"
→ P1: Plan: URL=localhost:5173/login, test login with test@test.com
→ P2: Setup Chrome DevTools MCP
→ P3: Execute: Navigate, fill form, submit, capture screenshots
→ P4: Report: Login successful, redirected to /dashboard

# Visual debugging
/debug "the modal isn't centered on mobile"
→ P1: Plan: URL=localhost:5173/users, resize to 375px, open modal
→ P2: Setup
→ P3: Execute: Resize, open modal, capture
→ P4: Report: Modal offset by 20px left, CSS issue identified

# E2E flow test
/debug "test the checkout flow"
→ P1: Plan: Full flow - add to cart, checkout, payment
→ P2: Setup
→ P3: Execute full flow with screenshots at each step
→ P4: Report: Flow completed successfully

# Console error investigation
/debug "there's a React error on the settings page"
→ P1: Plan: Navigate to settings, click Save, capture console
→ P2: Setup
→ P3: Execute, capture console messages
→ P4: Report: "Cannot read property 'map' of undefined" at Settings.tsx:42
```

---

## 8. Enforcement Rules

1. Plan phase confirms URL + test steps with user (quick HITL)
2. Check Chrome DevTools MCP connection before execution
3. Capture screenshots at each step
4. Always capture console messages
5. Always capture network requests (for debugging)
6. Report must include all evidence
7. Never auto-fix - report findings only

---

## 9. Prerequisites

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
