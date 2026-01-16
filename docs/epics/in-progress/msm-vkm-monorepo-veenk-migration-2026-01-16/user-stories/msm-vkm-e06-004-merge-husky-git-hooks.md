---
story_id: "MSM-VKM-E06-004"
epic_id: "MSM-VKM-E06"
title: "Merge Husky git hooks"
status: "pending"
complexity: 3
wave: 5
agent: "core-claude-plugin:config:version-control:husky-git-hooks-agent"
dependencies: ["MSM-VKM-E03-006"]
created: "2026-01-16"
updated: "2026-01-16"
---

# MSM-VKM-E06-004: Merge Husky git hooks

## User Story

**As a** developer committing code to the metasaver-marketplace repository
**I want** Husky git hooks merged from both repositories to enforce code quality standards
**So that** pre-commit and pre-push checks run automatically for all code changes

---

## Acceptance Criteria

- [ ] All Husky hooks from veenk repository identified and reviewed
- [ ] All Husky hooks from marketplace repository identified and reviewed
- [ ] Hooks merged intelligently (no duplicates, conflicts resolved)
- [ ] Merged hooks placed in `.husky/` directory
- [ ] Husky initialized correctly in root package.json
- [ ] Pre-commit hooks run successfully
- [ ] Pre-push hooks run successfully
- [ ] Hooks work with monorepo structure (affect only relevant packages)
- [ ] Follows established template/pattern
- [ ] Format validated

---

## Technical Details

### Location

- **Repo:** metasaver-marketplace
- **Package:** root level

### Files to Merge

**From veenk repository:**

- `.husky/pre-commit`
- `.husky/pre-push`
- `.husky/commit-msg`
- Any other hooks in `.husky/`

**From marketplace repository:**

- Check if Husky is currently configured
- Identify any existing git hooks

### Files to Create/Modify

| File                | Purpose                              |
| ------------------- | ------------------------------------ |
| `.husky/pre-commit` | Run lint/format checks before commit |
| `.husky/pre-push`   | Run tests before push                |
| `.husky/commit-msg` | Validate commit message format       |
| `package.json`      | Add Husky scripts if not present     |

---

## Implementation Notes

**Source location:** `/home/jnightin/code/veenk/.husky/`
**Target location:** `/home/jnightin/code/metasaver-marketplace/.husky/`

### Merge Strategy

1. Check if marketplace already has Husky configured
2. Compare hooks from veenk repository
3. Merge intelligently:
   - Combine unique checks from both sources
   - Ensure hooks work with monorepo structure
   - Add workspace-aware linting/testing
4. Update package.json with Husky scripts if needed
5. Initialize Husky: `pnpm exec husky install`

### Expected Hooks After Merge

**Pre-commit:**

- Run lint checks on staged files
- Run format checks (Prettier)
- Run type checks (TypeScript)
- Scope to changed packages only (performance)

**Pre-push:**

- Run unit tests for affected packages
- Verify build succeeds

**Commit-msg:**

- Validate commit message follows conventions
- Check for required metadata (if applicable)

### Monorepo Considerations

Hooks must be workspace-aware:

- Only lint/test changed packages
- Use Turborepo filtering if available
- Skip marketplace plugin files (no changes allowed)

---

## Architecture

(Added by architect-agent - technical annotations pending)

**Key Files:**

- `.husky/pre-commit` - Pre-commit validation
- `.husky/pre-push` - Pre-push validation
- `.husky/commit-msg` - Commit message validation
- `package.json` - Husky initialization scripts

---

## Definition of Done

- [ ] Implementation complete
- [ ] All hooks executable and tested
- [ ] Lint passes
- [ ] Acceptance criteria verified
- [ ] Hooks triggered successfully on test commit
- [ ] Hooks triggered successfully on test push

---

## Notes

- This story focuses on Husky git hooks (`.husky/`)
- Claude hooks are handled in MSM-VKM-E06-003
- Hooks must not block marketplace plugin changes (those are managed separately)
- Test hooks by making test commits and pushes
- Consider performance: hooks should be fast (<10 seconds for pre-commit)
