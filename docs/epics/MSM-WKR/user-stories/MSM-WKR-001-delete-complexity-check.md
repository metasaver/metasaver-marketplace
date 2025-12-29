---
story_id: "MSM-WKR-001"
epic_id: "MSM-WKR"
title: "Delete complexity-check skill"
status: "pending"
wave: 1
agent: "core-claude-plugin:generic:coder"
dependencies: []
priority: "P0"
created: "2024-12-29"
updated: "2024-12-29"
---

# MSM-WKR-001: Delete complexity-check skill

## User Story

As a plugin maintainer, I want to remove the complexity-check skill so that the codebase is cleaner and /build always runs the full workflow without complexity-based routing.

---

## Acceptance Criteria

- [ ] Delete `skills/cross-cutting/complexity-check/` folder entirely
- [ ] Remove all references to "complexity-check" in these files:
  - [ ] `commands/build.md`
  - [ ] `commands/ms.md`
  - [ ] `commands/qq.md`
  - [ ] `commands/audit.md`
  - [ ] `skills/workflow-steps/analysis-phase/SKILL.md`
  - [ ] Any agents that reference it
- [ ] Grep confirms zero references remain: `grep -r "complexity-check" plugins/ --include="*.md"`
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

| File                                             | Purpose          |
| ------------------------------------------------ | ---------------- |
| `skills/cross-cutting/complexity-check/SKILL.md` | The skill itself |
| `skills/cross-cutting/complexity-check/`         | Entire folder    |

### Files to Modify

| File                                            | Changes                                                   |
| ----------------------------------------------- | --------------------------------------------------------- |
| `commands/build.md`                             | Remove Phase 1 complexity-check, remove FAST PATH routing |
| `commands/ms.md`                                | Remove complexity-check reference                         |
| `commands/qq.md`                                | Remove complexity-check from analysis phase               |
| `commands/audit.md`                             | Remove complexity-check if present                        |
| `skills/workflow-steps/analysis-phase/SKILL.md` | Remove complexity-check spawn                             |

---

## Implementation Notes

1. Search for all references first: `grep -r "complexity-check" plugins/`
2. Delete the skill folder
3. Update each referencing file to remove complexity-based routing
4. For /build: remove FAST PATH logic, always run full workflow
5. Verify no orphaned references remain

---

## Definition of Done

- [ ] Skill folder deleted
- [ ] All references removed
- [ ] Grep returns 0 results
- [ ] Commands still parse correctly (no broken references)
