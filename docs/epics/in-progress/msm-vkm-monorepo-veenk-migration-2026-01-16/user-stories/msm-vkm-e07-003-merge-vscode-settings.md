---
story_id: "MSM-VKM-E07-003"
epic_id: "MSM-VKM-E07"
title: "Merge VS Code settings"
status: "pending"
complexity: 2
wave: 6
agent: "core-claude-plugin:config:workspace:vscode-agent"
dependencies: ["MSM-VKM-E03-006"]
created: "2026-01-16"
updated: "2026-01-16"
---

# MSM-VKM-E07-003: Merge VS Code settings

## User Story

**As a** developer using VS Code in the metasaver-marketplace repository
**I want** VS Code settings merged from both repositories to provide optimal editor configuration
**So that** I have consistent formatting, linting, and TypeScript support for all code

---

## Acceptance Criteria

- [ ] VS Code settings from veenk repository identified and reviewed
- [ ] VS Code settings from marketplace repository identified and reviewed
- [ ] Settings merged intelligently (no conflicts, best practices retained)
- [ ] Merged settings placed in `.vscode/settings.json`
- [ ] TypeScript settings configured for monorepo structure
- [ ] ESLint/Prettier settings work with all packages
- [ ] File associations configured correctly
- [ ] Recommended extensions documented in `.vscode/extensions.json`
- [ ] Follows established template/pattern
- [ ] Format validated

---

## Technical Details

### Location

- **Repo:** metasaver-marketplace
- **Package:** root level

### Files to Merge

**From veenk repository:**

- `.vscode/settings.json`
- `.vscode/extensions.json`
- `.vscode/launch.json` (if present)

**From marketplace repository:**

- `.vscode/settings.json` (if present)
- `.vscode/extensions.json` (if present)

### Files to Create/Modify

| File                      | Purpose                              |
| ------------------------- | ------------------------------------ |
| `.vscode/settings.json`   | Merged editor settings               |
| `.vscode/extensions.json` | Recommended extensions for workspace |
| `.vscode/launch.json`     | Debug configurations (if applicable) |

---

## Implementation Notes

**Source locations:**

- `/home/jnightin/code/veenk/.vscode/`
- `/home/jnightin/code/metasaver-marketplace/.vscode/`

**Target location:**

- `/home/jnightin/code/metasaver-marketplace/.vscode/`

### Merge Strategy

**1. Settings Priority:**

- Keep marketplace-specific settings for plugin development
- Add veenk settings for TypeScript/workflow development
- Resolve conflicts by choosing most permissive/helpful setting

**2. Key Settings to Merge:**

**TypeScript:**

```json
{
  "typescript.tsdk": "node_modules/typescript/lib",
  "typescript.enablePromptUseWorkspaceTsdk": true
}
```

**ESLint/Prettier:**

```json
{
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "eslint.workingDirectories": ["packages/*"]
}
```

**File Associations:**

```json
{
  "files.associations": {
    "*.md": "markdown",
    "CLAUDE.md": "markdown"
  }
}
```

**3. Recommended Extensions:**
Merge from both repositories:

- ESLint
- Prettier
- TypeScript
- Markdown
- LangGraph (if available)

---

## Architecture

(Added by architect-agent - technical annotations pending)

**Key Files:**

- `.vscode/settings.json` - Editor configuration
- `.vscode/extensions.json` - Recommended extensions
- `.vscode/launch.json` - Debug configurations (optional)

**Configuration Strategy:**

- Support both plugin development and workflow development
- Workspace-aware TypeScript configuration
- Consistent formatting across all packages
- Helpful extensions for all development tasks

---

## Definition of Done

- [ ] Implementation complete
- [ ] VS Code loads settings without errors
- [ ] TypeScript IntelliSense works in all packages
- [ ] ESLint runs in all packages
- [ ] Prettier formats all file types correctly
- [ ] Acceptance criteria verified
- [ ] Settings tested in fresh VS Code workspace

---

## Notes

- Test settings by opening workspace in VS Code
- Verify IntelliSense works in both plugins/ and packages/
- Check that formatting works consistently
- Recommended extensions should enhance productivity without being overwhelming
- Settings should not conflict with user-level VS Code config
