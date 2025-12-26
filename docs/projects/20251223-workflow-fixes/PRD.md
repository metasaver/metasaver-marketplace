# PRD: Workflow Fixes - HITL, Compact, Epic Tracking, Story Consolidation

**Project:** 20251223-workflow-fixes
**Complexity:** ~22
**Date:** 2025-12-23

---

## Executive Summary

Based on postmortem feedback, this PRD addresses 4 workflow issues:

1. **Remove inter-wave HITL** - HITL only before execution, not between waves
2. **Keep /compact between waves** - Prevent context exhaustion
3. **Fix epic counter tracking** - Update epic.storiesCompleted when stories complete
4. **Story consolidation** - BA creates one story per target file

---

## User Stories

### Epic 1: Wave Execution Fixes

**US-001: Remove inter-wave HITL from execution-phase skill**

- **Target File:** `plugins/metasaver-core/skills/workflow-steps/execution-phase/SKILL.md`
- **As a** workflow orchestrator
- **I want** waves to execute continuously after initial approval
- **So that** users only approve once (before execution starts)

**Acceptance Criteria:**

- [ ] Remove HITL checkpoint code from wave completion (lines 88-98)
- [ ] Remove HITL section from State Tracking (lines 135-148)
- [ ] Remove "HITL checkpoint" from execution logic pseudocode (lines 204-206)
- [ ] Keep `/compact` call between waves (already exists at line 48, 185)
- [ ] Update description to remove "HITL" references
- [ ] Positive framing: "Waves execute continuously with /compact between each wave"

---

**US-002: Update build.md to clarify HITL timing**

- **Target File:** `plugins/metasaver-core/commands/build.md`
- **As a** /build command
- **I want** clear documentation that HITL is pre-execution only
- **So that** orchestrators understand approval happens once before execution

**Acceptance Criteria:**

- [ ] Phase 4 (Approval) states "Single approval gate before execution begins"
- [ ] Add note: "After approval, all waves execute continuously with /compact between waves"
- [ ] Remove any inter-wave HITL references in Enforcement section

---

### Epic 2: State Tracking Fixes

**US-003: Add epic counter updates on story completion**

- **Target File:** `plugins/metasaver-core/skills/workflow-steps/execution-phase/SKILL.md`
- **As a** workflow state tracker
- **I want** epic.storiesCompleted to update when stories complete
- **So that** workflow-state.json is accurate for resumption after /clear

**Acceptance Criteria:**

- [ ] Add function/logic to update parent epic's storiesCompleted counter
- [ ] Story completion code updates both stories.completed AND epic counter
- [ ] Update State Tracking section with epic counter update example
- [ ] Positive framing: "ALWAYS update epic progress counters when marking story complete"

---

### Epic 3: Story Consolidation

**US-004: Add file-based story consolidation to requirements-phase skill**

- **Target File:** `plugins/metasaver-core/skills/workflow-steps/requirements-phase/SKILL.md`
- **As a** requirements phase
- **I want** one story per target file (consolidate multiple requirements)
- **So that** agents work on files sequentially, not in parallel on same file

**Acceptance Criteria:**

- [ ] Add "Story Consolidation Rule" section after Epic Count Guidelines
- [ ] Rule: "Create ONE story per target file - consolidate multiple requirements"
- [ ] Example: If US-001 and US-004 both target build.md, combine into single story
- [ ] Positive framing: "Group related requirements by target file for sequential execution"

---

**US-005: Add file consolidation guidance to BA agent**

- **Target File:** `plugins/metasaver-core/agents/generic/business-analyst.md`
- **As a** BA agent
- **I want** guidance to consolidate stories by target file
- **So that** PRDs don't create multiple stories for the same file

**Acceptance Criteria:**

- [ ] Add "Story Consolidation" section in Best Practices or Domain Knowledge
- [ ] Rule: "One story per target file - combine requirements targeting same file"
- [ ] Example showing consolidation
- [ ] Positive framing: "Group all requirements for a file into a single story"

---

### Epic 4: Workflow Resilience (NEW from feedback)

**US-006: Add interruption handling to execution-phase skill**

- **Target File:** `plugins/metasaver-core/skills/workflow-steps/execution-phase/SKILL.md`
- **As a** workflow orchestrator
- **I want** state to be saved before any potential interruption point
- **So that** workflows can resume correctly after user stops or context clears

**Acceptance Criteria:**

- [ ] Add "Interruption Handling" section
- [ ] Rule: "ALWAYS update workflow-state.json before spawning each agent"
- [ ] Rule: "ALWAYS update workflow-state.json after each story completes"
- [ ] Positive framing: "Save state early and often for reliable resumption"

---

**US-007: Add project folder existence check to requirements-phase skill**

- **Target File:** `plugins/metasaver-core/skills/workflow-steps/requirements-phase/SKILL.md`
- **As a** requirements phase
- **I want** to check for existing project folders before creating new ones
- **So that** docs don't get created in wrong location

**Acceptance Criteria:**

- [ ] Add check: "Glob for existing `docs/projects/*` folders before creating new"
- [ ] If related folder exists, ask user whether to reuse or create new
- [ ] Positive framing: "Check for existing project context before creating new folder"

---

**US-008: Add agent selection announcement to execution-phase skill**

- **Target File:** `plugins/metasaver-core/skills/workflow-steps/execution-phase/SKILL.md`
- **As a** workflow orchestrator
- **I want** to explicitly state which agent is being spawned
- **So that** users can see agent routing is working correctly

**Acceptance Criteria:**

- [ ] Add to agent spawning template: "Announce: 'Spawning {agent-name} for {story-id}'"
- [ ] Positive framing: "ALWAYS announce agent selection before spawning"

---

## Execution Plan

**Wave 1: Execution-phase skill (US-001, US-003, US-006, US-008)** ✅ COMPLETE

- All target same file, single skill-author agent
- US-001: Remove HITL between waves ✅
- US-003: Add epic counter updates ✅
- US-006: Add interruption handling (to be added)
- US-008: Add agent selection announcement (to be added)

**Wave 2: Commands + Skills (parallel)**

- US-002: build.md (command-author)
- US-004: requirements-phase (skill-author)
- US-007: requirements-phase - project folder check (skill-author) - same file as US-004

**Wave 3: BA Agent**

- US-005: business-analyst.md (agent-author)

---

## Files to Modify

| File                        | Stories                        | Author Agent   |
| --------------------------- | ------------------------------ | -------------- |
| execution-phase/SKILL.md    | US-001, US-003, US-006, US-008 | skill-author   |
| build.md                    | US-002                         | command-author |
| requirements-phase/SKILL.md | US-004, US-007                 | skill-author   |
| business-analyst.md         | US-005                         | agent-author   |

**Total:** 8 stories, 4 files, 3 waves
