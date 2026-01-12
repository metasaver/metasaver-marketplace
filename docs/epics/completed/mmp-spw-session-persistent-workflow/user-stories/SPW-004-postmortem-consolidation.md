# SPW-004: Post-Mortem Consolidation Document

## Story Info

| Field      | Value                            |
| ---------- | -------------------------------- |
| Story ID   | SPW-004                          |
| Epic       | MMP-SPW                          |
| Priority   | P2 (Medium)                      |
| Status     | complete                         |
| Complexity | Low                              |
| Agent      | core-claude-plugin:generic:coder |

---

## User Story

**As a** MetaSaver developer
**I want** all workflow failure learnings consolidated into one document
**So that** future development benefits from past mistakes without searching multiple files

---

## Acceptance Criteria

- [ ] Consolidation doc created at `docs/architecture/workflow-failures-consolidated.md`
- [ ] Document includes learnings from MSC-CAI post-mortem
- [ ] Document includes learnings from MUM-VCR post-mortem
- [ ] Document includes learnings from ESLint audit post-mortems
- [ ] Document organized by failure category (HITL, story updates, false completion, etc.)
- [ ] Document includes actionable prevention measures

---

## Definition of Done

- [ ] Consolidation document created
- [ ] All backlog post-mortems reviewed and key points extracted
- [ ] Backlog files moved to `docs/epics/backlog/archived/` (not deleted)
- [ ] Original files preserved for historical reference

---

## Technical Notes

### Document Structure

```markdown
# Workflow Failures: Consolidated Learnings

## Overview

Summary of all documented workflow failures and their root causes.

## Failure Categories

### 1. HITL Violations

- MSC-CAI: Auto-archived without approval
- Prevention: Require explicit user command to archive

### 2. Story Update Failures

- MUM-VCR: Stories never updated despite claiming completion
- Prevention: Workflow enforcement skill validates before completion

### 3. False Completion Claims

- Pattern: Build passing ≠ complete
- Prevention: HITL required before any completion claim

## Action Items (Implemented)

- [x] Constitution section in CLAUDE.md
- [x] /session restore command
- [x] Workflow enforcement skill

## References

- [MSC-CAI Post-Mortem](../backlog/archived/msc-cai...)
- [MUM-VCR Post-Mortem](../backlog/archived/mum-vcr...)
```

### File Organization After Consolidation

```
docs/epics/backlog/
├── archived/
│   ├── msc-cai-workflow-failure-post-mortem.md
│   ├── mum-vcr-workflow-failure-post-mortem.md
│   ├── eslint-audit-2026-01-06/
│   │   ├── post-mortem.md
│   │   └── eslint-audit-2026-01-07-postmortem.md
│   └── prompt.txt
└── (empty - ready for new backlog items)
```

---

## Dependencies

- SPW-001, SPW-002, SPW-003 should be complete so their implementation can be referenced
