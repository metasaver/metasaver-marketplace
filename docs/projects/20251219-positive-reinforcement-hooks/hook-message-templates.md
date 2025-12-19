# UserPromptSubmit Hook Message Templates

## Design Principles

1. **Helpful, not blocking** - Hook provides guidance, doesn't prevent action
2. **Positive framing** - Use "consider using" not "you should have used"
3. **Context-aware** - Different messages for different detected intents
4. **Actionable** - Include specific /ms command to use
5. **Brief** - One sentence guidance, not paragraphs

## Message Templates

### Complex Build Request

**Trigger:** Implementation keywords detected (add, create, implement, build)
**Message:**

```
💡 For complex builds, consider starting with `/ms {user_prompt_summary}` to enable workflow tracking and HITL approvals.
```

### Multi-file Refactoring

**Trigger:** Refactoring keywords detected (refactor, update all, change everywhere)
**Message:**

```
💡 Multi-file changes benefit from `/ms {user_prompt_summary}` for coordinated execution and state tracking.
```

### Architecture Changes

**Trigger:** Architecture keywords detected (restructure, migrate, integrate)
**Message:**

```
💡 Architectural changes are best managed through `/ms {user_prompt_summary}` for PRD creation and approval gates.
```

### Generic Complex Task

**Trigger:** High complexity score but no specific category
**Message:**

```
💡 This looks like complex work. Consider using `/ms {user_prompt_summary}` for workflow state tracking.
```

## Variables

- `{user_prompt_summary}` - First 50 characters of user prompt
- `{complexity_score}` - Score from complexity analysis

## Implementation Notes

- Hook should use stderr for the message (non-blocking guidance)
- Exit code 0 (allow prompt to proceed)
- Message goes into session as <system-reminder>
