---
# User Story Frontmatter - REQUIRED FIELDS
story_id: "US-{NNN}" # e.g., US-001, US-002
epic_id: "E{NN}" # e.g., E01, E02
title: "{Story Title}"
status: "pending" # pending | in-progress | complete | blocked
complexity: 0 # 1-10 score
wave: 0 # Wave number from execution-plan
agent: "{subagent_type}" # Full agent type that executes this story
dependencies: [] # List of story IDs this depends on
created: "YYYY-MM-DD"
updated: "YYYY-MM-DD"
---

# {Story ID}: {Story Title}

## User Story

**As a** {role/persona}
**I want** {feature/capability}
**So that** {benefit/value}

---

## Acceptance Criteria

- [ ] {Criterion 1}
- [ ] {Criterion 2}
- [ ] {Criterion 3}

---

## Technical Details

### Location

{Repository and package/feature path}

- **Repo:** {repo-name}
- **Package:** {package path}

### Files to Create

| File                | Purpose   |
| ------------------- | --------- |
| `{path/to/file.ts}` | {Purpose} |

### Files to Modify

| File                | Changes                  |
| ------------------- | ------------------------ |
| `{path/to/file.ts}` | {Description of changes} |

---

## Implementation Notes

{Technical guidance for the implementing agent}

### Code Example (if applicable)

```typescript
// Example implementation
```

### Dependencies

- {Dependency 1}
- {Dependency 2}

---

## Architecture

{Added by architect-agent - brief technical notes}

**API Endpoints:** (if applicable)

| Method | Endpoint             | Description   |
| ------ | -------------------- | ------------- |
| GET    | `/api/v1/{resource}` | {Description} |

**Database Models:** (if applicable)

| Model   | Fields       |
| ------- | ------------ |
| {Model} | {key fields} |

**Key Files:**

- `{path}` - {purpose}

---

## Definition of Done

- [ ] Implementation complete
- [ ] Unit tests passing
- [ ] TypeScript compiles
- [ ] Lint passes
- [ ] Acceptance criteria verified

---

## Notes

{Any additional notes, decisions, or context}

---

<!--
TEMPLATE RULES:
1. Every user story MUST have frontmatter with agent field
2. story_id format: US-{NNN} (3-digit, zero-padded)
3. epic_id format: E{NN} (2-digit, zero-padded)
4. agent field uses full subagent_type from execution-plan
5. dependencies list story IDs (e.g., ["US-001", "US-002"])
6. Architecture section added by architect-agent, not BA
7. Status updates as story progresses
8. File naming: US-{NNN}-{kebab-case-title}.md
-->
