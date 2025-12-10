---
name: tool-check
description: Use when selecting MCP servers, choosing which tools to use, or mapping prompts to serena/Context7/semgrep/shadcn/sequential-thinking/chrome-devtools. Analyzes prompt keywords and returns tools[] for BA and Architect agents. Runs in parallel with complexity-check during Phase 1 analysis.
---

# Tool Check Skill

**Purpose:** Analyze a prompt and return an array of MCP tool names relevant to the task.

**Input:** `prompt` (string) - The user's request

**Output:** `tools: string[]` - Array of MCP tool names

**Note:** This skill runs in PARALLEL with complexity-check. All decisions are keyword-based only.

---

## How to Execute

This is a TEXT ANALYSIS task - analyze the prompt text as your sole input:

1. Scan the prompt text (case-insensitive) for trigger keywords in the table below
2. Add matching tools to the output array
3. Remove duplicates
4. Return ONLY: `tools: [...]`
5. Complete in under 200 tokens

**Expected output format:**

```
tools: ["serena", "sequential-thinking"]
```

Work exclusively with the prompt text as your sole input. Use keyword-based pattern matching and return your answer immediately.

---

## Available MCP Tools

| Tool                  | Purpose                                 | Trigger Keywords                     |
| --------------------- | --------------------------------------- | ------------------------------------ |
| `serena`              | Semantic code search, symbol navigation | **ALWAYS for code tasks**            |
| `Context7`            | Library docs, API research              | Library names, "docs", "latest"      |
| `sequential-thinking` | Multi-step analysis, debugging          | "debug", "step by step", "trace"     |
| `semgrep`             | Security scanning, SAST                 | "security", "vulnerability", "OWASP" |
| `shadcn`              | UI components, React components         | Component names, "shadcn", "UI"      |
| `chrome-devtools`     | Browser automation, E2E testing         | "e2e", "browser", "screenshot"       |

---

## Selection Algorithm

### Step 1: Detect Code Task → Include serena

```
tools = []

IF prompt involves code (reading, writing, fixing, understanding, file path mentioned):
    tools.push("serena")
```

**Why always serena?** 94% token savings:

- Traditional: Read file → ~5,000 tokens
- Serena: get_symbols_overview + find_symbol → ~300 tokens

---

### Step 2: Keyword Matching

Scan prompt (case-insensitive) and add tools:

**Context7** - Include when:

- Library/package names: "react", "prisma", "express", "zod", "stripe", "auth0"
- Keywords: `library`, `package`, `npm`, `docs`, `documentation`, `API`, `latest`, `version`, `upgrade`, `migrate`, `example`, `usage`

**sequential-thinking** - Include when:

- Keywords: `debug`, `diagnose`, `root cause`, `investigate`, `step by step`, `analyze`, `multi-phase`, `hypothesis`, `validate`, `trace`, `think through`

**semgrep** - Include when:

- Keywords: `security`, `vulnerability`, `CVE`, `OWASP`, `audit` (security context), `scan`, `SAST`, `injection`, `XSS`, `CSRF`, `hardening`, `secure`, `penetration`

**shadcn** - Include when:

- Keywords: `shadcn`, `radix`, `component`, `UI`, `button`, `form`, `dialog`, `modal`, `design system`
- Component names: `accordion`, `alert`, `avatar`, `badge`, `card`, `checkbox`, `dropdown`, `input`, `menu`, `popover`, `select`, `sheet`, `sidebar`, `table`, `tabs`, `toast`, `tooltip`

**chrome-devtools** - Include when:

- Keywords: `e2e`, `end-to-end`, `browser`, `visual`, `screenshot`, `ui test`, `interaction test`, `click`, `navigate`, `page`, `responsive`, `viewport`
- **IMPORTANT:** When triggered, also load the `chrome-devtools-testing` skill for setup instructions

---

### Step 3: Handle Edge Cases

```
IF tools is empty AND no code task detected:
    # Pure non-code question (e.g., "What time is it?")
    RETURN []

# Remove duplicates
tools = [...new Set(tools)]
RETURN tools
```

---

## Examples

### Example 1: Simple Bug Fix

```
Prompt: "Fix the TypeScript error in user.service.ts"

Analysis:
  - Code task (file path mentioned) → serena
  - No library keywords
  - No security keywords

Output: ["serena"]
```

### Example 2: Debugging Complex Issue

```
Prompt: "Debug the race condition in the payment flow, trace through step by step"

Analysis:
  - Code task → serena
  - "debug" + "trace" + "step by step" → sequential-thinking

Output: ["serena", "sequential-thinking"]
```

### Example 3: E2E Testing

```
Prompt: "Write E2E tests for the checkout flow in the browser"

Analysis:
  - Code task → serena
  - "E2E tests" + "browser" → chrome-devtools

Output: ["serena", "chrome-devtools"]
```

### Example 4: Research Only (No Code)

```
Prompt: "Explain how React Server Components work"

Analysis:
  - No code task (explanation only) → skip serena
  - "React" → external library → Context7

Output: ["Context7"]
```

---

## Integration with Workflow

This skill runs in **Phase 1 (Analysis)** in **PARALLEL** with:

- `complexity-check` (returns int)
- `scope-check` (returns string[])

**Complexity-based additions happen AFTER Phase 1 in ms.md:**

- IF complexity ≥ 20 → ensure `sequential-thinking` included
- `vibe-check` is a workflow step (not returned by this skill)

The output `tools[]` is passed to:

- Business Analyst (for PRD creation)
- Architect (for technical spec)

**Tool availability checks happen at runtime:**

- If an agent tries to use `chrome-devtools` and it's not running, the agent should stop and ask user to enable it
- This will be handled by a future sanity-check step in the workflow
