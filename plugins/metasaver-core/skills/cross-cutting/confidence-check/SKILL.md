---
name: confidence-check
description: Pre-implementation confidence assessment to prevent wrong-direction execution. Automatically invoked for complexity score ≥15. Performs 5 weighted checks (no duplicate implementations 25%, MetaSaver pattern compliance 25%, architecture verified 20%, similar implementations found 15%, requirements clear 15%). Requires ≥90% confidence to proceed, 70-89% triggers clarification, <70% stops execution. ROI of 25-250x token savings by catching misaligned work early. Use when complexity score ≥15 to validate implementation direction before spawning agents.
---

# Confidence Check - Pre-Implementation Assessment

**Purpose:** Prevent wrong-direction execution by assessing confidence BEFORE implementation.
**Trigger:** Automatically invoked for complexity score ≥15 (medium-complex tasks)
**Threshold:** Requires ≥90% confidence to proceed

## ROI

**Cost:** 100-200 tokens for assessment
**Savings:** 5,000-50,000 tokens on wrong-direction work
**ROI:** 25-250x token savings when stopping misaligned execution

---

## Assessment Protocol

When invoked, Claude MUST complete these 5 checks and calculate confidence score:

### 1. No Duplicate Implementations (25%)

**Action:** Search codebase for existing functionality

```bash
# Required searches before implementation:
Grep "function_name" --path /mnt/f/code/{project}
Glob "**/*{feature_keyword}*" --path /mnt/f/code/{project}
```

**Pass if:** No existing implementation found OR existing code clearly insufficient

**Fail if:** Similar functionality already exists (reinventing the wheel)

---

### 2. MetaSaver Pattern Compliance (25%)

**Action:** Verify solution uses established patterns

```bash
# Check Serena memories for patterns:
list_memories()  # Find pattern-*.md and decision-*.md files
read_memory({ memory_file_name: "pattern-{task_type}.md" })

# OR read relevant MULTI-MONO.md section:
Read /mnt/f/code/{project}/docs/architecture/MULTI-MONO.md
```

**Pass if:**

- Package naming uses `@metasaver` scope
- Dependencies use `workspace:*` protocol
- Environment uses centralized root `.env`
- Database URLs follow `{PROJECT}_DATABASE_URL` pattern

**Fail if:** Solution introduces non-standard patterns

---

### 3. Architecture Verified (20%)

**Action:** Confirm understanding of project architecture

```bash
# Read project CLAUDE.md:
Read /mnt/f/code/{project}/CLAUDE.md

# Check workspace structure:
Bash "pnpm list -r --depth 0" --path /mnt/f/code/{project}
```

**Pass if:**

- Technology stack understood (Turborepo, pnpm, Prisma, etc.)
- Target workspace identified
- Dependencies mapped

**Fail if:** Unclear which workspace to modify or how pieces connect

---

### 4. Similar Implementations Found (15%)

**Action:** Find existing examples in other multi-monos

```bash
# Search across all multi-monos:
Grep "{feature_pattern}" --path /mnt/f/code/metasaver-com
Grep "{feature_pattern}" --path /mnt/f/code/rugby-crm
Grep "{feature_pattern}" --path /mnt/f/code/multi-mono
```

**Pass if:** Found similar working implementation to reference

**Fail if:** No examples found AND this is a novel pattern

---

### 5. Requirements Clear (15%)

**Action:** Verify user intent is unambiguous

**Pass if:**

- Task objective clearly stated
- Success criteria defined
- Edge cases considered
- No conflicting requirements

**Fail if:** Ambiguous requirements or multiple interpretations possible

---

## Scoring & Decision

Calculate total confidence score:

```
Score = (Check1 × 0.25) + (Check2 × 0.25) + (Check3 × 0.20) + (Check4 × 0.15) + (Check5 × 0.15)
```

### Decision Matrix

| Score      | Action     | Output                                                            |
| ---------- | ---------- | ----------------------------------------------------------------- |
| **≥90%**   | ✅ PROCEED | "High confidence - proceeding with implementation"                |
| **70-89%** | ⚠️ CLARIFY | Present gaps and ask user for clarification before proceeding     |
| **<70%**   | ❌ STOP    | "Low confidence - investigation incomplete" + list missing checks |

---

## Output Format

```markdown
## 📋 Confidence Assessment

**Task:** {user's request}
**Complexity Score:** {calculated score}

### Checklist:

- [ ] **No duplicates (25%)**: {status + evidence}
- [ ] **Pattern compliance (25%)**: {status + evidence}
- [ ] **Architecture verified (20%)**: {status + evidence}
- [ ] **Examples found (15%)**: {status + evidence}
- [ ] **Requirements clear (15%)**: {status + evidence}

**Total Confidence: {X}%**

### Recommendation:

{✅ PROCEED / ⚠️ CLARIFY / ❌ STOP}

{If <90%: List specific gaps to address}
```

---

## When to Skip

**DO NOT run confidence check for:**

- Simple tasks (complexity <15)
- Pure research/exploration tasks
- Single file edits
- Debugging/fixing existing code
- Documentation requests

**ALWAYS run confidence check for:**

- New feature implementation
- API development
- Database schema changes
- Multi-workspace changes
- Architecture decisions
- System-wide refactoring

---

## Integration with /ms Command

```
/ms "{complex task}"
↓
1. Calculate complexity score
2. IF score ≥ 15:
   → Invoke confidence-check skill
   → IF confidence ≥ 90%: proceed to routing
   → ELSE: output gaps, wait for clarification
3. ELSE:
   → Skip check, proceed directly
```
