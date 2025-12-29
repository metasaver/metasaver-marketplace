---
story_id: "MSM-WKR-012"
epic_id: "MSM-WKR"
title: "Update /build command"
status: "pending"
wave: 5
agent: "core-claude-plugin:generic:command-author"
dependencies: ["MSM-WKR-010", "MSM-WKR-011"]
priority: "P0"
created: "2024-12-29"
updated: "2024-12-29"
---

# MSM-WKR-012: Update /build command

## User Story

As a user, I want /build to always run the full workflow with sequential-thinking so that every build follows the complete agent chain.

---

## Acceptance Criteria

- [ ] /build ALWAYS runs full workflow (no complexity routing)
- [ ] /build uses sequential-thinking MCP tool
- [ ] /build follows workflow: requirements-phase → design-phase → execution-phase
- [ ] Remove any references to complexity-check-skill
- [ ] Remove any conditional routing based on complexity

### Standard AC Items (Required)

- [ ] Follows established template/pattern
- [ ] Format validated

---

## Technical Details

### Location

- **Repo:** metasaver-marketplace
- **Package:** plugins/metasaver-core/commands/

### Files to Modify

| File                | Changes                                     |
| ------------------- | ------------------------------------------- |
| `commands/build.md` | Remove complexity routing, always full flow |

---

## Architecture

**New Flow:**

```
/build {description}
    → sequential-thinking (plan approach)
    → requirements-phase (EA → Reviewer → HITL → BA)
    → design-phase (Architect → PM → Reviewer → HITL → BA → Reviewer → HITL)
    → execution-phase (wave-based agent spawning)
```

**Removed:**

- complexity-check-skill invocation
- Conditional routing to lightweight workflow
- Any "simple task" shortcuts

---

## Definition of Done

- [ ] /build always runs full workflow
- [ ] No complexity routing
- [ ] Uses sequential-thinking
- [ ] Follows complete agent chain
