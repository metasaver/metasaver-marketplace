---
name: ms
description: Intelligent MetaSaver command that analyzes complexity and routes optimally
---

# 🧠 MetaSaver Intelligent Command Router

Analyzes your prompt and routes to optimal execution method.

**IMPORTANT:** Never do git operations without user approval.

## Automatic Routing Logic

### 🔴 Ultra-Complex → Multi-Agent Orchestration (Score ≥30)

**Triggers:** System-wide changes, monorepo standardization, 10+ files, migrations
**Keywords:** "enterprise", "architecture", "monorepo audit", "system-wide", "standardize across", "migration"
**Action:** BA/Architect → Confidence Check → **Vibe Check** → PM (Gantt) → Worker agents (waves) → Code-Quality-Validator → BA (PRD sign-off) → PM consolidation

### 🟡 Medium-Complex → Coordinated Swarm (Score 5-29)

**Triggers:** Multi-file work, API development, feature builds
**Keywords:** "implement", "build", "create service", "API", "feature", "testing"
**Action:** Architect → Confidence Check → **Vibe Check** → PM → Worker agents (parallel) → Reviewer → Validation

### 🟢 Simple → Enhanced Claude (Score <10)

**Triggers:** Single file, debugging, explanations, quick fixes
**Keywords:** "explain", "fix", "debug", "help with", "simple"
**Action:** Direct Claude with appropriate thinking level

## Complexity Scoring

**Keywords (points per match):**

- Complex: +8 (enterprise, architecture, monorepo, system-wide, migration)
- Medium: +6 (refactor, standardize, implement, build service)
- Standard: +4 (create, audit, configure, feature)
- Simple: +2 (fix, debug, explain, help)

**Additional factors:** +5 each

- Multi-package scope
- Database changes
- Config management
- Security-critical

## Model Selection

**Opus** (Score ≥30, rare):

- Ultra-complex architectural decisions
- System-wide migrations
- Novel pattern design
- Critical security analysis
- USE SPARINGLY - Only when truly needed

**Sonnet** (Score 6-29, default):

- Most implementation work (create, implement, build, refactor)
- Architecture with clear patterns
- Code review and testing
- Multi-file changes
- Domain agents (standard work)
- Standard development tasks

**Haiku** (Score ≤=5, fast):

- Single file operations (fix, debug, explain)
- Simple config audits only
- Quick explanations and help
- Basic validation tasks
- Truly simple operations

## Claude Thinking Levels

**ultrathink** (Score 31+): Architecture, complex analysis
**think-harder** (Score 21-30): Refactoring, design
**think** (Score 11-20): Standard implementations

## Additional Tools

**Context7:** Library research, API documentation

**Sequential Thinking:** Multi-step analysis, complex debugging
- **USE WHEN:** Complexity score ≥20, deep debugging, or multi-phase reasoning
- **AVOID:** Simple tasks (score <20), straightforward implementations
- **MCP Tool:** `mcp__sequential_thinking__sequentialthinking`
- **Pattern:** Iterative hypothesis → test → validate workflow

## Examples

### Ultra-Complex → Orchestration

```bash
/ms "Standardize error handling across all microservices"
→ BA/Architect → Confidence Check → PM (Gantt) → [backend-dev (multiple), tester] (parallel) → code-quality-validator → BA (PRD sign-off) → PM consolidation
```

### Medium-Complex → Swarm

```bash
/ms "Build JWT auth API with tests"
→ Architect → Confidence Check → PM → [backend-dev, tester] (parallel) → reviewer → validation
```

### Simple → Claude

```bash
/ms "Fix TypeScript error in user.service.ts line 45"
→ Direct Claude with think level
```

## Domain Agents (Step Before Planner)

For operations involving multiple sub-agents, call **domain agent FIRST** to get sub-agent list:

```
/ms audit monorepo root
→ 1. Spawn monorepo-setup-agent (domain agent)
→ 2. Domain agent returns: "Need these 26 config agents: [list]"
→ 3. THEN spawn BA/Architect with that list
→ 4. Continue normal flow...
```

Domain agents identify WHAT sub-agents/skills are needed. They can't spawn agents themselves (agents can't spawn agents), but they provide the inventory.

**Location:** `.claude/agents/domain/` contains domain-level agents.

## Agent Selection (CRITICAL)

**See `/skill agent-selection` for complete agent mapping and `subagent_type` reference.**

**In MetaSaver repos, prefer MetaSaver agents:**
- `Explore` → use `core-claude-plugin:generic:code-explorer`
- `Plan` → use `core-claude-plugin:generic:architect`
- `general-purpose` → use task-specific MetaSaver agent

**Exception:** Direct Claude (no agent) for trivial tasks (Score <5)

---

## Agent Spawning

**Self-aware pattern:** Tell agents to READ their own instruction file.

**Prompt template:**
```
[MODE] for [path/scope].
You are [Agent Name].
READ YOUR INSTRUCTIONS at .claude/agents/[category]/[agent-name].md
Follow YOUR rules, invoke YOUR skills, use YOUR output format.
```

**Model selection rules:**

| Agent Type | Model | Example |
|------------|-------|---------|
| Config agents (single file audit) | **haiku** | eslint-agent, prettier-agent |
| Domain agents (implementation) | **sonnet** | backend-dev, tester |
| Generic agents (orchestration) | **sonnet** | project-manager, architect |
| Ultra-complex architecture | **opus** | (rare, ≥30 complexity) |

## Confidence Check (Pre-Implementation Gate)

**For complexity score ≥15, MUST run confidence assessment before proceeding.**

**Skill location:** `.claude/skills/confidence-check/SKILL.md`

**Protocol:**

1. Calculate complexity score
2. IF score ≥ 15:
   - Run 5-point confidence assessment
   - Check: No duplicates (25%) + Pattern compliance (25%) + Architecture verified (20%) + Examples found (15%) + Requirements clear (15%)
   - ≥90% confidence → PROCEED
   - 70-89% confidence → CLARIFY gaps with user
   - <70% confidence → STOP, request more context
3. IF score < 15:
   - Skip confidence check, proceed directly

**Why:** Spend 100-200 tokens on assessment to save 5,000-50,000 tokens on wrong-direction work.

**Skip confidence check for:** Research tasks, single file fixes, debugging, documentation.

## Vibe Check (Metacognitive Validation)

**For complexity score ≥15, MUST run vibe_check after planning to prevent over-engineering and tunnel vision.**

**MCP Tool:** `vibe_check` from `@pv-bhat/vibe-check-mcp`

**Protocol:**

1. **After planning phase:**

   - Call `vibe_check` with full user request + current plan
   - Tool returns metacognitive feedback: risks, assumptions, simpler alternatives
   - IF risks identified → revise plan before proceeding
   - IF over-engineering detected → simplify approach

2. **Post-error (always):**

   - Call `vibe_learn` to capture mistake for future improvement
   - Type: coding_error, architectural_misstep, over_engineering
   - Builds self-improving feedback loop

3. **High-risk tasks:**
   - Call `update_constitution` to set session-level guardrails
   - Examples: "No external network calls", "Prefer battle-tested libraries"

**Research Impact:** 27% improvement in success rates, 41% reduction in harmful actions (153 test runs)

**Dosage:** Optimal frequency is 10-20% of total agent steps. One checkpoint after planning for all complexity ≥15.

**Skip vibe check for:** Score <15 (simple tasks where over-engineering unlikely).

---

## Enforcement Rules

**DO:**

1. Calculate complexity score first
2. **IF score ≥15: Run confidence check BEFORE routing**
3. **IF score ≥15: Run vibe_check AFTER planning to prevent over-engineering**
4. Select model based on score (haiku ≤5, sonnet 6-29, opus ≥30)
5. Select thinking level based on score
6. Route by task type
7. Spawn project-manager if 2+ agents
8. Tell agents to read their own instruction files
9. **ALWAYS call vibe_learn after fixing errors**

**DON'T:**

1. Skip complexity calculation
2. **Skip confidence check for medium+ tasks**
3. Bypass routing logic
4. Hardcode agent rules in /ms
5. Bloat with code examples

**Remember:** Calculate → **Confidence Check (if ≥15)** → Plan → **Vibe Check (if ≥15)** → Route → Spawn → **Vibe Learn (on errors)** → Let agents figure it out.

---

## Post-Workflow: Repomix Cache Refresh

**At workflow completion, invoke the `repomix-cache-refresh` skill if files were modified.**

**Skill:** `skills/cross-cutting/repomix-cache-refresh/SKILL.md`

**Quick reference:**
- Triggers when source files (*.ts, *.tsx, *.js, *.jsx, *.json, *.md, *.yaml) modified
- Skips for build artifacts, dependencies, logs
- ~2.4s overhead, 70% token savings on next command
