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

## How It Works

### Step 1: Parse Natural Language

Detect audit scope from user's request:

**Single File Patterns:**
- "audit turbo.json"
- "validate eslint"
- "check prettier config"
- "audit the typescript config"

**Domain Patterns:**
- "audit code quality"
- "audit build tools"
- "audit version control"
- "audit workspace configs"

**Composite Patterns:**
- "audit monorepo root"
- "audit all configs"
- "audit root configuration"

**Full Monorepo Patterns:**
- "audit entire monorepo"
- "audit everything"
- "full monorepo audit"

### Step 2: Calculate Complexity

Based on scope detected:

```typescript
// Single file
complexity = 5 (one agent)

// Domain (3-8 files)
complexity = 10-15 (multiple agents, same category)

// Composite (20-30 files)
complexity = 25 (all config agents, parallel)

// Full monorepo (50+ files)
complexity = 40 (all configs + workspace packages)
```

### Step 3: Select Workflow

**Simple (Complexity <10):**
```
Direct → Single config agent → Report
```

**Medium (Complexity 10-24):**
```
Business Analyst → PM → Domain agents (parallel) → Reviewer → PM consolidation
```

**Complex (Complexity ≥25):**
```
Business Analyst → Confidence Check → PM (Gantt) → Config agents (waves of 10) → Reviewer → PM consolidation
```

### Step 4: Execute Workflow

Follow the standard AUDIT workflow from `/skill workflow-orchestration`:

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

Spawn all agents in current wave (max 10):

```typescript
// Wave 1 (code quality)
Task("eslint-agent", "AUDIT /mnt/f/code/resume-builder/eslint.config.js")
Task("prettier-agent", "AUDIT /mnt/f/code/resume-builder/.prettierrc.json")
Task("typescript-agent", "AUDIT /mnt/f/code/resume-builder/tsconfig.json")
Task("editorconfig-agent", "AUDIT /mnt/f/code/resume-builder/.editorconfig")

// Wave 2 (build tools)
Task("turbo-config-agent", "AUDIT /mnt/f/code/resume-builder/turbo.json")
Task("pnpm-workspace-agent", "AUDIT /mnt/f/code/resume-builder/pnpm-workspace.yaml")
Task("vitest-agent", "AUDIT /mnt/f/code/resume-builder/vitest.config.ts")
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

Use `/skill mcp-tool-selection` to determine tool usage:

**For audit tasks:**
- **Serena:** Code navigation and symbol search (if needed)
- **Recall:** Check for established patterns and prior decisions
- **Context7:** Research latest config standards (if uncertainty)
- **Sequential Thinking:** Complex multi-config analysis (complexity ≥20)

## Complexity Scoring

```typescript
function calculateAuditComplexity(request: string): number {
  let score = 0;

  // Keyword matching
  if (request.includes("entire") || request.includes("everything")) score += 15;
  if (request.includes("monorepo") || request.includes("all")) score += 10;
  if (request.includes("audit")) score += 4;

  // Scope detection
  const singleFilePatterns = /audit (the )?([\w.-]+\.(json|js|ts|yaml|md))/i;
  if (singleFilePatterns.test(request)) score += 5; // Single file

  const domainPatterns = /(code quality|build tools|version control|workspace)/i;
  if (domainPatterns.test(request)) score += 12; // Domain audit

  const compositePatterns = /(root|all configs)/i;
  if (compositePatterns.test(request)) score += 25; // Composite

  return score;
}
```

**Thresholds:**
- <10: Simple (direct execution)
- 10-24: Medium (BA → PM → Workers)
- ≥25: Complex (BA → Confidence → PM → Workers)

## Examples

### Example 1: Single File Audit

```bash
User: /audit turbo.json

Complexity: 5 (simple)
Workflow: Direct execution

→ Task("turbo-config-agent", "AUDIT turbo.json")
→ Report directly to user
```

### Example 2: Domain Audit

```bash
User: /audit code quality configs

Complexity: 12 (medium)
Workflow: BA → PM → Workers → Reviewer → PM

→ BA: Define scope (eslint, prettier, typescript, editorconfig)
→ PM: Plan 4 agents in parallel
→ Workers: All 4 agents execute concurrently
→ Reviewer: Assess consistency
→ PM: Consolidate report
```

### Example 3: Full Monorepo Audit

```bash
User: /audit all monorepo configs

Complexity: 25 (complex)
Workflow: BA → Confidence Check → PM → Workers (waves) → Reviewer → PM

→ BA: Define comprehensive scope (26 config agents)
→ Confidence Check: Verify understanding and readiness
→ PM: Plan 3 waves of 10 agents each
→ Workers Wave 1: 10 agents in parallel
→ Workers Wave 2: 10 agents in parallel
→ Workers Wave 3: 6 agents in parallel
→ Reviewer: Overall quality assessment
→ PM: Consolidated executive report
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
3. **Respect parallelism** - Max 10 agents per wave (Claude Code limitation)
4. **Always consolidate** - PM must summarize all results into executive report
5. **Prioritize findings** - Critical → Warning → Info hierarchy
6. **Offer remediation** - Always present conform/ignore/update options

## Integration

This command integrates with:
- `/skill workflow-orchestration` - Standard AUDIT pipeline
- `/skill monorepo-audit` - File-to-agent mapping and discovery
- `/skill confidence-check` - Pre-execution validation
- `/skill remediation-options` - Post-audit next steps
- `/skill mcp-tool-selection` - External tool determination
