---
name: hitl-approval
description: Use when presenting a plan/summary to user and requesting explicit approval before proceeding. Generic approval gate for /audit, /build, /architect, /debug commands. Checks for auto-approve conditions (complexity <15 with fast-path enabled, or "do without approval" in prompt).
---

# HITL Approval Skill

> **ROOT AGENT ONLY** - Uses AskUserQuestion, runs only from root agent.

**Purpose:** Present plan/summary to user and get explicit approval before proceeding
**Trigger:** Decision point requiring human validation
**Inputs:** summary, affectedFiles, approach, complexity, fastPathEnabled
**Outputs:** approved (boolean), feedback (string)

---

## Purpose & Use Cases

Use this skill as a **generic approval gate** for any major decision:

- **After /build analysis** → Approve implementation approach
- **After /audit findings** → Approve remediation plan
- **After /architect design** → Approve technical direction
- **After /debug investigation** → Approve fix strategy

---

## When to Skip Approval

Approval is **skipped** (auto-approved) if ANY condition is met:

| Condition                             | Auto-Approve? |
| ------------------------------------- | ------------- |
| Complexity < 15 AND fastPathEnabled   | ✅ Yes        |
| Prompt contains "do without approval" | ✅ Yes        |
| Prompt contains "just do it"          | ✅ Yes        |
| Otherwise                             | ❌ No         |

---

## Workflow

### Step 1: Check Auto-Approve Conditions

```
IF complexity < 15 AND fastPathEnabled:
    RETURN { approved: true, feedback: null }

IF prompt contains "do without approval" OR "just do it":
    RETURN { approved: true, feedback: null }

CONTINUE to Step 2
```

### Step 2: Present Summary to User

Format the summary clearly with sections:

```
APPROVAL NEEDED
════════════════════════════════════════

📋 Summary:
{summary text}

📁 Affected Files:
{list of files}

🛠️  Approach:
{approach description}

Ready to proceed?
```

### Step 3: Ask for Approval

Use AskUserQuestion tool with two options:

- **APPROVE** → Continue to next phase
- **REVISE** → Collect feedback → Return to caller

### Step 4: Handle Response

**If APPROVED:**

```json
{
  "approved": true,
  "feedback": null
}
```

**If NOT APPROVED:**

```json
{
  "approved": false,
  "feedback": "User requested changes to approach - needs optimization for database queries"
}
```

### Step 5: Return to Previous Phase

If not approved, return control to calling agent with:

- `approved: false`
- `feedback: string` (user's requested changes)

Calling agent decides whether to:

- Revise and re-submit for approval
- Abandon the operation
- Loop back to investigation phase

---

## Input Schema

```json
{
  "summary": "string (2-5 sentences describing what will happen)",
  "affectedFiles": "string[] (list of file paths or patterns)",
  "approach": "string (3-5 sentences explaining HOW it will be done)",
  "complexity": "number (0-100, from complexity-check skill)",
  "fastPathEnabled": "boolean (skip approvals for low-complexity tasks)"
}
```

---

## Output Schema

```json
{
  "approved": "boolean",
  "feedback": "string | null (only if approved=false)"
}
```

---

## Examples

### Example 1: Simple Fix (Auto-Approved)

```
Inputs:
{
  "summary": "Add missing email validation to signup form",
  "affectedFiles": ["src/components/SignupForm.tsx"],
  "approach": "Add Zod schema validation before form submission",
  "complexity": 3,
  "fastPathEnabled": true
}

Processing:
  - Complexity (3) < 15 AND fastPathEnabled=true
  - Auto-approve without showing to user

Output:
{
  "approved": true,
  "feedback": null
}
```

### Example 2: Complex Change (Requires Approval)

```
Inputs:
{
  "summary": "Refactor database schema to support multi-tenancy. Affects 12 tables, requires data migration.",
  "affectedFiles": [
    "src/db/schema.ts",
    "src/migrations/",
    "src/services/user.service.ts",
    "src/services/team.service.ts"
  ],
  "approach": "1. Create new schema with tenant_id column. 2. Write migration script. 3. Deploy with blue-green strategy.",
  "complexity": 42,
  "fastPathEnabled": false
}

Processing:
  - Complexity (42) >= 15
  - fastPathEnabled=false
  - Show approval request to user

User sees:
────────────────────────────────────────
APPROVAL NEEDED
════════════════════════════════════════

📋 Summary:
Refactor database schema to support multi-tenancy. Affects 12 tables, requires data migration.

📁 Affected Files:
- src/db/schema.ts
- src/migrations/
- src/services/user.service.ts
- src/services/team.service.ts

🛠️  Approach:
1. Create new schema with tenant_id column.
2. Write migration script.
3. Deploy with blue-green strategy.

Ready to proceed?

User clicks: YES

Output:
{
  "approved": true,
  "feedback": null
}
```

### Example 3: Approval Denied with Feedback

```
User clicks: NO, requesting changes

Follow-up prompt appears:
"What changes would you like? Be specific."

User responds:
"Don't deploy with blue-green yet. Need to test with read-only mode first."

Output:
{
  "approved": false,
  "feedback": "Don't deploy with blue-green yet. Need to test with read-only mode first."
}
```

---

## Integration

**Called by:** /audit, /build, /architect, /debug commands
**Calls:** AskUserQuestion tool
**Returns:** approved (boolean), feedback (string or null)
**Previous phase:** Analysis/investigation/design complete
**Next phase:** Execution (if approved) or revision (if rejected)

---

## Notes

- **Always respect explicit user instructions** in the original prompt about approval
- **Complexity threshold is 15** for auto-approval (not negotiable)
- **fastPathEnabled** flag comes from command configuration (e.g., /build --fast)
- **AskUserQuestion** is required for this skill (only runs in root agent context)
