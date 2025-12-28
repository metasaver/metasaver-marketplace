# UserPromptSubmit Hook Usage Guide

## Overview

The `/ms` reminder hook provides helpful guidance when complex work is detected without proper workflow routing. It's designed to be helpful, not blocking.

## Purpose

Help users benefit from MetaSaver workflow features:

- PRD creation and approval
- Wave-based parallel execution
- State tracking for resumption
- Coordinated HITL gates

## Behavior

### When the Hook Fires

The hook shows a reminder when ALL of these are true:

1. Prompt does NOT start with a command (`/ms`, `/build`, `/audit`, etc.)
2. Complexity keywords detected (implement, add, create, build, fix, refactor, etc.)
3. No opt-out phrase present

### When the Hook Skips

The hook remains silent when ANY of these are true:

- Prompt starts with a recognized command
- Prompt is a simple question (what, how, why, where, explain)
- Prompt contains opt-out phrase ("ignore /ms", "skip workflow", "just do it")

## Message Format

When triggered, you'll see:

```
💡 For complex work, consider using `/ms {first 50 chars of prompt}...` to enable workflow tracking and HITL approvals.
```

## Opting Out

### Per-prompt opt-out

Include one of these phrases in your prompt:

- "ignore /ms"
- "skip workflow"
- "just do it"

Example: `just do it - add a logout button to the header`

### Using direct commands

Start your prompt with a command:

- `/build add user auth` - Runs build workflow
- `/audit check eslint` - Runs audit workflow
- `/qq what is auth` - Quick question, no workflow

## Troubleshooting

### Hook not firing when expected

- Check if prompt starts with a command prefix
- Verify complexity keywords are present
- Ensure no opt-out phrase is included

### Hook firing too often

- Use direct commands (/build, /audit) for planned work
- Add "just do it" for quick tasks you don't want tracked
- Simple questions starting with "what/how/why" skip automatically

## Technical Details

- **Hook type:** UserPromptSubmit
- **Script:** `plugins/metasaver-core/hooks/scripts/ms-reminder-hook.js`
- **Exit code:** Always 0 (non-blocking)
- **Output:** stderr (appears as system reminder)

## Related Documentation

- [/ms Command Target State](ms-command-target-state.md)
- [Workflow State Specification](workflow-state-spec.md)
- [Migration Guide](../projects/completed/msm004-positive-reinforcement-hooks/migration-guide.md)
