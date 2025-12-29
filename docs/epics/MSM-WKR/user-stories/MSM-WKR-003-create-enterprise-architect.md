---
story_id: "MSM-WKR-003"
epic_id: "MSM-WKR"
title: "Create enterprise-architect agent"
status: "pending"
wave: 2
agent: "core-claude-plugin:generic:agent-author"
dependencies: ["MSM-WKR-001", "MSM-WKR-002"]
priority: "P0"
created: "2024-12-29"
updated: "2024-12-29"
---

# MSM-WKR-003: Create enterprise-architect agent

## User Story

As a workflow orchestrator, I want an Enterprise Architect (EA) agent that understands user requests, explores the codebase, asks clarifying questions, and creates PRDs so that strategic requirements gathering is separated from tactical story decomposition.

---

## Acceptance Criteria

- [ ] Agent file created at `agents/generic/enterprise-architect.md`
- [ ] Agent has correct frontmatter:
  - [ ] name: enterprise-architect
  - [ ] description: Strategic vision, PRD creation, requirements gathering
  - [ ] tools: Read, Write, Edit, Glob, Grep, Bash, Task
- [ ] Agent uses MCP tools:
  - [ ] Serena (code exploration)
  - [ ] Context7 (library documentation)
  - [ ] Sequential Thinking (structured analysis)
  - [ ] AskUserQuestion (HITL clarification)
- [ ] Agent workflow documented:
  - [ ] Phase 1: Understand request
  - [ ] Phase 2: Explore existing system (Serena)
  - [ ] Phase 3: Clarify with user (HITL)
  - [ ] Phase 4: Create PRD (invoke prd-creation-skill)
- [ ] Agent does NOT create user stories (that's BA's job)
- [ ] Agent references `prd-creation-skill` for template

### Standard AC Items (Required)

- [ ] Follows established template/pattern
- [ ] Format validated

---

## Technical Details

### Location

- **Repo:** metasaver-marketplace
- **Package:** plugins/metasaver-core/agents/generic/

### Files to Create

| File                                     | Purpose             |
| ---------------------------------------- | ------------------- |
| `agents/generic/enterprise-architect.md` | EA agent definition |

---

## Architecture

**Domain:** Strategic requirements, PRD creation

**Workflow:**

```
User Request → EA parses intent
            → EA explores codebase (Serena)
            → EA asks clarifying questions (HITL)
            → EA invokes prd-creation-skill
            → Output: prd.md
```

**Key Distinction from Other Agents:**

- EA: WHAT to build (requirements, strategic)
- Architect: HOW to build (technical design)
- BA: Breaking down into stories (tactical)

**Tools Required:**

- Serena: `get_symbols_overview`, `find_symbol`, `search_for_pattern`
- Context7: `resolve-library-id`, `query-docs`
- Sequential Thinking: `sequentialthinking`
- Core: Read, Write, Edit, Glob, Grep, Bash, Task

---

## Definition of Done

- [ ] Agent file exists and is valid markdown
- [ ] Agent has correct tools in frontmatter
- [ ] Agent references prd-creation-skill
- [ ] Agent does not mention creating user stories
