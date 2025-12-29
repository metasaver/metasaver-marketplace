---
story_id: "MSM-WKR-014"
epic_id: "MSM-WKR"
title: "Update /ms command"
status: "pending"
wave: 5
agent: "core-claude-plugin:generic:command-author"
dependencies: ["MSM-WKR-001", "MSM-WKR-002"]
priority: "P1"
created: "2024-12-29"
updated: "2024-12-29"
---

# MSM-WKR-014: Update /ms command

## User Story

As a user, I want /ms to remain a lightweight router without complexity-check or tool-check so that quick tasks execute efficiently.

---

## Acceptance Criteria

- [ ] /ms does NOT use complexity-check-skill (removed)
- [ ] /ms does NOT use tool-check-skill (removed)
- [ ] /ms remains lightweight (no PRD files, inline only)
- [ ] /ms routes to appropriate command or handles inline
- [ ] Update any references to removed skills

### Standard AC Items (Required)

- [ ] Follows established template/pattern
- [ ] Format validated

---

## Technical Details

### Location

- **Repo:** metasaver-marketplace
- **Package:** plugins/metasaver-core/commands/

### Files to Modify

| File             | Changes                             |
| ---------------- | ----------------------------------- |
| `commands/ms.md` | Remove references to deleted skills |

---

## Architecture

**Lightweight Workflow:**

```
/ms {description}
    → scope-check-agent (identify repos/files)
    → Route decision:
        → Complex project → Redirect to /build
        → Quick question → Redirect to /qq
        → Simple task → Handle inline with HITL gates
```

**Removed:**

- complexity-check-skill invocation
- tool-check-skill invocation

---

## Definition of Done

- [ ] /ms updated
- [ ] No references to complexity-check
- [ ] No references to tool-check
- [ ] Remains lightweight router
