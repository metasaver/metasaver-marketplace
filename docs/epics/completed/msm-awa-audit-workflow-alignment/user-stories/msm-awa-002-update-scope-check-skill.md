# US-002: Update scope-check Skill

**Status:** 🔵 Pending
**Priority:** Critical
**Estimated Effort:** High
**File:** `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/cross-cutting/scope-check/SKILL.md`

---

## Story

As a scope detection skill, I need to return both repository paths AND specific file paths so that the agent-check skill can map files to appropriate config agents for audit execution.

---

## Acceptance Criteria

### Output Format Change

- [ ] Change output from `{ targets: [], references: [] }` to `{ repos: [], files: [] }`
- [ ] Update all code examples to use new format
- [ ] Update all text references to use new field names

### Remove Reference vs Target Logic

- [ ] Remove Step 1: Detect Reference Repositories section
- [ ] Remove Step 2: Detect Target Repositories section (replace with unified repo detection)
- [ ] Remove distinction between "reference indicators" and "target indicators"
- [ ] Simplify to single repo detection logic

### Add File Detection Logic

- [ ] Add section: "File Detection Patterns"
- [ ] Document pattern: "audit eslint" → detect all eslint.config.js files in repos
- [ ] Document pattern: "audit turbo" → detect turbo.json files
- [ ] Document pattern: "audit prettier" → detect .prettierrc, prettier.config.js files
- [ ] Document pattern: "audit monorepo root" → detect root config files (turbo.json, pnpm-workspace.yaml, package.json, etc.)
- [ ] Document pattern: "audit code quality" → detect eslint, prettier, editorconfig files
- [ ] Document pattern: "audit build tools" → detect vite, vitest, postcss, tailwind configs
- [ ] Document pattern: "audit across all repos" → resolve to known repo list + detect specified files

### Update Examples

- [ ] Example 1: "audit eslint" → repos=[CWD], files=[eslint.config.js]
- [ ] Example 2: "audit eslint across consumer repos" → repos=[rugby-crm, resume-builder], files=[eslint.config.js, eslint.config.js]
- [ ] Example 3: "audit monorepo root" → repos=[CWD], files=[turbo.json, pnpm-workspace.yaml, package.json, ...]
- [ ] Example 4: "audit code quality" → repos=[CWD], files=[eslint.config.js, .prettierrc, .editorconfig]
- [ ] Remove all examples showing targets/references distinction

### Update Integration Section

- [ ] Note that agent-check skill receives scope output
- [ ] Remove references to reference repos (pattern learning)
- [ ] Update output description to emphasize file detection

---

## Dependencies

- **Depends on:** None
- **Blocks:** US-001 (audit.md references scope-check output), US-005 (agent-check consumes scope output)

---

## Technical Notes

### Known Repositories Reference

Keep this table but simplify usage:

- multi-mono (producer)
- metasaver-com (consumer)
- resume-builder (consumer)
- rugby-crm (consumer)
- metasaver-marketplace (plugin)

### File Type Mapping Reference

**Config Files to Detect:**

**Build Tools:**

- turbo.json
- vite.config.ts, vite.config.js
- vitest.config.ts, vitest.config.js
- postcss.config.js, postcss.config.cjs
- tailwind.config.js, tailwind.config.ts
- pnpm-workspace.yaml
- docker-compose.yml
- .dockerignore

**Code Quality:**

- eslint.config.js, eslint.config.mjs, .eslintrc.js
- .prettierrc, prettier.config.js
- .editorconfig

**Version Control:**

- .gitignore
- .gitattributes
- husky hooks (in .husky/)
- .github/workflows/\*.yml

**Workspace:**

- tsconfig.json, tsconfig.\*.json
- .nvmrc
- nodemon.json
- .npmrc (template)
- .env.example
- README.md
- .vscode/settings.json
- package.json (root)
- CLAUDE.md
- repomix.config.json

### Special Case Handling

| Prompt Pattern        | Repos             | Files                           |
| --------------------- | ----------------- | ------------------------------- |
| "audit {file-type}"   | [CWD]             | [detected files matching type]  |
| "audit across all"    | [all known repos] | [detected files in each]        |
| "audit monorepo root" | [CWD]             | [all root config files]         |
| "audit {domain}"      | [CWD]             | [all files in domain category]  |
| No specific file/repo | [CWD]             | [all config files - full audit] |

---

## Definition of Done

- [ ] Output format changed throughout file
- [ ] File detection patterns documented with 8+ examples
- [ ] All examples updated to new format
- [ ] Reference vs target distinction removed
- [ ] Integration notes updated
- [ ] Known repositories table retained
- [ ] Special cases documented
- [ ] File validates as proper markdown
