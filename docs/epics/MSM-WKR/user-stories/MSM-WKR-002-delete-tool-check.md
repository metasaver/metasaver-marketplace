---
story_id: "MSM-WKR-002"
epic_id: "MSM-WKR"
title: "Delete tool-check skill"
status: "pending"
wave: 1
agent: "core-claude-plugin:generic:coder"
dependencies: []
priority: "P0"
created: "2024-12-29"
updated: "2024-12-29"
---

# MSM-WKR-002: Delete tool-check skill

## User Story

As a plugin maintainer, I want to remove the tool-check skill so that agents have fixed tool assignments rather than dynamic tool detection.

---

## Acceptance Criteria

- [ ] Delete `skills/cross-cutting/tool-check/` folder entirely
- [ ] Remove all references to "tool-check" in commands and agents
- [ ] Grep confirms zero references remain: `grep -r "tool-check" plugins/ --include="*.md"`
- [ ] Update `marketplace.json` if skill was listed

### Standard AC Items (Required)

- [ ] Follows established template/pattern
- [ ] Format validated

---

## Technical Details

### Location

- **Repo:** metasaver-marketplace
- **Package:** plugins/metasaver-core

### Files to Delete

| File                                       | Purpose          |
| ------------------------------------------ | ---------------- |
| `skills/cross-cutting/tool-check/SKILL.md` | The skill itself |
| `skills/cross-cutting/tool-check/`         | Entire folder    |

### Files to Modify

| File                                | Changes           |
| ----------------------------------- | ----------------- |
| Any commands referencing tool-check | Remove references |
| Any agents referencing tool-check   | Remove references |

---

## Implementation Notes

1. Search for all references: `grep -r "tool-check" plugins/`
2. Delete the skill folder
3. Update each referencing file
4. Verify no orphaned references remain

---

## Definition of Done

- [ ] Skill folder deleted
- [ ] All references removed
- [ ] Grep returns 0 results
