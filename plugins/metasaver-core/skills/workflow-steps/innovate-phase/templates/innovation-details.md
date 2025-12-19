# Innovation Details Template

Display format for detailed innovation explanation (shown when user chooses "More Details").

```
═══════════════════════════════════════════════════════════════
{title} - Detailed Explanation
═══════════════════════════════════════════════════════════════

**Current Approach:**
{detailed.currentApproach}

**Suggested Improvement:**
{detailed.suggestedImprovement}

**Rationale:**
{detailed.rationale}

**Implementation Approach:**
1. {detailed.implementationApproach[0]}
2. {detailed.implementationApproach[1]}
3. {detailed.implementationApproach[2]}
...

**Architecture Impact:**
- {detailed.architectureImpact[0]}
- {detailed.architectureImpact[1]}
...

**Effort Breakdown:**
{detailed.effortBreakdown.setup}: {time}
{detailed.effortBreakdown.implementation}: {time}
{detailed.effortBreakdown.testing}: {time}
Total: {detailed.effortBreakdown.total}

**Considerations:**
- {detailed.considerations[0]}
- {detailed.considerations[1]}
...
```

## Variables

All variables come from the `innovation.detailed` object returned by innovation-advisor agent.

| Variable                            | Type     | Example                                |
| ----------------------------------- | -------- | -------------------------------------- |
| `{title}`                           | string   | `Add OpenAPI Documentation`            |
| `{detailed.currentApproach}`        | string   | `No API documentation in PRD`          |
| `{detailed.suggestedImprovement}`   | string   | `Generate OpenAPI 3.0 spec...`         |
| `{detailed.rationale}`              | string   | `Industry standard for API docs...`    |
| `{detailed.implementationApproach}` | string[] | Array of step-by-step instructions     |
| `{detailed.architectureImpact}`     | string[] | Array of architectural changes         |
| `{detailed.effortBreakdown}`        | object   | Object with phase: time mappings       |
| `{detailed.considerations}`         | string[] | Array of important decisions/tradeoffs |

## Notes

- After showing this view, return to HITL question with only "Implement" and "Skip" options (remove "More Details")
- User has now seen full context and must make a decision
