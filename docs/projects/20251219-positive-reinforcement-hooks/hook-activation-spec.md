# UserPromptSubmit Hook Activation Specification

## Overview

Hook activates to remind users about /ms workflow when complex work is detected without proper entry point.

## Decision Logic

### FIRE when:

1. Prompt does NOT start with /ms, /build, /audit, /debug, /qq, /architect
2. Complexity score >= 15 (determined by keyword analysis)
3. No explicit opt-out phrase present

### SKIP when:

1. Prompt starts with recognized command prefix: /ms, /build, /audit, /debug, /qq, /architect, /clear, /help
2. Complexity score < 15 (simple question/task)
3. Prompt contains "ignore /ms", "skip workflow", or "just do it"
4. Prompt is purely informational (starts with "what", "how", "where", "why", "explain")

## Complexity Keywords (trigger >=15)

- Implementation: "implement", "add", "create", "build", "fix"
- Multi-file: "refactor", "update all", "change everywhere"
- Architecture: "restructure", "migrate", "integrate"

## Decision Flowchart

```
START
  │
  ▼
Has /command prefix? ──YES──► SKIP
  │
  NO
  │
  ▼
Contains opt-out phrase? ──YES──► SKIP
  │
  NO
  │
  ▼
Complexity < 15? ──YES──► SKIP
  │
  NO
  │
  ▼
FIRE (show /ms reminder)
```

## Examples

| Prompt                                   | Fire/Skip | Reason                        |
| ---------------------------------------- | --------- | ----------------------------- |
| "/build add auth"                        | SKIP      | Has /build prefix             |
| "add user authentication"                | FIRE      | Complex, no prefix            |
| "what does this function do?"            | SKIP      | Simple question               |
| "fix all the bugs in the repo"           | FIRE      | Complex, no prefix            |
| "just do it - update the config"         | SKIP      | Opt-out phrase                |
| "/ms implement login flow"               | SKIP      | Has /ms prefix                |
| "explain how authentication works"       | SKIP      | Informational question        |
| "create a new database schema for users" | FIRE      | Complex, no prefix            |
| "refactor the entire codebase"           | FIRE      | Complex multi-file, no prefix |
| "where is the auth module located?"      | SKIP      | Simple location question      |
