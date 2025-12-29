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

| Command  | Checks                    | Output                     |
| -------- | ------------------------- | -------------------------- |
| `/ms`    | scope-check               | scope                      |
| `/build` | scope-check               | scope                      |
| `/audit` | scope-check + agent-check | repos[], files[], agents[] |

**IMPORTANT:** Refer to the command file for the exact checks to spawn.

---

## Available Check Skills

| Skill                | Agent             | Output                                         |
| -------------------- | ----------------- | ---------------------------------------------- |
| `/skill scope-check` | scope-check-agent | `scope: { targets: [...], references: [...] }` |
| `/skill agent-check` | agent-check-agent | `agents: [...]`                                |

---

## How to Execute

Spawn check agents in PARALLEL using dedicated analysis agents (zero tool access):

```
# Example for /ms or /build
Task 1: subagent_type="core-claude-plugin:generic:scope-check-agent"
  Prompt: "Analyze this prompt and return scope (CWD: {CWD}): {USER_PROMPT}"
```

**Results are returned inline.** Each Task call returns the agent's output directly in the response. Read the result from the Task response and proceed immediately.

**Why dedicated agents?** These agents specify `tools: TodoWrite` (a minimal core tool) instead of inheriting all tools, which eliminates ~37k tokens of MCP tool schemas per agent.

Collect results from the Task responses based on which checks were run.

---

## Skill Outputs

Each agent invokes its corresponding skill for the detailed algorithm:

| Agent             | Skill                | Output                                         |
| ----------------- | -------------------- | ---------------------------------------------- |
| scope-check-agent | `/skill scope-check` | `scope: { targets: [...], references: [...] }` |

See individual skill files for detailed algorithms and examples.

---

## Output Example

```json
{
  "scope": {
    "targets": ["/home/user/code/metasaver-com"],
    "references": ["/home/user/code/rugby-crm"]
  }
}
```

---

## Next Phase

After analysis, proceed to requirements-phase.

---

## Integration

**Called by:**

- `/audit` command
- `/build` command
- `/ms` command

**Calls:**

- `scope-check` skill (returns {targets: string[], references: string[]})

**Next step:** requirements-phase

---

## Example

```
Command: /build "Add Applications screen to metasaver-com, look at rugby-crm for patterns"

Analysis Phase:
  → scope-check: { targets: ["/home/user/code/metasaver-com"], references: ["/home/user/code/rugby-crm"] }

Output:
  {
    scope: {
      targets: ["/home/user/code/metasaver-com"],
      references: ["/home/user/code/rugby-crm"]
    }
  }

Next: requirements-phase
```
