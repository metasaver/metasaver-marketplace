# PRD: Audit Command Workflow Alignment

**Created:** 2025-12-17
**Type:** Technical debt / workflow simplification
**Complexity:** High (30+)

---

## Executive Summary

Align the `/audit` command implementation with the new target state document that defines a simplified, two-phase workflow (Investigation + Remediation) with HITL per-discrepancy resolution.

**Scope:** 4 existing files to update, 2 new files to create

---

## Current State vs Target State

### Phase Changes

| Phase            | Current (OLD)                       | Target (NEW)                                                    |
| ---------------- | ----------------------------------- | --------------------------------------------------------------- |
| Analysis         | 3 agents (complexity, tools, scope) | 2 agents (scope-check, agent-check)                             |
| Cross-Repo       | Phase 1.5 (path resolution)         | Removed (hardcoded in scope-check)                              |
| Requirements     | BA investigates + creates PRD       | BA investigates + creates PRD + user stories (1 per agent/file) |
| Vibe Check       | Single check after PRD              | Removed                                                         |
| Human Validation | Light/Full based on complexity      | Simplified approval after stories                               |
| Design           | Architect + PM planning             | PM batches agents only                                          |
| Execution        | Config agents audit + apply fixes   | Split into Phase 4 (Investigation) + Phase 6 (Remediation)      |
| HITL Resolution  | None                                | NEW Phase 5 (per-discrepancy with 4 options)                    |
| Validation       | Full standards audit                | Simplified (build/lint/test only)                               |
| Report           | BA sign-off + PM consolidation      | BA consolidates all results                                     |

### Scope Check Changes

**OLD Output:**

```json
{
  "targets": ["path/to/repo"],
  "references": ["path/to/reference/repo"]
}
```

**NEW Output:**

```json
{
  "repos": ["path/to/repo1", "path/to/repo2"],
  "files": ["path/to/repo1/eslint.config.js", "path/to/repo2/turbo.json"]
}
```

**Key Change:** Scope check now detects specific files to audit based on prompt, not just repos.

### Agent Check (NEW)

**Purpose:** Map detected files to config agents

**Input:** `scope: { repos[], files[] }`

**Output:** `agents: ["eslint-agent", "turbo-agent"]`

**Logic:**

- Match file types to config agents (eslint.config.js → eslint-agent)
- Match domain references to agent groups (e.g., "code quality" → eslint-agent, prettier-agent)
- Support composite agents for domain audits (e.g., "monorepo root" → all root config agents)

---

## Success Criteria

1. All 6 files (4 updates + 2 new) aligned with target state
2. No complexity-check or tool-check agents in Analysis phase
3. Scope-check returns `{ repos[], files[] }` format
4. Agent-check maps files to agents correctly
5. Requirements phase creates user stories (1 per agent/file combo)
6. Investigation phase is read-only (no changes)
7. Phase 5 (Resolution) implements HITL with 4 options per discrepancy
8. Phase 6 (Remediation) only applies approved fixes
9. Validation runs build/lint/test only (no config agents)
10. Phase 1.5 (Cross-Repo Resolution) removed
11. Vibe Check removed
12. Human Validation simplified

---

## User Stories

### US-001: Update audit.md Command File

**File:** `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/commands/audit.md`
**Priority:** Critical
**Estimated Effort:** High

**Changes Required:**

**REMOVE:**

- Phase 1: complexity-check-agent and tool-check-agent spawning
- Phase 1.5: Cross-Repo Resolution section (lines 36-56)
- Phase 3: Vibe Check section (lines 83-87)
- Complexity-based routing in Human Validation (line 96-98)
- References to `scope.targets` and `scope.references`

**ADD:**

- Phase 1: Spawn only 2 agents in parallel (scope-check, agent-check)
- Phase 4: Investigation (read-only agent spawning, discrepancy collection)
- Phase 5: Report & Resolution (HITL per-discrepancy with 4 options)
- Phase 6: Remediation (apply approved fixes)
- Updated model selection table (remove complexity routing)

**UPDATE:**

- Phase 2: Requirements - Add user story creation (1 per agent/file combo)
- Phase 4: Rename from "Execution" to "Investigation"
- Phase 7: Validation - Simplify to build/lint/test only
- Phase 8: Report - Update to reflect new phases
- Enforcement rules (reflect new phase structure)
- Examples section (reflect new workflow)

**Acceptance Criteria:**

- [ ] Only 2 agents spawned in Analysis phase
- [ ] All removed sections deleted
- [ ] All new phases documented with mermaid diagrams
- [ ] Examples reflect new workflow
- [ ] Enforcement rules updated
- [ ] No references to complexity or tools checks
- [ ] No references to targets/references format

---

### US-002: Update scope-check Skill

**File:** `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/cross-cutting/scope-check/SKILL.md`
**Priority:** Critical
**Estimated Effort:** High

**Changes Required:**

**UPDATE Output Format:**

- Change from `{ targets: [], references: [] }` to `{ repos: [], files: [] }`
- Remove reference vs target distinction
- Add file detection logic based on prompt

**ADD:**

- File detection patterns:
  - "audit eslint" → detect all eslint.config.js files in target repos
  - "audit turbo" → detect turbo.json files
  - "audit monorepo root" → detect root config files (turbo.json, pnpm-workspace.yaml, etc.)
  - "audit code quality" → detect eslint, prettier, editorconfig files
  - "audit across all repos" → resolve to known repo list + detect files

**UPDATE:**

- All examples to show new output format
- Step sections to focus on repo + file detection (not reference classification)
- Integration section to note agent-check receives scope output

**Acceptance Criteria:**

- [ ] Output format changed to `{ repos[], files[] }`
- [ ] File detection logic documented for common prompts
- [ ] Examples updated with new format
- [ ] Reference vs target distinction removed
- [ ] All steps reflect file detection priority

---

### US-003: Update scope-check-agent

**File:** `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/generic/scope-check-agent.md`
**Priority:** Medium
**Estimated Effort:** Low

**Changes Required:**

**UPDATE:**

- Agent description to mention file detection
- Output format reference to `{ repos[], files[] }`
- Purpose statement to emphasize file detection in addition to repo detection

**Acceptance Criteria:**

- [ ] Description mentions file detection
- [ ] Output format reference updated
- [ ] No breaking changes to agent behavior

---

### US-004: Update requirements-phase Skill

**File:** `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/workflow-steps/requirements-phase/SKILL.md`
**Priority:** Critical
**Estimated Effort:** Medium

**Changes Required:**

**ADD:**

- Step 5: Extract user stories from PRD
- User story creation logic:
  - One story per (agent, file) pair
  - Story includes: agent name, file path, template/skill reference, acceptance criteria
  - Stories saved to `{projectFolder}/user-stories/` directory
  - Filename format: `US-{number}-{slug}.md`
- User story template reference (from /skill user-story-template)

**UPDATE:**

- Workflow Steps section to include story extraction after PRD
- Output Format to include `{ storiesFolder, storyFiles[] }`
- Audit Mode section to note story creation for each agent/file combo

**Acceptance Criteria:**

- [ ] Story extraction step documented
- [ ] Story template referenced
- [ ] One story per agent/file combo rule documented
- [ ] Output format includes story file paths
- [ ] Stories saved to correct directory structure

---

### US-005: Create agent-check Skill (NEW)

**File:** `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/cross-cutting/agent-check/SKILL.md`
**Priority:** Critical
**Estimated Effort:** High

**Content Required:**

**Frontmatter:**

```yaml
---
name: agent-check
description: Maps detected files to appropriate config agents for audit execution
---
```

**Sections:**

1. **Purpose:** Map files to agents based on file type and domain
2. **Input:** `scope: { repos[], files[] }`, `prompt` (string)
3. **Output:** `agents: string[]` (list of agent names)
4. **File Type Mapping Table:**
   - eslint.config.js → eslint-agent
   - .prettierrc → prettier-agent
   - turbo.json → turbo-agent
   - tsconfig.json → typescript-configuration-agent
   - vite.config.ts → vite-agent
   - vitest.config.ts → vitest-agent
   - docker-compose.yml → docker-compose-agent
   - .gitignore → gitignore-agent
   - etc. (complete list from monorepo-audit skill)

5. **Domain Mapping Table:**
   - "code quality" → [eslint-agent, prettier-agent, editorconfig-agent]
   - "build tools" → [turbo-agent, vite-agent, vitest-agent, postcss-agent, etc.]
   - "version control" → [gitignore-agent, gitattributes-agent, husky-agent, etc.]
   - "monorepo root" → [all root config agents]

6. **Examples:**
   - Input: files=[eslint.config.js] → Output: agents=[eslint-agent]
   - Input: prompt="audit code quality", files=[eslint.config.js, .prettierrc] → Output: agents=[eslint-agent, prettier-agent]
   - Input: prompt="audit monorepo root", files=[turbo.json, pnpm-workspace.yaml] → Output: agents=[turbo-agent, pnpm-workspace-agent]

7. **Integration:** Runs in Phase 1 parallel with scope-check

**Acceptance Criteria:**

- [ ] Complete file type mapping table (25+ config types)
- [ ] Domain mapping table for composite audits
- [ ] 5+ examples with different input scenarios
- [ ] Integration notes for Analysis phase
- [ ] Output format clearly documented

---

### US-006: Create agent-check-agent (NEW)

**File:** `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/generic/agent-check-agent.md`
**Priority:** Critical
**Estimated Effort:** Low

**Content Required:**

**Frontmatter:**

```yaml
---
name: agent-check-agent
description: Mapping specialist that identifies which config agents are needed for audit
tools: TodoWrite
permissionMode: bypassPermissions
---
```

**Sections:**

1. **Purpose:** Analyze scope and return list of agents needed
2. **Domain:** Agent selection and mapping
3. **Authority:** Text classification and file type matching
4. **Mode:** Analysis (no file access needed)
5. **How to Execute:**
   - Invoke `/skill agent-check`
   - Pass scope and prompt
   - Return `agents: string[]`

6. **Input:** scope (with repos[] and files[]), prompt
7. **Output:** `agents: string[]`

**Acceptance Criteria:**

- [ ] Agent metadata complete (model, tools, permissions)
- [ ] Purpose clearly stated
- [ ] Execution steps documented
- [ ] Input/output format specified
- [ ] References agent-check skill

---

## Dependencies

**Story Dependencies:**

- US-002, US-003 must complete before US-001 (audit.md references scope-check output)
- US-005, US-006 must complete before US-001 (audit.md references agent-check)
- US-004 can be done independently but should complete before US-001

**Recommended Order:**

1. US-005, US-006 (create new agent-check skill/agent)
2. US-002, US-003 (update scope-check)
3. US-004 (update requirements-phase)
4. US-001 (update audit.md command - integrates everything)

---

## Technical Notes

### Backward Compatibility

- This is a BREAKING change to /audit workflow
- No gradual migration possible
- All changes must be deployed together

### Testing Strategy

1. Test scope-check with various prompts (verify files[] output)
2. Test agent-check with scope output (verify correct agent mapping)
3. Test requirements-phase story creation (verify 1 story per agent/file)
4. Test full /audit workflow end-to-end
5. Verify Investigation phase is read-only
6. Verify HITL resolution with all 4 options
7. Verify Remediation only applies approved fixes

### Validation

- Run sample audits: "audit eslint", "audit monorepo root", "audit across all repos"
- Verify no complexity or tools checks occur
- Verify correct agent spawning in Investigation phase
- Verify HITL prompts user for each discrepancy
- Verify validation runs build/lint/test only

---

## Open Questions

1. Should agent-check skill include domain agents (e.g., data-service-agent) or only config agents?
   - **Recommendation:** Start with config agents only, add domain agents in future iteration

2. How to handle "update template" decisions in HITL?
   - **Per target state:** Create branch in multi-mono, update skill templates, open PR for review
   - **Needs implementation details:** Which agent handles this? When does it happen?

3. Should we create separate skills for Investigation and Remediation phases?
   - **Recommendation:** Yes, for clarity and reusability

4. How to store user decisions during HITL loop?
   - **Recommendation:** Update user story markdown files with decision in "User Decision" section

---

## Definition of Done

- [ ] All 6 files created or updated per specifications
- [ ] All acceptance criteria in each user story met
- [ ] Target state document fully reflected in implementation
- [ ] No references to removed features (complexity-check, tool-check, vibe check, cross-repo resolution)
- [ ] New features documented (agent-check, user stories, Investigation/Remediation/Resolution phases)
- [ ] Examples and integration notes updated
- [ ] Testing strategy validated with sample prompts
