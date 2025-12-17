# US-004: Update requirements-phase Skill

**Status:** 🔵 Pending
**Priority:** Critical
**Estimated Effort:** Medium
**File:** `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/workflow-steps/requirements-phase/SKILL.md`

---

## Story

As a requirements phase skill, I need to create user stories (one per agent/file combo) after PRD creation so that each audit task has a trackable story with agent, file, template, and acceptance criteria.

---

## Acceptance Criteria

### Add User Story Creation Step

- [ ] Add Step 5 in Workflow Steps section: "Extract user stories from PRD"
- [ ] Document story creation logic:
  - One story per (agent, file) pair
  - Story includes: agent name, file path, template/skill reference, acceptance criteria
  - Stories saved to `{projectFolder}/user-stories/` directory
  - Filename format: `US-{number}-{slug}.md`
  - Status field set to 🔵 Pending
  - Dependencies identified (if US-2 needs data from US-1)

### Reference User Story Template

- [ ] Add section: "User Story Template for Audits"
- [ ] Reference `/skill user-story-template` for standard format
- [ ] Document required sections:
  - Title: "Audit {file} in {repo}"
  - Agent: {agent-name}
  - Scope: {repo}/{path/to/file}
  - Template: {skill-name}
  - Acceptance Criteria (5 standard items)
  - User Decision section (for HITL resolution)

### Update Output Format

- [ ] Add to Output Format section:
  - `storiesFolder: string` - Path to user-stories directory
  - `storyFiles: string[]` - Array of created story file paths
  - `dependencies: object` - Map of story dependencies (e.g., {"US-002": ["US-001"]})
- [ ] Keep existing fields: status, projectFolder, prdPath, prdContent, clarificationsProvided

### Update Workflow Steps Section

- [ ] Insert new Step 5 after "BA completes PRD"
- [ ] Update Step 4 to note "Continue to story extraction"
- [ ] Document story directory creation: `{projectFolder}/user-stories/`

### Update Audit Mode Section

- [ ] Add note: "For audits, BA creates stories after PRD (1 per agent/file combo)"
- [ ] Document story creation happens BEFORE exiting requirements phase
- [ ] Note: Stories used for Investigation phase planning

---

## Dependencies

- **Depends on:** None (independent enhancement)
- **Blocks:** US-001 (audit.md references story creation in Requirements phase)

---

## Technical Notes

### User Story Template Structure

```markdown
# Story: Audit {file} in {repo}

**Agent:** {agent-name}
**Scope:** {repo}/{path/to/file}
**Template:** {skill-name}

### Acceptance Criteria

- [ ] Agent reads template from skill
- [ ] Agent reads actual file
- [ ] Agent compares and identifies discrepancies
- [ ] Discrepancies reported with line numbers
- [ ] User decision recorded (apply/update/ignore/custom)

### User Decision

- [ ] Pending investigation
```

### Story Creation Examples

**Example 1: Single File Audit**

- Prompt: "audit eslint"
- Scope: repos=[CWD], files=[eslint.config.js]
- Agents: [eslint-agent]
- Stories: 1 story (US-001-audit-eslint-config.md)

**Example 2: Multi-File Audit**

- Prompt: "audit code quality"
- Scope: repos=[CWD], files=[eslint.config.js, .prettierrc, .editorconfig]
- Agents: [eslint-agent, prettier-agent, editorconfig-agent]
- Stories: 3 stories (one per agent/file combo)

**Example 3: Cross-Repo Audit**

- Prompt: "audit eslint across consumer repos"
- Scope: repos=[rugby-crm, resume-builder], files=[eslint.config.js, eslint.config.js]
- Agents: [eslint-agent]
- Stories: 2 stories (one per repo/file combo)

### Output Format Example

```json
{
  "status": "complete",
  "projectFolder": "docs/projects/20251217-eslint-audit",
  "prdPath": "docs/projects/20251217-eslint-audit/prd.md",
  "prdContent": "# PRD...",
  "clarificationsProvided": 0,
  "storiesFolder": "docs/projects/20251217-eslint-audit/user-stories/",
  "storyFiles": ["US-001-audit-eslint-config.md"],
  "dependencies": {}
}
```

---

## Definition of Done

- [ ] Step 5 added with story extraction logic
- [ ] User story template section added
- [ ] Output format updated with stories fields
- [ ] Workflow steps section updated
- [ ] Audit mode section updated
- [ ] 3+ examples documented
- [ ] Dependencies structure documented
- [ ] File validates as proper markdown
