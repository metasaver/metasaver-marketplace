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

## How to Execute

This is a PARALLEL text analysis phase. Spawn 3 independent agents simultaneously:

1. **complexity-check agent** - Analyzes keywords, scopes, and quantities in the prompt only
2. **tool-check agent** - Matches prompt keywords to MCP tool requirements
3. **scope-check agent** - Discovers repositories and matches keywords to affected paths

**Key Points:**

- Parse the prompt text directly (keyword scanning, like regex)
- Complete in ~200 tokens per agent
- Focus exclusively on text analysis tasks - parse the prompt as a self-contained string
- Each agent operates independently (true parallel execution)
- Return structured output format exactly as specified

---

## Workflow

**Spawn 3 agents in PARALLEL to execute skills:**

```
Task 1: subagent_type="general-purpose", model="haiku"
  Prompt: "Execute /skill complexity-check on: {USER_PROMPT}. Return ONLY: score: <int>"

Task 2: subagent_type="general-purpose", model="haiku"
  Prompt: "Execute /skill tool-check on: {USER_PROMPT}. Return ONLY: tools: [...]"

Task 3: subagent_type="general-purpose", model="haiku"
  Prompt: "Execute /skill scope-check on: {USER_PROMPT}. Return ONLY: repos: [...]"
```

Collect results: `complexity_score`, `tools`, `repos`

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
