---
story_id: "MSM-WKR-015"
epic_id: "MSM-WKR"
title: "Remove skill references from /qq and /audit"
status: "pending"
wave: 5
agent: "core-claude-plugin:generic:command-author"
dependencies: ["MSM-WKR-001", "MSM-WKR-002"]
priority: "P1"
created: "2024-12-29"
updated: "2024-12-29"
---

# MSM-WKR-015: Remove skill references from /qq and /audit

## User Story

As a maintainer, I want any references to complexity-check and tool-check removed from /qq and /audit so that there are no dangling references to deleted skills.

---

## Acceptance Criteria

- [ ] /qq has no references to complexity-check-skill
- [ ] /qq has no references to tool-check-skill
- [ ] /audit has no references to complexity-check-skill
- [ ] /audit has no references to tool-check-skill
- [ ] Commands function correctly after removal

### Standard AC Items (Required)

- [ ] Follows established template/pattern
- [ ] Format validated

---

## Technical Details

### Location

- **Repo:** metasaver-marketplace
- **Package:** plugins/metasaver-core/commands/

### Files to Modify

| File                | Changes                             |
| ------------------- | ----------------------------------- |
| `commands/qq.md`    | Remove references to deleted skills |
| `commands/audit.md` | Remove references to deleted skills |

---

## Architecture

**Search Pattern:**

```
grep -r "complexity-check" commands/
grep -r "tool-check" commands/
```

Remove all matches from /qq and /audit commands.

---

## Definition of Done

- [ ] /qq has no dangling skill references
- [ ] /audit has no dangling skill references
- [ ] Commands tested and functional
