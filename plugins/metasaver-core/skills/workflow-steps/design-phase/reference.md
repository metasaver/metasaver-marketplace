# Design Phase Reference

## Story Granularity Guidelines

**ALWAYS create stories by functional capability, not by package/layer.**

| Approach         | Result                              |
| ---------------- | ----------------------------------- |
| Package-based    | Bottlenecks, sequential execution   |
| Capability-based | Parallel execution, smaller stories |

**Rules:**

1. **Stories = Testable Units**: Each story independently testable
2. **Max 15-20 min per story**: Break down larger stories
3. **Parallel by default**: Stories in same wave run concurrently
4. **Dependency-aware**: Use `dependencies` field in frontmatter

**Example - Good (capability-based):**

```
prj-epc-001: Database schema       -> Wave 1 (parallel)
prj-epc-002: Contracts types       -> Wave 1 (parallel)
prj-epc-003: Workflow scaffolding  -> Wave 2
prj-epc-004: Height/weight parser  -> Wave 2 (parallel)
prj-epc-005: Team fuzzy matching   -> Wave 2 (parallel)
```

## Validation Gate Pattern

Each validation gate follows this pattern:

1. Spawn reviewer agent
2. Reviewer invokes document-validation skill
3. If valid: Continue to next step
4. If invalid: Return issues to authoring agent
5. Authoring agent fixes issues
6. Loop back to validation
