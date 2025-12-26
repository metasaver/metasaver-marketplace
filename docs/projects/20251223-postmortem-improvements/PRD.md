# PRD: Postmortem Improvements - Positive Reinforcement for /build Workflow

**Project:** 20251223-postmortem-improvements
**Complexity:** 34/50
**Date:** 2025-12-23

---

## Executive Summary

Based on the /build workflow postmortem, this PRD addresses three critical issues through **positive reinforcement** (not negative):

1. **Agent-based execution** - Claude implemented directly instead of spawning agents
2. **TDD discipline** - Tests weren't written first consistently
3. **Barrel file prevention** - Modern treeshaking requires direct imports, not index.ts barrels

All improvements use **positive framing** - telling Claude what TO DO, not what NOT to do.

---

## Problem Statement

During a recent /build execution (complexity 38/50), the workflow failed at the implementation stage because:

| Issue                 | What Happened                                              | Root Cause                                                |
| --------------------- | ---------------------------------------------------------- | --------------------------------------------------------- |
| Direct implementation | Claude wrote code directly instead of spawning coder agent | Missing positive instruction to ALWAYS spawn agents       |
| TDD skipped           | Tests weren't written before implementation                | Missing positive instruction to ALWAYS spawn tester first |
| Barrel exports        | Claude created index.ts barrel files                       | Missing positive instruction to use direct imports        |

**Key insight:** The postmortem showed that positive reinforcement works better than negative. The plugin already has positive framing throughout; we need to strengthen the agent-delegation and direct-import patterns.

---

## Success Criteria

1. /build workflow ALWAYS spawns tester agent before coder agent
2. /build workflow NEVER implements code directly - ALWAYS delegates to agents
3. Coder agent ALWAYS uses direct imports (never barrel exports)
4. All instructions use positive framing ("DO this" not "DON'T do that")

---

## User Stories

### Epic 1: Agent Delegation Reinforcement

**US-001: Strengthen /build command agent delegation**

- **As a** /build workflow
- **I want** clear positive instructions to ALWAYS delegate implementation to agents
- **So that** Claude never writes implementation code directly

**Acceptance Criteria:**

- [ ] /build command has explicit "ALWAYS spawn agents for implementation" instruction
- [ ] Enforcement section lists "ALWAYS use Task tool to spawn tester then coder agents"
- [ ] Example section shows proper agent spawning pattern
- [ ] No negative framing ("never", "don't") - only positive ("always", "do")

---

**US-002: Add agent-first execution to execution-phase skill**

- **As a** execution-phase skill
- **I want** positive reinforcement that agents execute work, not the orchestrator
- **So that** the orchestrator only spawns and waits, never implements

**Acceptance Criteria:**

- [ ] Clear statement: "Orchestrator spawns agents and tracks progress - implementation happens in agents"
- [ ] Workflow steps explicitly state "spawn" not "implement"
- [ ] Success criteria includes "All implementation done by spawned agents"

---

**US-003: Add agent-first execution to tdd-execution skill**

- **As a** tdd-execution skill
- **I want** explicit positive instruction that TDD phases execute through agents only
- **So that** RED and GREEN phases always involve agent spawning

**Acceptance Criteria:**

- [ ] RED phase clearly states "Spawn tester agent to write tests"
- [ ] GREEN phase clearly states "Spawn coder agent to implement"
- [ ] Execution logic shows spawn → await pattern only
- [ ] No inline implementation allowed in orchestrator

---

### Epic 2: TDD Discipline Reinforcement

**US-004: Strengthen tester-first requirement in /build**

- **As a** /build command
- **I want** explicit positive instruction that tester agent runs FIRST
- **So that** tests always exist before implementation begins

**Acceptance Criteria:**

- [ ] Enforcement section: "Spawn tester agent to write tests BEFORE spawning coder agent"
- [ ] Phase 5 (Execution) explicitly references tester → coder sequence
- [ ] Fast path (<15 complexity) also requires tests first

---

**US-005: Add TDD sequence validation to tdd-execution skill**

- **As a** tdd-execution skill
- **I want** clear positive instruction that tester completes before coder starts
- **So that** RED phase finishes before GREEN phase begins

**Acceptance Criteria:**

- [ ] Workflow shows: "Wait for tester agent to complete" before coder spawn
- [ ] Execution logic shows sequential await, not parallel
- [ ] Success criteria: "All tests written before any implementation code"

---

### Epic 3: Direct Import Reinforcement (No Barrel Files)

**US-006: Add direct import standard to coder agent**

- **As a** coder agent
- **I want** explicit positive instruction to use direct file imports
- **So that** modern treeshaking works and barrel files are avoided

**Acceptance Criteria:**

- [ ] Import/Export section has "Direct Imports Pattern" subsection
- [ ] Examples show importing from specific files, not index.ts
- [ ] Positive framing: "Import directly from the source file for optimal treeshaking"
- [ ] Internal and external import examples use direct paths

---

**US-007: Add direct import standard to tester agent**

- **As a** tester agent
- **I want** explicit positive instruction to import test subjects directly
- **So that** test files use direct imports matching coder patterns

**Acceptance Criteria:**

- [ ] Test file examples show direct imports (not from index.ts)
- [ ] Mock import examples use direct file paths
- [ ] Positive framing consistent with coder agent

---

**US-008: Add direct import guidance to coding-standards skill**

- **As a** coding-standards skill
- **I want** a "Direct Imports" section explaining the pattern
- **So that** all agents reference the same standard

**Acceptance Criteria:**

- [ ] New "Direct Imports" section in coding standards
- [ ] Explains treeshaking benefits (positive framing)
- [ ] Shows before/after examples (direct vs barrel)
- [ ] Links to coder agent for implementation

---

## Technical Approach

All changes follow the **positive reinforcement pattern**:

| Instead of                  | Use                                          |
| --------------------------- | -------------------------------------------- |
| "Never implement directly"  | "Always spawn agents to implement"           |
| "Don't create barrel files" | "Import directly from source files"          |
| "Don't skip tests"          | "Spawn tester agent first, then coder agent" |

Changes target `.md` files in:

- `plugins/metasaver-core/commands/build.md`
- `plugins/metasaver-core/agents/generic/coder.md`
- `plugins/metasaver-core/agents/generic/tester.md`
- `plugins/metasaver-core/skills/workflow-steps/tdd-execution/SKILL.md`
- `plugins/metasaver-core/skills/workflow-steps/execution-phase/SKILL.md`
- `plugins/metasaver-core/skills/cross-cutting/coding-standards/SKILL.md`

---

## Execution Plan

**Wave 1: Core Workflow (Sequential)**

- US-001: /build command agent delegation
- US-004: /build command TDD sequence

**Wave 2: Skills (Parallel)**

- US-002: execution-phase skill
- US-003: tdd-execution skill
- US-005: tdd-execution TDD sequence

**Wave 3: Agents (Parallel)**

- US-006: coder agent direct imports
- US-007: tester agent direct imports

**Wave 4: Standards**

- US-008: coding-standards skill

---

## Constraints

- All edits MUST go through author agents (agent-author, skill-author, command-author)
- All framing MUST be positive (what to do, not what to avoid)
- No structural changes to existing workflows - only reinforcement additions

---

## Approval Required

Please review and approve this PRD before implementation begins.

**Files to be modified:**

1. `plugins/metasaver-core/commands/build.md`
2. `plugins/metasaver-core/skills/workflow-steps/execution-phase/SKILL.md`
3. `plugins/metasaver-core/skills/workflow-steps/tdd-execution/SKILL.md`
4. `plugins/metasaver-core/agents/generic/coder.md`
5. `plugins/metasaver-core/agents/generic/tester.md`
6. `plugins/metasaver-core/skills/cross-cutting/coding-standards/SKILL.md`

**Total Stories:** 8
**Estimated Waves:** 4
