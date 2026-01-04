---
story_id: "MSM-WFE-008"
title: "Enforce AskUserQuestion for HITL gates"
status: "pending"
agent: "core-claude-plugin:generic:skill-author"
dependencies: []
---

# Story: Enforce AskUserQuestion Tool for HITL Gates

## Description

As a workflow system, I need HITL gates to require the AskUserQuestion tool so that prose questions cannot bypass approval gates.

## Acceptance Criteria

- [ ] Modify `hitl-approval` skill to mandate AskUserQuestion tool
- [ ] Document prose question rejection
- [ ] Add examples of correct vs incorrect HITL
- [ ] Follows established skill template

## Technical Notes

**Files to modify:**

- `plugins/metasaver-core/skills/cross-cutting/hitl-approval/SKILL.md`

**Implementation:**

Add enforcement section:

```markdown
## HITL Tool Enforcement

HITL gates MUST use AskUserQuestion tool, never prose.

**Correct HITL:**
```

Use AskUserQuestion tool with:

- question: "Approve PRD package for implementation?"
- options: ["Approve", "Request Changes"]

```

**Incorrect HITL (REJECTED):**
```

"Ready to proceed? Let me know if you'd like any changes."

```

**Why:** Prose questions allow agents to continue without explicit user consent. The AskUserQuestion tool creates a blocking gate.

**Detection:** Commands check for AskUserQuestion tool call in agent response. Prose-only responses trigger loop back with instruction to use tool.
```
