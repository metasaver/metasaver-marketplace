---
name: audit
description: Natural language audit command that validates configurations, code quality, and standards compliance across single files, multiple domains, or entire monorepo
---

# Audit Command

Intelligent audit routing with NLP parsing and automated workflow orchestration.

**Compliance Target:** 100%

---

## Workflow Overview

```
┌─────────────────────────────────────────────────────────────┐
│ PHASE 1: ANALYSIS (PARALLEL)                                │
│ Skills: complexity-check, tool-check, scope-check           │
│ Output: complexity (int), tools (string[]), scope (string[])│
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│ PHASE 2: REQUIREMENTS                                       │
│ Skill: /skill requirements-phase (workflow-step)            │
│ Output: Validated PRD path in /docs/prd/                    │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│ PHASE 3: PLANNING                                           │
│ Agent: project-manager                                      │
│ Output: Execution plan with waves (max 10 agents/wave)      │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│ PHASE 4: EXECUTION                                          │
│ Agents: Config agents (haiku) in parallel waves             │
│ Output: Individual audit results                            │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│ PHASE 5: VALIDATION                                         │
│ Agent: reviewer + confidence-check skill                    │
│ Output: Quality assessment                                  │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│ PHASE 6: REPORT                                             │
│ Agents: business-analyst (sign-off), project-manager        │
│ Output: Consolidated executive report                       │
└─────────────────────────────────────────────────────────────┘
```

---

## Phase-to-Skill Mapping

| Phase           | Skill/Agent                 | Purpose                   |
| --------------- | --------------------------- | ------------------------- |
| 1. Analysis     | `/skill complexity-check`   | Calculate score (1-50)    |
| 1. Analysis     | `/skill tool-check`         | Determine MCP servers     |
| 1. Analysis     | `/skill scope-check`        | Discover repositories     |
| 2. Requirements | `/skill requirements-phase` | PRD + vibe check workflow |
| 3. Planning     | `project-manager` agent     | Create execution plan     |
| 4. Execution    | Config agents (26 total)    | Run audits                |
| 5. Validation   | `/skill confidence-check`   | Technical readiness       |
| 5. Validation   | `reviewer` agent            | Quality assessment        |
| 6. Report       | `business-analyst` agent    | PRD sign-off              |
| 6. Report       | `project-manager` agent     | Consolidate results       |

---

## Usage

```bash
# Single file audit
/audit turbo.json
/audit the eslint config

# Domain audit (multiple related configs)
/audit code quality configs
/audit build tools

# Composite audit (all root configs)
/audit monorepo root
/audit all configs

# Full monorepo audit (including workspaces)
/audit entire monorepo
/audit everything
```

---

## Routing by Complexity

| Complexity    | Route                                                     | Model Selection |
| ------------- | --------------------------------------------------------- | --------------- |
| ≤4 (Simple)   | Direct → Single agent → Report                            | haiku           |
| 5-24 (Medium) | Requirements → PM → Workers → Report                      | sonnet + haiku  |
| ≥25 (Complex) | Requirements → Confidence → PM → Workers (waves) → Report | sonnet + haiku  |

---

## Phase Details

### Phase 1: Analysis (PARALLEL)

Run these skills in parallel at the start:

```
/skill complexity-check → complexity: int (1-50)
/skill tool-check → tools: string[]
/skill scope-check → scope: string[]
```

### Phase 2: Requirements

**Skill:** `/skill requirements-phase` (workflow-steps folder)

> **ROOT AGENT ONLY** - This skill spawns agents.

**What it does:**

1. Spawns `business-analyst` agent (create PRD)
2. Writes PRD to `/docs/prd/prd-{timestamp}-{slug}.md`
3. Calls `vibe_check` MCP tool
4. If fails: Asks user for clarification (max 2 loops)
5. Returns validated PRD path

### Phase 3: Planning

**Agent:** `project-manager`

**Task:**

```
Task("project-manager", `
  Create execution plan for audit.
  Requirements: {PRD from Phase 2}
  Organize agents into waves (max 10 per wave).
  Return ExecutionPlan with wave structure.
`, model: "sonnet")
```

### Phase 4: Execution

**Agents:** Config agents (26 total)

Spawn all agents in current wave with haiku model:

```
Task("{config-agent}", `
  AUDIT MODE for {file_path}
  READ YOUR INSTRUCTIONS at .claude/agents/config/{category}/{agent}.md
  Invoke YOUR skill, use YOUR output format.
`, model: "haiku")
```

### Phase 5: Validation

**Skill:** `/skill confidence-check` (if complexity ≥15)
**Agent:** `reviewer`

```
Task("reviewer", `
  Review all {N} audit results.
  Assess compliance patterns, consistency, coverage.
  Return quality assessment.
`, model: "sonnet")
```

### Phase 6: Report

**Agents:** `business-analyst` (sign-off), `project-manager` (consolidation)

```
Task("business-analyst", `
  MODE: sign-off
  PRD: {prd_path}
  Results: {all worker results}
  Validate requirements completion.
`, model: "sonnet")

Task("project-manager", `
  Consolidate {N} audit results into executive report.
  Include: summary, status by domain, metrics, recommendations.
`, model: "sonnet")
```

---

## Output Format

```markdown
# {Scope} Audit Report

**Repository:** {repo}
**Compliance Target:** 100%
**Date:** {timestamp}

## Executive Summary

{1-2 sentence summary}

## Status by Domain

✅ **ESLint** - PASS (100% compliant)
❌ **Turbo.json** - FAIL (72% compliant)

## Metrics

- Total configs audited: N
- Overall compliance: X%
- Critical violations: N
- Warning violations: N

## Prioritized Recommendations

### Critical (Fix Immediately)

### Warnings (Address Soon)

### Info (Nice to Have)

## Remediation Options

Use `/skill remediation-options` for next steps.
```

---

## Model Selection

| Agent Type         | Model      | Rationale                              |
| ------------------ | ---------- | -------------------------------------- |
| Config agents      | **haiku**  | Fast, efficient for standards checking |
| PM, Reviewer       | **sonnet** | Coordination and analysis              |
| BA (complex scope) | **sonnet** | Reasoning for requirements             |

---

## Integration

**Workflow Steps (skills/workflow-steps/):**

- `/skill requirements-phase` - Phase 2 orchestration

**Utility Skills (skills/cross-cutting/):**

- `/skill complexity-check` - Phase 1 scoring
- `/skill tool-check` - Phase 1 MCP selection
- `/skill scope-check` - Phase 1 repo discovery
- `/skill confidence-check` - Phase 5 technical validation

**Domain Skills (skills/domain/):**

- `/skill monorepo-audit` - File-to-agent mapping
- `/skill remediation-options` - Post-audit options
- `/skill audit-workflow` - Bi-directional comparison

**MCP Tools:**

- `vibe_check` - PRD validation (via requirements-phase)
- `vibe_learn` - Post-error learning

**Agents:**

- `business-analyst` - PRD creation SME
- `project-manager` - Planning + consolidation
- Config agents (26 total) - Individual audits
- `reviewer` - Quality assessment
