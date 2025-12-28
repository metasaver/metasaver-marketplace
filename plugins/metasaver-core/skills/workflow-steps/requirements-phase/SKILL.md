---
name: requirements-phase
description: PRD creation with HITL clarification loop, then EPIC-FIRST extraction. BA drafts PRD, asks user questions until requirements are clear, then creates epics (ALWAYS at least 1) followed by user stories under each epic. Formal approval happens in the design phase.
---

# Requirements Phase - PRD + Epic/Story Creation (HITL)

> **ROOT AGENT ONLY** - Called by commands only, always invoked at root level.

**Purpose:** Create PRD with human-in-the-loop clarification, then extract epics and stories
**Trigger:** After analysis-phase completes
**Input:** prompt, complexity, tools, scope (from analysis-phase)
**Output:** PRD + Epics + User Stories (hierarchy: PRD → Epics → Stories)

---

## Important: Clarification Only

This phase is for **clarification and collection**, not formal approval. The user can ask questions, provide context, and clarify requirements interactively. Formal approval happens later in **plan-approval** phase after:

- PRD is written
- Stories are extracted
- Architect has annotated stories
- PM has created execution plan

This way the user sees the full picture before approving.

---

## Workflow Steps

1. **Check for existing project folder:**
   - Glob for `docs/projects/*` to find existing project folders
   - If a related folder exists (matching topic/date), ask user: "Found existing project folder {path}. Reuse this or create new?"
   - If no match or user wants new, create: `docs/projects/{yyyymmdd}-{descriptive-name}/`
   - Example: `docs/projects/msm008-applications-feature/`
   - BA creates or reuses folder before drafting PRD

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

5. **Create epics and stories (ALWAYS - all modes):**
   - **Create folder:** `{projectFolder}/user-stories/`
   - **CRITICAL: Create at least 1 epic FIRST**
     - Determine epic boundaries based on complexity (see Epic Count Guidelines)
     - Create epic file: `EPIC-{NNN}-{name}.md`
     - Use `/skill user-story-template` for epic format
   - **Then create stories under each epic:**
     - For each story, link to parent epic
     - Create story file: `US-{NNN}-{name}.md`
     - Use `/skill user-story-template` for story format
   - **Numbering:** Epics sequential (EPIC-001, EPIC-002), Stories sequential (US-001, US-002)

6. **Continue to next phase** (no approval stop here)

---

## Epic Count Guidelines

| Complexity | Recommended Epics | Example Split                 |
| ---------- | ----------------- | ----------------------------- |
| < 15       | 1 epic            | Single feature                |
| 15-29      | 1-2 epics         | Feature + Tests               |
| 30-44      | 2-3 epics         | Backend + Frontend + Database |
| ≥ 45       | 3+ epics          | Multiple domains/services     |

**ALWAYS create stories within an epic.** Even for simple tasks, wrap stories in at least one epic.

---

## Story Consolidation Rule

**Create ONE story per target file.** When multiple requirements target the same file, consolidate them into a single story.

**Why:** Prevents parallel agents from editing the same file simultaneously. Ensures sequential, conflict-free execution.

**Example:**

- Requirements: "Add agent delegation to build.md" + "Add TDD sequence to build.md"
- Result: ONE story "US-001: Update build.md with agent delegation and TDD sequence"

**Rule:** Group all requirements for a file into a single story. List all acceptance criteria together.

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
  "projectFolder": "docs/projects/msm007-feature-xyz",
  "prdPath": "docs/projects/msm007-feature-xyz/prd.md",
  "prdContent": "# PRD...",
  "epics": [
    {
      "id": "EPIC-001",
      "title": "User Authentication",
      "path": "docs/projects/msm007-feature-xyz/user-stories/EPIC-001-user-auth.md",
      "stories": ["US-001", "US-002", "US-003"]
    },
    {
      "id": "EPIC-002",
      "title": "Dashboard UI",
      "path": "docs/projects/msm007-feature-xyz/user-stories/EPIC-002-dashboard.md",
      "stories": ["US-004", "US-005"]
    }
  ],
  "stories": [
    {
      "id": "US-001",
      "epic": "EPIC-001",
      "title": "Create users table",
      "agent": "prisma-database-agent",
      "path": "docs/projects/msm007-feature-xyz/user-stories/US-001-users-table.md"
    },
    {
      "id": "US-002",
      "epic": "EPIC-001",
      "title": "Add password hashing",
      "agent": "backend-worker-agent",
      "path": "docs/projects/msm007-feature-xyz/user-stories/US-002-password-hash.md"
    }
  ],
  "clarificationsProvided": 0
}
```

**CRITICAL:** Every output MUST have at least 1 epic. Stories MUST reference their parent epic.

---

## Integration

**Called by:** /audit, /build, /architect, /ms (all complexity levels that need PRD)
**Calls:** business-analyst agent, AskUserQuestion
**References:** `/skill user-story-template` for epic and story formats

**Epic + Story Creation:**

- **ALWAYS create at least 1 epic** - Required for all workflows
- **For /audit:** Stories created automatically from scope.files + agent-check results. Group into "Audit" epic(s).
- **For /build:** Stories extracted from PRD narrative. Group by domain/feature.
- **For /architect:** Deep exploration with multiple epics for complex planning.

**Next phase:**

- /build → design-phase (architect enriches epics/stories)
- /architect → vibe-check → innovate-phase
- /audit → design-phase (skip vibe/innovate)
- All → **hitl-approval** (where formal approval happens)
