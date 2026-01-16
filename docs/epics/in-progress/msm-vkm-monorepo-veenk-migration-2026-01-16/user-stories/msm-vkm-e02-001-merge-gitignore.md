---
story_id: "MSM-VKM-E02-001"
epic_id: "MSM-VKM-E02"
title: "Merge .gitignore files"
status: "pending"
complexity: 2
wave: 0
agent: "core-claude-plugin:config:version-control:gitignore-agent"
dependencies: []
created: "2026-01-16"
updated: "2026-01-16"
---

# MSM-VKM-E02-001: Merge .gitignore files

## User Story

**As a** developer working in the unified monorepo
**I want** a merged .gitignore file that excludes appropriate files from both repositories
**So that** Git ignores build artifacts, dependencies, and environment files consistently

---

## Acceptance Criteria

- [ ] .gitignore file contains entries from both marketplace and veenk repositories
- [ ] Node.js patterns included (node_modules/, dist/, build/, .turbo/)
- [ ] Environment files ignored (.env, .env.local, .env.\*.local)
- [ ] IDE files ignored (.vscode/, .idea/, \*.swp)
- [ ] LangGraph files ignored (.langgraph_api/)
- [ ] Package manager files ignored (pnpm-lock.yaml for tracking, but ignore if needed)
- [ ] Duplicate entries removed
- [ ] Entries organized by category with comments
- [ ] Unit tests cover acceptance criteria
- [ ] All tests pass

---

## Technical Details

### Location

- **Repo:** metasaver-marketplace
- **Package:** root level

### Files to Create

None - this modifies an existing file.

### Files to Modify

| File         | Changes                                         |
| ------------ | ----------------------------------------------- |
| `.gitignore` | Merge patterns from marketplace and veenk repos |

---

## Implementation Notes

Merge .gitignore files from both repositories:

**Source files:**

- `/home/jnightin/code/metasaver-marketplace/.gitignore` (current)
- `/home/jnightin/code/veenk/.gitignore` (to merge)

**Merge strategy:**

1. Preserve all marketplace entries
2. Add veenk-specific entries (LangGraph, workflow-specific patterns)
3. Remove duplicates
4. Organize by category (Node.js, IDEs, Environment, Build, etc.)
5. Add comments for clarity

### Common Patterns to Include

```gitignore
# Dependencies
node_modules/
.pnp
.pnp.js

# Build outputs
dist/
build/
.turbo/
.next/
out/

# Environment
.env
.env.local
.env.*.local
.npmrc

# LangGraph
.langgraph_api/

# IDE
.vscode/
.idea/
*.swp
*.swo

# Testing
coverage/

# Logs
*.log
npm-debug.log*
```

### Dependencies

None - this is a configuration file merge.

---

## Architecture

(Added by architect-agent - technical annotations pending)

**Key Files:**

- `.gitignore` - Git ignore patterns for monorepo

---

## Definition of Done

- [ ] Implementation complete
- [ ] Unit tests passing
- [ ] TypeScript compiles
- [ ] Lint passes
- [ ] Acceptance criteria verified
- [ ] `git status` shows appropriate files ignored
- [ ] No unintended files tracked by git

---

## Notes

- Careful merge required to avoid losing marketplace-specific patterns
- Test by running `git status` and verifying expected files are ignored
- Does not affect existing plugin structure at plugins/metasaver-core/
