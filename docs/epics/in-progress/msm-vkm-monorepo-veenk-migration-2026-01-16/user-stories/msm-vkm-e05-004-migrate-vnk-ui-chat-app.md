---
story_id: "MSM-VKM-E05-004"
epic_id: "MSM-VKM-E05"
title: "Migrate vnk-ui-chat-app epic"
status: "pending"
complexity: 3
wave: 4
agent: "core-claude-plugin:generic:coder"
dependencies: ["MSM-VKM-E03-006"]
created: "2026-01-16"
updated: "2026-01-16"
---

# MSM-VKM-E05-004: Migrate vnk-ui-chat-app epic

## User Story

**As a** developer referencing epic documentation
**I want** vnk-ui-chat-app epic migrated to marketplace docs
**So that** all planning and requirements are accessible in unified location

---

## Acceptance Criteria

- [ ] Directory docs/epics/in-progress/vnk-ui-chat-app/ migrated to marketplace
- [ ] All markdown files copied (PRD, user stories, execution plans, investigations)
- [ ] Directory structure preserved
- [ ] File contents unchanged during copy
- [ ] Migration note added to PRD header
- [ ] Epic status preserved (in-progress, backlog, or completed)
- [ ] All files accessible in marketplace location
- [ ] Unit tests cover acceptance criteria
- [ ] All tests pass

---

## Technical Details

### Location

- **Repo:** metasaver-marketplace
- **Package:** docs/epics/

### Files to Create

All files from veenk vnk-ui-chat-app epic.

### Files to Modify

- PRD file: Add migration note header

---

## Implementation Notes

Copy entire epic directory from veenk to marketplace:

**Source location:** `/home/jnightin/code/veenk/docs/epics/in-progress/vnk-ui-chat-app/`
**Target location:** `/home/jnightin/code/metasaver-marketplace/docs/epics/in-progress/vnk-ui-chat-app/`

### Migration Note Template

Add to top of PRD file:

```markdown
> **Migration Note:** Migrated from veenk repository (2026-01-16)
> Original epic: vnk-ui-chat-app | Veenk commit: [hash]
```

### Dependencies

Depends on MSM-VKM-E03-006 (code migration complete).

---

## Architecture

(Added by architect-agent - technical annotations pending)

**Key Files:**

- All files in vnk-ui-chat-app epic directory

---

## Definition of Done

- [ ] Implementation complete
- [ ] Unit tests passing
- [ ] TypeScript compiles
- [ ] Lint passes
- [ ] Acceptance criteria verified
- [ ] All files migrated
- [ ] Migration note added

---

## Notes

- Straight copy operation - preserve all content
- Migration note provides traceability
- Does not affect existing plugin structure at plugins/metasaver-core/
