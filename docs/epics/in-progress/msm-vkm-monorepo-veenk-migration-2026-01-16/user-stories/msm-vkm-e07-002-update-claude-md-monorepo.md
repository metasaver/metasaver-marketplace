---
story_id: "MSM-VKM-E07-002"
epic_id: "MSM-VKM-E07"
title: "Update CLAUDE.md with monorepo guidance"
status: "pending"
complexity: 3
wave: 6
agent: "core-claude-plugin:config:workspace:claude-md-configuration-agent"
dependencies: ["MSM-VKM-E03-006", "MSM-VKM-E04-003", "MSM-VKM-E05-007"]
created: "2026-01-16"
updated: "2026-01-16"
---

# MSM-VKM-E07-002: Update CLAUDE.md with monorepo guidance

## User Story

**As a** Claude Code AI working in the metasaver-marketplace repository
**I want** CLAUDE.md to provide clear guidance on working with the hybrid monorepo structure
**So that** I follow correct patterns when working with both marketplace plugins and workflow packages

---

## Acceptance Criteria

- [ ] CLAUDE.md updated to explain hybrid repository structure
- [ ] Guidance added for working with monorepo packages
- [ ] Workspace command patterns documented
- [ ] Turborepo usage patterns documented
- [ ] Plugin development rules maintained (no changes to plugins/)
- [ ] Workflow development rules added (packages/ allowed)
- [ ] Directory-specific rules clearly separated
- [ ] Command selection table updated if needed
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
| `CLAUDE.md` | Update with monorepo guidance for Claude AI |

---

## Implementation Notes

### Key Sections to Update

**1. Repository Overview**
Update description:

```markdown
**MetaSaver Official Marketplace + Veenk Workflows** - A Claude Code marketplace with a hybrid structure:

- Primary: Marketplace plugin registry (@metasaver/core-claude-plugin)
- Secondary: LangGraph workflow implementations (@metasaver/veenk-workflows)
```

**2. Repository Structure**
Add packages/ directory to structure:

```markdown
metasaver-marketplace/
├── plugins/metasaver-core/ # Marketplace plugin (PROTECTED)
├── packages/ # Monorepo packages (ALLOWED)
│ └── veenk-workflows/ # LangGraph workflows
├── docs/epics/ # Project documentation
└── scripts/ # Utility scripts
```

**3. Always-On Behavior**
Add monorepo-specific rules:

```markdown
## Monorepo Workspace Commands

When working with packages:

- Use pnpm workspace commands: `pnpm --filter <package> <command>`
- Use Turborepo for builds: `pnpm build` (uses turbo.json)
- Test specific package: `pnpm --filter @metasaver/veenk-workflows test`

## Directory-Specific Rules

| Directory               | Changes Allowed | Notes                         |
| ----------------------- | --------------- | ----------------------------- |
| plugins/metasaver-core/ | NO              | Use author agents only        |
| packages/\*             | YES             | Standard code changes allowed |
| docs/epics/             | YES             | Documentation allowed         |
| scripts/                | YES             | Utility scripts allowed       |
```

**4. Development Patterns**
Add workflow development section:

```markdown
## Workflow Development

When working with veenk-workflows package:

1. Use standard coder/tester agents (not author agents)
2. Follow workspace commands for testing/building
3. Update imports when adding new workflow modules
4. Run `pnpm test` to verify all workflows
```

**5. Command Selection**
Update if workflows introduce new command patterns:

```markdown
| Task Type                  | Command      |
| -------------------------- | ------------ |
| Marketplace plugin changes | `/ms`        |
| Workflow code changes      | `/ms`        |
| Build/test all packages    | `pnpm build` |
```

---

## Architecture

(Added by architect-agent - technical annotations pending)

**Key Files:**

- `CLAUDE.md` - Claude Code configuration and guidance

**Configuration Strategy:**

- Clear separation of rules for plugins/ vs packages/
- Explicit permission model for each directory
- Workspace command examples
- Reference to author agent requirements

---

## Definition of Done

- [ ] Implementation complete
- [ ] CLAUDE.md structure validated
- [ ] All examples tested and accurate
- [ ] Directory rules unambiguous
- [ ] Acceptance criteria verified
- [ ] Reviewed for clarity and completeness

---

## Notes

- This is Claude-specific guidance (not general developer docs)
- Focus on AI-specific workflow patterns
- Maintain strict plugin protection rules
- Add clear permissions for workflow development
- Keep file concise and scannable (Claude reads this frequently)
