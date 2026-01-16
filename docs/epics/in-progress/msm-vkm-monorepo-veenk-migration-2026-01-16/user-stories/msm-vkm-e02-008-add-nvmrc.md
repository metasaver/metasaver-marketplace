---
story_id: "MSM-VKM-E02-008"
epic_id: "MSM-VKM-E02"
title: "Add .nvmrc for Node version"
status: "pending"
complexity: 1
wave: 2
agent: "core-claude-plugin:config:workspace:nvmrc-agent"
dependencies: []
created: "2026-01-16"
updated: "2026-01-16"
---

# MSM-VKM-E02-008: Add .nvmrc for Node version

## User Story

**As a** developer setting up the monorepo locally
**I want** an .nvmrc file specifying the required Node.js version
**So that** nvm automatically switches to the correct Node version

---

## Acceptance Criteria

- [ ] File `.nvmrc` created at repository root
- [ ] Contains Node.js version 22.0.0 or higher
- [ ] Version format compatible with nvm
- [ ] Version matches package.json engines field
- [ ] File contains only version number (no extra content)
- [ ] nvm recognizes and uses version from file
- [ ] Follows established template/pattern
- [ ] Format validated

---

## Technical Details

### Location

- **Repo:** metasaver-marketplace
- **Package:** root level

### Files to Create

| File     | Purpose                       |
| -------- | ----------------------------- |
| `.nvmrc` | Node.js version specification |

### Files to Modify

None - this is a new file.

---

## Implementation Notes

Copy .nvmrc from veenk repository:

**Source location:** `/home/jnightin/code/veenk/.nvmrc`
**Target location:** `/home/jnightin/code/metasaver-marketplace/.nvmrc`

### Expected Content

```
22.0.0
```

### Version Alignment

Ensure consistency across:

- `.nvmrc` (this file)
- `package.json` engines.node field
- CI/CD workflow Node version

### Dependencies

None - this is a configuration file.

---

## Architecture

(Added by architect-agent - technical annotations pending)

**Key Files:**

- `.nvmrc` - Node version specification for nvm

**Integration:**

- nvm reads this file: `nvm use`
- CI/CD can reference for Node version
- Ensures consistent Node version across team

---

## Definition of Done

- [ ] Implementation complete
- [ ] Unit tests passing
- [ ] TypeScript compiles
- [ ] Lint passes
- [ ] Acceptance criteria verified
- [ ] File contains only version number
- [ ] `nvm use` switches to specified version
- [ ] Version matches package.json engines

---

## Notes

- Simple file containing only Node version number
- Critical for consistent development environment
- nvm users benefit from automatic version switching
- Does not affect existing plugin structure at plugins/metasaver-core/
