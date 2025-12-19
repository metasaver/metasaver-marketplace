# US-006: Create File Audit Checklist

**Epic:** EPIC-001
**Status:** 🔵 Pending
**Assignee:** unassigned
**Depends On:** none
**Parallelizable With:** US-001, US-002, US-003, US-004, US-005
**Priority:** Medium
**Estimated Size:** Small (10 min)
**PRD Reference:** ../prd.md

---

## User Story

As a PM tracking positive framing refactoring, I want a checklist of all 59 files with NEVER/DON'T/DO NOT so that I can prioritize and track review progress.

---

## Acceptance Criteria

- [ ] Checklist file created at `docs/projects/20251219-positive-reinforcement-hooks/file-audit-checklist.md`
- [ ] All 59 files listed with file paths
- [ ] Files categorized by type: commands, agents, skills, docs
- [ ] Priority assigned: High (commands, core agents), Medium (skills, config agents), Low (docs)
- [ ] Parallelizable batches identified
- [ ] Checkbox format for tracking completion

---

## Architecture Notes

> Added by Architect after PRD approval

- **Files:**
  - `docs/projects/20251219-positive-reinforcement-hooks/file-audit-checklist.md` (create)
- **Pattern:**
  - Use Grep tool to find files: pattern="NEVER|DON'T|DO NOT", glob="\*.md"
  - Search in: `plugins/metasaver-core/{agents,skills,commands}/`
  - Generate categorized markdown checklist
- **Dependencies:**
  - None (can run in parallel with US-001)
- **Notes:**
  - Grep command: `pattern="NEVER|DON'T|DO NOT"` with `output_mode="files_with_matches"`
  - Categorize files: commands (High), agents/generic (High), skills (Medium), agents/config (Medium), docs (Low)
  - Format: checkbox per file with priority label
  - Group by parallelizable batches (e.g., all commands can be reviewed together)
  - Include file counts per category for tracking
  - Note: This is a tracking document for US-007 and US-008 execution

---

## Implementation Notes

> Added by Worker during execution

(Not started yet)

---

## Completion

> Updated by PM when story is complete

(Not completed yet)
