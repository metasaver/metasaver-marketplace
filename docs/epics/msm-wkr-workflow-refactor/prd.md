---
epic_id: "msm-wkr"
title: "Workflow Refactor - Agent/Skill Separation & Template Enforcement"
version: "1.0"
status: "draft"
created: "2024-12-29"
updated: "2024-12-29"
owner: "enterprise-architect-agent"
---

# PRD: Workflow Refactor - Agent/Skill Separation & Template Enforcement

## 1. Executive Summary

Refactor the MetaSaver plugin workflow to enforce consistent documentation standards through proper agent/skill separation. This epic introduces an Enterprise Architect (EA) agent for PRD creation, refactors the Business Analyst (BA) to focus on story decomposition, creates template-wrapping skills with built-in validation, and removes deprecated complexity/tool check skills.

**Goal:** Ensure all PRDs, execution plans, and user stories follow standardized templates with validation gates before HITL approval.

---

## 2. Problem Statement

### Current State

Documentation created by agents is inconsistent:

- PRDs contain embedded user stories (should be requirements only)
- Frontmatter is missing or incomplete (no agent assignments)
- Templates exist in `templates/docs/` but are not referenced by agents
- BA agent handles too many responsibilities (PRD + stories)
- Complexity-check and tool-check skills add overhead without value

| Issue                  | Impact                                           |
| ---------------------- | ------------------------------------------------ |
| User stories in PRDs   | Bloated PRDs, unclear separation of concerns     |
| Missing frontmatter    | Can't identify document owner or executing agent |
| Templates not enforced | Inconsistent structure across epics              |
| BA overloaded          | Poor separation of strategic vs tactical work    |

### Pain Points

1. Documents don't follow templates despite templates existing
2. No validation before HITL - user sees malformed docs
3. Agent responsibilities overlap (BA does PRD + stories)
4. Deprecated skills (complexity-check, tool-check) clutter codebase

---

## 3. Solution Overview

### Target State

Clean separation of concerns:

- **EA Agent**: Creates PRDs (strategic, requirements-focused)
- **Architect Agent**: Adds technical annotations (unchanged)
- **BA Agent**: Decomposes PRD into user stories (tactical)
- **PM Agent**: Creates execution plans with wave assignments
- **Standards Reviewer**: Validates documents before HITL

Skills wrap templates and provide validation:

- `prd-creation-skill`: Template + process + validation
- `execution-plan-skill`: Template + process + validation
- `user-story-creation-skill`: Template + process + validation
- `document-validation-skill`: Validation checklists for all types

### Core Principles

| #   | Principle                    | Description                            |
| --- | ---------------------------- | -------------------------------------- |
| 1   | Single Responsibility        | Each agent has one clear domain        |
| 2   | Templates as Source of Truth | Skills wrap templates, don't duplicate |
| 3   | Validate Before HITL         | User sees only valid documents         |
| 4   | Remove Dead Code             | Delete unused complexity/tool checks   |

---

## 4. Requirements

### Functional Requirements

| ID     | Requirement                                                        | Priority |
| ------ | ------------------------------------------------------------------ | -------- |
| FR-001 | Create Enterprise Architect (EA) agent for PRD creation            | P0       |
| FR-002 | Create prd-creation-skill that wraps prd-template.md               | P0       |
| FR-003 | Create execution-plan-skill that wraps execution-plan-template.md  | P0       |
| FR-004 | Create user-story-creation-skill that wraps user-story-template.md | P0       |
| FR-005 | Create document-validation-skill with checklists                   | P0       |
| FR-006 | Refactor BA agent to focus on story decomposition only             | P0       |
| FR-007 | Enhance reviewer agent with document validation capability         | P1       |
| FR-008 | Remove complexity-check skill and all references                   | P0       |
| FR-009 | Remove tool-check skill and all references                         | P0       |
| FR-010 | Update /build command to always run full workflow                  | P0       |
| FR-011 | Update /architect command to make innovation optional              | P1       |
| FR-012 | Update /ms command with intelligent routing                        | P1       |
| FR-013 | Audit all agents for correct tools (match .mcp.json)               | P1       |

### Non-Functional Requirements

| ID      | Requirement                                                              | Priority |
| ------- | ------------------------------------------------------------------------ | -------- |
| NFR-001 | Skills must reference templates, not duplicate content                   | P0       |
| NFR-002 | Validation must complete in <5 seconds                                   | P1       |
| NFR-003 | All heavy workflows (/build, /architect, /audit) use sequential-thinking | P0       |

---

## 5. Scope

### In Scope

1. Create EA agent with proper tools (Serena, Context7, sequential-thinking)
2. Create 4 new skills (prd-creation, execution-plan, user-story-creation, document-validation)
3. Refactor BA agent (remove PRD creation)
4. Enhance reviewer agent (add document validation)
5. Delete complexity-check and tool-check skills
6. Update /build, /architect, /ms commands
7. Audit all agents for correct tool assignments

### Out of Scope

1. Changes to /qq command (already lightweight)
2. Changes to /audit command workflow (separate epic)
3. Migration of existing epic docs to new format
4. Changes to execution-phase or tdd-execution skills

---

## 6. Story Summary

| Story ID    | Title                              | Wave | Priority |
| ----------- | ---------------------------------- | ---- | -------- |
| MSM-WKR-001 | Delete complexity-check skill      | 1    | P0       |
| MSM-WKR-002 | Delete tool-check skill            | 1    | P0       |
| MSM-WKR-003 | Create enterprise-architect agent  | 2    | P0       |
| MSM-WKR-004 | Create prd-creation-skill          | 2    | P0       |
| MSM-WKR-005 | Create document-validation-skill   | 2    | P0       |
| MSM-WKR-006 | Create execution-plan-skill        | 3    | P0       |
| MSM-WKR-007 | Create user-story-creation-skill   | 3    | P0       |
| MSM-WKR-008 | Refactor business-analyst agent    | 4    | P0       |
| MSM-WKR-009 | Enhance reviewer agent             | 4    | P1       |
| MSM-WKR-010 | Update requirements-phase skill    | 4    | P0       |
| MSM-WKR-011 | Update design-phase skill          | 4    | P0       |
| MSM-WKR-012 | Update /build command              | 5    | P0       |
| MSM-WKR-013 | Update /architect command          | 5    | P0       |
| MSM-WKR-014 | Update /ms command                 | 5    | P1       |
| MSM-WKR-015 | Remove refs from /qq and /audit    | 5    | P1       |
| MSM-WKR-016 | Audit all agents for correct tools | 5    | P0       |

**Total Stories:** 16

---

## 7. Success Criteria

### Technical Requirements

- [ ] EA agent can create PRDs using prd-creation-skill
- [ ] BA agent creates stories using user-story-creation-skill
- [ ] PM agent creates plans using execution-plan-skill
- [ ] Standards Reviewer validates docs before HITL
- [ ] All documents pass validation before user sees them
- [ ] No references to complexity-check or tool-check remain

### Verification

- [ ] All agents have correct tools per .mcp.json
- [ ] Templates are referenced (not duplicated) in skills
- [ ] /build runs full workflow without complexity routing

---

## 8. Risks & Mitigations

| Risk                              | Impact | Likelihood | Mitigation                      |
| --------------------------------- | ------ | ---------- | ------------------------------- |
| Breaking existing workflows       | High   | Medium     | Test each command after changes |
| Circular dependencies in refactor | Medium | Low        | Careful ordering of changes     |
| Agent tool mismatches             | Medium | Medium     | Audit .mcp.json first           |

---

## 9. Dependencies

### External

- None

### Internal

- Existing templates in `templates/docs/` (already exist)
- Existing agents (architect, business-analyst, project-manager, reviewer)
- Existing commands (/build, /architect, /ms)

---

## 10. Design Decisions (HITL)

| Decision                | Choice              | Rationale                              |
| ----------------------- | ------------------- | -------------------------------------- |
| EA vs extending BA      | Create new EA agent | Cleaner separation, BA already complex |
| Skills wrap templates   | Yes                 | Single source of truth, DRY principle  |
| Remove complexity-check | Yes                 | /build always full, no routing needed  |
| Innovation optional     | Ask user            | Not everyone needs innovation phase    |

---

**Document Owner:** enterprise-architect-agent
**Review Status:** Pending
