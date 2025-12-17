# Execution Plan: No-Barrel Module Architecture

## Overview

This execution plan implements the no-barrel module architecture across the MetaSaver marketplace. The work is organized into 2 waves based on dependency analysis, maximizing parallel execution while respecting inter-story dependencies.

## Wave Summary

| Wave | Stories                                | Parallelism  | Agent Type   | Estimated Duration |
| ---- | -------------------------------------- | ------------ | ------------ | ------------------ |
| 1    | US-002, US-003, US-004, US-005, US-006 | 5 parallel   | agent-author | 15-20 minutes      |
| 2    | US-001                                 | 1 sequential | agent-author | 5-8 minutes        |

**Total Estimated Duration:** 20-28 minutes

## Dependency Graph

```
Wave 1 (Parallel - No Dependencies):
┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐
│   US-002    │  │   US-003    │  │   US-004    │  │   US-005    │  │   US-006    │
│Code Gen     │  │Config       │  │Config       │  │Templates    │  │Domain       │
│Agents       │  │Agents       │  │Skills       │  │             │  │Skills       │
└──────┬──────┘  └──────┬──────┘  └──────┬──────┘  └─────────────┘  └─────────────┘
       │                │                │
       └────────────────┴────────────────┘
                        ↓
                  ┌─────────────┐
                  │   US-001    │ Wave 2
                  │Commands     │
                  └─────────────┘
```

## Wave 1: Foundation (Parallel Execution)

All Wave 1 stories have no dependencies and can execute in parallel. They establish the no-barrel architecture patterns across agents, skills, and templates.

### US-002: Update Code Generation Agents

**Story:** Update code generation agents for no-barrel pattern

**Assigned:** agent-author

**Files:**

- `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/generic/backend-dev.md`
- `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/generic/coder.md`
- `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/domain/frontend/react-app-agent.md`

**Key Changes:**

- Add "No-Barrel Import Standards" section to each agent
- Include internal import pattern: `import { User } from "#/users/types.js"`
- Include external import pattern: `import { User } from "@metasaver/contracts/users/types"`
- Add "Prohibited Patterns" listing: `export *`, default exports, relative `../` imports, barrel files
- Update skill references for domain skills (updated in US-006)

**Acceptance Criteria:**

- Agents generate internal imports using `#/` prefix
- Agents generate external imports using direct export paths
- Agents never generate `export *` statements or barrel index.ts files
- All agents follow file naming conventions

**Blocks:** US-001 (commands route to these agents)

---

### US-003: Update Configuration Agents

**Story:** Update configuration agents for package.json and tsconfig

**Assigned:** agent-author

**Files:**

- `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/config/workspace/typescript-agent.md`
- `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/config/workspace/root-package-json-agent.md`

**Key Changes:**

**typescript-agent.md:**

- Add "Path Alias Configuration" section after introduction
- Include required compilerOptions: `baseUrl: "."`, `paths: { "#/*": ["./src/*"] }`
- Add validation logic for `#/` alias presence
- Include example tsconfig.json snippet with paths configuration

**root-package-json-agent.md:**

- Add "No-Barrel Package Configuration" section after introduction
- Include required fields: `imports: { "#/*": "./src/*.js" }`, `exports: { "./feature/types": {...} }`
- Add validation for imports/exports field structure
- Include validation that exports have both `.d.ts` and `.js` entries
- Document export path naming patterns

**Acceptance Criteria:**

- typescript-agent adds `paths` configuration for `#/` alias
- typescript-agent includes `baseUrl: "."` in compilerOptions
- root-package-json-agent adds `imports` field with `#/*` mapping
- root-package-json-agent generates `exports` field with per-module entries
- Exports validate for both `.d.ts` and `.js` files

**Blocks:** US-001 (commands reference config skills which use these agents)

---

### US-004: Update Configuration Skills

**Story:** Update configuration skills with no-barrel validation

**Assigned:** agent-author

**Files:**

- `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/config/workspace/root-package-json-config/SKILL.md`
- `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/config/build-tools/vitest-config/SKILL.md`
- `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/config/workspace/typescript-configuration/SKILL.md`

**Key Changes:**

**root-package-json-config/SKILL.md:**

- Add Rule 6 to standards table: "No-Barrel Architecture"
- Add validation for `imports["#/*"]` equals `"./src/*.js"`
- Add validation for `exports` object with per-module entries
- Add validation that each export has `types` and `import` fields
- Add examples section showing correct structure

**vitest-config/SKILL.md:**

- Add "Path Alias Resolution" section
- Include `resolve.alias` configuration: `{ "#": resolve(__dirname, "./src") }`
- Add validation check for `#` alias
- Add complete example with alias

**typescript-configuration/SKILL.md:**

- Update "Validation" section to include paths checking
- Add validation: `baseUrl` must exist when using `paths`
- Add validation: `paths["#/*"]` must point to `["./src/*"]`
- Add common violation and remediation guidance
- Include example snippet

**Acceptance Criteria:**

- Skills validate presence of required configuration fields
- Skills provide clear violation messages and remediation guidance
- Skills include examples demonstrating correct patterns
- Skills can be referenced by audit commands

**Blocks:** US-001 (commands directly reference these skills)

---

### US-005: Update Templates

**Story:** Update templates to include no-barrel patterns

**Assigned:** agent-author

**Files:**

- `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/templates/common/tsconfig-*.template.json` (all tsconfig templates)
- Domain-specific templates with import/export examples
- Package templates with package.json examples

**Key Changes:**

**All tsconfig templates:**

- Add to compilerOptions: `"baseUrl": "."`, `"paths": { "#/*": ["./src/*"] }`
- Files: `tsconfig-base.template.json`, `tsconfig-vite-app.template.json`, `tsconfig-vite-node.template.json`, `tsconfig-vite-root.template.json`

**Domain templates with code examples:**

- Identify templates containing `import` or `export` keywords
- Remove barrel file examples (index.ts with re-exports)
- Replace relative `../` imports with `#/` pattern examples
- Replace `export *` with named export examples
- Replace `export default` with named export examples
- Add import order comments

**Package templates:**

- Add `imports` field: `{ "#/*": "./src/*.js" }`
- Add `exports` field with proper structure
- Update any existing package.json templates

**Acceptance Criteria:**

- All tsconfig templates include paths configuration
- Domain templates show correct import/export patterns
- No templates contain barrel files or prohibited patterns
- Package templates include imports/exports fields

**Blocks:** None (templates are used by skills/agents but not a hard dependency)

---

### US-006: Update Domain Skills

**Story:** Update domain skills with no-barrel import examples

**Assigned:** agent-author

**Files:**

- `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/domain/react-app-structure/SKILL.md`
- `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/domain/react-app-structure/TEMPLATES.md`
- `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/domain/contracts-package/SKILL.md`
- `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/domain/prisma-database/SKILL.md`
- `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/domain/data-service/SKILL.md`
- Additional domain skills with code examples (to be identified)

**Key Changes:**

**react-app-structure/SKILL.md:**

- Update "File Organization" to remove barrel exports
- Replace barrel file references with direct imports
- Add import pattern section with `#/` examples
- Update component imports: `import { Button } from "#/components/Button.tsx"`
- Update hook imports: `import { useAuth } from "#/hooks/useAuth.ts"`

**react-app-structure/TEMPLATES.md:**

- Update all code examples to use `#/` imports
- Remove default exports, use named exports
- Update component examples with import order
- Add file extensions to import paths

**contracts-package/SKILL.md:**

- Update export examples for direct path exports
- Remove barrel file references
- Show correct exports: `./users/types`, `./positions/hierarchy`
- Update consumer import examples

**prisma-database/SKILL.md:**

- Update Prisma client import examples
- Show `#/` pattern for internal utilities
- Update service layer examples

**data-service/SKILL.md:**

- Update TypeScript examples with `#/` imports
- Remove barrel patterns
- Add import order comments

**Additional domain skills:**

- Search for skills containing `import` or `export` keywords
- Update systematically with `#/` pattern
- Focus on TEMPLATES.md files

**Acceptance Criteria:**

- All domain skills use `#/` for internal imports
- All domain skills use direct export paths for external packages
- No `export *` or barrel files in examples
- Correct file naming demonstrated
- Named exports only (no default exports)
- Standard import order shown

**Blocks:** None (skills are referenced by agents but can be updated in parallel)

---

## Wave 2: Integration (Sequential Execution)

Wave 2 depends on completion of Wave 1. Commands must reference updated agents and skills.

### US-001: Update Commands

**Story:** Update commands to support no-barrel architecture

**Assigned:** agent-author

**Files:**

- `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/commands/build.md`
- `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/commands/audit.md`
- `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/commands/ms.md`

**Key Changes:**

**build.md:**

- Add "No-Barrel Architecture Standards" section after Phase 4 (Design)
- Include import pattern requirements (`#/` internal, direct paths external)
- Add package.json structure requirements (imports/exports fields)
- Add tsconfig.json requirements (paths for `#/` alias)
- Reference skills: `/skill root-package-json-config`, `/skill typescript-configuration`

**audit.md:**

- Add "No-Barrel Architecture Violations" section after Phase 5 (Audit Execution)
- Define CRITICAL violations:
  - Barrel files (index.ts with re-exports)
  - `export *` statements
  - Relative `../` imports
  - Missing `imports` field in package.json
  - Missing `exports` field in package.json
- Add detection patterns and remediation guidance

**ms.md:**

- Update Phase 2 (BA Clarification) agent routing logic
- Add no-barrel pattern awareness to agent selection
- Ensure routed agents follow no-barrel standards
- Update validation criteria in Phase 5

**Acceptance Criteria:**

- `/build` generates code with `#/` imports and direct export paths
- `/build` generates package.json with imports/exports fields
- `/build` generates tsconfig.json with paths configuration
- `/audit` detects all barrel violations as CRITICAL
- `/audit` detects missing configuration as CRITICAL
- `/ms` routes to updated agents

**Depends on:**

- US-002 (agents must be updated before commands route to them)
- US-004 (skills must be updated before commands reference them)

**Blocks:** None (terminal node in workflow)

---

## Spawn Instructions for Main Conversation

After reviewing this plan, execute Wave 1 with the following Task() calls:

```typescript
// Wave 1 - Execute all in parallel (5 agents)
Task({
  agent: "core-claude-plugin:generic:agent-author",
  task: "Update code generation agents for no-barrel pattern. See /home/jnightin/code/metasaver-marketplace/docs/projects/20251216-no-barrel-architecture/user-stories/US-002-update-code-gen-agents.md for complete requirements.",
});

Task({
  agent: "core-claude-plugin:generic:agent-author",
  task: "Update configuration agents for package.json and tsconfig. See /home/jnightin/code/metasaver-marketplace/docs/projects/20251216-no-barrel-architecture/user-stories/US-003-update-config-agents.md for complete requirements.",
});

Task({
  agent: "core-claude-plugin:generic:agent-author",
  task: "Update configuration skills with no-barrel validation. See /home/jnightin/code/metasaver-marketplace/docs/projects/20251216-no-barrel-architecture/user-stories/US-004-update-config-skills.md for complete requirements.",
});

Task({
  agent: "core-claude-plugin:generic:agent-author",
  task: "Update templates to include no-barrel patterns. See /home/jnightin/code/metasaver-marketplace/docs/projects/20251216-no-barrel-architecture/user-stories/US-005-update-templates.md for complete requirements.",
});

Task({
  agent: "core-claude-plugin:generic:agent-author",
  task: "Update domain skills with no-barrel import examples. See /home/jnightin/code/metasaver-marketplace/docs/projects/20251216-no-barrel-architecture/user-stories/US-006-update-domain-skills.md for complete requirements.",
});

// After Wave 1 completes, execute Wave 2
Task({
  agent: "core-claude-plugin:generic:agent-author",
  task: "Update commands to support no-barrel architecture. See /home/jnightin/code/metasaver-marketplace/docs/projects/20251216-no-barrel-architecture/user-stories/US-001-update-commands.md for complete requirements. WAIT for Wave 1 completion before starting.",
});
```

## Post-Execution Consolidation

After all agents complete, spawn project-manager again with:

```
Consolidate results from no-barrel architecture implementation.
Include:
- All agent execution results
- Story completion status
- Files modified count
- Verification outcomes
- Next steps for validation
```

## Success Criteria

**Wave 1 Complete:**

- 5 stories marked as complete
- All agents, skills, and templates updated with no-barrel patterns
- No violations detected in updated files

**Wave 2 Complete:**

- Commands reference updated agents and skills
- Build command generates no-barrel code
- Audit command detects barrel violations

**Project Complete:**

- All 6 user stories verified
- No barrel files in examples or templates
- All imports follow `#/` pattern
- All exports use direct paths
- Configuration files include required fields

## Risk Mitigation

**Risk:** Wave 1 agent makes incompatible changes
**Mitigation:** Each story has clear acceptance criteria and file lists; agent-author follows specifications exactly

**Risk:** Dependencies between Wave 1 stories discovered during execution
**Mitigation:** Stories were analyzed for dependencies; if discovered, pause and re-sequence

**Risk:** Commands in Wave 2 reference patterns not yet updated
**Mitigation:** Wave 2 explicitly waits for Wave 1 completion; dependencies documented

## Notes

- This is a **hard-cut** implementation with no backward compatibility
- All violations are CRITICAL severity (no warnings)
- Focus on exhaustive examples in skills and templates
- Story files will be updated as work progresses
- Final verification should test both `/build` and `/audit` commands
