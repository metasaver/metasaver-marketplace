---
story_id: "MSM-VKM-E04-003"
epic_id: "MSM-VKM-E04"
title: "Validate plugin discovery still works"
status: "pending"
complexity: 2
wave: 3
agent: "core-claude-plugin:generic:tester"
dependencies: ["MSM-VKM-E04-001"]
created: "2026-01-16"
updated: "2026-01-16"
---

# MSM-VKM-E04-003: Validate plugin discovery still works

## User Story

**As a** Claude Code user
**I want** verification that plugin discovery continues to work after monorepo changes
**So that** existing marketplace functionality remains intact

---

## Acceptance Criteria

- [ ] Claude Code discovers metasaver-core plugin
- [ ] Plugin manifest (.claude-plugin/plugin.json) valid
- [ ] Marketplace manifest (.claude-plugin/marketplace.json) valid
- [ ] All agents discoverable by Claude Code
- [ ] All skills discoverable by Claude Code
- [ ] All commands discoverable by Claude Code
- [ ] No plugin loading errors in Claude Code
- [ ] Plugin functionality unaffected by monorepo structure
- [ ] Unit tests cover acceptance criteria
- [ ] All tests pass

---

## Technical Details

### Location

- **Repo:** metasaver-marketplace
- **Package:** root level (affects plugins/metasaver-core/)

### Files to Create

None - this story verifies existing functionality.

### Files to Modify

None - this story is verification only.

---

## Implementation Notes

Validate plugin discovery through Claude Code:

**Verification Steps:**

1. **Validate manifests**:

   ```bash
   cat .claude-plugin/marketplace.json | jq
   cat plugins/metasaver-core/.claude-plugin/plugin.json | jq
   ```

2. **Test plugin loading**: Start Claude Code and verify plugin loads

3. **Test agent discovery**: Verify agents list includes metasaver-core agents

4. **Test skill discovery**: Verify skills list includes metasaver-core skills

5. **Test command discovery**: Verify commands list includes metasaver-core commands

### Expected Results

- All manifests parse successfully
- Plugin loads without errors
- All components discoverable
- No regression in functionality

### Dependencies

Depends on MSM-VKM-E04-001 (directory structure verified).

---

## Architecture

(Added by architect-agent - technical annotations pending)

**Key Files:**

- `.claude-plugin/marketplace.json` - Marketplace manifest
- `plugins/metasaver-core/.claude-plugin/plugin.json` - Plugin manifest

**Plugin Discovery:**

- Claude Code scans .claude-plugin/marketplace.json
- Discovers plugins via plugins[] array
- Loads plugin manifests from source directories

---

## Definition of Done

- [ ] Implementation complete
- [ ] Unit tests passing
- [ ] TypeScript compiles
- [ ] Lint passes
- [ ] Acceptance criteria verified
- [ ] Plugin discovery works
- [ ] All components accessible
- [ ] No functionality regression

---

## Notes

- Critical validation - ensures zero impact on existing functionality
- Must verify plugins/metasaver-core/ completely untouched
- New monorepo structure should not affect plugin discovery
- Does not affect existing plugin structure at plugins/metasaver-core/
