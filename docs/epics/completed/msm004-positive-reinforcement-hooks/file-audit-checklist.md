# File Audit Checklist - Positive Framing Refactoring

## Summary

Based on grep analysis for negative language patterns (NEVER, DON'T, DO NOT, AVOID, MUST NOT):

- **Total files to review:** 140 files
- **High priority:** 56 files (commands, core agents, workflow skills)
- **Medium priority:** 61 files (domain skills, config skills, config agents)
- **Low priority:** 23 files (templates, docs, reference materials)

## High Priority - Wave 5 (Commands: 8 files)

Critical user-facing slash commands that guide workflows:

- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/commands/architect.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/commands/audit.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/commands/build.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/commands/debug.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/commands/ms.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/commands/msold.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/commands/qq.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/commands/ss.md`

## High Priority - Wave 6 (Core Generic Agents: 20 files)

Foundation agents used across all workflows:

### Authoring & Validation (5 files)

- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/generic/agent-author.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/generic/agent-check-agent.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/generic/command-author.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/generic/skill-author.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/generic/code-quality-validator.md`

### Core Development (6 files)

- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/generic/architect.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/generic/backend-dev.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/generic/coder.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/generic/reviewer.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/generic/tester.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/generic/code-explorer.md`

### Business & Analysis (2 files)

- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/generic/business-analyst.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/generic/project-manager.md`

### Specialized Engineers (4 files)

- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/generic/performance-engineer.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/generic/security-engineer.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/generic/innovation-advisor.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/generic/root-cause-analyst.md`

### Utility Agents (3 files)

- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/generic/complexity-check-agent.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/generic/scope-check-agent.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/generic/tool-check-agent.md`

## High Priority - Wave 7 (Workflow Skills: 23 files)

Skills that orchestrate multi-step workflows:

### Core Workflow Phases (10 files)

- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/workflow-steps/analysis-phase/SKILL.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/workflow-steps/architect-phase/SKILL.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/workflow-steps/design-phase/SKILL.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/workflow-steps/execution-phase/SKILL.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/workflow-steps/innovate-phase/SKILL.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/workflow-steps/planning-phase/SKILL.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/workflow-steps/report-phase/SKILL.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/workflow-steps/requirements-phase/SKILL.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/workflow-steps/validation-phase/SKILL.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/workflow-steps/user-story-template/SKILL.md`

### Debug Workflow (2 files)

- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/workflow-steps/debug-execution/SKILL.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/workflow-steps/debug-plan/SKILL.md`

### Audit Workflow (3 files)

- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/workflow-steps/audit-investigation/SKILL.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/workflow-steps/audit-remediation/SKILL.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/workflow-steps/audit-resolution/SKILL.md`

### Approval & Verification (4 files)

- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/workflow-steps/ac-verification/SKILL.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/workflow-steps/hitl-approval/SKILL.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/workflow-steps/prd-approval/SKILL.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/workflow-steps/production-check/SKILL.md`

### Specialized Workflow Steps (4 files)

- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/workflow-steps/save-prd/SKILL.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/workflow-steps/tdd-execution/SKILL.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/workflow-steps/template-update/SKILL.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/workflow-steps/vibe-check/SKILL.md`

## High Priority - Wave 8 (Cross-Cutting Skills: 11 files)

Shared utilities invoked by multiple agents:

- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/cross-cutting/agent-check/SKILL.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/cross-cutting/agent-selection/SKILL.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/cross-cutting/chrome-devtools-testing/SKILL.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/cross-cutting/coding-standards/SKILL.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/cross-cutting/complexity-check/SKILL.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/cross-cutting/dry-check/SKILL.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/cross-cutting/repomix-cache-refresh/SKILL.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/cross-cutting/scope-check/SKILL.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/cross-cutting/serena-code-reading/SKILL.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/cross-cutting/structure-check/SKILL.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/cross-cutting/tool-check/SKILL.md`

## Medium Priority - Wave 9 (Domain Skills: 7 files)

Domain-specific architectural patterns:

- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/domain/audit-workflow/SKILL.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/domain/contracts-package/SKILL.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/domain/data-service/SKILL.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/domain/monorepo-audit/SKILL.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/domain/prisma-database/SKILL.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/domain/react-app-structure/SKILL.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/domain/remediation-options/SKILL.md`

## Medium Priority - Wave 10 (Config Agents: 28 files)

Configuration file specialists:

### Build Tools (8 files)

- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/config/build-tools/docker-compose-agent.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/config/build-tools/dockerignore-agent.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/config/build-tools/pnpm-workspace-agent.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/config/build-tools/postcss-agent.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/config/build-tools/tailwind-agent.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/config/build-tools/turbo-config-agent.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/config/build-tools/vite-agent.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/config/build-tools/vitest-agent.md`

### Code Quality (3 files)

- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/config/code-quality/editorconfig-agent.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/config/code-quality/eslint-agent.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/config/code-quality/prettier-agent.md`

### Version Control (5 files)

- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/config/version-control/commitlint-agent.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/config/version-control/gitattributes-agent.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/config/version-control/github-workflow-agent.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/config/version-control/gitignore-agent.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/config/version-control/husky-agent.md`

### Workspace (12 files)

- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/config/workspace/claude-md-agent.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/config/workspace/env-example-agent.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/config/workspace/monorepo-root-structure-agent.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/config/workspace/nodemon-agent.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/config/workspace/npmrc-template-agent.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/config/workspace/nvmrc-agent.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/config/workspace/readme-agent.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/config/workspace/repomix-config-agent.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/config/workspace/root-package-json-agent.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/config/workspace/scripts-agent.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/config/workspace/typescript-agent.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/config/workspace/vscode-agent.md`

## Medium Priority - Wave 11 (Config Skills: 23 files)

Configuration skill libraries supporting config agents:

### Build Tools (6 files)

- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/config/build-tools/docker-compose-config/SKILL.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/config/build-tools/pnpm-workspace-config/SKILL.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/config/build-tools/postcss-config/SKILL.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/config/build-tools/turbo-config/SKILL.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/config/build-tools/vite-config/SKILL.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/config/build-tools/vitest-config/SKILL.md`

### Code Quality (3 files)

- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/config/code-quality/editorconfig-config/SKILL.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/config/code-quality/eslint-config/SKILL.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/config/code-quality/prettier-config/SKILL.md`

### Version Control (4 files)

- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/config/version-control/commitlint-config/SKILL.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/config/version-control/gitattributes-config/SKILL.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/config/version-control/gitignore-config/SKILL.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/config/version-control/husky-hooks-config/SKILL.md`

### Workspace (10 files)

- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/config/workspace/dockerignore-config/SKILL.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/config/workspace/nodemon-config/SKILL.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/config/workspace/npmrc-config/SKILL.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/config/workspace/readme-config/SKILL.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/config/workspace/repomix-config/SKILL.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/config/workspace/root-package-json-config/SKILL.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/config/workspace/scripts-config/SKILL.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/config/workspace/tailwind-config/SKILL.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/config/workspace/typescript-configuration/SKILL.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/config/workspace/vscode-config/SKILL.md`

## Low Priority - Defer (Templates & Reference: 23 files)

Template files and reference documentation (may contain intentional negative patterns for examples):

### Templates

- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/domain/react-app-structure/templates/feature-component.tsx.template`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/cross-cutting/coding-standards/templates/dry-kiss-yagni.ts.template`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/config/workspace/npmrc-config/templates/.npmrc.template`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/config/version-control/husky-hooks-config/templates/pre-commit.template.sh`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/config/version-control/commitlint-config/templates/commitlint.config.template.js`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/config/version-control/commitlint-config/templates/.copilot-commit-message-instructions.template.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/templates/config/copilot-commit-instructions.template.md`

### Reference Documentation

- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/cross-cutting/coding-standards/reference.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/domain/contracts-package/TEMPLATES.md`
- [ ] `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/scripts/README.md`

## Execution Strategy

### Parallelization Approach

**Wave 5-6 (High Priority Foundation):** Can be parallelized into 3 groups

- Group A: Commands (8 files) - Single batch
- Group B: Authoring/Validation agents (5 files) - Single batch
- Group C: Development agents (6 files) + Business (2 files) + Specialized (4 files) + Utility (3 files) - Can split into 2-3 batches

**Wave 7-8 (High Priority Workflows):** Can be parallelized into 4 groups

- Group A: Core workflow phases (10 files) - 2 batches of 5
- Group B: Debug + Audit workflows (5 files) - Single batch
- Group C: Approval workflows (4 files) - Single batch
- Group D: Cross-cutting skills (11 files) - 2 batches of 5-6

**Wave 9-11 (Medium Priority):** Can be parallelized into 3 groups

- Group A: Domain skills (7 files) - Single batch
- Group B: Config agents (28 files) - 3-4 batches of 7
- Group C: Config skills (23 files) - 3 batches of 7-8

### Recommended Batch Sizes

- **Optimal batch size:** 5-8 files per parallel task
- **Maximum batch size:** 10 files per task
- **Rationale:** Balance context window usage with parallelization efficiency

## Progress Tracking

Total checkboxes: 140

- [ ] Wave 5 complete (8 files)
- [ ] Wave 6 complete (20 files)
- [ ] Wave 7 complete (23 files)
- [ ] Wave 8 complete (11 files)
- [ ] Wave 9 complete (7 files)
- [ ] Wave 10 complete (28 files)
- [ ] Wave 11 complete (23 files)
- [ ] Low priority review complete (20 files)

## Notes

- Files with negative patterns identified via grep for: NEVER, DON'T, DO NOT, AVOID, MUST NOT (case-insensitive)
- Some files may contain intentional negative patterns in examples or templates
- Review each file in context to determine if negative language should be reframed
- Follow positive reinforcement patterns from waves 1-4 for consistency
