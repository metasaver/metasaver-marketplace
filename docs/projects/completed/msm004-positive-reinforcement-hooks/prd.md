# PRD: Hook Enforcement System with Positive Reinforcement

**Request:** Implement hook enforcement system for MetaSaver workflows with positive framing guidance
**Type:** Full - Major workflow enhancement with plugin-wide refactoring
**Complexity:** 32 (FULL PATH - requires Opus for requirements)
**Date:** 2025-12-19

---

## Executive Summary

Transform MetaSaver plugin to use positive reinforcement patterns throughout, implement UserPromptSubmit hook for /ms workflow enforcement, and update /ms command to match target state architecture with workflow-state.json management.

**Key Insight:** PreToolUse hooks are broken (GitHub issue #6305), but UserPromptSubmit hooks work. Use this to remind users about /ms routing before processing prompts.

---

## Problem Statement

Current state has several issues:

1. **Negative framing epidemic:** 59 files contain NEVER/DON'T/DO NOT statements, which creates adversarial tone
2. **No /ms enforcement:** Users bypass /ms and directly spawn agents or use core agents
3. **Broken workflow resumption:** /ms doesn't match target state diagram for continuation
4. **Missing state tracking:** No workflow-state.json management for PM to track progress
5. **No hook workaround:** PreToolUse hooks broken, need UserPromptSubmit alternative

---

## Success Criteria

### Hook Enforcement

- [ ] UserPromptSubmit hook implemented to remind about /ms usage
- [ ] Hook activates only when appropriate (no /ms, complex work detected)
- [ ] Hook provides helpful guidance, not blocking behavior
- [ ] Hook references CLAUDE.md section for /ms routing rules

### Positive Framing

- [ ] All 59 files with NEVER/DON'T/DO NOT reviewed and reframed
- [ ] Author agent prompts updated with positive reinforcement guidance
- [ ] CLAUDE.md uses ALWAYS/DO patterns instead of NEVER/DON'T
- [ ] Tone is collaborative and instructive, not adversarial

### /ms Command Updates

- [ ] Phase 1: Entry + State Check implemented per target diagram
- [ ] Phase 2a: Resume Workflow reads workflow-state.json
- [ ] Phase 2b: New Workflow runs parallel analysis skills
- [ ] Phase 3: Routing logic matches target state decision tree
- [ ] Phase 4: Execution tracking updates workflow-state.json

### Workflow State Management

- [ ] workflow-state.json schema implemented per target diagram
- [ ] PM skill created for state file management (read/write/update)
- [ ] State tracking integrated into execution phase
- [ ] Resume logic validates state and routes correctly

### Documentation

- [ ] CLAUDE.md updated with mandatory /ms routing section
- [ ] Hook usage documented with examples
- [ ] Positive framing guidelines added to author agent docs
- [ ] Migration guide for old /ms behavior

---

## Scope

### In Scope

**EPIC-001: Positive Reinforcement Refactoring**

- Review all 59 files with negative framing
- Reframe NEVER/DON'T → ALWAYS/DO patterns
- Update author agent prompts with positive guidance
- Update CLAUDE.md routing section

**EPIC-002: Hook Enforcement System**

- Implement UserPromptSubmit hook
- Add /ms reminder logic
- Update plugin.json with hook registration
- Test hook activation patterns

**EPIC-003: Workflow State & /ms Updates**

- Implement workflow-state.json schema
- Create PM state management skill
- Update /ms command to match target diagram
- Add resume workflow logic (Phase 2a)
- Update execution tracking (Phase 4)

### Out of Scope

- Rewriting all 59 files in this workflow (just patterns/guidance)
- Fixing PreToolUse hooks (acknowledged broken, using workaround)
- Changing commands other than /ms
- Modifying build/audit/architect command internals

---

## Requirements

### EPIC-001: Positive Reinforcement Refactoring

#### R1: Positive Framing Pattern Library

- Create skill document with NEVER→ALWAYS transformation patterns
- Include 20+ examples of before/after transformations
- Reference cognitive psychology research on positive framing
- Provide decision tree for choosing between imperative/suggestive tone

#### R2: Author Agent Updates

- Update agent-author prompt with positive reinforcement section
- Update skill-author prompt with positive reinforcement section
- Update command-author prompt with positive reinforcement section
- Add validation checks for NEVER/DON'T in new content

#### R3: CLAUDE.md /ms Routing Section

- Replace "NEVER spawn agents directly" with "ALWAYS route through /ms"
- Use positive framing for all routing rules
- Provide clear examples of WHEN to use /ms
- Link to ms-command-target-state.md for details

#### R4: File Audit Checklist

- Create checklist of 59 files to review
- Prioritize by impact (commands > agents > skills)
- Mark parallelizable review tasks
- Track progress in execution plan

### EPIC-002: Hook Enforcement System

#### R5: UserPromptSubmit Hook Implementation

- Register hook in plugin.json
- Create hook handler file in plugins/metasaver-core/hooks/
- Implement detection logic for complex work without /ms
- Generate helpful reminder message with examples

#### R6: Hook Activation Logic

- Detect when user submits prompt without /ms prefix
- Skip hook if prompt is simple question (complexity < 10)
- Skip hook if prompt already uses /ms or MetaSaver command
- Skip hook if user explicitly says "ignore /ms" or "direct mode"

#### R7: Hook Message Content

- Provide friendly reminder about /ms benefits
- Show 2-3 relevant examples of /ms usage
- Include CLAUDE.md reference link
- Offer "Continue anyway" option (non-blocking)

#### R8: Hook Testing & Validation

- Test hook fires on complex prompts
- Test hook skips on /ms commands
- Test hook skips on simple questions
- Verify non-blocking behavior

### EPIC-003: Workflow State & /ms Updates

#### R9: Workflow State Schema

- Implement JSON schema per ms-command-target-state.md section 3
- Include all required fields: command, phase, step, status, etc.
- Add epic/story tracking arrays
- Add HITL question/resume action fields

#### R10: PM State Management Skill

- Create skill for reading workflow-state.json
- Create skill for writing/updating workflow-state.json
- Add helper methods: getCurrentWave, getNextStories, markStoryComplete
- Include error handling for missing/corrupt state files

#### R11: /ms Phase 1 - Entry + State Check

- Check for workflow-state.json in docs/projects/\*/
- Check TodoWrite for active workflow markers
- Parse prompt for continuation keywords
- Route to Phase 2a (resume) or 2b (new)

#### R12: /ms Phase 2a - Resume Workflow

- Read workflow-state.json
- Extract command, phase, step, wave
- Read execution-plan.md for context
- Read story files for current status
- Route to appropriate workflow step

#### R13: /ms Phase 2b - New Workflow Analysis

- Spawn 3 skills in parallel: complexity-check, scope-check, tool-check
- Collect results
- Route to Phase 3

#### R14: /ms Phase 3 - Route to Command

- Implement routing decision tree from target diagram
- Route based on: complexity, keywords, scope
- Pass state context to target command
- Commands: /build, /audit, /architect, /debug, /qq

#### R15: /ms Phase 4 - Execution Tracking Integration

- Update workflow-state.json at wave start
- Update story statuses in state file
- Save HITL questions to state file
- Mark workflow complete when finished

#### R16: /ms Phase 5 - Validation

- Run production-check if files modified
- Run repomix-cache-refresh
- Clear workflow-state.json on completion

---

## User Stories Summary

### EPIC-001: Positive Reinforcement Refactoring (8 stories)

- Create positive framing pattern library
- Update agent-author prompt
- Update skill-author prompt
- Update command-author prompt
- Update CLAUDE.md /ms routing section
- Create file audit checklist
- Review high-priority files (commands, core agents)
- Review medium-priority files (skills, config agents)

### EPIC-002: Hook Enforcement System (6 stories)

- Design hook activation logic
- Implement UserPromptSubmit hook handler
- Register hook in plugin.json
- Create hook message templates
- Add hook testing scenarios
- Document hook behavior

### EPIC-003: Workflow State & /ms Updates (10 stories)

- Define workflow-state.json schema
- Create PM state management skill
- Implement /ms Phase 1 (Entry + State Check)
- Implement /ms Phase 2a (Resume Workflow)
- Implement /ms Phase 2b (New Workflow Analysis)
- Implement /ms Phase 3 (Route to Command)
- Implement /ms Phase 4 (Execution Tracking)
- Implement /ms Phase 5 (Validation)
- Update execution-phase skill for state tracking
- Create migration guide documentation

**Total Stories:** 24 stories across 3 epics

---

## Dependencies

**External:**

- GitHub issue #6305 (PreToolUse hooks broken) - workaround with UserPromptSubmit
- Claude Code marketplace plugin API (for hook registration)

**Internal:**

- ms-command-target-state.md (workflow architecture reference)
- CLAUDE.md (routing rules)
- Existing skills: complexity-check, scope-check, tool-check, production-check
- Existing commands: /build, /audit, /architect, /debug, /qq

**Story Dependencies:**

- EPIC-001 can run in parallel with EPIC-002
- EPIC-003 depends on EPIC-002 R5 (hook registration pattern)
- Phase 2a stories depend on R9/R10 (state schema + management)

---

## Technical Design Notes

### Hook Implementation Pattern

```javascript
// plugins/metasaver-core/hooks/user-prompt-submit.js
export async function onUserPromptSubmit(prompt, context) {
  // Skip if already using /ms or MetaSaver command
  if (prompt.startsWith("/ms") || prompt.startsWith("/build") /* etc */) {
    return null; // No intervention
  }

  // Skip if simple question
  const complexity = await estimateComplexity(prompt);
  if (complexity < 10) {
    return null;
  }

  // Provide helpful reminder
  return {
    message:
      '💡 This looks like complex work. Consider using `/ms` for better workflow tracking and resumption.\n\nExamples:\n- `/ms "add user authentication"`\n- `/ms "audit eslint config"`\n\nSee CLAUDE.md for routing rules. Continue anyway? Just re-send your prompt.',
    blocking: false,
  };
}
```

### Workflow State File Location

```
docs/projects/{yyyymmdd}-{name}/workflow-state.json
```

### PM State Management API

```javascript
// Example skill usage
const state = await readWorkflowState(projectFolder);
const nextWave = state.currentWave + 1;
const stories = getStoriesForWave(state, nextWave);

await updateWorkflowState(projectFolder, {
  currentWave: nextWave,
  stories: {
    ...state.stories,
    inProgress: stories.map((s) => s.id),
  },
});
```

---

## Risks & Mitigations

| Risk                                | Impact                      | Mitigation                                            |
| ----------------------------------- | --------------------------- | ----------------------------------------------------- |
| UserPromptSubmit hook too noisy     | High - user frustration     | Add smart detection, make non-blocking, allow disable |
| Positive framing feels forced       | Medium - tone inconsistency | Use pattern library, test with real examples          |
| State file conflicts with TodoWrite | Medium - dual tracking      | Clarify: state = PM internal, TodoWrite = user-facing |
| Resume logic misidentifies state    | High - workflow breaks      | Robust state validation, fallback to new workflow     |

---

## Open Questions

None - requirements are clear based on existing target state documentation.

---

## Approval

BA recommends proceeding to design phase with Architect to annotate user stories with implementation details.

**Next Phase:** Design Phase (Architect enrichment of epics/stories)
