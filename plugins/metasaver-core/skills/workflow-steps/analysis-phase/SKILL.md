---
name: analysis-phase
description: Parallel execution of complexity-check, tool-check, and scope-check skills. Returns complexity score (1-50), required MCP tools array, and scope object with targets and references arrays. First phase of all workflows.
---

# Analysis Phase Skill

> **ROOT AGENT ONLY** - Invokes skills in parallel, runs only from root Claude Code agent.

**Purpose:** Gather context for routing and planning decisions
**Trigger:** First phase of any workflow command
**Input:** `prompt` (string) - Original user request
**Output:** `{complexity: int, tools: string[], scope: {targets: string[], references: string[]}}`

---

## How to Execute

This is a PARALLEL text analysis phase. Spawn 3 independent agents simultaneously:

1. **complexity-check agent** - Analyzes keywords, scopes, and quantities in the prompt only
2. **tool-check agent** - Matches prompt keywords to MCP tool requirements
3. **scope-check agent** - Identifies target repos (for changes) vs reference repos (for patterns)

**Key Points:**

- Parse the prompt text directly (keyword scanning, like regex)
- Complete in ~200 tokens per agent
- Focus exclusively on text analysis tasks - parse the prompt as a self-contained string
- Each agent operates independently (true parallel execution)
- Return structured output format exactly as specified

---

## Workflow

**Spawn 3 agents in PARALLEL using dedicated analysis agents (zero tool access):**

```
Task 1: subagent_type="core-claude-plugin:generic:complexity-check-agent"
  Prompt: "Analyze this prompt and return complexity score: {USER_PROMPT}"

Task 2: subagent_type="core-claude-plugin:generic:tool-check-agent"
  Prompt: "Analyze this prompt and return required MCP tools: {USER_PROMPT}"

Task 3: subagent_type="core-claude-plugin:generic:scope-check-agent"
  Prompt: "Analyze this prompt and return scope (CWD: {CWD}): {USER_PROMPT}"
```

**Why dedicated agents?** These agents specify `tools: TodoWrite` (a minimal core tool) instead of inheriting all tools, which eliminates ~37k tokens of MCP tool schemas per agent. Total savings: ~111k input tokens per analysis phase.

Collect results: `complexity_score`, `tools`, `scope` (with targets and references)

---

## Skill Outputs

Each agent invokes its corresponding skill for the detailed algorithm:

| Agent                  | Skill                     | Output                                         |
| ---------------------- | ------------------------- | ---------------------------------------------- |
| complexity-check-agent | `/skill complexity-check` | `score: <int 1-50>`                            |
| tool-check-agent       | `/skill tool-check`       | `tools: [...]`                                 |
| scope-check-agent      | `/skill scope-check`      | `scope: { targets: [...], references: [...] }` |

See individual skill files for detailed algorithms and examples.

---

## Output Example

```json
{
  "complexity": 28,
  "tools": ["serena", "Context7", "sequential-thinking"],
  "scope": {
    "targets": ["/home/user/code/metasaver-com"],
    "references": ["/home/user/code/rugby-crm"]
  }
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
- `scope-check` skill (returns {targets: string[], references: string[]})

**Next step:** requirements-phase (for complexity ≥5) or direct execution (≤4)

---

## Example

```
Command: /build "Add Applications screen to metasaver-com, look at rugby-crm for patterns"

Analysis Phase:
  → complexity-check: 26
  → tool-check: ["serena"]
  → scope-check: { targets: ["/home/user/code/metasaver-com"], references: ["/home/user/code/rugby-crm"] }

Output:
  {
    complexity: 26,
    tools: ["serena"],
    scope: {
      targets: ["/home/user/code/metasaver-com"],
      references: ["/home/user/code/rugby-crm"]
    }
  }

Next: requirements-phase (complexity ≥15)
```
