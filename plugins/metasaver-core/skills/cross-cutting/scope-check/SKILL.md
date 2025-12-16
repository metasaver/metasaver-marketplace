---
name: scope-check
description: Use when determining which repositories a task affects. Distinguishes between target repos (where changes happen) and reference repos (for learning patterns). Returns structured object with targets and references arrays.
---

# Scope Check Skill

**Purpose:** Analyze a prompt and return target repositories (where changes happen) vs reference repositories (for learning patterns).

**Input:** `prompt` (string) - The user's request

**Output:** `{ targets: string[], references: string[] }` - Structured object with repo paths

---

## How to Execute

This is a TEXT ANALYSIS task - analyze the prompt text as your sole input:

1. Scan the prompt for **reference indicators** (repos mentioned for pattern learning)
2. Scan the prompt for **target indicators** (repos where changes should happen)
3. Apply default: CWD is target if no explicit target mentioned
4. Return ONLY: `scope: { targets: [...], references: [...] }`
5. Complete in under 200 tokens

**Expected output format:**

```
scope: { targets: ["{CODE_ROOT}/metasaver-com"], references: ["{CODE_ROOT}/rugby-crm"] }
```

**Path Resolution:** Replace `{CODE_ROOT}` with the actual code directory (e.g., `/home/user/code/`). The calling agent provides the resolved paths.

---

## Step 1: Detect Reference Repositories

**Reference indicators** - repos mentioned for learning/copying, NOT for changes:

| Pattern                                   | Example                                  |
| ----------------------------------------- | ---------------------------------------- |
| `look at {repo}`, `check {repo}`          | "look at rugby-crm for patterns"         |
| `similar to {repo}`, `like in {repo}`     | "similar to how resume-builder does it"  |
| `follow pattern from {repo}`              | "follow the pattern from multi-mono"     |
| `reference {repo}`, `based on {repo}`     | "reference the rugby-crm implementation" |
| `how {repo} does it`, `copy from {repo}`  | "see how metasaver-com handles this"     |
| `{repo} has examples`, `{repo} shows how` | "rugby-crm has several pages like this"  |

**Key distinction:** Reference repos are mentioned WITH context clues indicating they're for learning, not changing.

---

## Step 2: Detect Target Repositories

**Target indicators** - repos where changes WILL be made:

| Pattern                                            | Example                                  |
| -------------------------------------------------- | ---------------------------------------- |
| `in {repo}`, `to {repo}`, `for {repo}`             | "add feature to metasaver-com"           |
| `update {repo}`, `fix {repo}`, `change {repo}`     | "fix the bug in resume-builder"          |
| `create in {repo}`, `build for {repo}`             | "create new component in rugby-crm"      |
| `{repo}'s {thing}`, `the {repo} {thing}`           | "the metasaver-com database"             |
| Direct path mentioned                              | "/home/user/code/resume-builder/src/..." |
| Explicit: `make changes in`, `modify`, `implement` | "implement auth in metasaver-com"        |

**Default target:** If no explicit target mentioned, use current working directory (CWD).

---

## Step 3: Known Repositories Reference

| Repository Name         | Type     | Keywords                                                |
| ----------------------- | -------- | ------------------------------------------------------- |
| `multi-mono`            | Producer | multi-mono, shared, library, config package             |
| `metasaver-com`         | Consumer | metasaver-com, metasaver.com, main site                 |
| `resume-builder`        | Consumer | resume, resume-builder                                  |
| `rugby-crm`             | Consumer | rugby, rugby-crm, commithub                             |
| `metasaver-marketplace` | Plugin   | agent, skill, command, plugin, mcp, claude, marketplace |

---

## Step 4: Handle Special Cases

| Pattern                                       | Targets                       | References |
| --------------------------------------------- | ----------------------------- | ---------- |
| No repo mentioned at all                      | [CWD]                         | []         |
| Only reference indicators found               | [CWD]                         | [matched]  |
| `sync between X and Y`, `update both X and Y` | [X, Y]                        | []         |
| `all repos`, `across all`, `all my metasaver` | [all known repos from Step 3] | []         |
| `standardize X based on Y`                    | [X]                           | [Y]        |

---

## Examples

### Example 1: Clear reference vs target

```
Prompt: "Add Applications screen to metasaver-com, look at rugby-crm for the pattern"
→ Target: "metasaver-com" (explicit target)
→ Reference: "rugby-crm" (look at = reference indicator)
→ Output: scope: { targets: ["{CODE_ROOT}/metasaver-com"], references: ["{CODE_ROOT}/rugby-crm"] }
```

### Example 2: No repo mentioned (use CWD)

```
Prompt: "Fix the login bug"
→ Target: CWD (no explicit target)
→ Reference: none
→ Output: scope: { targets: ["{CWD}"], references: [] }
```

### Example 3: Only reference mentioned

```
Prompt: "Check how rugby-crm handles authentication"
→ Target: CWD (no explicit target for changes)
→ Reference: "rugby-crm" (check how = reference indicator)
→ Output: scope: { targets: ["{CWD}"], references: ["{CODE_ROOT}/rugby-crm"] }
```

### Example 4: Multiple targets

```
Prompt: "Update scope-check skill in metasaver-marketplace and multi-mono"
→ Target: both repos (explicit update targets)
→ Reference: none
→ Output: scope: { targets: ["{CODE_ROOT}/metasaver-marketplace", "{CODE_ROOT}/multi-mono"], references: [] }
```

### Example 5: Target implicit from context

```
Prompt: "Create a shared Button component"
→ Target: multi-mono (shared = producer repo keyword)
→ Reference: none
→ Output: scope: { targets: ["{CODE_ROOT}/multi-mono"], references: [] }
```

### Example 6: Standardize pattern

```
Prompt: "Standardize error handling in resume-builder based on metasaver-com patterns"
→ Target: resume-builder (standardize in)
→ Reference: metasaver-com (based on = reference indicator)
→ Output: scope: { targets: ["{CODE_ROOT}/resume-builder"], references: ["{CODE_ROOT}/metasaver-com"] }
```

### Example 7: All repositories

```
Prompt: "audit all docker-compose files in all my metasaver repos"
→ Target: ALL known repos (detected: "all my metasaver repos")
→ Reference: none
→ Output: scope: { targets: ["{CODE_ROOT}/multi-mono", "{CODE_ROOT}/metasaver-com", "{CODE_ROOT}/resume-builder", "{CODE_ROOT}/rugby-crm", "{CODE_ROOT}/metasaver-marketplace"], references: [] }
```

### Example 8: All repos with different phrasing

```
Prompt: "standardize eslint config across all repos"
→ Target: ALL known repos (detected: "across all repos")
→ Reference: none
→ Output: scope: { targets: ["{CODE_ROOT}/multi-mono", "{CODE_ROOT}/metasaver-com", "{CODE_ROOT}/resume-builder", "{CODE_ROOT}/rugby-crm", "{CODE_ROOT}/metasaver-marketplace"], references: [] }
```

---

## Integration

Runs in Phase 1 (Analysis) parallel with complexity-check and tool-check.

Output passed to agents:

- `targets` - Repos where workers will make changes
- `references` - Repos for pattern research (read-only exploration)
