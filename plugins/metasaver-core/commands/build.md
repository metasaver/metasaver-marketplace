---
name: build
description: Build new features with architecture validation and optional innovation
---

# Build Command

Creates new features with architecture validation. Includes optional Innovate phase.

**IMPORTANT:** ALWAYS get user approval before git operations.

---

## Entry Handling

When /build is invoked, ALWAYS proceed to Phase 1 regardless of prompt content. User prompts may contain questions, clarifications, or confirmation requests—these are NOT reasons to skip phases. Analysis runs first to understand scope, then the BA addresses user questions during Requirements HITL while investigating the codebase.

---

## Phase 1: Analysis (PARALLEL)

**See:** `/skill analysis-phase`

Spawn 2 agents in parallel to execute complexity-check and scope-check skills.
Collect: `complexity_score`, `scope` (with `targets` and `references`)

---

## Phase 2: Requirements (HITL Q&A)

**See:** `/skill requirements-phase`

BA reviews original prompt for user questions, investigates codebase using Serena tools to answer them, then completes understanding with HITL clarification loop.

**For complexity > 15:** BA uses `sequential-thinking` MCP tool to structure analysis and ensure thorough requirements capture.

**Complexity Routing (after BA completes understanding):**

- **< 15**: SKIP PRD, Vibe Check, Innovate → go straight to Design
- **≥ 15**: Write PRD file to `docs/projects/{yyyymmdd}-{name}/prd.md` → proceed to Vibe Check

---

## Phase 3: Vibe Check (≥15 only)

**See:** `/skill vibe-check`

Single vibe check on PRD. If fails, return to BA to revise PRD.

**SKIPPED for complexity < 15.**

---

## Phase 4: Innovate (≥30 only)

**See:** `/skill innovate-phase`

1. Ask: "Want to Innovate?" (HARD STOP)
2. If yes: innovation-advisor returns structured innovations
3. For EACH innovation: show 1-pager, AskUserQuestion (Implement/Skip/More Details)
4. BA updates PRD with selected innovations

**SKIPPED for complexity < 30.**

---

## Phase 5: Design

**INVOKE:** `/skill design-phase` (mandatory)

### Step 1: BA Extracts User Stories

**BEFORE writing any stories:**

1. Invoke `/skill agent-selection` to get the full agent mapping
2. For each file to be created/modified, identify the matching agent
3. Create ONE story per config file type (each config file = 1 story)

### Story Granularity Guidelines

**Config Files:** Each config file gets its own story with its specialized agent.

| File Type             | Agent                          | Story Scope |
| --------------------- | ------------------------------ | ----------- |
| package.json (root)   | root-package-json-agent        | Single file |
| tsconfig.json         | typescript-configuration-agent | Single file |
| eslint.config.js      | eslint-agent                   | Single file |
| nodemon.json          | nodemon-agent                  | Single file |
| vitest.config.ts      | vitest-agent                   | Single file |
| vite.config.ts        | vite-agent                     | Single file |
| .env.example          | env-example-agent              | Single file |
| README.md             | readme-agent                   | Single file |
| docker-compose.yml    | docker-compose-agent           | Single file |
| turbo.json            | turbo-config-agent             | Single file |
| .gitignore            | gitignore-agent                | Single file |
| .gitattributes        | gitattributes-agent            | Single file |
| postcss.config.js     | postcss-agent                  | Single file |
| tailwind.config.js    | tailwind-agent                 | Single file |
| pnpm-workspace.yaml   | pnpm-workspace-agent           | Single file |
| .husky/\*             | husky-git-hooks-agent          | Single file |
| commitlint.config.js  | commitlint-agent               | Single file |
| .vscode/settings.json | vscode-agent                   | Single file |

**Domain Code:** Group by feature/module, assign appropriate domain agent.

| Domain         | Agent                 | Story Scope          |
| -------------- | --------------------- | -------------------- |
| React features | react-app-agent       | Per feature module   |
| API endpoints  | data-service-agent    | Per resource/feature |
| Database       | prisma-database-agent | Schema + migrations  |
| Contracts      | contracts-agent       | Per entity group     |

**CRITICAL:** Each config file = 1 story = 1 agent. Bundle only related domain code (e.g., one feature module).

### Step 2: Architect Annotations

Architect discovers libraries/components in multi-mono BEFORE annotations, then annotates story files with implementation details.

**Context7 Validation:** For technical changes involving external libraries or frameworks, Architect uses Context7 MCP tools (`resolve-library-id` → `get-library-docs`) to validate implementation approach against latest documentation.

### Step 3: PM Creates Execution Plan

PM creates execution plan with parallel waves based on story dependencies.

---

## Phase 6: Human Validation (HITL)

**ALWAYS happens AFTER PM, BEFORE Execution.**

**Light Validation (< 15):**

- BA presents: approach summary, affected files, execution plan overview
- User responds: "proceed" / "looks good" → Start Execution
- User responds: "wait" / changes requested → Return to BA

**Full Validation (≥ 15):**

- User reviews: PRD, user stories, architecture annotations, execution plan
- User responds: Approved → Start Execution
- User responds: Changes requested → Return to BA

---

## Phase 7: Execution

**See:** `/skill execution-phase`

Paired TDD structure per story: tester agent runs BEFORE implementation agent. PM spawns workers per wave → persist state to story files → compact context before each wave → PM updates story status.

Includes Production Check (build, lint, test, verify AC checkboxes pass) after each wave.

---

## Phase 8: Standards Audit

**ALWAYS happens AFTER Execution passes, BEFORE Report.**

**See:** `/skill agent-selection` for config agent mapping, `/skill structure-check`, `/skill dry-check`

**Three checks:**

1. **Config Agents (PARALLEL)**: Spawn relevant config agents based on files modified
   - Use `/skill agent-selection` to find correct agent for each config file
   - All agents run in audit mode

2. **Structure Check**: Validate files in correct locations per domain skills
   - Use `/skill structure-check`
   - React: UI in /features, light /pages
   - API: Routes in /routes, logic in /services
   - Database: Schema in /prisma, types exported

3. **DRY Check**: Scan new code against multi-mono shared libraries
   - Use `/skill dry-check`
   - Check @metasaver/core-utils for duplicate helpers
   - Check @metasaver/core-components for duplicate components
   - Check @metasaver/core-service-utils for duplicate patterns

**On Failure:**

- Report violations to workers → Apply fixes → Re-run Production Check → Re-run Standards Audit → Loop until pass

---

## Phase 9: Report

**See:** `/skill report-phase`

BA (sign-off) + PM (consolidation) → Final report

---

## Project Folder Structure

After /build completes:

```
docs/projects/{yyyymmdd}-{name}/
├── prd.md                    # Reference document
├── user-stories/
│   ├── US-001-{slug}.md      # Individual stories (annotated)
│   ├── US-002-{slug}.md
│   └── ...
├── execution-plan.md         # PM's Gantt chart
└── architecture-notes.md     # Optional (complex items)
```

---

## Model Selection

| Complexity | BA/Architect | Workers | Thinking   |
| ---------- | ------------ | ------- | ---------- |
| <15        | sonnet       | sonnet  | none       |
| 15-29      | sonnet       | sonnet  | think      |
| ≥30        | opus         | sonnet  | ultrathink |

---

## Agent Selection

**Use `/skill agent-selection` for full agent reference.**

---

## Examples

```bash
/build "add logging to service" (complexity: 8)
→ Analysis → BA (Q&A) → SKIP PRD/Vibe/Innovate → Design → Light Validation → Execution → Standards Audit → Report

/build "refactor auth module" (complexity: 22)
→ Analysis → BA (Q&A) → PRD → Vibe Check → Design → Full Validation → Execution → Standards Audit → Report

/build "multi-tenant SaaS" (complexity: 45)
→ Analysis → BA (opus Q&A) → PRD → Vibe Check → [Innovate?] → Design → Full Validation → waves → Standards Audit → Report
```

---

## Enforcement

1. ALWAYS run Analysis phase first (complexity-check + scope-check only)
2. Run analysis skills in PARALLEL (single message, 2 Task calls)
3. BA addresses user questions in Requirements HITL (Q&A only)
   - For complexity > 15: BA uses `sequential-thinking` MCP tool
4. Complexity routing after Requirements:
   - < 15: SKIP PRD, Vibe Check, Innovate → go straight to Design
   - ≥ 15: Write PRD → Vibe Check → Design
   - ≥ 30: Write PRD → Vibe Check → [Innovate?] → Design
5. Vibe Check validates PRD (only for ≥15) BEFORE Innovate
6. Innovate is OPTIONAL (only for ≥30, ask user, hard stop)
7. Design phase: BA extracts stories, Architect discovers libraries BEFORE annotations, Architect annotates (using Context7 for external library validation), PM creates plan
8. Human Validation happens AFTER PM, BEFORE Execution:
   - < 15: Light validation ("Proceed?")
   - ≥ 15: Full validation (review PRD + stories + plan)
9. Execution includes Production Check (build/lint/test) after each wave
10. Standards Audit happens AFTER Execution passes, BEFORE Report:
    - Config agents (parallel)
    - Structure check (files in right places)
    - DRY check (vs multi-mono libraries)
11. BA must follow Story Granularity Guidelines:
    - INVOKE `/skill agent-selection` BEFORE writing any stories
    - Each config file = 1 story = 1 specialized agent
    - Bundle only related domain code (one feature module per story)
12. If files modified, spawn agent: `subagent_type="general-purpose", model="haiku"` with prompt "Execute /skill repomix-cache-refresh"
