---
name: scope-check
description: Use when determining which repositories a task affects. Scans /mnt/f/code/ to discover MetaSaver repositories and matches prompt keywords to identify where work should happen. Returns array of repository paths.
---

# Scope Check Skill

**Purpose:** Analyze a prompt and return an array of repository paths where the work should happen.

**Input:** `prompt` (string) - The user's request

**Output:** `repositories` (string[]) - Array of absolute repository paths

---

## Step 1: Discover Repositories

Scan `/mnt/f/code/` and classify each directory by reading `package.json`:

| Condition                                                                       | Type     |
| ------------------------------------------------------------------------------- | -------- |
| `name` starts with `@metasaver` AND `metasaver.applicationType` = `"libraries"` | Producer |
| `name` starts with `@metasaver` AND `metasaver.applicationType` = `"consumer"`  | Consumer |
| Directory is `claude-marketplace`                                               | Plugin   |

**CRITICAL:** Never hardcode repository names. Always discover dynamically.

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
| `resume`, `resume-builder`                                         | `/mnt/f/code/resume-builder` |
| `metasaver-com`, `metasaver.com`, `main site`                      | `/mnt/f/code/metasaver-com`  |
| `rugby`, `rugby-crm`, `commithub`                                  | `/mnt/f/code/rugby-crm`      |
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
| File path mentioned (e.g., `/mnt/f/code/resume-builder/`)     | That specific repo          |
| No matches found                                              | Current working directory   |

---

## Examples

### Example 1

```
Prompt: "Create a shared Button component"
→ Matches: "shared"
→ Output: ["/mnt/f/code/multi-mono"]
```

### Example 2

```
Prompt: "Fix the login bug in resume-builder"
→ Matches: "resume-builder"
→ Output: ["/mnt/f/code/resume-builder"]
```

### Example 3

```
Prompt: "Create a new agent for validation"
→ Matches: "agent"
→ Output: ["/mnt/f/code/claude-marketplace"]
```

### Example 4

```
Prompt: "Add a new service to commithub"
→ Matches: "service", "commithub"
→ Output: ["/mnt/f/code/rugby-crm"]
```

### Example 5

```
Prompt: "Create a custom workflow agent for resume-builder"
→ Matches: "workflow", "agent", "resume-builder"
→ Context: specific app mentioned
→ Output: ["/mnt/f/code/resume-builder"]
```

---

## Integration

Runs in Phase 1 (Analysis) parallel with complexity-check and tool-check.

Output passed to agents for workspace context.
