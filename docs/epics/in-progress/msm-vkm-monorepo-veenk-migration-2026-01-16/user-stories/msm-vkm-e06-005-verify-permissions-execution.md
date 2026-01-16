---
story_id: "MSM-VKM-E06-005"
epic_id: "MSM-VKM-E06"
title: "Verify permissions and execution"
status: "pending"
complexity: 3
wave: 5
agent: "core-claude-plugin:generic:coder"
dependencies: ["MSM-VKM-E06-001", "MSM-VKM-E06-002", "MSM-VKM-E06-003", "MSM-VKM-E06-004"]
created: "2026-01-16"
updated: "2026-01-16"
---

# MSM-VKM-E06-005: Verify permissions and execution

## User Story

**As a** developer using scripts and hooks in the metasaver-marketplace repository
**I want** all scripts and hooks to have correct permissions and execute successfully
**So that** automation workflows function properly without permission errors

---

## Acceptance Criteria

- [ ] All utility scripts in `scripts/` directory have execute permissions
- [ ] All Claude hooks in `.claude/hooks/` have execute permissions
- [ ] All Husky hooks in `.husky/` have execute permissions
- [ ] Each utility script executes without errors (smoke test)
- [ ] Each Claude hook executes without errors (test scenario)
- [ ] Each Husky hook executes without errors (test scenario)
- [ ] Scripts work with updated monorepo paths
- [ ] Hooks work with hybrid repository structure
- [ ] Follows established template/pattern
- [ ] Format validated

---

## Technical Details

### Location

- **Repo:** metasaver-marketplace
- **Package:** root level

### Files to Verify

**Utility Scripts (from E06-001, E06-002):**

- `scripts/qbp.sh`
- `scripts/repomix.sh`
- `scripts/sync-code-to-kb.sh`
- `scripts/verify-build.sh`
- `scripts/verify-imports.sh`
- `scripts/verify-tests.sh`
- And 3 other scripts migrated from veenk

**Claude Hooks (from E06-003):**

- `.claude/hooks/pre-dangerous.sh`
- `.claude/hooks/ms-reminder-hook.js`
- `.claude/hooks/post-response.sh` (if present)
- Any other Claude hooks

**Husky Hooks (from E06-004):**

- `.husky/pre-commit`
- `.husky/pre-push`
- `.husky/commit-msg`
- Any other Husky hooks

---

## Implementation Notes

### Permission Verification

Run for each directory:

```bash
# Check scripts
ls -la scripts/

# Check Claude hooks
ls -la .claude/hooks/

# Check Husky hooks
ls -la .husky/
```

### Set Permissions

For any non-executable files:

```bash
# Make scripts executable
chmod +x scripts/*.sh

# Make Claude hooks executable
chmod +x .claude/hooks/*

# Make Husky hooks executable
chmod +x .husky/*
```

### Execution Verification

**Utility Scripts:**

- Run each script with `--help` or minimal args
- Verify no permission errors
- Verify paths resolve correctly

**Claude Hooks:**

- Trigger pre-dangerous hook with test scenario
- Verify hook executes and returns correctly
- Check hook logs for errors

**Husky Hooks:**

- Make test commit to trigger pre-commit
- Test push to trigger pre-push
- Verify hooks execute successfully

### Expected Permissions

All scripts and hooks should have:

- Owner: read + write + execute (rwx)
- Group: read + execute (rx)
- Other: read + execute (rx)
- Octal: 755

---

## Architecture

(Added by architect-agent - technical annotations pending)

**Key Verification Points:**

- `scripts/` - All utility scripts
- `.claude/hooks/` - All Claude hooks
- `.husky/` - All Husky git hooks

**Verification Commands:**

```bash
# List all scripts with permissions
find scripts -type f -name "*.sh" -ls

# List all hooks with permissions
find .claude/hooks -type f -ls
find .husky -type f -ls

# Test script execution
./scripts/qbp.sh --help

# Test Husky hooks
git commit --allow-empty -m "Test hook execution"
```

---

## Definition of Done

- [ ] Implementation complete
- [ ] All scripts have correct permissions (755)
- [ ] All hooks have correct permissions (755)
- [ ] All scripts execute without permission errors
- [ ] All hooks execute without permission errors
- [ ] Acceptance criteria verified
- [ ] Documentation updated with any execution requirements

---

## Notes

- This is a verification and fix story, not implementation
- Dependencies: Must run after all script/hook migration stories complete
- If permission issues found, fix them in this story
- If execution issues found, coordinate with previous story owners to fix
- Test in clean environment (new terminal session) to catch PATH issues
