---
story_id: "MSM-VKM-E02-007"
epic_id: "MSM-VKM-E02"
title: "Add .npmrc.template for GitHub auth"
status: "pending"
complexity: 2
wave: 2
agent: "core-claude-plugin:config:workspace:npmrc-template-agent"
dependencies: []
created: "2026-01-16"
updated: "2026-01-16"
---

# MSM-VKM-E02-007: Add .npmrc.template for GitHub auth

## User Story

**As a** developer setting up the monorepo locally
**I want** an .npmrc.template file documenting GitHub authentication setup
**So that** I can configure private GitHub package access consistently

---

## Acceptance Criteria

- [ ] File `.npmrc.template` created at repository root
- [ ] Contains GitHub package registry configuration
- [ ] Documents GITHUB_TOKEN placeholder
- [ ] Includes scoped package configuration (@metasaver)
- [ ] Instructions for setup included in comments
- [ ] Format follows npm configuration standards
- [ ] Template can be copied to .npmrc and customized
- [ ] Does not contain actual tokens (template only)
- [ ] Follows established template/pattern
- [ ] Format validated

---

## Technical Details

### Location

- **Repo:** metasaver-marketplace
- **Package:** root level

### Files to Create

| File              | Purpose                                  |
| ----------------- | ---------------------------------------- |
| `.npmrc.template` | Template for GitHub authentication setup |

### Files to Modify

None - this is a new file.

---

## Implementation Notes

Copy .npmrc.template from veenk repository:

**Source location:** `/home/jnightin/code/veenk/.npmrc.template`
**Target location:** `/home/jnightin/code/metasaver-marketplace/.npmrc.template`

### Expected Configuration

```
# GitHub Packages Authentication
# Replace ${GITHUB_TOKEN} with your personal access token
# Token needs read:packages permission

@metasaver:registry=https://npm.pkg.github.com
//npm.pkg.github.com/:_authToken=${GITHUB_TOKEN}
```

### Usage Instructions

Developers should:

1. Copy `.npmrc.template` to `.npmrc`
2. Replace `${GITHUB_TOKEN}` with actual token
3. Ensure `.npmrc` is in `.gitignore` (never commit tokens)

### Dependencies

None - this is a template file.

---

## Architecture

(Added by architect-agent - technical annotations pending)

**Key Files:**

- `.npmrc.template` - GitHub authentication template

**Security:**

- Template contains no secrets
- Actual `.npmrc` file must be in `.gitignore`
- Token requires read:packages permission

---

## Definition of Done

- [ ] Implementation complete
- [ ] Unit tests passing
- [ ] TypeScript compiles
- [ ] Lint passes
- [ ] Acceptance criteria verified
- [ ] Template file contains no actual tokens
- [ ] Instructions clear for developers
- [ ] `.npmrc` confirmed in `.gitignore`

---

## Notes

- This is a template file - does not contain actual credentials
- Developers copy to `.npmrc` and add their own token
- Critical for private GitHub package access
- Does not affect existing plugin structure at plugins/metasaver-core/
