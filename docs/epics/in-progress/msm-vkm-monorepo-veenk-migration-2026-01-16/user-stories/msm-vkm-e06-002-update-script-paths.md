---
story_id: "MSM-VKM-E06-002"
epic_id: "MSM-VKM-E06"
title: "Update script paths"
status: "pending"
complexity: 3
wave: 5
agent: "core-claude-plugin:generic:coder"
dependencies: ["MSM-VKM-E06-001"]
created: "2026-01-16"
updated: "2026-01-16"
---

# MSM-VKM-E06-002: Update script paths

## User Story

**As a** developer running utility scripts
**I want** all script path references updated to marketplace structure
**So that** scripts work correctly after migration

---

## Acceptance Criteria

- [ ] All hardcoded veenk paths replaced with marketplace paths
- [ ] Relative path references updated if needed
- [ ] Scripts reference correct package locations (packages/veenk-workflows)
- [ ] Scripts reference correct configuration file locations
- [ ] All scripts execute without path errors
- [ ] Scripts tested manually
- [ ] Unit tests cover acceptance criteria
- [ ] All tests pass

---

## Technical Details

### Location

- **Repo:** metasaver-marketplace
- **Package:** scripts/

### Files to Modify

All migrated script files (9 scripts).

---

## Implementation Notes

Update path references in all scripts.

### Dependencies

Depends on MSM-VKM-E06-001 (scripts must be migrated first).

---

## Architecture

(Added by architect-agent - technical annotations pending)

**Key Files:**

- All script files in scripts/ directory

---

## Definition of Done

- [ ] Implementation complete
- [ ] Unit tests passing
- [ ] TypeScript compiles
- [ ] Lint passes
- [ ] Acceptance criteria verified
- [ ] All paths updated
- [ ] Scripts execute without errors

---

## Notes

- Test scripts manually after path updates
- Verify package references correct
- Does not affect existing plugin structure at plugins/metasaver-core/
