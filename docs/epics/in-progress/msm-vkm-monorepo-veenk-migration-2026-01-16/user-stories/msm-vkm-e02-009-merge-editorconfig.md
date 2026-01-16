---
story_id: "MSM-VKM-E02-009"
epic_id: "MSM-VKM-E02"
title: "Merge .editorconfig files"
status: "pending"
complexity: 1
wave: 2
agent: "core-claude-plugin:config:code-quality:editorconfig-agent"
dependencies: []
created: "2026-01-16"
updated: "2026-01-16"
---

# MSM-VKM-E02-009: Merge .editorconfig files

## User Story

**As a** developer editing code in the unified monorepo
**I want** a merged .editorconfig file that enforces consistent formatting
**So that** editor settings are consistent across IDEs and team members

---

## Acceptance Criteria

- [ ] .editorconfig file contains settings from both marketplace and veenk repositories
- [ ] Root directive set (root = true)
- [ ] Universal settings configured (charset, trim_trailing_whitespace, insert_final_newline)
- [ ] JavaScript/TypeScript settings configured (indent_style, indent_size)
- [ ] Markdown settings configured (trim_trailing_whitespace = false)
- [ ] YAML settings configured (indent_size = 2)
- [ ] Shell script settings configured (indent_style = space)
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

None - this modifies an existing file if present, or creates new file.

### Files to Modify

| File            | Changes                                         |
| --------------- | ----------------------------------------------- |
| `.editorconfig` | Merge settings from marketplace and veenk repos |

---

## Implementation Notes

Merge .editorconfig files from both repositories:

**Source files:**

- `/home/jnightin/code/metasaver-marketplace/.editorconfig` (current, if exists)
- `/home/jnightin/code/veenk/.editorconfig` (to merge)

**Merge strategy:**

1. Preserve marketplace root settings
2. Add veenk-specific file type configurations
3. Remove duplicates
4. Organize by file type
5. Add comments for clarity

### Expected Configuration

```ini
root = true

[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true

[*.{js,ts,jsx,tsx}]
indent_style = space
indent_size = 2

[*.{json,yml,yaml}]
indent_style = space
indent_size = 2

[*.md]
trim_trailing_whitespace = false

[*.sh]
indent_style = space
indent_size = 2
```

### Dependencies

None - this is a configuration file merge.

---

## Architecture

(Added by architect-agent - technical annotations pending)

**Key Files:**

- `.editorconfig` - Editor configuration for monorepo

---

## Definition of Done

- [ ] Implementation complete
- [ ] Unit tests passing
- [ ] TypeScript compiles
- [ ] Lint passes
- [ ] Acceptance criteria verified
- [ ] Editor respects configuration
- [ ] Formatting consistent across file types

---

## Notes

- Careful merge required to avoid losing marketplace-specific settings
- Test by opening files in IDE and verifying indent/formatting
- Does not affect existing plugin structure at plugins/metasaver-core/
