---
name: scope-check
description: Use when determining which repositories a task affects. Scans /mnt/f/code/ to discover MetaSaver repositories and matches prompt keywords to identify where work should happen. Returns array of repository paths.
---

# Scope Check Skill

**Purpose:** Analyze a prompt and return an array of repository paths where the work should happen.

**Input:** `prompt` (string) - The user's request

**Output:** `repositories` (string[]) - Array of absolute repository paths

---

## How to Execute

This is a TEXT ANALYSIS task - analyze the prompt text as your sole input:

1. Scan the prompt text (case-insensitive) for repository keywords in the matching tables below
2. Match prompt keywords to repository names using the reference tables
3. Return ONLY: `repos: [...]`
4. Complete in under 200 tokens

**Expected output format:**

```
repos: ["{CODE_ROOT}/resume-builder", "{CODE_ROOT}/metasaver-com"]
```

Work exclusively with the prompt text and keyword tables as your sole input. Use pattern matching and return your answer immediately.

**Path Resolution:** Replace `{CODE_ROOT}` with the actual code directory (e.g., `/home/user/code/` or `/mnt/f/code/`). The calling agent provides the resolved paths.

---

## Step 1: Known Repositories Reference

Use this table to identify repositories:

| Repository Name      | Type     | Keywords                                    |
| -------------------- | -------- | ------------------------------------------- |
| `multi-mono`         | Producer | multi-mono, shared, library, config package |
| `metasaver-com`      | Consumer | metasaver-com, metasaver.com, main site     |
| `resume-builder`     | Consumer | resume, resume-builder                      |
| `rugby-crm`          | Consumer | rugby, rugby-crm, commithub                 |
| `claude-marketplace` | Plugin   | agent, skill, command, plugin, mcp, claude  |

**Note:** This is a static reference. New repositories must be added to this table manually.

---

## Step 2: Match Prompt to Repositories

Scan prompt for keywords and return matching repositories:

### Producer Repository (multi-mono)

| Keywords                                                                                 |
| ---------------------------------------------------------------------------------------- |
| `multi-mono`, `shared`, `library`, `config package`, `shared component`, `shared config` |

### Consumer Repositories

| Keywords                                                           | Repository                   |
| ------------------------------------------------------------------ | ---------------------------- |
| `resume`, `resume-builder`                                         | `{CODE_ROOT}/resume-builder` |
| `metasaver-com`, `metasaver.com`, `main site`                      | `{CODE_ROOT}/metasaver-com`  |
| `rugby`, `rugby-crm`, `commithub`                                  | `{CODE_ROOT}/rugby-crm`      |
| `service`, `backend service`, `api endpoint`, `database`, `prisma` | All consumer repos           |
| `workflow`, `custom mcp`, `consumer agent`                         | All consumer repos           |

### Plugin Repository (claude-marketplace)

| Keywords                                                                     |
| ---------------------------------------------------------------------------- |
| `agent`, `skill`, `command`, `plugin`, `mcp server`, `claude`, `marketplace` |

### Ambiguous Keywords (need context)

| Keywords            | Default            | Context Override                              |
| ------------------- | ------------------ | --------------------------------------------- |
| `agent`, `workflow` | claude-marketplace | If mentions specific app name → that consumer |
| `mcp`               | claude-marketplace | If "custom mcp" → consumer repos              |

---

## Step 3: Handle Special Cases

| Pattern                                                       | Return                      |
| ------------------------------------------------------------- | --------------------------- |
| `all repos` / `every repo` / `across all` / `entire codebase` | All discovered repositories |
| `all consumer` / `all applications`                           | All consumer-type repos     |
| `standardize` / `migrate` + `across`                          | Producer + all consumers    |
| File path mentioned (e.g., `{CODE_ROOT}/resume-builder/`)     | That specific repo          |
| No matches found                                              | Current working directory   |

---

## Examples

### Example 1

```
Prompt: "Create a shared Button component"
→ Matches: "shared"
→ Output: repos: ["{CODE_ROOT}/multi-mono"]
```

### Example 2

```
Prompt: "Fix the login bug in resume-builder"
→ Matches: "resume-builder"
→ Output: repos: ["{CODE_ROOT}/resume-builder"]
```

### Example 3

```
Prompt: "Create a new agent for validation"
→ Matches: "agent"
→ Output: repos: ["{CODE_ROOT}/claude-marketplace"]
```

### Example 4

```
Prompt: "Add a new service to commithub"
→ Matches: "service", "commithub"
→ Output: repos: ["{CODE_ROOT}/rugby-crm"]
```

### Example 5

```
Prompt: "Create a custom workflow agent for resume-builder"
→ Matches: "workflow", "agent", "resume-builder"
→ Context: specific app mentioned
→ Output: repos: ["{CODE_ROOT}/resume-builder"]
```

---

## Integration

Runs in Phase 1 (Analysis) parallel with complexity-check and tool-check.

Output passed to agents for workspace context.
