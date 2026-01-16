---
story_id: "MSM-VKM-E07-007"
epic_id: "MSM-VKM-E07"
title: "Archive veenk repository on GitHub"
status: "pending"
complexity: 2
wave: 6
agent: "core-claude-plugin:generic:coder"
dependencies: ["MSM-VKM-E07-005", "MSM-VKM-E07-006"]
created: "2026-01-16"
updated: "2026-01-16"
---

# MSM-VKM-E07-007: Archive veenk repository on GitHub

## User Story

**As a** repository owner of the veenk GitHub repository
**I want** the veenk repository archived on GitHub
**So that** it's preserved as read-only historical record after successful migration to metasaver-marketplace

---

## Acceptance Criteria

- [ ] Veenk repository identified on GitHub (owner/repo)
- [ ] Migration completion verified (all stories complete)
- [ ] Archive README added to veenk repository explaining migration
- [ ] Archive README links to new location in metasaver-marketplace
- [ ] Repository archived on GitHub (read-only mode)
- [ ] Archive notice visible on GitHub repository page
- [ ] Original commit history preserved
- [ ] Follows established template/pattern
- [ ] Format validated

---

## Technical Details

### Location

- **Original Repo:** github.com/[owner]/veenk (TBD)
- **New Location:** github.com/[owner]/metasaver-marketplace/packages/veenk-workflows
- **Archive Reference:** zzzold/veenk-reference/ in marketplace

### Actions Required

| Action                        | Purpose                                    |
| ----------------------------- | ------------------------------------------ |
| Add ARCHIVED.md to veenk      | Explain migration and link to new location |
| Archive repository on GitHub  | Set to read-only mode                      |
| Update repository description | Add "Archived - migrated to marketplace"   |

---

## Implementation Notes

### Pre-Archive Checklist

Before archiving, verify:

- [ ] All code migrated successfully (MSM-VKM-E03 complete)
- [ ] All documentation migrated (MSM-VKM-E05 complete)
- [ ] All scripts/hooks migrated (MSM-VKM-E06 complete)
- [ ] Reference copy created (MSM-VKM-E07-005 complete)
- [ ] Migration summary documented (MSM-VKM-E07-006 complete)
- [ ] All builds/tests passing in marketplace

### Archive Process

**1. Add ARCHIVED.md to veenk repository:**

Create file at repository root:

```markdown
# Repository Archived

This repository has been migrated to the MetaSaver Marketplace monorepo.

**Migration Date:** 2026-01-16

**New Location:**

- Code: [metasaver-marketplace/packages/veenk-workflows](https://github.com/[owner]/metasaver-marketplace/tree/main/packages/veenk-workflows)
- Documentation: [metasaver-marketplace/docs/epics/](https://github.com/[owner]/metasaver-marketplace/tree/main/docs/epics)
- Reference: [metasaver-marketplace/zzzold/veenk-reference](https://github.com/[owner]/metasaver-marketplace/tree/main/zzzold/veenk-reference)

**Why Migrated:**
Veenk workflows have been integrated into the MetaSaver ecosystem as a monorepo package for better code sharing, unified CI/CD, and streamlined maintenance.

**What Was Migrated:**

- LangGraph workflow implementations
- Documentation (4 epics, 58+ files)
- Utility scripts and hooks
- Configuration files

**Historical Reference:**
This repository remains available as read-only archive. All commit history is preserved.

For questions or issues, please open an issue in [metasaver-marketplace](https://github.com/[owner]/metasaver-marketplace).
```

**2. Update repository description on GitHub:**

Change description to:

```
[Archived] Veenk LangGraph workflows - Migrated to metasaver-marketplace/packages/veenk-workflows
```

**3. Archive repository on GitHub:**

- Go to repository Settings
- Scroll to "Danger Zone"
- Click "Archive this repository"
- Confirm archive action

**4. Verify archive status:**

- Repository shows "Archived" badge
- No new issues/PRs can be opened
- Code remains readable
- Commit history preserved

---

## Architecture

(Added by architect-agent - technical annotations pending)

**Key Files:**

- `ARCHIVED.md` - Archive notice in veenk repository
- GitHub repository settings - Archive status

**Archive Strategy:**

- Preserve complete history
- Provide clear migration path
- Link to new locations
- Prevent new development in archived repo

---

## Definition of Done

- [ ] Implementation complete
- [ ] ARCHIVED.md added to veenk repository
- [ ] Repository description updated
- [ ] Repository archived on GitHub
- [ ] Archive badge visible on GitHub
- [ ] Links to new locations tested
- [ ] Acceptance criteria verified
- [ ] Stakeholders notified of archive

---

## Notes

- This is the final step in the migration process
- Archive is irreversible (but can be unarchived if needed)
- Original repository remains readable forever
- All commit history and releases preserved
- Issues and PRs become read-only
- Forks remain active (not affected by archive)
- Consider announcement to users/contributors before archiving
