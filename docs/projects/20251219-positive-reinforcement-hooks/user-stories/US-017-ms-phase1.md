# US-017: Implement /ms Phase 1 (Entry + State Check)

**Epic:** EPIC-003
**Status:** 🔵 Pending
**Assignee:** unassigned
**Depends On:** US-016
**Parallelizable With:** none (needs state management)
**Priority:** High
**Estimated Size:** Medium (15-20 min)
**PRD Reference:** ../prd.md

---

## User Story

As a /ms command user, I want the command to detect active workflows so that I can resume work seamlessly after HITL stops.

---

## Acceptance Criteria

- [ ] /ms checks for workflow-state.json in docs/projects/\*/
- [ ] /ms checks TodoWrite for workflow markers
- [ ] /ms parses prompt for continuation keywords: "continue", "proceed", "yes", "do it"
- [ ] Detection priority: state file > TodoWrite > prompt keywords
- [ ] Routes to Phase 2a (resume) if active workflow detected
- [ ] Routes to Phase 2b (new) if no active workflow
- [ ] Logs detection decision for debugging

---

## Architecture Notes

> Added by Architect after PRD approval

- **Files:**
  - `plugins/metasaver-core/commands/ms.md` (update Phase 1 section)
- **Pattern:**
  - Use command-author to modify /ms command
  - Update existing Phase 1 logic to add state detection
  - Add workflow resumption routing
- **Dependencies:**
  - Requires US-016 (state-management skill) complete
  - State management skill must be available for invocation
- **Notes:**
  - Detection priority: 1) workflow-state.json file, 2) TodoWrite markers, 3) prompt keywords
  - Glob for state files: `docs/projects/*/workflow-state.json`
  - TodoRead check: look for "WORKFLOW:" markers or project folder references
  - Prompt keywords: "continue", "proceed", "yes", "do it", "resume"
  - If state file found: route to Phase 2a (resume workflow)
  - If no state file: route to Phase 2b (new workflow analysis)
  - Log detection decision for debugging: "Detected active workflow in {folder}"
  - Use state-management skill to read state file
  - Insert this logic at START of Phase 1 (before existing analysis)

---

## Implementation Notes

> Added by Worker during execution

(Not started yet)

---

## Completion

> Updated by PM when story is complete

(Not completed yet)
