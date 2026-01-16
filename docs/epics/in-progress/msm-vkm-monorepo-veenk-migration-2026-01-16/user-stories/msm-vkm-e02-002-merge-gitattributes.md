---
story_id: "MSM-VKM-E02-002"
epic_id: "MSM-VKM-E02"
title: "Merge .gitattributes files"
status: "pending"
complexity: 1
wave: 2
agent: "core-claude-plugin:config:version-control:gitattributes-agent"
dependencies: []
created: "2026-01-16"
updated: "2026-01-16"
---

# MSM-VKM-E02-002: Merge .gitattributes files

## User Story

**As a** developer working in the unified monorepo
**I want** a merged .gitattributes file that ensures consistent line endings and file attributes
**So that** Git handles text and binary files appropriately across platforms

---

## Acceptance Criteria

- [ ] .gitattributes file contains entries from both marketplace and veenk repositories
- [ ] Line ending rules configured for text files (text eol=lf)
- [ ] Binary file patterns specified (_.png binary, _.jpg binary, etc.)
- [ ] Script file patterns have correct attributes (\*.sh text eol=lf)
- [ ] Markdown files have consistent line endings
- [ ] Duplicate entries removed
- [ ] Entries organized by file type with comments
- [ ] Follows established template/pattern
- [ ] Format validated

---

## Technical Details

### Location

- **Repo:** metasaver-marketplace
- **Package:** root level

### Files to Create

None - this modifies an existing file.

### Files to Modify

| File             | Changes                                         |
| ---------------- | ----------------------------------------------- |
| `.gitattributes` | Merge patterns from marketplace and veenk repos |

---

## Implementation Notes

Merge .gitattributes files from both repositories:

**Source files:**

- `/home/jnightin/code/metasaver-marketplace/.gitattributes` (current)
- `/home/jnightin/code/veenk/.gitattributes` (to merge)

**Merge strategy:**

1. Preserve all marketplace entries
2. Add veenk-specific entries
3. Remove duplicates
4. Organize by category (Text files, Scripts, Binary files, etc.)
5. Add comments for clarity

### Common Patterns to Include

```gitattributes
# Auto-detect text files
* text=auto

# Text files - enforce LF
*.md text eol=lf
*.ts text eol=lf
*.js text eol=lf
*.json text eol=lf
*.yml text eol=lf
*.yaml text eol=lf

# Scripts - enforce LF
*.sh text eol=lf

# Binary files
*.png binary
*.jpg binary
*.jpeg binary
*.gif binary
*.ico binary
*.woff binary
*.woff2 binary
```

### Dependencies

None - this is a configuration file merge.

---

## Architecture

(Added by architect-agent - technical annotations pending)

**Key Files:**

- `.gitattributes` - Git attribute rules for monorepo

---

## Definition of Done

- [ ] Implementation complete
- [ ] Unit tests passing
- [ ] TypeScript compiles
- [ ] Lint passes
- [ ] Acceptance criteria verified
- [ ] `git check-attr --all <file>` shows correct attributes
- [ ] Line endings consistent across platforms

---

## Notes

- Careful merge required to avoid losing marketplace-specific patterns
- Test by checking file attributes with git check-attr
- Does not affect existing plugin structure at plugins/metasaver-core/
