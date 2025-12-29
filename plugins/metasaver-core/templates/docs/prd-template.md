---
# PRD Frontmatter - REQUIRED FIELDS
project_id: "{PREFIX}{NNN}" # e.g., MSC015, CHB008, MUM003
title: "{Project Title}"
version: "1.0"
status: "draft" # draft | in-review | approved | in-progress | complete
complexity: 0 # 1-50 score from complexity-check
created: "YYYY-MM-DD"
updated: "YYYY-MM-DD"
owner: "business-analyst-agent" # Agent that owns this document
---

# PRD: {Project Title}

## 1. Executive Summary

{2-3 sentence overview of what this project delivers and why it matters}

**Goal:** {One sentence stating the primary objective}

---

## 2. Problem Statement

### Current State

{Describe the current situation and its limitations}

| Issue     | Impact     |
| --------- | ---------- |
| {Issue 1} | {Impact 1} |
| {Issue 2} | {Impact 2} |

### Pain Points

1. {Pain point 1}
2. {Pain point 2}
3. {Pain point 3}

---

## 3. Solution Overview

### Target State

{Describe what success looks like}

### Core Principles

| #   | Principle     | Description   |
| --- | ------------- | ------------- |
| 1   | {Principle 1} | {Description} |
| 2   | {Principle 2} | {Description} |

---

## 4. Requirements

### Functional Requirements

| ID     | Requirement   | Priority |
| ------ | ------------- | -------- |
| FR-001 | {Requirement} | P0/P1/P2 |
| FR-002 | {Requirement} | P0/P1/P2 |

### Non-Functional Requirements

| ID      | Requirement   | Priority |
| ------- | ------------- | -------- |
| NFR-001 | {Requirement} | P0/P1/P2 |

### Data Model (if applicable)

| Field   | Type   | Required | Description   |
| ------- | ------ | -------- | ------------- |
| {field} | {type} | Yes/No   | {description} |

---

## 5. Scope

### In Scope

1. {In scope item 1}
2. {In scope item 2}

### Out of Scope

1. {Out of scope item 1}
2. {Out of scope item 2}

---

## 6. Epic Summary

{Brief list of epics - details go in execution-plan.md and user-stories/}

| Epic ID | Title          | Story Count | Complexity |
| ------- | -------------- | ----------- | ---------- |
| E01     | {Epic 1 Title} | {N}         | {X}        |
| E02     | {Epic 2 Title} | {N}         | {X}        |

**Total Complexity:** {Sum}

---

## 7. Success Criteria

### Technical Requirements

- [ ] {Technical requirement 1}
- [ ] {Technical requirement 2}

### Verification

- [ ] `pnpm build` succeeds
- [ ] `pnpm lint` passes
- [ ] `pnpm test` passes

### Metrics

| Metric     | Target         |
| ---------- | -------------- |
| {Metric 1} | {Target value} |

---

## 8. Risks & Mitigations

| Risk     | Impact       | Likelihood   | Mitigation   |
| -------- | ------------ | ------------ | ------------ |
| {Risk 1} | High/Med/Low | High/Med/Low | {Mitigation} |

---

## 9. Dependencies

### External

- {External dependency 1}

### Internal

- {Internal dependency 1}

---

## 10. Design Decisions (HITL)

| Decision         | Choice        | Rationale |
| ---------------- | ------------- | --------- |
| {Decision point} | {Choice made} | {Why}     |

---

**Document Owner:** business-analyst-agent
**Review Status:** {Pending | Approved}

---

<!--
TEMPLATE RULES:
1. PRD contains REQUIREMENTS ONLY - no user story details
2. Epic summary lists epics but does NOT include acceptance criteria
3. User stories go in /user-stories/ folder
4. Architect adds technical notes via inline "Architecture:" subsections
5. Frontmatter MUST include owner agent
6. Status field tracks document lifecycle
7. Complexity score from complexity-check agent
-->
