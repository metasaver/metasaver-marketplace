---
story_id: "MSM-WKR-013"
epic_id: "MSM-WKR"
title: "Update /architect command"
status: "pending"
wave: 5
agent: "core-claude-plugin:generic:command-author"
dependencies: ["MSM-WKR-004"]
priority: "P0"
created: "2024-12-29"
updated: "2024-12-29"
---

# MSM-WKR-013: Update /architect command

## User Story

As a user, I want /architect to ASK me about innovation instead of always running it so that I have control over the analysis depth.

---

## Acceptance Criteria

- [ ] /architect uses sequential-thinking MCP tool
- [ ] /architect ASKS user about innovation (AskUserQuestion)
- [ ] Innovation is optional, not automatic
- [ ] /architect uses prd-creation-skill for PRD output
- [ ] Remove automatic innovation-advisor invocation

### Standard AC Items (Required)

- [ ] Follows established template/pattern
- [ ] Format validated

---

## Technical Details

### Location

- **Repo:** metasaver-marketplace
- **Package:** plugins/metasaver-core/commands/

### Files to Modify

| File                    | Changes                             |
| ----------------------- | ----------------------------------- |
| `commands/architect.md` | Ask about innovation, use new skill |

---

## Architecture

**New Flow:**

```
/architect {description}
    → sequential-thinking (plan approach)
    → AskUserQuestion: "Run innovation analysis?" [Yes/No]
    → IF Yes: Spawn innovation-advisor
    → Spawn EA agent (uses prd-creation-skill)
    → Spawn Reviewer → HITL
    → Output: PRD file
```

**Old Flow (to change):**

```
/architect {description}
    → Always run innovation-advisor
    → ...
```

---

## Definition of Done

- [ ] /architect asks about innovation
- [ ] Innovation is optional
- [ ] Uses sequential-thinking
- [ ] Uses prd-creation-skill for output
