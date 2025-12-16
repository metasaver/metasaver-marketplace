---
name: innovate-phase
description: Optional PRD enhancement with industry best practices. Writes PRD file, links to user, asks "Want to Innovate?" (HITL STOP). If yes, spawns innovation-advisor then walks through each innovation interactively using AskUserQuestion. Use for /build only.
---

# Innovate Phase - PRD Complete & Optional Enhancement

> **ROOT AGENT ONLY** - Called by commands only, never by subagents.

**Purpose:** Write PRD file, ask user about innovation, walk through each enhancement interactively
**Trigger:** After requirements-phase (/build only, NOT /audit)
**Input:** PRD content from requirements-phase, complexity, scope
**Output:** Final PRD path with selected innovations

---

## Workflow Steps

### Phase 1: Write & Link PRD

1. **Write PRD file:**
   - Path: `{scope[0]}/docs/prd/prd-{YYYYMMDD-HHmmss}-{slug}.md`
   - Write PRD content to file

2. **Link PRD to user:**
   - Show file path
   - Brief summary of what's in the PRD

3. **Ask: "Do you want to innovate with industry best practices?" (HARD STOP)**
   - Use AskUserQuestion with options: Yes, No
   - NO → Return PRD path (skip to design-phase)
   - YES → Continue to Phase 2

### Phase 2: Gather Innovations

4. **Spawn innovation-advisor agent:**
   - Analyze PRD against industry best practices
   - Return structured list of innovations (max 5-7)
   - Each innovation includes: title, impact, effort, 1-pager summary, detailed explanation

### Phase 3: Interactive Innovation Review

5. **For EACH innovation (one at a time):**

   a. **Display 1-pager summary:**

   ```
   ## Innovation 1 of N: [Title] [RECOMMENDED] or [OPTIONAL]

   **Impact:** High/Medium/Low | **Effort:** High/Medium/Low
   **Industry Standard:** [Reference - e.g., "OWASP API Security Top 10"]

   [1-paragraph summary of what this innovation does and why it matters]

   **Key Benefits:**
   - Benefit 1
   - Benefit 2
   - Benefit 3

   **Recommendation:** [recommendationReason from innovation-advisor]
   ```

   b. **Use AskUserQuestion:**

   If `recommended: true`:

   ```
   question: "Would you like to implement [Innovation Title]?"
   header: "Innovation"
   options:
     - label: "Implement (Recommended)"
       description: "[recommendationReason] - Add this innovation to the PRD"
     - label: "Skip"
       description: "Don't include this innovation"
     - label: "More Details"
       description: "Show expanded explanation before deciding"
   multiSelect: false
   ```

   If `recommended: false`:

   ```
   question: "Would you like to implement [Innovation Title]?"
   header: "Innovation"
   options:
     - label: "Implement"
       description: "Add this innovation to the PRD requirements"
     - label: "Skip (Recommended)"
       description: "[recommendationReason] - Skip for now"
     - label: "More Details"
       description: "Show expanded explanation before deciding"
   multiSelect: false
   ```

   c. **Handle response:**
   - **Implement** → Add to selectedInnovations list, continue to next
   - **Skip** → Continue to next innovation
   - **More Details** → Display detailed explanation, then ask again (Implement/Skip only)
   - **Other (custom text)** → Record user notes, ask if they want to implement with modifications

6. **Repeat step 5 for all innovations**

### Phase 4: Apply Selections

7. **If user selected any improvements:**
   - Spawn BA agent to update PRD with selections
   - Include any user notes/modifications
   - Update PRD file

8. **Summary to user:**
   - List innovations implemented
   - List innovations skipped
   - Confirm PRD updated

9. **Return PRD path**

---

## Innovation Advisor Output Format

The innovation-advisor agent should return structured data:

```json
{
  "innovations": [
    {
      "id": 1,
      "title": "Add OpenAPI Documentation",
      "impact": "High",
      "effort": "Low",
      "onePager": "OpenAPI (formerly Swagger) documentation provides a machine-readable API specification that enables automatic client generation, interactive documentation, and improved API discoverability. This is an industry standard for REST APIs.",
      "benefits": [
        "Auto-generate client SDKs in multiple languages",
        "Interactive API explorer for developers",
        "Contract-first development possible"
      ],
      "detailed": "Full explanation with implementation approach, examples, and considerations..."
    },
    {
      "id": 2,
      "title": "Implement Rate Limiting",
      "impact": "High",
      "effort": "Medium",
      "onePager": "Rate limiting prevents API abuse by restricting the number of requests a client can make within a time window. Essential for production APIs to ensure fair resource allocation and protection against DDoS attacks.",
      "benefits": [
        "Prevents service degradation from abuse",
        "Ensures fair resource allocation",
        "Required for most enterprise deployments"
      ],
      "detailed": "Full explanation with implementation approach, examples, and considerations..."
    }
  ]
}
```

---

## Example Interaction Flow

```
User: /build Add user authentication

[... requirements phase completes, PRD written ...]

Claude: [Asks: "Do you want to innovate with industry best practices?"]
User: Yes

[innovation-advisor returns 4 innovations with recommendations]

Claude displays each innovation 1-by-1:

## Innovation 1 of 4: Add OAuth2/OIDC Support [RECOMMENDED]

**Impact:** High | **Effort:** Medium
**Industry Standard:** OAuth 2.0 (RFC 6749), OpenID Connect 1.0

OAuth2 and OIDC enable "Sign in with Google/GitHub" functionality...

**Key Benefits:**
- Users sign in with existing accounts
- No password storage liability
- 30-50% higher conversion rates

**Recommendation:** Worth the investment - industry standard for modern auth

[AskUserQuestion: Implement (Recommended) / Skip / More Details]
User: Implement

## Innovation 2 of 4: Add MFA [OPTIONAL]

**Impact:** High | **Effort:** High
**Industry Standard:** NIST SP 800-63B

**Recommendation:** High effort - consider for v2 unless compliance requires

[AskUserQuestion: Implement / Skip (Recommended) / More Details]
User: Skip

## Innovation 3 of 4: Rate Limiting [RECOMMENDED]

**Impact:** High | **Effort:** Low
**Industry Standard:** OWASP API Security Top 10 (API4:2023)

**Recommendation:** Security-critical, low effort - implement immediately

[AskUserQuestion: Implement (Recommended) / Skip / More Details]
User: Implement

## Innovation 4 of 4: Audit Logging [OPTIONAL]

**Recommendation:** Nice-to-have, save for future iteration

[AskUserQuestion: Implement / Skip (Recommended) / More Details]
User: Skip

Claude: Updating PRD with 2 innovations (OAuth2/OIDC, Rate Limiting)...
→ BA agent updates PRD with OAuth2 + Rate Limiting
→ Continue to design-phase
```

---

## Output Format

```json
{
  "status": "complete",
  "prdPath": "docs/projects/20241208-feature/prd.md",
  "innovated": true,
  "innovationsReviewed": 4,
  "innovationsImplemented": ["OAuth2/OIDC Support", "Rate Limiting"],
  "innovationsSkipped": ["MFA", "Audit Logging"]
}
```

---

## Integration

**Called by:** /build, /ms (complexity ≥30)
**NOT called by:** /audit
**Calls:** innovation-advisor agent, business-analyst agent, AskUserQuestion
**Next phase:** design-phase
