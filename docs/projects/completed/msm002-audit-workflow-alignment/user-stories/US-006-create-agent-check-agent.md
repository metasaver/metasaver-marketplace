# US-006: Create agent-check-agent (NEW)

**Status:** 🔵 Pending
**Priority:** Critical
**Estimated Effort:** Low
**File:** `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/generic/agent-check-agent.md`

---

## Story

As a new agent, I need to invoke the agent-check skill and return the list of agents needed for audit execution so that the workflow knows which config agents to spawn during Investigation phase.

---

## Acceptance Criteria

### Create File with Proper Frontmatter

- [ ] Create file at: `plugins/metasaver-core/agents/generic/agent-check-agent.md`
- [ ] Add frontmatter:
  - name: agent-check-agent
  - description: Mapping specialist that identifies which config agents are needed for audit
  - model: haiku
  - tools: TodoWrite
  - permissionMode: bypassPermissions

### Document Agent Purpose

- [ ] Purpose: Analyze scope and return list of agents needed for audit
- [ ] Domain: Agent selection and mapping
- [ ] Authority: Text classification and file type matching
- [ ] Mode: Analysis (no file access needed)

### Document Execution Steps

- [ ] How to Execute section with clear steps:
  1. Receive scope from command (repos[], files[])
  2. Receive prompt from command
  3. Invoke `/skill agent-check` with scope and prompt
  4. Return output: `agents: string[]`

### Define Input/Output

- [ ] Input section:
  - scope: { repos[], files[] } (from scope-check-agent)
  - prompt: string (original user prompt)
  - CWD context (from command)

- [ ] Output section:
  - agents: string[] (list of agent names to spawn)
  - Example: `agents: ["eslint-agent", "prettier-agent"]`

### Add Integration Notes

- [ ] Runs in Phase 1 Analysis (parallel with scope-check-agent)
- [ ] Receives scope-check output via command orchestration
- [ ] Output passed to Requirements phase for story creation
- [ ] Fast execution (haiku model, text analysis only)

---

## Dependencies

- **Depends on:** US-005 (agent-check skill must exist)
- **Blocks:** US-001 (audit.md references this agent)

---

## Technical Notes

### Agent Structure

This is a lightweight wrapper agent similar to scope-check-agent:

- Invokes a skill (doesn't implement logic directly)
- Fast execution (haiku model)
- Text analysis only (no file operations)
- Returns structured output for command to consume

**Template Reference:** See `scope-check-agent.md` for similar structure

### Execution Flow

```
Command spawns agent-check-agent with:
  - scope: { repos: [...], files: [...] }
  - prompt: "audit eslint across all repos"

Agent invokes:
  /skill agent-check

Skill returns:
  agents: ["eslint-agent"]

Agent forwards to command:
  agents: ["eslint-agent"]
```

### Output Format Example

```
agents: ["eslint-agent", "prettier-agent", "turbo-agent"]
```

**NOT JSON** - Just plain text list for easy parsing by command.

---

## Definition of Done

- [ ] File created at correct path
- [ ] Frontmatter complete with all required fields
- [ ] Purpose section clearly states agent role
- [ ] Execution steps documented (invoke skill pattern)
- [ ] Input/output format specified
- [ ] Integration notes added
- [ ] File validates as proper markdown
- [ ] Follows same pattern as scope-check-agent.md
