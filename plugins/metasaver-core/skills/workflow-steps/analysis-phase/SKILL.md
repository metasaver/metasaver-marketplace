---
name: analysis-phase
description: Parallel execution of analysis check skills. Command-specific - /ms uses all 3 checks, /build uses 2, /audit uses 2 different ones. See command for which checks to run.
---

# Analysis Phase Skill

> **ROOT AGENT ONLY** - Invokes skills in parallel, runs only from root Claude Code agent.

**Purpose:** Gather context for routing and planning decisions
**Trigger:** First phase of workflow commands

---

## Command-Specific Checks

Each command specifies which checks to run in parallel:

| Command  | Checks                                      | Output                     |
| -------- | ------------------------------------------- | -------------------------- |
| `/ms`    | complexity-check + tool-check + scope-check | score, tools[], scope      |
| `/build` | complexity-check + scope-check              | score, scope               |
| `/audit` | scope-check + agent-check                   | repos[], files[], agents[] |

**IMPORTANT:** Refer to the command file for the exact checks to spawn.

---

## Available Check Skills

| Skill                     | Agent                  | Output                                         |
| ------------------------- | ---------------------- | ---------------------------------------------- |
| `/skill complexity-check` | complexity-check-agent | `score: <int 1-50>`                            |
| `/skill tool-check`       | tool-check-agent       | `tools: [...]`                                 |
| `/skill scope-check`      | scope-check-agent      | `scope: { targets: [...], references: [...] }` |
| `/skill agent-check`      | agent-check-agent      | `agents: [...]`                                |

---

## How to Execute

Spawn check agents in PARALLEL using dedicated analysis agents (zero tool access):

```
# Example for /ms (3 checks)
Task 1: subagent_type="core-claude-plugin:generic:complexity-check-agent"
  Prompt: "Analyze this prompt and return complexity score: {USER_PROMPT}"

Task 2: subagent_type="core-claude-plugin:generic:tool-check-agent"
  Prompt: "Analyze this prompt and return required MCP tools: {USER_PROMPT}"

Task 3: subagent_type="core-claude-plugin:generic:scope-check-agent"
  Prompt: "Analyze this prompt and return scope (CWD: {CWD}): {USER_PROMPT}"
```

**Results are returned inline.** Each Task call returns the agent's output directly in the response. Read the result from the Task response and proceed immediately.

**Why dedicated agents?** These agents specify `tools: TodoWrite` (a minimal core tool) instead of inheriting all tools, which eliminates ~37k tokens of MCP tool schemas per agent.

Collect results from the Task responses based on which checks were run.

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
