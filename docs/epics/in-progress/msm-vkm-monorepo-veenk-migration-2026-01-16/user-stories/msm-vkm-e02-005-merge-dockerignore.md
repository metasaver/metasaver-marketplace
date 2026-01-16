---
story_id: "MSM-VKM-E02-005"
epic_id: "MSM-VKM-E02"
title: "Merge .dockerignore files"
status: "pending"
complexity: 1
wave: 2
agent: "core-claude-plugin:config:build-tools:dockerignore-agent"
dependencies: []
created: "2026-01-16"
updated: "2026-01-16"
---

# MSM-VKM-E02-005: Merge .dockerignore files

## User Story

**As a** developer building Docker images from the monorepo
**I want** a merged .dockerignore file that excludes unnecessary files from Docker context
**So that** Docker builds are faster and container images are smaller

---

## Acceptance Criteria

- [ ] .dockerignore file contains entries from both marketplace and veenk repositories
- [ ] Version control files ignored (.git/, .gitignore)
- [ ] Dependency directories ignored (node_modules/, .pnpm/)
- [ ] Build artifacts ignored (dist/, build/, .turbo/)
- [ ] Documentation files ignored (\*.md, docs/)
- [ ] Test files ignored (**tests**/, \*.test.ts, coverage/)
- [ ] Development files ignored (.env, .env.local, docker-compose.yml)
- [ ] Duplicate entries removed
- [ ] Entries organized by category with comments
- [ ] Follows established template/pattern
- [ ] Format validated

---

## Technical Details

### Location

- **Repo:** metasaver-marketplace
- **Package:** root level

### Files to Create

None - this modifies an existing file if present, or creates new file.

### Files to Modify

| File            | Changes                                         |
| --------------- | ----------------------------------------------- |
| `.dockerignore` | Merge patterns from marketplace and veenk repos |

---

## Implementation Notes

Merge .dockerignore files from both repositories:

**Source files:**

- `/home/jnightin/code/metasaver-marketplace/.dockerignore` (current, if exists)
- `/home/jnightin/code/veenk/.dockerignore` (to merge)

**Merge strategy:**

1. Preserve all marketplace entries
2. Add veenk-specific entries
3. Remove duplicates
4. Organize by category (Version Control, Dependencies, Build, Development, etc.)
5. Add comments for clarity

### Common Patterns to Include

```
# Version Control
.git/
.gitignore
.gitattributes

# Dependencies
node_modules/
.pnpm/

# Build outputs
dist/
build/
.turbo/
.next/

# Documentation
*.md
docs/
README.md

# Tests
__tests__/
*.test.ts
*.spec.ts
coverage/

# Development
.env
.env.local
.env.*.local
docker-compose.yml
.vscode/
.idea/

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

- `.dockerignore` - Docker ignore patterns for monorepo

---

## Definition of Done

- [ ] Implementation complete
- [ ] Unit tests passing
- [ ] TypeScript compiles
- [ ] Lint passes
- [ ] Acceptance criteria verified
- [ ] Docker build context size reduced
- [ ] Unnecessary files excluded from images

---

## Notes

- Careful merge required to avoid losing marketplace-specific patterns
- Test by running docker build and checking context size
- Does not affect existing plugin structure at plugins/metasaver-core/
