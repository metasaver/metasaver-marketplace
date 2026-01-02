# Post-Mortem: CHB-NBA No-Barrel Consumer Migration

**Epic ID:** CHB-NBA
**Status:** In Progress
**Created:** 2026-01-02

---

## Workflow Issues Log

### Issue 1: Template Non-Compliance (2026-01-02)

**Category:** Process Failure
**Phase:** Requirements/Design

**Problem:**
Initial PRD, execution plan, and user stories were created without following the MetaSaver plugin templates. The orchestrator created documents manually instead of using the proper skill templates from:

- `plugins/metasaver-core/skills/workflow-steps/prd-creation/templates/prd-template.md`
- `plugins/metasaver-core/skills/workflow-steps/user-story-creation/templates/user-story-template.md`
- `plugins/metasaver-core/skills/workflow-steps/execution-plan-creation/templates/execution-plan-template.md`

**Root Cause:**
Orchestrator did not initially check for plugin templates and skill definitions before creating documents.

**Resolution:**
Regenerating all documents using proper templates with correct frontmatter, sections, and formatting.

**Lesson Learned:**
Always check `plugins/metasaver-core/skills/workflow-steps/*/templates/` before creating workflow documents.

---

### Issue 2: Skill Discovery Gap (2026-01-02)

**Category:** Process Failure
**Phase:** Planning

**Problem:**
The orchestrator spawned agents but did not verify they were using the correct skills. The agents (EA, BA, PM, Reviewer) created documents without referencing the skill templates.

**Root Cause:**
Agents were not instructed to read and follow the skill templates.

**Resolution:**
Re-running workflow with explicit template references passed to agents.

**Lesson Learned:**
When spawning agents, include explicit instructions to read skill templates from the plugin.

---

## Wave Logs

### Wave 1 (Not Yet Started)

_No wave execution logs yet_

### Wave 2 (Not Yet Started)

_No wave execution logs yet_

### Wave 3 (Not Yet Started)

_No wave execution logs yet_

### Wave 4 (Not Yet Started)

_No wave execution logs yet_

---

## Summary

**Issues Logged:** 2
**Issues by Category:**

- Process Failure: 2

**Patterns Identified:**

1. Template compliance must be verified before document creation
2. Skills and templates should be referenced explicitly when spawning agents

---

**Document Owner:** orchestrator
**Updated:** 2026-01-02
