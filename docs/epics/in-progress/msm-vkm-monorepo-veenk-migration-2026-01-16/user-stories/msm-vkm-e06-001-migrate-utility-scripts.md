---
story_id: "MSM-VKM-E06-001"
epic_id: "MSM-VKM-E06"
title: "Migrate utility scripts"
status: "pending"
complexity: 3
wave: 5
agent: "core-claude-plugin:generic:coder"
dependencies: ["MSM-VKM-E03-006"]
created: "2026-01-16"
updated: "2026-01-16"
---

# MSM-VKM-E06-001: Migrate utility scripts

## User Story

**As a** developer using repository utility scripts
**I want** veenk utility scripts migrated to marketplace scripts directory
**So that** workflow-related scripts are available in unified repository

---

## Acceptance Criteria

- [ ] All 9 utility scripts copied to marketplace scripts/ directory
- [ ] Scripts: setup-npmrc.js, setup-env.js, clean-and-build.sh, use-local-packages.sh, back-to-prod.sh, killport.sh, run.sh, qbp.sh, publish.sh
- [ ] File permissions preserved (executable)
- [ ] File contents unchanged during copy
- [ ] No naming conflicts with existing marketplace scripts
- [ ] Scripts prefixed with veenk- if conflicts exist
- [ ] Executable permissions verified (chmod +x)
- [ ] Unit tests cover acceptance criteria
- [ ] All tests pass

---

## Technical Details

### Location

- **Repo:** metasaver-marketplace
- **Package:** scripts/

### Files to Create

9 script files in scripts/ directory.

---

## Implementation Notes

Copy utility scripts from veenk to marketplace.

### Dependencies

Depends on MSM-VKM-E03-006 (code migration complete).

---

## Architecture

(Added by architect-agent - technical annotations pending)

**Key Files:**

- All utility scripts in scripts/ directory

---

## Definition of Done

- [ ] Implementation complete
- [ ] Unit tests passing
- [ ] TypeScript compiles
- [ ] Lint passes
- [ ] Acceptance criteria verified
- [ ] All 9 scripts migrated
- [ ] Permissions correct

---

## Notes

- Preserve executable permissions
- Rename if conflicts exist
- Does not affect existing plugin structure at plugins/metasaver-core/
