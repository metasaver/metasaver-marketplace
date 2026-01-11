# SPW-002: Session Restore Command

## Story Info

| Field      | Value                                     |
| ---------- | ----------------------------------------- |
| Story ID   | SPW-002                                   |
| Epic       | MMP-SPW                                   |
| Priority   | P1 (High)                                 |
| Status     | complete                                  |
| Complexity | Medium                                    |
| Agent      | core-claude-plugin:generic:command-author |

---

## User Story

**As a** MetaSaver developer
**I want** a `/session` command that restores MetaSaver workflow context
**So that** after any crash or interruption I can quickly re-establish the workflow with one command

---

## What `/session` Does

When you type `/session`, it:

1. **Explicitly re-states** the MetaSaver Constitution rules (from CLAUDE.md)
2. **Confirms** that MetaSaver workflow is active
3. **Outputs**: "MetaSaver workflow active - using agents, skills, templates in parallel"

**Why this helps:**

- After a crash, Claude loses conversation context
- CLAUDE.md is read but may not be prioritized
- `/session` acts as a "context refresh" - a short command that reinforces the workflow rules
- Faster than typing the full prompt from `prompt.txt`

**Example usage:**

```
# After system crash/reboot
User: /session
Claude: MetaSaver workflow active. Using agents, skills, templates in parallel.
        Ready to continue. What would you like to work on?

# Then continue where you left off
User: continue with the MMP-SPW epic
```

---

## Acceptance Criteria

- [ ] `/session` command exists in `plugins/metasaver-core/commands/`
- [ ] Command explicitly states the Constitution rules
- [ ] Command confirms MetaSaver workflow is active
- [ ] Command output is concise (1-3 lines)
- [ ] Command can be used at any point in a conversation

---

## Definition of Done

- [ ] Command file created at `plugins/metasaver-core/commands/session.md`
- [ ] Command added to marketplace.json if needed
- [ ] Command tested by simulating crash recovery scenario
- [ ] Documentation includes usage examples

---

## Technical Notes

### Command Content

The `/session` command prompt re-establishes context by:

1. Reading Constitution rules from CLAUDE.md (implicit)
2. Asserting these rules are now active
3. Confirming readiness to continue

### Why Not Just Use CLAUDE.md Alone?

CLAUDE.md is read at session start, but:

- Its instructions can be "forgotten" or deprioritized during long conversations
- After crashes, the context from before the crash is lost
- A command provides an explicit, user-triggered refresh

### Command Structure

```markdown
---
name: session
description: Restore MetaSaver workflow context after interruption
---

# Session Restore

Confirm MetaSaver workflow is active with these rules:

1. Use MetaSaver agents for implementation work
2. Spawn agents in parallel when tasks are independent
3. Follow /build or /ms workflow for code changes
4. Get user approval (HITL) before marking complete
5. Update story files during execution
6. Use AskUserQuestion for user interactions

Output: "MetaSaver workflow active. Using agents, skills, templates in parallel."
```

---

## Dependencies

- SPW-001 (CLAUDE.md Constitution) defines the rules that `/session` reinforces
