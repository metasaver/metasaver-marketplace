---
project_id: "MSM-WFE"
title: "Execution Plan - Workflow Enforcement"
version: "3.0"
status: "draft"
created: "2026-01-02"
total_stories: 8
total_waves: 2
---

# Execution Plan: Workflow Enforcement

## Overview

8 stories organized into 2 parallel waves. Focus on 3 enforcement mechanisms:

1. Mandatory reviewer validation gates
2. Phase transition artifact checks
3. Agent name validation

---

## Wave 1: Core Enforcement (Parallel)

All stories can run in parallel - no dependencies.

| Story | Title                                     | Agent        | Dependencies |
| ----- | ----------------------------------------- | ------------ | ------------ |
| 001   | Add mandatory reviewer gate after PRD     | skill-author | None         |
| 002   | Add mandatory reviewer gate after plan    | skill-author | None         |
| 003   | Add mandatory reviewer gate after stories | skill-author | None         |
| 004   | Add checkPhaseRequirements to state-mgmt  | skill-author | None         |
| 005   | Add validateAgentName to story creation   | skill-author | None         |
| 008   | Enforce AskUserQuestion for HITL gates    | skill-author | None         |

**Agent count:** 6 parallel skill-author agents

---

## Wave 2: Command Integration (Parallel)

Depends on Wave 1 completion.

| Story | Title                                     | Agent          | Dependencies       |
| ----- | ----------------------------------------- | -------------- | ------------------ |
| 006   | Update /build command with gate calls     | command-author | 001, 002, 003, 004 |
| 007   | Update /architect command with gate calls | command-author | 001, 002, 003, 004 |

**Agent count:** 2 parallel command-author agents

---

## Dependency Graph

```
Wave 1 (parallel):
  001 ─┐
  002 ─┤
  003 ─┼──> Wave 2 (parallel):
  004 ─┤      006
  005 ─┘      007
  008 ─┘
```

---

## Validation Gates

| After Wave | Validation                           |
| ---------- | ------------------------------------ |
| Wave 1     | Skills modified, reviewer can test   |
| Wave 2     | Commands updated, full workflow test |

---

## Agent Assignments

| Story | subagent_type                               |
| ----- | ------------------------------------------- |
| 001   | `core-claude-plugin:generic:skill-author`   |
| 002   | `core-claude-plugin:generic:skill-author`   |
| 003   | `core-claude-plugin:generic:skill-author`   |
| 004   | `core-claude-plugin:generic:skill-author`   |
| 005   | `core-claude-plugin:generic:skill-author`   |
| 006   | `core-claude-plugin:generic:command-author` |
| 007   | `core-claude-plugin:generic:command-author` |
| 008   | `core-claude-plugin:generic:skill-author`   |

---

## Simplified from v2.0

- v2.0: 25 stories, 9 epics, 4 waves
- v3.0: 8 stories, 3 enforcement points, 2 waves

---

**Document Owner:** project-manager-agent
**PRD Reference:** ./prd.md
