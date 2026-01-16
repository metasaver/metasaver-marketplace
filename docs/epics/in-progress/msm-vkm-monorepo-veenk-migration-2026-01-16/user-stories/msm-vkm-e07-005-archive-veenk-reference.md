---
story_id: "MSM-VKM-E07-005"
epic_id: "MSM-VKM-E07"
title: "Archive veenk reference implementations"
status: "pending"
complexity: 3
wave: 6
agent: "core-claude-plugin:generic:coder"
dependencies: ["MSM-VKM-E03-006", "MSM-VKM-E05-008"]
created: "2026-01-16"
updated: "2026-01-16"
---

# MSM-VKM-E07-005: Archive veenk reference implementations

## User Story

**As a** developer maintaining the metasaver-marketplace repository
**I want** veenk reference implementations archived in a designated location
**So that** historical code remains accessible for reference without cluttering the active codebase

---

## Acceptance Criteria

- [ ] Archive directory created at `zzzold/veenk-reference/`
- [ ] All veenk source code copied to archive (read-only reference)
- [ ] Archive includes original repository structure
- [ ] Archive includes commit history reference (git log exported)
- [ ] Archive README explains purpose and migration date
- [ ] Archive location documented in main README
- [ ] Archive excluded from TypeScript compilation
- [ ] Archive excluded from ESLint/Prettier
- [ ] Follows established template/pattern
- [ ] Format validated

---

## Technical Details

### Location

- **Repo:** metasaver-marketplace
- **Archive Path:** `zzzold/veenk-reference/`

### Files to Create

| File                                    | Purpose                              |
| --------------------------------------- | ------------------------------------ |
| `zzzold/veenk-reference/README.md`      | Explain archive purpose              |
| `zzzold/veenk-reference/src/`           | Copy of original veenk source code   |
| `zzzold/veenk-reference/docs/`          | Copy of original veenk documentation |
| `zzzold/veenk-reference/COMMIT-LOG.txt` | Git log from original repository     |

### Files to Modify

| File            | Purpose                                 |
| --------------- | --------------------------------------- |
| `README.md`     | Add note about archive location         |
| `.gitignore`    | Ensure archive is tracked (not ignored) |
| `tsconfig.json` | Exclude archive from compilation        |
| `.eslintignore` | Exclude archive from linting            |

---

## Implementation Notes

**Source location:** `/home/jnightin/code/veenk/`
**Target location:** `/home/jnightin/code/metasaver-marketplace/zzzold/veenk-reference/`

### Archive Creation Process

**1. Create archive directory:**

```bash
mkdir -p zzzold/veenk-reference
```

**2. Copy veenk source code:**

```bash
# Copy entire veenk repository structure
cp -r /home/jnightin/code/veenk/src zzzold/veenk-reference/
cp -r /home/jnightin/code/veenk/docs zzzold/veenk-reference/
cp -r /home/jnightin/code/veenk/scripts zzzold/veenk-reference/
cp -r /home/jnightin/code/veenk/tests zzzold/veenk-reference/
```

**3. Export commit history:**

```bash
cd /home/jnightin/code/veenk
git log --pretty=format:"%h - %an, %ar : %s" > /home/jnightin/code/metasaver-marketplace/zzzold/veenk-reference/COMMIT-LOG.txt
```

**4. Create archive README:**

Document:

- Purpose: Read-only reference of original veenk repository
- Migration date: 2026-01-16
- New location: packages/veenk-workflows/
- Why archived: Historical reference, migration completed

**5. Exclude from tooling:**

Update `tsconfig.json`:

```json
{
  "exclude": ["zzzold/**", "node_modules/**"]
}
```

Update `.eslintignore`:

```
zzzold/
```

---

## Architecture

(Added by architect-agent - technical annotations pending)

**Key Files:**

- `zzzold/veenk-reference/` - Full archive directory
- `zzzold/veenk-reference/README.md` - Archive documentation

**Archive Strategy:**

- Keep complete copy of original repository
- Preserve directory structure for reference
- Exclude from active development tooling
- Document migration path clearly

---

## Definition of Done

- [ ] Implementation complete
- [ ] Archive directory created and populated
- [ ] Archive README documents purpose
- [ ] Archive excluded from TypeScript/ESLint
- [ ] Main README references archive location
- [ ] Acceptance criteria verified
- [ ] Archive committed to git

---

## Notes

- Archive is read-only reference (no active development)
- Use `zzzold/` prefix to sort archive to bottom of directory listings
- Keep original structure intact for easy reference
- Commit history export provides attribution and timeline
- This preserves veenk history even after GitHub archive (E07-007)
