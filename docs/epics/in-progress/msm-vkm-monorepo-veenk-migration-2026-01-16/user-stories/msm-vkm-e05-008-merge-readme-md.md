---
story_id: "MSM-VKM-E05-008"
epic_id: "MSM-VKM-E05"
title: "Merge README.md files"
status: "pending"
complexity: 4
wave: 4
agent: "core-claude-plugin:generic:coder"
dependencies: ["MSM-VKM-E03-006"]
created: "2026-01-16"
updated: "2026-01-16"
---

# MSM-VKM-E05-008: Merge README.md files

## User Story

**As a** developer discovering the repository
**I want** README.md merged from both repositories
**So that** the README accurately describes the hybrid marketplace + monorepo structure

---

## Acceptance Criteria

- [ ] README.md contains sections from both marketplace and veenk
- [ ] Repository overview updated to describe hybrid structure
- [ ] Marketplace features documented
- [ ] Monorepo structure documented
- [ ] LangGraph workflows section added
- [ ] Installation instructions comprehensive
- [ ] Development workflow updated
- [ ] No duplicate sections
- [ ] Sections organized logically
- [ ] Unit tests cover acceptance criteria
- [ ] All tests pass

---

## Technical Details

### Location

- **Repo:** metasaver-marketplace
- **Package:** root level

### Files to Modify

| File | Changes |
| ---- | ------- |
| `README.md` | Merge sections from veenk README.md |

---

## Implementation Notes

Merge README.md files intelligently:

**Source files:**

- `/home/jnightin/code/metasaver-marketplace/README.md` (current)
- `/home/jnightin/code/veenk/README.md` (to merge)

**Merge strategy:**

1. Preserve marketplace overview and features
2. Add monorepo structure section
3. Add LangGraph workflows section
4. Update installation instructions
5. Merge development workflow sections

### New Sections to Add

- **Monorepo Structure**: Document packages/, apps/, services/
- **LangGraph Workflows**: Document workflow package
- **Development Workflow**: Updated for monorepo
- **Running Workflows**: Instructions for LangGraph Studio

### Dependencies

Depends on MSM-VKM-E03-006 (workflow package migration complete).

---

## Architecture

(Added by architect-agent - technical annotations pending)

**Key Files:**

- `README.md` - Repository documentation

---

## Definition of Done

- [ ] Implementation complete
- [ ] Unit tests passing
- [ ] TypeScript compiles
- [ ] Lint passes
- [ ] Acceptance criteria verified
- [ ] README comprehensive
- [ ] All sections accurate

---

## Notes

- README is first impression - must be comprehensive
- Balance marketplace and monorepo information
- Does not affect existing plugin structure at plugins/metasaver-core/
