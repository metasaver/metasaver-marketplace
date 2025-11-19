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
**Action:** BA/Architect → Confidence Check → PM (Gantt) → Worker agents (waves) → Code-Quality-Validator → BA (PRD sign-off) → PM consolidation

### 🟡 Medium-Complex → Coordinated Swarm (Score 10-29)

**Triggers:** Multi-file work, API development, feature builds
**Keywords:** "implement", "build", "create service", "API", "feature", "testing"
**Action:** Architect → Confidence Check → PM → Worker agents (parallel) → Reviewer → Validation

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

## Claude Thinking Levels

**ultrathink** (Score 31+): Architecture, complex analysis
**think-harder** (Score 21-30): Refactoring, design
**think** (Score 11-20): Standard implementations

## Additional Tools

**Context7:** Library research, API documentation
**Sequential Thinking:** Multi-step analysis, complex debugging

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

## Agent Spawning

**Self-aware pattern:** Tell agents to read their own instruction files.

```
Task("agent-name",
  "AUDIT MODE for [path].
   You are [Agent Name].
   READ YOUR INSTRUCTIONS at .claude/agents/config/[category]/[agent].md
   Follow YOUR rules, invoke YOUR skills, use YOUR output format.",
  "agent-name")
```

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

---

## Enforcement Rules

**DO:**

1. Calculate complexity score first
2. **IF score ≥15: Run confidence check BEFORE routing**
3. Select thinking level based on score
4. Route by task type
5. Spawn project-manager if 2+ agents
6. Tell agents to read their own instruction files

**DON'T:**

1. Skip complexity calculation
2. **Skip confidence check for medium+ tasks**
3. Bypass routing logic
4. Hardcode agent rules in /ms
5. Bloat with code examples

**Remember:** Calculate → **Confidence Check (if ≥15)** → Think → Route → Spawn → Let agents figure it out.
