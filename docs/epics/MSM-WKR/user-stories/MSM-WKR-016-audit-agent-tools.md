---
story_id: "MSM-WKR-016"
epic_id: "MSM-WKR"
title: "Audit all agents for correct tools"
status: "pending"
wave: 5
agent: "core-claude-plugin:generic:reviewer"
dependencies: ["MSM-WKR-003", "MSM-WKR-008", "MSM-WKR-009"]
priority: "P0"
created: "2024-12-29"
updated: "2024-12-29"
---

# MSM-WKR-016: Audit all agents for correct tools

## User Story

As a maintainer, I want all agents audited to ensure their listed tools match the actual tools available in .mcp.json so that agents don't reference unavailable tools.

---

## Acceptance Criteria

- [ ] All agents in `agents/generic/` audited
- [ ] All agents in `agents/domain/` audited
- [ ] All agents in `agents/config/` audited
- [ ] Each agent's tool list compared against `.mcp.json`
- [ ] Discrepancies documented and fixed
- [ ] No agent references tools not in `.mcp.json`

### Standard AC Items (Required)

- [ ] Follows established template/pattern
- [ ] Format validated

---

## Technical Details

### Location

- **Repo:** metasaver-marketplace
- **Package:** plugins/metasaver-core/

### Files to Audit

| Directory         | Action                              |
| ----------------- | ----------------------------------- |
| `agents/generic/` | Audit all .md files                 |
| `agents/domain/`  | Audit all .md files                 |
| `agents/config/`  | Audit all .md files                 |
| `.mcp.json`       | Source of truth for available tools |

### Files to Modify

Any agent files with incorrect tool references.

---

## Architecture

**Audit Process:**

```
1. Parse .mcp.json to get list of available MCP tools
2. For each agent file:
   a. Extract tool list from frontmatter/body
   b. Compare against .mcp.json
   c. Flag any tools not in .mcp.json
3. Generate audit report
4. Fix discrepancies
```

**Expected Tool Categories:**

- Claude Code built-in: Read, Write, Edit, Glob, Grep, Bash, Task, etc.
- MCP tools from .mcp.json: Serena, Context7, Chrome DevTools, etc.
- Skills: Referenced by name, not as tools

---

## Definition of Done

- [ ] All agents audited
- [ ] Audit report generated
- [ ] All discrepancies fixed
- [ ] No agents reference unavailable tools
