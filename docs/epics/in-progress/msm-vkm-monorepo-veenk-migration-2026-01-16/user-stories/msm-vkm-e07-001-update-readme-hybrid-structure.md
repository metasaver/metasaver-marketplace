---
story_id: "MSM-VKM-E07-001"
epic_id: "MSM-VKM-E07"
title: "Update README.md for hybrid structure"
status: "pending"
complexity: 3
wave: 6
agent: "core-claude-plugin:config:workspace:readme-agent"
dependencies: ["MSM-VKM-E03-006", "MSM-VKM-E04-003", "MSM-VKM-E05-008"]
created: "2026-01-16"
updated: "2026-01-16"
---

# MSM-VKM-E07-001: Update README.md for hybrid structure

## User Story

**As a** new developer onboarding to the metasaver-marketplace repository
**I want** README.md to document the hybrid monorepo structure clearly
**So that** I understand the repository organization and where to find code, documentation, and workflows

---

## Acceptance Criteria

- [ ] README.md updated to explain hybrid structure (marketplace + workflows)
- [ ] Repository structure section shows both plugins/ and packages/ directories
- [ ] Documentation explains purpose of each top-level directory
- [ ] Quick start section updated for monorepo workflow
- [ ] Installation instructions updated (pnpm workspace commands)
- [ ] Build/test instructions updated (Turborepo commands)
- [ ] Links to veenk workflows documentation added
- [ ] Links to plugin development documentation maintained
- [ ] Follows established template/pattern
- [ ] Format validated

---

## Technical Details

### Location

- **Repo:** metasaver-marketplace
- **Package:** root level

### Files to Modify

| File        | Purpose                                     |
| ----------- | ------------------------------------------- |
| `README.md` | Update to reflect hybrid monorepo structure |

---

## Implementation Notes

### Key Sections to Update

**1. Overview**

- Explain hybrid nature: marketplace + workflows
- Clarify that plugins remain primary focus
- Introduce workflows package as secondary capability

**2. Repository Structure**
Update structure diagram:

```
metasaver-marketplace/
├── .claude-plugin/          # Marketplace manifest
├── plugins/
│   └── metasaver-core/      # Official marketplace plugin
├── packages/                # NEW: Monorepo packages
│   └── veenk-workflows/     # LangGraph workflow implementations
├── docs/
│   └── epics/               # Project documentation and veenk epics
├── scripts/                 # Utility scripts
├── pnpm-workspace.yaml      # NEW: Workspace configuration
├── turbo.json               # NEW: Turborepo configuration
└── README.md
```

**3. Getting Started**
Update with monorepo commands:

```bash
# Install dependencies (monorepo-aware)
pnpm install

# Build all packages
pnpm build

# Test all packages
pnpm test

# Work with specific package
pnpm --filter @metasaver/veenk-workflows test
```

**4. Development Workflow**

- Add section on workspace commands
- Add section on Turborepo caching
- Keep existing plugin development instructions
- Add workflow development instructions

**5. Documentation Links**

- Link to veenk workflow documentation in docs/epics/
- Link to plugin development guide (maintain existing)
- Link to monorepo architecture docs (if created)

---

## Architecture

(Added by architect-agent - technical annotations pending)

**Key Files:**

- `README.md` - Main repository documentation

**Documentation Strategy:**

- Focus on hybrid structure clarity
- Separate plugin development from workflow development
- Provide clear entry points for both use cases
- Maintain marketplace focus as primary purpose

---

## Definition of Done

- [ ] Implementation complete
- [ ] README.md renders correctly on GitHub
- [ ] All links tested and working
- [ ] Structure diagram accurate
- [ ] Commands verified to work
- [ ] Acceptance criteria verified
- [ ] Reviewed by stakeholder for clarity

---

## Notes

- This README focuses on repository-level documentation
- Package-specific READMEs remain in their respective directories
- Keep marketplace focus prominent (workflows are secondary)
- Use clear headings to separate marketplace and workflow content
