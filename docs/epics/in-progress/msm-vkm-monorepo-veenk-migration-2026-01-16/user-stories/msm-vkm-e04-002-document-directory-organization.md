---
story_id: "MSM-VKM-E04-002"
epic_id: "MSM-VKM-E04"
title: "Document directory organization"
status: "pending"
complexity: 2
wave: 3
agent: "core-claude-plugin:generic:coder"
dependencies: ["MSM-VKM-E04-001"]
created: "2026-01-16"
updated: "2026-01-16"
---

# MSM-VKM-E04-002: Document directory organization

## User Story

**As a** developer onboarding to the monorepo
**I want** clear documentation of the directory structure and organization
**So that** I understand where different types of code should live

---

## Acceptance Criteria

- [ ] README.md in packages/ explains purpose and conventions
- [ ] README.md in apps/ explains purpose and conventions
- [ ] README.md in services/ explains purpose and conventions
- [ ] Each README includes examples of what belongs in directory
- [ ] Each README explains naming conventions
- [ ] Documentation references relationship between directories
- [ ] Root README.md updated to reference new structure (handled in E07)
- [ ] Follows established template/pattern
- [ ] Format validated

---

## Technical Details

### Location

- **Repo:** metasaver-marketplace
- **Package:** root level

### Files to Create

None - these files already created in MSM-VKM-E01-004.

### Files to Modify

| File                 | Changes                                 |
| -------------------- | --------------------------------------- |
| `packages/README.md` | Document purpose, conventions, examples |
| `apps/README.md`     | Document purpose, conventions, examples |
| `services/README.md` | Document purpose, conventions, examples |

---

## Implementation Notes

Enhance README.md files with comprehensive documentation:

### packages/README.md Content

```markdown
# Packages

This directory contains shared code packages and libraries used across the monorepo.

## Purpose

Packages are reusable TypeScript/JavaScript libraries that can be imported by apps, services, or other packages.

## Current Packages

- `@metasaver/veenk-workflows` - LangGraph workflow implementations

## Naming Convention

- Use `@metasaver/` namespace
- Use kebab-case for package names
- Example: `@metasaver/shared-utils`

## Creating a New Package

1. Create directory: `packages/my-package/`
2. Add package.json with `@metasaver/my-package` name
3. Add tsconfig.json, README.md
4. Register in pnpm-workspace.yaml (already configured)
```

### apps/README.md Content

```markdown
# Apps

This directory contains standalone applications with entry points.

## Purpose

Apps are executable applications (web apps, CLIs, desktop apps) that can be run independently.

## Future Use

- Web UI for workflow management
- CLI tools for developer workflows
- Chat application for AI interactions

## Naming Convention

- Use descriptive names for apps
- Example: `workflow-ui`, `metasaver-cli`
```

### services/README.md Content

```markdown
# Services

This directory contains backend services and APIs.

## Purpose

Services are backend applications that provide APIs or handle long-running processes.

## Future Use

- MCP (Model Context Protocol) servers
- API gateways
- Background job processors

## Naming Convention

- Use descriptive service names
- Example: `mcp-server`, `workflow-api`
```

### Dependencies

Depends on MSM-VKM-E04-001 (directory structure must be verified).

---

## Architecture

(Added by architect-agent - technical annotations pending)

**Key Files:**

- `packages/README.md` - Package documentation
- `apps/README.md` - Apps documentation
- `services/README.md` - Services documentation

---

## Definition of Done

- [ ] Implementation complete
- [ ] Unit tests passing
- [ ] TypeScript compiles
- [ ] Lint passes
- [ ] Acceptance criteria verified
- [ ] All README.md files comprehensive
- [ ] Documentation clear and helpful

---

## Notes

- Documentation helps developers understand monorepo organization
- Sets conventions for future additions
- Does not affect existing plugin structure at plugins/metasaver-core/
