---
name: audit
description: Natural language audit command that validates configurations, code quality, and standards compliance across single files, multiple domains, or entire monorepo
---

# Audit Command

Intelligent audit routing with NLP parsing and automated workflow orchestration.

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

## Agent Selection (CRITICAL)

**See `/skill agent-selection` for complete agent mapping and `subagent_type` reference.**

**In MetaSaver repos, prefer MetaSaver agents:**
- `Explore` → use `core-claude-plugin:generic:code-explorer`
- `Plan` → use `core-claude-plugin:generic:architect`
- `general-purpose` → use task-specific MetaSaver agent

**Model selection:**
- Config agents use **haiku** model
- Generic/domain agents use **sonnet** model

---

## How It Works

**Phase 1 - Analysis (PARALLEL):**
- `/skill complexity-check` → score (int)
- `/skill tool-check` → tools (string[])
- `/skill scope-check` → scope (string[])

**Phase 2+ - Route by complexity:**
- ≤4: Direct → single config agent (haiku) → Report
- 5-24: BA (sonnet) → PM → Workers (haiku) → Reviewer → PM consolidation
- ≥25: BA (opus) → Vibe Check → PM → Workers in waves → Reviewer → PM consolidation

### Workflow Execution

Follow `/skill workflow-orchestration` for standard AUDIT pipeline:

```
BA (define scope + criteria) →
PM (plan execution) →
Workers (parallel audits) →
Reviewer (validate findings) →
PM (consolidate report)
```

## Workflow Details

### Business Analyst Phase

**Input:** User's audit request (NLP parsed)

**Output:** AuditRequirements
```typescript
{
  scope: "full" | "partial" | "specific",
  domains: string[], // e.g., ["eslint", "prettier", "typescript"]
  criteria: "All configs follow MetaSaver patterns",
  successMetrics: {
    minComplianceRate: 95,
    maxCriticalViolations: 0,
    maxTotalViolations: 20
  }
}
```

**Task:**
```
Task("business-analyst", `
  Analyze audit requirements for: {user_request}

  Define:
  1. Scope (which files/domains to audit)
  2. Success criteria
  3. Compliance metrics

  Return AuditRequirements in structured format.
`)
```

### Confidence Check Phase

**Trigger:** IF complexity ≥15

Use `/skill confidence-check` to assess:
- ✅ No duplicate work (25%)
- ✅ Pattern compliance known (25%)
- ✅ Architecture verified (20%)
- ✅ Examples found (15%)
- ✅ Requirements clear (15%)

**Decision:**
- ≥90% → PROCEED
- 70-89% → CLARIFY with user
- <70% → STOP, gather more context

### Project Manager Phase

**Input:** AuditRequirements from BA

**Output:** ExecutionPlan
```typescript
{
  waves: [
    {
      waveNumber: 1,
      agents: ["eslint-agent", "prettier-agent", "typescript-agent"],
      dependsOn: [],
      expectedOutputs: ["eslint_audit", "prettier_audit", "typescript_audit"]
    }
  ],
  totalAgents: 13,
  strategy: "Parallel execution in waves of 10 (Claude Code max)"
}
```

**Task:**
```
Task("project-manager", `
  Create execution plan for audit:

  Requirements: {BA output}

  Organize agents into waves (max 10 per wave).
  No dependencies between config audits (all parallel).

  Return ExecutionPlan with wave structure.
`)
```

### Worker Execution Phase

**Discovery (for composite audits):**

If scope requires multiple agents, spawn domain agent first:

```
Task("monorepo-setup-agent", `
  MODE: audit-discovery
  TARGET: /mnt/f/code/resume-builder

  Use /skill monorepo-audit to:
  1. Scan repository root
  2. Generate manifest of all config agents needed
  3. Return exact Task calls for worker phase

  DO NOT execute audits - only discover what needs auditing.
`)
```

**Parallel Execution:**

Spawn all agents in current wave (max 10) with appropriate models:

```typescript
// Wave 1 (code quality) - haiku for config agents
Task("eslint-agent", "AUDIT /mnt/f/code/resume-builder/eslint.config.js",
  subagent_type: "eslint-agent", model: "haiku")
Task("prettier-agent", "AUDIT /mnt/f/code/resume-builder/.prettierrc.json",
  subagent_type: "prettier-agent", model: "haiku")
Task("typescript-agent", "AUDIT /mnt/f/code/resume-builder/tsconfig.json",
  subagent_type: "typescript-agent", model: "haiku")
Task("editorconfig-agent", "AUDIT /mnt/f/code/resume-builder/.editorconfig",
  subagent_type: "editorconfig-agent", model: "haiku")

// Wave 2 (build tools) - haiku for config agents
Task("turbo-config-agent", "AUDIT /mnt/f/code/resume-builder/turbo.json",
  subagent_type: "turbo-config-agent", model: "haiku")
Task("pnpm-workspace-agent", "AUDIT /mnt/f/code/resume-builder/pnpm-workspace.yaml",
  subagent_type: "pnpm-workspace-agent", model: "haiku")
Task("vitest-agent", "AUDIT /mnt/f/code/resume-builder/vitest.config.ts",
  subagent_type: "vitest-agent", model: "haiku")
```

Each agent:
1. Reads its own instructions (`.claude/agents/config/{category}/{agent}.md`)
2. Invokes its skill for standards (`.claude/skills/{config-name}/SKILL.md`)
3. Performs bi-directional audit
4. Returns violations + recommendations

### Reviewer Phase

**Input:** All worker audit results

**Output:** Quality assessment
```typescript
{
  overallQuality: "excellent" | "good" | "needs-improvement",
  consistencyScore: 88,
  coverageComplete: true,
  missedAreas: ["Environment security"],
  recommendations: ["Add .env validation"]
}
```

**Task:**
```
Task("reviewer", `
  Review all {N} audit results.

  Assess:
  - Overall compliance patterns
  - Consistency across configs
  - Coverage completeness
  - Critical vs warning issues

  Identify any missed areas or patterns.

  Return quality assessment.
`)
```

### PM Consolidation Phase

**Input:** All worker results + Reviewer assessment

**Output:** ConsolidatedReport
```typescript
{
  summary: "Monorepo audit: 91% compliance, 2 critical issues",
  statusByDomain: {
    "eslint": "PASS (96%)",
    "prettier": "PASS (100%)",
    "typescript": "PASS (94%)",
    "turbo": "FAIL (72%)"
  },
  totalMetrics: {
    totalAgentsExecuted: 13,
    totalViolations: 47,
    criticalViolations: 2,
    averageCompliance: 91
  },
  recommendations: [
    "CRITICAL: Fix turbo.json pipeline dependencies",
    "WARNING: Update GitHub workflow Node version"
  ],
  overallStatus: "partial"
}
```

**Task:**
```
Task("project-manager", `
  Consolidate {N} audit results into executive report.

  Include:
  - Executive summary
  - Status by domain (pass/partial/fail)
  - Aggregated metrics
  - Prioritized recommendations (critical → warning → info)
  - Overall pass/fail status

  Return ConsolidatedReport.
`)
```

## Agent Self-Awareness Pattern

All config agents are spawned with self-awareness instructions:

```
Task("turbo-config-agent", `
  AUDIT MODE for /mnt/f/code/resume-builder/turbo.json

  You are the Turbo Config Agent.

  READ YOUR INSTRUCTIONS:
  .claude/agents/config/build-tools/turbo-config-agent.md

  Follow YOUR rules.
  Invoke YOUR skill: /skill turbo-config
  Use YOUR output format.

  Report violations and recommendations.
`)
```

## MCP Tool Integration

**Run `/skill tool-check` to determine tool usage.**

## Complexity Scoring

**Run `/skill complexity-check` to calculate score.**

**Thresholds:**
- ≤4: Simple (direct execution, haiku)
- 5-24: Medium (BA → PM → Workers, sonnet orchestration)
- ≥25: Complex (BA → Confidence → PM → Workers, opus for BA)

## Examples

### Example 1: Single File Audit

```bash
User: /audit turbo.json

Complexity: 5 (simple)
Workflow: Direct execution
Model: haiku

→ Task("turbo-config-agent", "AUDIT turbo.json",
    subagent_type: "turbo-config-agent", model: "haiku")
→ Report directly to user
```

### Example 2: Domain Audit

```bash
User: /audit code quality configs

Complexity: 12 (medium)
Workflow: BA → PM → Workers → Reviewer → PM
Models: sonnet for orchestration, haiku for config agents

→ BA (sonnet): Define scope (eslint, prettier, typescript, editorconfig)
→ PM (sonnet): Plan 4 agents in parallel
→ Workers (haiku): All 4 config agents execute concurrently
→ Reviewer (sonnet): Assess consistency
→ PM (sonnet): Consolidate report
```

### Example 3: Full Monorepo Audit

```bash
User: /audit all monorepo configs

Complexity: 25 (complex)
Workflow: BA → Confidence Check → PM → Workers (waves) → Reviewer → PM
Models: opus for BA (complex scope), sonnet for orchestration, haiku for config agents

→ BA (opus): Define comprehensive scope (26 config agents)
→ Confidence Check: Verify understanding and readiness
→ PM (sonnet): Plan 3 waves of 10 agents each
→ Workers Wave 1 (haiku): 10 config agents in parallel
→ Workers Wave 2 (haiku): 10 config agents in parallel
→ Workers Wave 3 (haiku): 6 config agents in parallel
→ Reviewer (sonnet): Overall quality assessment
→ PM (sonnet): Consolidated executive report
```

## Output Format

All audit reports follow this structure:

```markdown
# {Scope} Audit Report

**Repository:** resume-builder
**Type:** Consumer repo (strict standards enforced)
**Date:** {timestamp}

## Executive Summary

{1-2 sentence summary of overall compliance}

## Status by Domain

✅ **ESLint** - PASS (96% compliant)
  - All rules configured correctly
  - 2 minor warnings

❌ **Turbo.json** - FAIL (72% compliant)
  - CRITICAL: Missing pipeline outputs
  - CRITICAL: Invalid task dependencies
  - WARNING: No persistent task configuration

## Metrics

- Total configs audited: 13
- Overall compliance: 91%
- Critical violations: 2
- Warning violations: 8
- Info violations: 4

## Prioritized Recommendations

### Critical (Fix Immediately)
1. Fix turbo.json pipeline dependencies
2. Add missing task hashes

### Warnings (Address Soon)
1. Update GitHub workflow Node version
2. Add gitignore patterns for .turbo cache

### Info (Nice to Have)
1. Consider environment variable validation
2. Add pre-commit hook for config linting

## Remediation Options

Use `/skill remediation-options` for next steps:
1. **Conform** - Fix all violations to match standards
2. **Ignore** - Document exceptions for specific violations
3. **Update** - Evolve standards if violations are intentional
```

## Best Practices

1. **Parse intent first** - Understand what user wants to audit before spawning agents
2. **Use domain agents** - For composite audits, let domain agents discover what's needed
3. **Select appropriate models**:
   - haiku: All config agents (fast, efficient for standards checking)
   - sonnet: PM, Reviewer, domain agents (coordination work)
   - opus: BA for ultra-complex scope (≥25 complexity, rare)
4. **Respect parallelism** - Max 10 agents per wave (Claude Code limitation)
5. **Always consolidate** - PM must summarize all results into executive report
6. **Prioritize findings** - Critical → Warning → Info hierarchy
7. **Offer remediation** - Always present conform/ignore/update options

## Integration

This command integrates with:
- `/skill workflow-orchestration` - Standard AUDIT pipeline
- `/skill monorepo-audit` - File-to-agent mapping and discovery
- `/skill confidence-check` - Pre-execution validation
- `/skill remediation-options` - Post-audit next steps
- `/skill repomix-cache-refresh` - Post-workflow cache update if files modified
