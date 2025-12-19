# US-016: Create PM State Management Skill

**Epic:** EPIC-003
**Status:** 🔵 Pending
**Assignee:** unassigned
**Depends On:** US-015
**Parallelizable With:** none (needs schema from US-015)
**Priority:** High
**Estimated Size:** Medium (15-20 min)
**PRD Reference:** ../prd.md

---

## User Story

As a PM agent, I want a state management skill so that I can read, write, and update workflow-state.json files consistently.

---

## Acceptance Criteria

- [ ] Skill created at `plugins/metasaver-core/skills/workflow-steps/state-management.md`
- [ ] Provides read method: readWorkflowState(projectFolder)
- [ ] Provides write method: writeWorkflowState(projectFolder, state)
- [ ] Provides update method: updateWorkflowState(projectFolder, updates)
- [ ] Provides helper: getCurrentWave(state)
- [ ] Provides helper: getNextStories(state, wave)
- [ ] Provides helper: markStoryComplete(state, storyId)
- [ ] Includes error handling for missing/corrupt files
- [ ] Validates state against schema from US-015

---

## Architecture Notes

> Added by Architect after PRD approval

- **Files:**
  - `plugins/metasaver-core/skills/workflow-steps/state-management.md` (create)
- **Pattern:**
  - Use skill-author agent to create skill file
  - Skill provides helper methods for state operations
  - All methods use Read/Write tools for file I/O
- **Dependencies:**
  - Requires US-015 (workflow-state-schema) for schema definition
  - Used by US-016, US-017, US-018, US-021, US-023
- **Notes:**
  - Method: `readWorkflowState(projectFolder)` - returns state object or null
  - Method: `writeWorkflowState(projectFolder, state)` - writes state.json file
  - Method: `updateWorkflowState(projectFolder, updates)` - merges updates into state
  - Helper: `getCurrentWave(state)` - returns current wave number
  - Helper: `getNextStories(state, wave)` - returns story IDs for wave
  - Helper: `markStoryComplete(state, storyId)` - moves story to completed array
  - Helper: `setHITL(state, question, resumeAction)` - sets HITL fields
  - Error handling: validate state against schema, return errors gracefully
  - File path: `{projectFolder}/workflow-state.json`
  - Include JSON validation before write operations

---

## Implementation Notes

> Added by Worker during execution

(Not started yet)

---

## Completion

> Updated by PM when story is complete

(Not completed yet)
