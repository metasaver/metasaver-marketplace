# Migration Guide: /ms Command Updates

## Overview

The /ms command has been updated to support workflow state tracking and continuation after HITL (human-in-the-loop) interruptions.

## Old Behavior

- /ms spawned BA directly
- /ms spawned agents directly
- No state tracking
- HITL broke workflows (couldn't resume)
- No workflow-state.json

## New Behavior

- /ms checks state first (looks for workflow-state.json)
- /ms routes to commands (/build, /audit, /architect, /debug, /qq)
- Commands handle their workflows
- PM tracks state throughout execution
- /ms resumes workflows after HITL via workflow-state.json

## Workflow Pattern

### Starting a New Workflow

1. `/clear` - Clear context
2. `/build add user authentication` or `/audit check eslint config`
3. Workflow executes with HITL gates via AskUserQuestion
4. State saved to `docs/projects/{date}-{name}/workflow-state.json`

### Resuming After HITL

If context breaks or you exit regular prompts:

- `/ms continue` - Auto-detects active workflow from workflow-state.json
- `/ms continue path/to/project-folder` - Explicit folder path
- `/ms` alone - Checks for active workflow, asks if none found

### Direct Commands (Skip /ms)

For simple tasks, use commands directly:

- `/build` - Start build workflow
- `/audit` - Start audit workflow
- `/qq` - Quick question (no workflow)

## Breaking Changes

None. Old behavior is enhanced, not replaced.

## Examples

### Example 1: Standard Build Workflow

```
User: /clear
User: /build add user authentication
[Workflow starts, creates PRD, asks approval question]
User: approve
[Execution starts, HITL at Wave 2]
User: yes proceed
[Workflow completes]
```

### Example 2: Resume After Context Loss

```
User: /clear
User: /build add feature X
[Context runs out during execution]
User: /ms continue
[Reads workflow-state.json, resumes at Wave 3]
```

### Example 3: Check for Active Workflow

```
User: /ms
[Checks for workflow-state.json]
[If found: "Active workflow detected for 'feature X'. Resume?"]
[If not found: "No active workflow. What would you like to do?"]
```

## FAQ

**Q: Do I have to use /ms for everything now?**
A: Using /ms is recommended for complex work. Simple questions can still be answered directly.

**Q: What if I forget to use /ms?**
A: The UserPromptSubmit hook will remind you to consider /ms for complex prompts.

**Q: Can I opt out of /ms reminders?**
A: Include "ignore /ms" or "skip workflow" in your prompt.
