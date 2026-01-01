---
project_id: "MSM-BAM"
title: "Batch Audit Mode Enhancement"
version: "1.0"
status: "draft"
created: "2025-12-30"
updated: "2025-12-30"
owner: "enterprise-architect-agent"
---

# PRD: Batch Audit Mode Enhancement

## 1. Executive Summary

Enhance the `/audit` command with a batch audit mode that enables efficient auditing across multiple repositories and config agents without per-discrepancy interactive prompts. This addresses the scaling problem where auditing N config agents across M repositories generates up to N x M x D interactive questions (where D = discrepancies per audit), making cross-repo compliance audits impractical.

**Goal:** Enable users to audit all config agents across multiple consumer repositories with minimal interaction, generating comprehensive reports and applying batch decisions by pattern.

---

## 2. Problem Statement

### Current State

The `/audit` command implements a thorough per-discrepancy HITL (Human-in-the-Loop) workflow via the `audit-resolution` skill. For each discrepancy found, the system prompts the user with 4 options: [1] Apply template, [2] Update template, [3] Ignore, [4] Custom instruction. This works well for single-repo or single-config audits.

| Issue                      | Impact                                                           |
| -------------------------- | ---------------------------------------------------------------- |
| Per-discrepancy prompts    | 28 config agents x 4 repos x avg 3 discrepancies = 336 questions |
| No report-only mode        | Cannot preview scope without committing to HITL loop             |
| No pattern-based decisions | Same decision must be made repeatedly for similar violations     |
| No progress tracking       | No way to resume interrupted multi-repo audits                   |
| Context window exhaustion  | Large audits consume tokens on repetitive prompts                |

### Pain Points

1. **User fatigue:** Answering hundreds of similar questions for the same violation pattern across repos
2. **No preview:** Cannot see the full scope of discrepancies before deciding how to handle them
3. **Lost progress:** If session ends mid-audit, must restart from beginning
4. **Inconsistent decisions:** Easy to make different decisions for identical violations across repos
5. **Time investment:** Multi-repo audits can take hours of interactive time

---

## 3. Solution Overview

### Target State

Users can run `/audit --dry-run` to generate a comprehensive discrepancy report without prompts, then apply batch decisions using pattern matching (e.g., "apply template to all eslint violations across all repos"). Progress is tracked so audits can resume if interrupted. The existing per-discrepancy HITL mode remains available for detailed control.

### Core Principles

| #   | Principle              | Description                                                     |
| --- | ---------------------- | --------------------------------------------------------------- |
| 1   | Progressive disclosure | Dry-run first, then batch or individual decisions               |
| 2   | Pattern matching       | Apply same decision to matching violations (by agent, severity) |
| 3   | Resumable workflows    | Track progress in state file, enable continuation               |
| 4   | Backward compatible    | Existing per-discrepancy mode unchanged as default              |
| 5   | Report-first           | Always generate report before any remediation                   |

---

## 4. Requirements

### Functional Requirements

| ID     | Requirement                                                                                   | Priority |
| ------ | --------------------------------------------------------------------------------------------- | -------- |
| FR-001 | Dry-run mode: Run investigation phase and generate report without prompts                     | P0       |
| FR-002 | Report output: Generate markdown report with all discrepancies grouped by repo/agent/severity | P0       |
| FR-003 | Batch decision: Apply same decision to multiple discrepancies matching a pattern              | P0       |
| FR-004 | Pattern types: Support patterns by agent, severity, repo, or combination                      | P0       |
| FR-005 | Progress tracking: Persist audit state (repos audited, discrepancies, decisions)              | P1       |
| FR-006 | Resume capability: Continue interrupted audit from saved state                                | P1       |
| FR-007 | Report location: Save reports to `docs/audits/{date}-{scope}.md`                              | P1       |
| FR-008 | Summary view: Display aggregated counts before batch decision prompts                         | P0       |
| FR-009 | Confirm before apply: Require explicit confirmation before batch remediation                  | P0       |
| FR-010 | Mixed mode: Allow batch decisions for some patterns, individual for others                    | P2       |

### Non-Functional Requirements

| ID      | Requirement                                                            | Priority |
| ------- | ---------------------------------------------------------------------- | -------- |
| NFR-001 | Investigation phase completes for all repos before any prompting       | P0       |
| NFR-002 | Report generation under 30 seconds for typical 4-repo audit            | P1       |
| NFR-003 | State file format: JSON, human-readable, under 100KB for typical audit | P1       |
| NFR-004 | Backward compatible: `/audit` without flags behaves as current         | P0       |

### Data Model

| Field         | Type                                           | Required | Description                          |
| ------------- | ---------------------------------------------- | -------- | ------------------------------------ |
| audit_id      | string                                         | Yes      | Unique identifier for audit run      |
| mode          | enum: "interactive", "dry-run", "batch"        | Yes      | Audit execution mode                 |
| scope         | object: { repos: string[], agents: string[] }  | Yes      | What was audited                     |
| status        | enum: "in-progress", "complete", "interrupted" | Yes      | Current audit state                  |
| discrepancies | Discrepancy[]                                  | Yes      | All findings from investigation      |
| decisions     | Decision[]                                     | No       | User decisions (batch or individual) |
| created_at    | string (ISO date)                              | Yes      | When audit started                   |
| updated_at    | string (ISO date)                              | Yes      | Last state update                    |

---

## 5. Scope

### In Scope

1. Dry-run mode flag (`--dry-run` or `--report-only`) for investigation without prompts
2. Report generation with discrepancies grouped by repo, agent, severity
3. Batch decision interface for applying decisions by pattern
4. Pattern matching by: agent name, severity level, repository, field name
5. State persistence in `docs/audits/.audit-state/{audit-id}.json`
6. Resume capability via `/audit --resume`
7. Summary statistics display before decision prompting
8. Integration with existing audit-resolution skill (as fallback/detailed mode)

### Out of Scope

1. Parallel remediation across repos (remediation remains sequential)
2. Scheduled/automated audits (future enhancement)
3. Git integration for automatic PR creation per repo (manual for now)
4. Cross-repo template synchronization (handled by template-update skill)
5. Web UI for audit management (CLI only)
6. Notification system for audit completion
7. Audit history/trending (single audit scope only)

---

## 6. Epic Summary

| Epic ID | Title                    | Story Count | Complexity |
| ------- | ------------------------ | ----------- | ---------- |
| E01     | Dry-Run Mode             | 3           | 8          |
| E02     | Report Generation        | 3           | 10         |
| E03     | Batch Decision Interface | 4           | 15         |
| E04     | Progress Tracking        | 3           | 8          |
| E05     | Command Integration      | 2           | 5          |

**Total Complexity:** 46

---

## 7. Success Criteria

### Technical Requirements

- [ ] `/audit --dry-run` completes investigation for all in-scope repos without prompting
- [ ] Report file generated at `docs/audits/{date}-{scope}.md` with all discrepancies
- [ ] Batch decision pattern matching works for agent, severity, repo filters
- [ ] State file persisted after investigation phase completes
- [ ] Resume from state file recovers all discrepancies and prior decisions
- [ ] Existing `/audit` command (no flags) behaves identically to current implementation

### Verification

- [ ] `pnpm build` succeeds (N/A for markdown-only changes)
- [ ] Manual test: dry-run across 4 consumer repos completes without prompts
- [ ] Manual test: batch decision "apply all eslint" affects only eslint discrepancies
- [ ] Manual test: resume after interruption recovers full state

### Metrics

| Metric                               | Target                             |
| ------------------------------------ | ---------------------------------- |
| User prompts for 4-repo full audit   | < 10 (batch mode) vs 336 (current) |
| Time to view full discrepancy report | < 2 minutes (dry-run mode)         |
| Audit completion rate                | 100% (with resume capability)      |

---

## 8. Risks & Mitigations

| Risk                                    | Impact | Likelihood | Mitigation                                     |
| --------------------------------------- | ------ | ---------- | ---------------------------------------------- |
| Batch decision applies unintended fixes | High   | Med        | Require explicit confirm before batch apply    |
| State file corruption loses progress    | Med    | Low        | JSON validation on read, backup before write   |
| Large audits exhaust context window     | Med    | Med        | Compact state between phases, use waves        |
| Pattern matching too coarse/fine        | Med    | Med        | Provide preview of matched discrepancies first |
| Breaking existing audit workflow        | High   | Low        | Flag-based opt-in, default unchanged           |

---

## 9. Dependencies

### External

- No external dependencies

### Internal

- `/audit` command (base command to extend)
- `audit-investigation` skill (provides discrepancy discovery)
- `audit-resolution` skill (fallback for per-discrepancy mode)
- `audit-remediation` skill (applies decisions)
- State management pattern from workflow-state.json

---

## 10. Design Decisions (HITL)

| Decision             | Choice                                          | Rationale                                                   |
| -------------------- | ----------------------------------------------- | ----------------------------------------------------------- |
| Dry-run flag name    | `--dry-run`                                     | Standard convention, clear meaning                          |
| Report format        | Markdown with tables                            | Human-readable, version-controllable, consistent with docs/ |
| State file location  | `docs/audits/.audit-state/`                     | Colocated with reports, gitignore-able                      |
| Batch pattern syntax | Filter flags: `--agent`, `--severity`, `--repo` | Explicit, composable, CLI-friendly                          |
| Default mode         | Interactive (current behavior)                  | Backward compatibility, explicit opt-in to batch            |
| Resume mechanism     | `--resume` flag with optional audit-id          | Simple, supports multiple interrupted audits                |

---

**Document Owner:** enterprise-architect-agent
**Review Status:** Pending

---

<!--
TEMPLATE RULES:
1. PRD contains REQUIREMENTS ONLY - no user story details
2. Epic summary lists epics but does NOT include acceptance criteria
3. User stories go in /user-stories/ folder
4. Architect adds technical notes via inline "Architecture:" subsections
5. Frontmatter MUST include owner agent
6. Status field tracks document lifecycle
-->
