# Innovation Summary Template

Display format for 1-page innovation summary during HITL review.

```
═══════════════════════════════════════════════════════════════
Innovation {N} of {total}: {title} [{RECOMMENDED} or {OPTIONAL}]
═══════════════════════════════════════════════════════════════

**Impact:** {impact} | **Effort:** {effort}
**Category:** {category}
**Industry Standard:** {industryStandard}

{onePager}

**Key Benefits:**
- {benefits[0]}
- {benefits[1]}
- {benefits[2]}

**Recommendation:** {recommendationReason}
```

## Variables

| Variable                 | Source                           | Example                        |
| ------------------------ | -------------------------------- | ------------------------------ |
| `{N}`                    | Current innovation number        | `1`                            |
| `{total}`                | Total innovations count          | `4`                            |
| `{title}`                | innovation.title                 | `Add OpenAPI Documentation`    |
| `RECOMMENDED/OPTIONAL`   | innovation.recommended (boolean) | `RECOMMENDED`                  |
| `{impact}`               | innovation.impact                | `High`                         |
| `{effort}`               | innovation.effort                | `Low`                          |
| `{category}`             | innovation.category              | `Developer Experience`         |
| `{industryStandard}`     | innovation.industryStandard      | `OpenAPI 3.0 Specification`    |
| `{onePager}`             | innovation.onePager              | `2-3 sentence description`     |
| `{benefits[0..2]}`       | innovation.benefits array        | `Auto-generate client SDKs...` |
| `{recommendationReason}` | innovation.recommendationReason  | `High impact, low effort...`   |
