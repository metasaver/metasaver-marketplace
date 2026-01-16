---
story_id: "MSM-VKM-E05-006"
epic_id: "MSM-VKM-E05"
title: "Update internal documentation links"
status: "pending"
complexity: 3
wave: 4
agent: "core-claude-plugin:generic:coder"
dependencies: ["MSM-VKM-E05-001", "MSM-VKM-E05-002", "MSM-VKM-E05-003", "MSM-VKM-E05-004"]
created: "2026-01-16"
updated: "2026-01-16"
---

# MSM-VKM-E05-006: Update internal documentation links

## User Story

**As a** developer following documentation links
**I want** all internal links updated to reflect marketplace paths
**So that** documentation navigation works correctly after migration

---

## Acceptance Criteria

- [ ] All veenk repository paths replaced with marketplace paths
- [ ] Relative links work correctly
- [ ] Absolute paths updated to marketplace structure
- [ ] Cross-epic references work
- [ ] No broken links remain
- [ ] Links verified manually or with link checker
- [ ] File references correct
- [ ] Unit tests cover acceptance criteria
- [ ] All tests pass

---

## Technical Details

### Location

- **Repo:** metasaver-marketplace
- **Package:** docs/epics/

### Files to Modify

All markdown files in migrated epic directories.

---

## Implementation Notes

Update all internal documentation links:

**Path Changes:**

- `/home/jnightin/code/veenk/` → `/home/jnightin/code/metasaver-marketplace/`
- `../veenk/` → `../`
- Relative paths: Update if directory structure changed

**Grep for hardcoded paths:**

```bash
grep -r "/home/jnightin/code/veenk" docs/epics/in-progress/vnk-*
grep -r "../../veenk" docs/epics/in-progress/vnk-*
```

### Dependencies

Depends on E05-001 through E05-004 (epics must be migrated first).

---

## Architecture

(Added by architect-agent - technical annotations pending)

**Key Files:**

- All markdown files in migrated epic directories

---

## Definition of Done

- [ ] Implementation complete
- [ ] Unit tests passing
- [ ] TypeScript compiles
- [ ] Lint passes
- [ ] Acceptance criteria verified
- [ ] All links work
- [ ] No broken references

---

## Notes

- Use find/replace for common path patterns
- Verify links manually after update
- Does not affect existing plugin structure at plugins/metasaver-core/
