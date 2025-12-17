# US-005: Create agent-check Skill (NEW)

**Status:** 🔵 Pending
**Priority:** Critical
**Estimated Effort:** High
**File:** `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/cross-cutting/agent-check/SKILL.md`

---

## Story

As a new skill, I need to map detected files to appropriate config agents so that the audit workflow knows which agents to spawn for investigation.

---

## Acceptance Criteria

### Create File with Proper Structure

- [ ] Create file at correct path: `plugins/metasaver-core/skills/cross-cutting/agent-check/SKILL.md`
- [ ] Add frontmatter with name and description
- [ ] Create all required sections (Purpose, Input, Output, Examples, Integration)

### Document Purpose and Scope

- [ ] Purpose: Map files to agents based on file type and domain
- [ ] Scope: Config agents only (not domain agents like data-service-agent)
- [ ] Execution mode: Text analysis (no file access needed)

### Define Input/Output Format

- [ ] Input: `scope: { repos[], files[] }`, `prompt: string`
- [ ] Output: `agents: string[]` (list of unique agent names)
- [ ] Note: Deduplication if multiple files map to same agent

### Create File Type Mapping Table

- [ ] Build Tools (8 agents):
  - turbo.json → turbo-agent
  - vite.config.ts → vite-agent
  - vitest.config.ts → vitest-agent
  - postcss.config.js → postcss-agent
  - tailwind.config.js → tailwind-agent
  - pnpm-workspace.yaml → pnpm-workspace-agent
  - docker-compose.yml → docker-compose-agent
  - .dockerignore → dockerignore-agent

- [ ] Code Quality (3 agents):
  - eslint.config.js → eslint-agent
  - .prettierrc → prettier-agent
  - .editorconfig → editorconfig-agent

- [ ] Version Control (5 agents):
  - .gitignore → gitignore-agent
  - .gitattributes → gitattributes-agent
  - .husky/\* → husky-agent
  - .commitlintrc → commitlint-agent
  - .github/workflows/\*.yml → github-workflow-agent

- [ ] Workspace (9 agents):
  - tsconfig.json → typescript-configuration-agent
  - .nvmrc → nvmrc-agent
  - nodemon.json → nodemon-agent
  - .npmrc (template) → npmrc-template-agent
  - .env.example → env-example-agent
  - README.md → readme-agent
  - .vscode/settings.json → vscode-agent
  - scripts/\* → scripts-agent
  - CLAUDE.md → claude-md-agent
  - repomix.config.json → repomix-config-agent
  - package.json (root) → root-package-json-agent

### Create Domain Mapping Table

- [ ] "code quality" → [eslint-agent, prettier-agent, editorconfig-agent]
- [ ] "build tools" → [turbo-agent, vite-agent, vitest-agent, postcss-agent, tailwind-agent, pnpm-workspace-agent, docker-compose-agent, dockerignore-agent]
- [ ] "version control" → [gitignore-agent, gitattributes-agent, husky-agent, commitlint-agent, github-workflow-agent]
- [ ] "workspace" → [all 11 workspace agents]
- [ ] "monorepo root" → [all root config agents: turbo, pnpm-workspace, root-package-json, scripts, readme, etc.]

### Provide Examples

- [ ] Example 1: Single file → Single agent
  - Input: files=[eslint.config.js] → Output: agents=[eslint-agent]
- [ ] Example 2: Multiple files, same agent → Deduplicated
  - Input: files=[eslint.config.js, eslint.config.js] (cross-repo) → Output: agents=[eslint-agent]
- [ ] Example 3: Multiple files, different agents
  - Input: files=[eslint.config.js, .prettierrc] → Output: agents=[eslint-agent, prettier-agent]
- [ ] Example 4: Domain prompt with files
  - Input: prompt="audit code quality", files=[eslint.config.js, .prettierrc, .editorconfig] → Output: agents=[eslint-agent, prettier-agent, editorconfig-agent]
- [ ] Example 5: Monorepo root audit
  - Input: prompt="audit monorepo root", files=[turbo.json, pnpm-workspace.yaml, package.json] → Output: agents=[turbo-agent, pnpm-workspace-agent, root-package-json-agent]

### Add Integration Notes

- [ ] Runs in Phase 1 Analysis (parallel with scope-check)
- [ ] Receives scope output from scope-check
- [ ] Output passed to Requirements phase (BA creates stories from agent list)
- [ ] Agent list determines Investigation phase spawning

---

## Dependencies

- **Depends on:** None (new file)
- **Blocks:** US-001 (audit.md references agent-check), US-006 (agent-check-agent invokes this skill)

---

## Technical Notes

### Mapping Logic

**Priority Order:**

1. **Direct file match:** If file matches known config type, return specific agent
2. **Domain match:** If prompt contains domain keyword AND files match domain, return domain agents
3. **Fallback:** If no match, return empty array (let BA ask for clarification)

**Deduplication:**

- If multiple files map to same agent (e.g., eslint.config.js in 2 repos), return agent only once
- Investigation phase spawns agent multiple times (once per file) based on stories

### File Pattern Matching

Support multiple filename variants per agent:

- eslint: eslint.config.js, eslint.config.mjs, .eslintrc.js, .eslintrc.json
- prettier: .prettierrc, .prettierrc.json, prettier.config.js
- typescript: tsconfig.json, tsconfig.\*.json (base, build, etc.)
- vite: vite.config.ts, vite.config.js, vite.config.mjs
- vitest: vitest.config.ts, vitest.config.js

### Special Cases

| Case                          | Handling                                         |
| ----------------------------- | ------------------------------------------------ |
| No files detected by scope    | Return empty array, let BA clarify               |
| Unknown file type             | Return empty array, let BA clarify               |
| Domain prompt, no files       | Return domain agents, let Investigation discover |
| Mixed domain + specific files | Combine both mappings, deduplicate               |

---

## Definition of Done

- [ ] File created with proper frontmatter
- [ ] All sections present (Purpose, Input, Output, Mappings, Examples, Integration)
- [ ] File type mapping table complete (25+ config types)
- [ ] Domain mapping table complete (4+ domains)
- [ ] 5+ examples with different scenarios
- [ ] Integration notes comprehensive
- [ ] File validates as proper markdown
- [ ] References align with existing agent names in metasaver-marketplace
