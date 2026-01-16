---
story_id: "MSM-VKM-E06-003"
epic_id: "MSM-VKM-E06"
title: "Merge Claude hooks"
status: "pending"
complexity: 3
wave: 5
agent: "core-claude-plugin:generic:coder"
dependencies: ["MSM-VKM-E03-006"]
created: "2026-01-16"
updated: "2026-01-16"
---

# MSM-VKM-E06-003: Merge Claude hooks

## User Story

**As a** developer working with Claude Code in the metasaver-marketplace repository
**I want** Claude hooks merged from both repositories to maintain automated workflow behaviors
**So that** Claude Code integrations work correctly with the hybrid monorepo structure

---

## Acceptance Criteria

- [ ] All Claude hooks from veenk repository identified and reviewed
- [ ] All Claude hooks from marketplace repository identified and reviewed
- [ ] Hooks merged intelligently (no duplicates, conflicts resolved)
- [ ] Merged hooks placed in `.claude/hooks/` directory
- [ ] Hook permissions set correctly (executable scripts)
- [ ] Hooks reference correct paths for monorepo structure
- [ ] All hook scripts validated syntactically
- [ ] Follows established template/pattern
- [ ] Format validated

---

## Technical Details

### Location

- **Repo:** metasaver-marketplace
- **Package:** root level

### Files to Merge

**From veenk repository:**

- `.claude/hooks/pre-dangerous.sh`
- `.claude/hooks/post-response.sh`
- Any other hooks in `.claude/hooks/`

**From marketplace repository:**

- `.claude/hooks/pre-dangerous.sh` (already exists)
- `.claude/hooks/ms-reminder-hook.js` (already exists)
- Any other hooks in `.claude/hooks/`

### Files to Modify

| File                                | Purpose                                    |
| ----------------------------------- | ------------------------------------------ |
| `.claude/hooks/pre-dangerous.sh`    | Merge safety checks from both repositories |
| `.claude/hooks/post-response.sh`    | Add veenk post-response hooks if present   |
| `.claude/hooks/ms-reminder-hook.js` | Keep marketplace reminder hook             |
| Any additional hooks                | Merge as appropriate                       |

---

## Implementation Notes

**Source locations:**

- `/home/jnightin/code/veenk/.claude/hooks/`
- `/home/jnightin/code/metasaver-marketplace/.claude/hooks/`

**Target location:**

- `/home/jnightin/code/metasaver-marketplace/.claude/hooks/`

### Merge Strategy

1. Compare hooks from both repositories
2. Identify overlapping functionality (e.g., pre-dangerous checks)
3. Merge intelligently:
   - Combine unique checks from both sources
   - Preserve marketplace-specific hooks
   - Add veenk-specific hooks that are relevant
4. Update paths to work with monorepo structure
5. Set correct permissions (`chmod +x`)

### Expected Hooks After Merge

**Priority 1 (must have):**

- `pre-dangerous.sh` - Combined safety checks
- `ms-reminder-hook.js` - Marketplace reminder (keep as-is)

**Priority 2 (if present in veenk):**

- `post-response.sh` - Post-execution hooks
- Any workflow-specific hooks

### Path Considerations

Update any hardcoded paths in hooks to work with:

- Monorepo root structure
- New packages/ directory
- Existing plugins/ directory

---

## Architecture

(Added by architect-agent - technical annotations pending)

**Key Files:**

- `.claude/hooks/pre-dangerous.sh` - Pre-execution safety hook
- `.claude/hooks/ms-reminder-hook.js` - Marketplace reminder hook
- `.claude/hooks/post-response.sh` - Post-execution hook (if applicable)

---

## Definition of Done

- [ ] Implementation complete
- [ ] All hooks executable and tested
- [ ] TypeScript compiles (if hooks use TypeScript)
- [ ] Lint passes
- [ ] Acceptance criteria verified
- [ ] Hooks execute without errors in test scenarios

---

## Notes

- This story focuses on Claude-specific hooks (`.claude/hooks/`)
- Git hooks (Husky) are handled in MSM-VKM-E06-004
- Hooks must maintain backward compatibility with existing marketplace workflows
- Test hooks by triggering their conditions (e.g., dangerous operations for pre-dangerous.sh)
