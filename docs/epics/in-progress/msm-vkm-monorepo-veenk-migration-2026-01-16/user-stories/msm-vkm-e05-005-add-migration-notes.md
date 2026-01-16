---
story_id: "MSM-VKM-E05-005"
epic_id: "MSM-VKM-E05"
title: "Add migration notes to all PRDs"
status: "pending"
complexity: 2
wave: 4
agent: "core-claude-plugin:generic:coder"
dependencies: ["MSM-VKM-E05-001", "MSM-VKM-E05-002", "MSM-VKM-E05-003", "MSM-VKM-E05-004"]
created: "2026-01-16"
updated: "2026-01-16"
---

# MSM-VKM-E05-005: Add migration notes to all PRDs

## User Story

**As a** developer reviewing migrated documentation
**I want** migration notes added to all PRD files from veenk
**So that** I can trace documentation origins and understand migration context

---

## Acceptance Criteria

- [ ] Migration note added to all 4 migrated PRD files
- [ ] Note includes migration date (2026-01-16)
- [ ] Note includes original epic name
- [ ] Note includes veenk commit hash (if available)
- [ ] Note format consistent across all PRDs
- [ ] Note placed at top of PRD file (after frontmatter)
- [ ] Original content unchanged
- [ ] Follows established template/pattern
- [ ] Format validated

---

## Technical Details

### Location

- **Repo:** metasaver-marketplace
- **Package:** docs/epics/in-progress/

### Files to Modify

| File | Changes |
| ---- | ------- |
| `vnk-mcp-server/prd.md` | Add migration note |
| `vnk-wfo-workflow-orchestrator/prd.md` | Add migration note |
| `vnk-multi-runtime-agents/prd.md` | Add migration note |
| `vnk-ui-chat-app/prd.md` | Add migration note |

---

## Implementation Notes

Add consistent migration note to all migrated PRDs:

### Migration Note Template

```markdown
> **Migration Note:** Migrated from veenk repository (2026-01-16)
> Original epic: [epic-id] | Veenk commit: [hash if available]
```

### Placement

- Insert after YAML frontmatter
- Before first heading
- Keep one blank line before/after note

### Dependencies

Depends on E05-001 through E05-004 (epics must be migrated first).

---

## Architecture

(Added by architect-agent - technical annotations pending)

**Key Files:**

- All PRD files in migrated epic directories

---

## Definition of Done

- [ ] Implementation complete
- [ ] Unit tests passing
- [ ] TypeScript compiles
- [ ] Lint passes
- [ ] Acceptance criteria verified
- [ ] All 4 PRDs have migration notes
- [ ] Notes format consistent

---

## Notes

- Provides traceability for migrated documentation
- Helps developers understand documentation origin
- Does not affect existing plugin structure at plugins/metasaver-core/
