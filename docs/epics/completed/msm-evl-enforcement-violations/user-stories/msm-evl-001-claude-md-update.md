# msm-evl-001: Remove "answer directly" guidance from CLAUDE.md

**Agent:** `manual-edit` (CLAUDE.md is not a plugin component)

## User Story

- **As a** Claude Code user
- **I want** CLAUDE.md to route all interactions through /ms
- **So that** the AskUserQuestion tool is always used for questions

## Acceptance Criteria

- [ ] Remove "Simple questions -> Answer directly without workflow" from Always-On Behavior table
- [ ] Remove "Simple questions -> Answer directly without workflow" from Routing Guidance
- [ ] Add: "All interactions -> Use /ms which routes to appropriate command"
- [ ] Add: "Questions to user -> Always use AskUserQuestion tool"
- [ ] Update table to show /ms as universal entry point

---

## Implementation Details

### Key Files to Modify

| File                                                  | Line Range | Section                    |
| ----------------------------------------------------- | ---------- | -------------------------- |
| `./CLAUDE.md` | 49-88      | Always-On Behavior section |

### Implementation Approach

**Step 1: Update Always-On Behavior Table (lines 51-58)**

Current:

```markdown
| Task Type        | Recommended Approach                  |
| ---------------- | ------------------------------------- |
| Simple questions | Answer directly without workflow      |
| Code tasks       | Use appropriate MetaSaver agent       |
| Complex work     | Route through `/ms` for full workflow |
| Config files     | Use specialized config agent          |
```

Change to:

```markdown
| Task Type        | Recommended Approach                          |
| ---------------- | --------------------------------------------- |
| All interactions | Use `/ms` which routes to appropriate command |
| Questions        | Always use AskUserQuestion tool               |
```

**Step 2: Update Routing Guidance (lines 60-65)**

Current:

```markdown
**Routing Guidance:**

- **Simple questions** -> Answer directly without workflow
- **Code tasks** -> Spawn appropriate agent (coder, tester, reviewer, backend-dev)
- **Config files** -> Spawn config agent (eslint-agent, vite-agent)
- **Complex work** -> Suggest `/ms`, `/build`, or `/audit` for workflow tracking
```

Change to:

```markdown
**Routing Guidance:**

- **All interactions** -> Route through `/ms` (analyzes and routes to appropriate command)
- **Questions to user** -> Always use AskUserQuestion tool (present structured options)
- **Clarifications** -> Route through `/qq` for question-handling workflow
```

**Step 3: Add AskUserQuestion Enforcement Note (after Agent Replacement Table)**

Add new section:

```markdown
**AskUserQuestion Tool Enforcement:**

All questions to the user MUST use the AskUserQuestion tool. Provide context and background in response text, but invoke AskUserQuestion for the actual question with structured options.
```

### Validation Steps

1. Read updated CLAUDE.md and verify:
   - No mention of "answer directly without workflow"
   - All interactions route through /ms
   - AskUserQuestion tool enforcement is documented
2. Search for any remaining "simple questions" text
3. Verify table formatting is correct (markdown renders properly)

---

## Dependencies

- None (foundation story - must complete first)

## Wave Assignment

**Wave 1** (Sequential - foundation for all other changes)
