---
name: requirements-phase
description: PRD creation with HITL clarification loop. BA drafts PRD, asks user questions until requirements are clear. NO approval here—approval happens after design phase when user can see full plan.
---

# Requirements Phase - PRD Creation (HITL)

> **ROOT AGENT ONLY** - Called by commands only, never by subagents.

**Purpose:** Create PRD with human-in-the-loop clarification (Q&A only, no approval)
**Trigger:** After analysis-phase completes
**Input:** prompt, complexity, tools, scope (from analysis-phase)
**Output:** Completed PRD content (not yet written to file)

---

## Important: No Approval Here

This phase is for **clarification only**, not approval. The user can ask questions, provide context, and clarify requirements interactively. Formal approval happens later in **plan-approval** phase after:

- PRD is written
- Stories are extracted
- Architect has annotated stories
- PM has created execution plan

This way the user sees the full picture before approving.

---

## Workflow Steps

1. **Create project folder:**
   - Format: `docs/projects/{yyyymmdd}-{descriptive-name}/`
   - Example: `docs/projects/20251208-applications-feature/`
   - BA creates this folder before drafting PRD

2. **Spawn BA agent (draft mode):**
   - Analyze prompt and context
   - **For audits:** Investigate codebase first using Serena tools (read package.json, config files, directory structure), discover scope, classify repo type from `metasaver.projectType` in package.json
   - Draft initial PRD based on discoveries
   - Identify questions/uncertainties

3. **HITL Clarification Loop:**

   ```
   WHILE BA has questions:
     → Ask user via AskUserQuestion
     → User provides answers
     → BA incorporates answers, may have follow-up questions
   ```

   **For audits:** Only enter this loop if scope is genuinely ambiguous after codebase investigation. Skip if scope is clear from file discovery.

4. **BA completes PRD:**
   - All questions resolved
   - Save to `{projectFolder}/prd.md`
   - Return completed PRD content and project folder path

5. **For audit mode: Create user stories:**
   - **Create folder:** `{projectFolder}/user-stories/`
   - **Generate story for each (agent, file) pair:**
     - For each file in scope.files:
       - Determine agent from agent-check results
       - Create user-story file: `US-{NNN}-audit-{file-slug}.md`
       - Use audit-focused template (see below)
   - **Story numbering:** Sequential (US-001, US-002, etc.)

6. **Continue to next phase** (no approval stop here)

---

## BA Agent Modes

| Mode  | Input                     | Output                |
| ----- | ------------------------- | --------------------- |
| draft | prompt, complexity, scope | PRD draft + questions |

---

## Audit Mode

For audit workflows, BA MUST prioritize codebase investigation before asking clarification questions:

- **Investigation First:** Use Serena tools to read package.json, config files (eslint, prettier, vite, etc.), and directory structure
- **Discover Scope:** Identify project type, dependencies, build tools, and configuration state
- **Classify Repos:** Determine if repo is consumer or library using `metasaver.projectType` field in package.json
- **Minimize Questions:** Only ask clarification questions if scope is genuinely ambiguous after investigation
- **Assumption:** For audits, scope is often self-evident from file discovery; unnecessary questions waste time

---

## User Story Template (Audit Mode)

For each (agent, file) combination, create a user story file following this template:

```markdown
## Story: Audit {file} in {repo}

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

**Example filename:** `US-001-audit-eslint.md` for auditing eslint.config.js

---

## Output Format

```json
{
  "status": "complete",
  "projectFolder": "docs/projects/20251217-audit-xyz",
  "prdPath": "docs/projects/20251217-audit-xyz/prd.md",
  "prdContent": "# PRD...",
  "stories": [
    {
      "id": "US-001",
      "file": "eslint.config.js",
      "agent": "eslint-agent",
      "path": "docs/projects/20251217-audit-xyz/user-stories/US-001-audit-eslint.md"
    },
    {
      "id": "US-002",
      "file": "package.json",
      "agent": "package-agent",
      "path": "docs/projects/20251217-audit-xyz/user-stories/US-002-audit-package.md"
    }
  ],
  "clarificationsProvided": 0
}
```

**Note:** `stories` array is only populated for `/audit` workflows. For `/build` workflows, stories are extracted by Architect in the design-phase.

---

## Integration

**Called by:** /audit, /build, /ms (all complexity levels that need PRD)
**Calls:** business-analyst agent, AskUserQuestion
**User Stories:**

- **For /audit:** Stories created automatically from scope.files + agent-check results. Each (agent, file) pair generates one audit-focused user story.
- **For /build:** Stories extracted by Architect in design-phase from PRD narrative (existing behavior unchanged).

**Next phase:**

- /build → innovate-phase (ask user)
- /audit → vibe-check (skip innovate)
- All → design-phase → **plan-approval** (where formal approval happens)
