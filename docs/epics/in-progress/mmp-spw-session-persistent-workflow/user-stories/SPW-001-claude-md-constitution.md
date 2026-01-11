# SPW-001: Enhanced CLAUDE.md Constitution

## Story Info

| Field      | Value                            |
| ---------- | -------------------------------- |
| Story ID   | SPW-001                          |
| Epic       | MMP-SPW                          |
| Priority   | P0 (Critical)                    |
| Status     | complete                         |
| Complexity | Medium                           |
| Agent      | core-claude-plugin:generic:coder |

---

## User Story

**As a** MetaSaver developer
**I want** CLAUDE.md to have a mandatory Constitution section at the very top
**So that** Claude always uses MetaSaver workflow without requiring manual prompting

---

## Acceptance Criteria

- [ ] Constitution section is the FIRST section in CLAUDE.md (before any other content)
- [ ] Constitution uses positive, mandatory language (MUST, ALWAYS - state what TO DO)
- [ ] Rules cover: agent usage, parallel execution, HITL, story updates, AskUserQuestion
- [ ] Section is visually distinct (clear header, formatted as rules)
- [ ] Existing "Always-On Behavior" section is updated to reference Constitution
- [ ] Template is created for propagation to consumer repos

---

## Definition of Done

- [ ] CLAUDE.md modified with Constitution section at top
- [ ] Constitution contains all 6 mandatory rules (positive framing)
- [ ] Template created at `templates/claude-md/constitution-section.md`
- [ ] Documentation on how to add Constitution to consumer repos
- [ ] Tested by starting new conversation and verifying workflow activates automatically

---

## Technical Notes

### Constitution Rules (Positive Framing)

1. ALWAYS use MetaSaver agents for implementation work (coder, tester, reviewer)
2. ALWAYS spawn agents in parallel when tasks are independent (single message, multiple Task calls)
3. ALWAYS follow /build or /ms workflow for code changes
4. ALWAYS get user approval (HITL) before marking work complete
5. ALWAYS update story files during execution (status, acceptance criteria checkboxes)
6. ALWAYS use AskUserQuestion tool for user interactions

### Placement

The Constitution appears as the FIRST section in CLAUDE.md, before "CRITICAL: Author Agent Requirements".

### Multi-Repo Propagation

This epic creates the **template** in the marketplace. Consumer repos need the Constitution added to their CLAUDE.md files:

**Target repos:**

- multi-mono
- metasaver-com
- rugby-crm
- resume-builder
- sandbox
- veenk

**Propagation options:**

1. Manual: Copy template to each repo's CLAUDE.md
2. Audit command: `/audit constitution` checks if repos have the Constitution section
3. Future: Auto-sync via plugin update mechanism

---

## Dependencies

None - this can be implemented immediately.
