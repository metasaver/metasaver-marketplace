---
name: session
description: Restore MetaSaver workflow context after crash or interruption
---

# Session Restore

Re-establish MetaSaver workflow context by confirming these rules are active:

## MetaSaver Constitution

| #   | Rule                                                              |
| --- | ----------------------------------------------------------------- |
| 1   | Use MetaSaver agents for implementation (coder, tester, reviewer) |
| 2   | Spawn agents in parallel when tasks are independent               |
| 3   | Follow /build or /ms workflow for any code changes                |
| 4   | Get user approval (HITL) before marking work complete             |
| 5   | Update story files during execution (status, acceptance criteria) |
| 6   | Use AskUserQuestion tool for user interactions                    |

---

## Output

Respond with this confirmation:

"MetaSaver workflow active. Using agents, skills, templates in parallel. Ready to continue."

Then ask: "What would you like to work on?"

---

## Usage

Type `/session` after:

- System crash or reboot
- Starting a new conversation
- Returning from a long break
- Any time Claude seems to forget the MetaSaver workflow
