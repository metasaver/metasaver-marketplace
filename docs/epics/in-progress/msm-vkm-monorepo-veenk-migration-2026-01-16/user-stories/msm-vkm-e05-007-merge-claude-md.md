---
story_id: "MSM-VKM-E05-007"
epic_id: "MSM-VKM-E05"
title: "Merge CLAUDE.md files"
status: "pending"
complexity: 4
wave: 4
agent: "core-claude-plugin:generic:coder"
dependencies: ["MSM-VKM-E03-006"]
created: "2026-01-16"
updated: "2026-01-16"
---

# MSM-VKM-E05-007: Merge CLAUDE.md files

## User Story

**As a** Claude Code user working in the monorepo
**I want** CLAUDE.md merged from both repositories
**So that** Claude Code has complete context for both marketplace and workflow packages

---

## Acceptance Criteria

- [ ] CLAUDE.md contains sections from both marketplace and veenk
- [ ] MetaSaver Constitution preserved from marketplace
- [ ] Monorepo conventions added from veenk
- [ ] Workflow-specific guidance added
- [ ] Package development instructions included
- [ ] Repository overview updated to reflect hybrid structure
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
| `CLAUDE.md` | Merge sections from veenk CLAUDE.md |

---

## Implementation Notes

Merge CLAUDE.md files intelligently:

**Source files:**

- `/home/jnightin/code/metasaver-marketplace/CLAUDE.md` (current)
- `/home/jnightin/code/veenk/CLAUDE.md` (to merge)

**Merge strategy:**

1. Preserve all marketplace sections (MetaSaver Constitution, principles, etc.)
2. Add veenk workflow-specific sections
3. Update repository overview to mention hybrid structure
4. Add monorepo development workflow
5. Add package development guidance

### New Sections to Add

- Monorepo Development Workflow
- Package Development Guidelines
- LangGraph Workflow Development
- Working with Multiple Packages

### Dependencies

Depends on MSM-VKM-E03-006 (workflow package migration complete).

---

## Architecture

(Added by architect-agent - technical annotations pending)

**Key Files:**

- `CLAUDE.md` - Claude Code instructions

---

## Definition of Done

- [ ] Implementation complete
- [ ] Unit tests passing
- [ ] TypeScript compiles
- [ ] Lint passes
- [ ] Acceptance criteria verified
- [ ] CLAUDE.md comprehensive
- [ ] All sections relevant

---

## Notes

- Careful merge to avoid losing marketplace context
- Add workflow-specific guidance without disrupting existing content
- Does not affect existing plugin structure at plugins/metasaver-core/
