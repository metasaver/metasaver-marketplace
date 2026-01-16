---
story_id: "MSM-VKM-E02-003"
epic_id: "MSM-VKM-E02"
title: "Merge .prettierignore files"
status: "pending"
complexity: 1
wave: 2
agent: "core-claude-plugin:config:code-quality:prettierignore-agent"
dependencies: []
created: "2026-01-16"
updated: "2026-01-16"
---

# MSM-VKM-E02-003: Merge .prettierignore files

## User Story

**As a** developer formatting code in the unified monorepo
**I want** a merged .prettierignore file that excludes appropriate files from formatting
**So that** Prettier doesn't format generated files, dependencies, or build artifacts

---

## Acceptance Criteria

- [ ] .prettierignore file contains entries from both marketplace and veenk repositories
- [ ] Build output directories ignored (dist/, build/, .turbo/, .next/)
- [ ] Dependency directories ignored (node_modules/, .pnpm/)
- [ ] Generated files ignored (_.generated.ts, _.d.ts)
- [ ] Cache directories ignored (.cache/, .parcel-cache/)
- [ ] Lock files ignored (pnpm-lock.yaml, package-lock.json)
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

| File              | Changes                                         |
| ----------------- | ----------------------------------------------- |
| `.prettierignore` | Merge patterns from marketplace and veenk repos |

---

## Implementation Notes

Merge .prettierignore files from both repositories:

**Source files:**

- `/home/jnightin/code/metasaver-marketplace/.prettierignore` (current, if exists)
- `/home/jnightin/code/veenk/.prettierignore` (to merge)

**Merge strategy:**

1. Preserve all marketplace entries
2. Add veenk-specific entries (build dirs, cache dirs)
3. Remove duplicates
4. Organize by category (Dependencies, Build, Cache, Generated, etc.)
5. Add comments for clarity

### Common Patterns to Include

```
# Dependencies
node_modules/
.pnpm/

# Build outputs
dist/
build/
.turbo/
.next/
out/

# Cache
.cache/
.parcel-cache/

# Generated files
*.generated.ts
*.d.ts

# Lock files
pnpm-lock.yaml
package-lock.json
yarn.lock

# Logs
*.log
```

### Dependencies

None - this is a configuration file merge.

---

## Architecture

(Added by architect-agent - technical annotations pending)

**Key Files:**

- `.prettierignore` - Prettier ignore patterns for monorepo

---

## Definition of Done

- [ ] Implementation complete
- [ ] Unit tests passing
- [ ] TypeScript compiles
- [ ] Lint passes
- [ ] Acceptance criteria verified
- [ ] `pnpm prettier --check .` respects ignore patterns
- [ ] Generated files not formatted by Prettier

---

## Notes

- Careful merge required to avoid losing marketplace-specific patterns
- Test by running prettier and verifying expected files are skipped
- Does not affect existing plugin structure at plugins/metasaver-core/
