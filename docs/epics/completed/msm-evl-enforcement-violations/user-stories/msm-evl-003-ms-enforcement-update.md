# msm-evl-003: Update /ms enforcement section for AskUserQuestion

**Agent:** `command-author`

## User Story

- **As a** /ms command
- **I want** explicit enforcement that all questions use AskUserQuestion tool
- **So that** the command never asks freeform questions

## Acceptance Criteria

- [ ] Enforcement section item 1 explicitly states: "Use AskUserQuestion tool for every question to the user"
- [ ] Add: "Provide context and background in response text, but invoke AskUserQuestion for the actual question"
- [ ] Add: "Route question-type interactions to /qq for proper handling"

---

## Implementation Details

### Key Files to Modify

| File                                                                              | Line Range | Section             |
| --------------------------------------------------------------------------------- | ---------- | ------------------- |
| `./plugins/metasaver-core/commands/ms.md` | 261-275    | Enforcement section |

### Implementation Approach

**Step 1: Update Enforcement Item 1 (line 263)**

Current:

```markdown
1. Use AskUserQuestion tool for every question to the user. Present structured options with clear descriptions.
```

This is correct but needs expansion. Add clarifying sub-points:

```markdown
1. Use AskUserQuestion tool for every question to the user:
   - Present structured options with clear descriptions
   - Provide context and background in response text
   - Invoke AskUserQuestion for the actual question (not freeform in response)
   - Route question-type interactions to /qq for proper handling
```

**Step 2: Add Freeform Question Prohibition (new item after current item 1)**

Insert:

```markdown
2. Freeform questions in response text are prohibited. All questions requiring user input must use AskUserQuestion tool invocation.
```

Renumber subsequent items (current 2-12 become 3-13).

### Validation Steps

1. Spawn command-author agent with task to make these changes
2. Read updated ms.md and verify:
   - Enforcement item 1 has expanded guidance on AskUserQuestion
   - New item explicitly prohibits freeform questions
   - Subsequent items are correctly renumbered
3. Verify AskUserQuestion is mentioned in enforcement context

---

## Dependencies

- msm-evl-001 (CLAUDE.md foundation)
- Can run parallel with msm-evl-002

## Wave Assignment

**Wave 2** (Commands Core - parallel with msm-evl-002, msm-evl-004)
