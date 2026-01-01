# msm-evl-002: Make Phase 2b analysis mandatory in /ms

**Agent:** `command-author`

## User Story

- **As a** /ms command
- **I want** Phase 2b analysis to always run for new workflows
- **So that** there are no complexity-based shortcuts that bypass routing

## Acceptance Criteria

- [ ] Remove any complexity-based bypass conditions in Phase 2b
- [ ] Analysis phase (complexity, scope, tool checks) runs for ALL new workflows
- [ ] No "fast path" that skips analysis based on prompt simplicity
- [ ] Phase 3 routing uses analysis results, never assumptions

---

## Implementation Details

### Key Files to Modify

| File                                                                              | Line Range | Section                 |
| --------------------------------------------------------------------------------- | ---------- | ----------------------- |
| `./plugins/metasaver-core/commands/ms.md` | 87-97      | Phase 2b section        |
| `./plugins/metasaver-core/commands/ms.md` | 99-130     | Phase 3 routing section |

### Implementation Approach

**Step 1: Review Phase 2b for Bypass Conditions**

Current Phase 2b (lines 87-97):

```markdown
## Phase 2b: New Workflow Analysis (PARALLEL)

**See:** `/skill analysis-phase`

Spawn 3 agents in parallel:

- `complexity-check` -> score (1-50)
- `tool-check` -> required MCP tools
- `scope-check` -> targets and references
```

This section is already correct (no bypasses). The issue is in Phase 3 routing.

**Step 2: Update Phase 3 Routing Table (lines 103-111)**

Current routing table includes complexity-based routing to /qq:

```markdown
| Trigger Keywords     | Detected Scope  | Route To |
| -------------------- | --------------- | -------- |
| None (question only) | complexity < 15 | /qq      |
```

Change to require analysis results (not assumptions):

```markdown
| Trigger Keywords                     | Detected Scope    | Route To |
| ------------------------------------ | ----------------- | -------- |
| None (question only, after analysis) | analysis complete | /qq      |
```

**Step 3: Update Routing Priority (lines 113-119)**

Current:

```markdown
**Routing Priority:**

1. /qq - Simple questions (lowest complexity, no file changes)
```

Change to emphasize analysis requirement:

```markdown
**Routing Priority:**

1. /qq - Questions (after analysis confirms no file changes needed)
```

**Step 4: Update Enforcement Section (line 268)**

Add explicit enforcement rule:

```markdown
6. For new workflows: ALWAYS run Analysis phase (parallel: complexity, tools, scope) - NO BYPASSES
```

### Validation Steps

1. Spawn command-author agent with task to make these changes
2. Read updated ms.md and verify:
   - Phase 2b has no bypass conditions
   - Phase 3 routing requires analysis results
   - Enforcement section explicitly prohibits bypasses
3. Test: `/ms "what is this?"` should still run analysis before routing to /qq

---

## Dependencies

- msm-evl-001 (CLAUDE.md should be updated first for consistency)

## Wave Assignment

**Wave 2** (Commands Core - parallel with msm-evl-003, msm-evl-004)
