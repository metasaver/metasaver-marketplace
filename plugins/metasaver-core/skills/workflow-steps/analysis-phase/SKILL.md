---
name: analysis-phase
description: Parallel execution of complexity-check, tool-check, and scope-check skills. Returns complexity score (1-50), required MCP tools array, and affected repository paths. First phase of all workflows.
---

# Analysis Phase Skill

> **ROOT AGENT ONLY** - Invokes skills in parallel, runs only from root Claude Code agent.

**Purpose:** Gather context for routing and planning decisions
**Trigger:** First phase of any workflow command
**Input:** `prompt` (string) - Original user request
**Output:** `{complexity: int, tools: string[], scope: string[]}`

---

## Workflow

**Execute all THREE skills in PARALLEL:**

1. `complexity-check` → Returns int (1-50)
2. `tool-check` → Returns string[] (MCP tools)
3. `scope-check` → Returns string[] (repo paths)

---

## Skill Outputs

### complexity-check

Returns integer score (1-50) based on keywords:

- Enterprise keywords: "enterprise", "migrate", "refactor", "rewrite"
- Scope indicators: "all", "every", "across", "entire"
- Quantity modifiers: "multiple", "several"
- Negation patterns

### tool-check

Returns MCP tools needed:

- `serena` - Semantic code analysis (auto-included for code tasks)
- `Context7` - Library documentation (package names, "docs", "API")
- `sequential-thinking` - Complex reasoning ("debug", "trace", "step by step")
- `semgrep` - Security scanning ("security", "vulnerability", "audit")
- `shadcn` - UI components ("shadcn", "component", "UI")
- `chrome-devtools` - Browser automation ("e2e", "browser", "screenshot")

### scope-check

Returns repository paths affected:

- Scans `/mnt/f/code/` for MetaSaver repositories
- Matches prompt keywords to repository names
- Returns absolute paths

---

## Output Example

```json
{
  "complexity": 28,
  "tools": ["serena", "Context7", "sequential-thinking"],
  "scope": ["/mnt/f/code/resume-builder", "/mnt/f/code/saver-connect"]
}
```

---

## Post-Analysis Routing

| Complexity | Route                           | Human Validation |
| ---------- | ------------------------------- | ---------------- |
| ≤4         | Direct Claude                   | No               |
| 5-14       | Quick workflow                  | No               |
| 15-29      | Full workflow (sonnet)          | Yes              |
| ≥30        | Full workflow (opus) + innovate | Yes              |

---

## Next Phase

| Complexity | Next Phase                       |
| ---------- | -------------------------------- |
| ≤4         | Direct Claude execution          |
| 5-14       | requirements-phase (abbreviated) |
| ≥15        | requirements-phase (full)        |

---

## Integration

**Called by:**

- `/audit` command
- `/build` command
- `/ms` command

**Calls:**

- `complexity-check` skill (returns int)
- `tool-check` skill (returns string[])
- `scope-check` skill (returns string[])

**Next step:** requirements-phase (for complexity ≥5) or direct execution (≤4)

---

## Example

```
Command: /audit monorepo root

Analysis Phase:
  → complexity-check: 28
  → tool-check: ["serena", "semgrep"]
  → scope-check: ["/mnt/f/code/resume-builder"]

Output:
  {complexity: 28, tools: ["serena", "semgrep"], scope: [...]}

Next: requirements-phase (complexity ≥15)
```
