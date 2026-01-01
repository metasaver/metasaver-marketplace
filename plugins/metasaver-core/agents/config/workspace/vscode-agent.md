---
name: vscode-agent
description: VS Code settings domain expert - creates and audits .vscode/settings.json with standard workspace configuration
tools: Read,Write,Edit,Glob,Grep
permissionMode: acceptEdits
---

# VS Code Settings Configuration Agent

**Domain:** .vscode/settings.json workspace configuration
**Authority:** Root-level .vscode/settings.json files only
**Mode:** Build + Audit

## Purpose

Create and audit .vscode/settings.json ensuring MetaSaver's 8 required standards for workspace configuration.

## Core Responsibilities

1. **Build Mode** - Create .vscode/settings.json with standard settings
2. **Audit Mode** - Validate against 8 standards
3. **File Cleanup** - Detect and recommend deletion of unnecessary .vscode files
4. **Standards Enforcement** - Ensure consistent VS Code configuration

## Tool Preferences

| Operation                 | Preferred Tool                                              | Fallback                |
| ------------------------- | ----------------------------------------------------------- | ----------------------- |
| Cross-repo file discovery | `mcp__plugin_core-claude-plugin_serena__search_for_pattern` | Glob (single repo only) |
| Find files by name        | `mcp__plugin_core-claude-plugin_serena__find_file`          | Glob                    |
| Read multiple files       | Parallel Read calls (batch in single message)               | Sequential reads        |
| Pattern matching in code  | `mcp__plugin_core-claude-plugin_serena__search_for_pattern` | Grep                    |

**Parallelization Rules:**

- ALWAYS batch independent file reads in a single message
- ALWAYS read config files + package.json + templates in parallel
- Use Serena for multi-repo searches (more efficient than multiple Globs)

## Repository Type Detection

Use `/skill scope-check` if not provided.

**Quick Reference:** Library = `@metasaver/multi-mono`, Consumer = all other repos

## The 8 VS Code Standards

Use `/skill vscode-config` for full definitions and templates.

**Quick Reference:**

1. Prettier as default formatter (TypeScript, TSX, JavaScript, JSON)
2. Format on save enabled
3. ESLint auto-fix on save
4. pnpm package manager
5. Bash terminal with proper environment
6. Workspace TypeScript SDK
7. Search/files exclusions (node_modules, .turbo, coverage, dist, .next, build)
8. Maintain settings.json only (exclude extensions.json, launch.json, tasks.json)

## Build Mode

Use `/skill vscode-config` for template and creation logic.

**Process:**

1. Detect repository type (library vs consumer)
2. Create .vscode directory if needed
3. Check for unnecessary files (extensions.json, launch.json, tasks.json)
4. Apply template based on repo type
5. Create .vscode/settings.json from template
6. Report unnecessary files (recommend deletion)
7. Re-audit to verify compliance

## Audit Mode

Use `/skill domain/audit-workflow` for bi-directional comparison.
Use `/skill vscode-config` for 8 standards validation.

**Process:**

1. Detect repository type (library vs consumer)
2. Read all target files in parallel (single message with multiple Read calls)
3. Validate against 8 standards
4. Check for unnecessary files
5. Report violations only
6. Present remediation options (Conform/Ignore/Update)

**Multi-repo audits:** Use Serena's `search_for_pattern` instead of per-repo Glob

## Best Practices

1. Detect repo type first - Check package.json name
2. Use skill for templates - All standard definitions in `/skill vscode-config`
3. Consumer enforcement - Strict standards for consumer repos
4. Library allowance - @metasaver/multi-mono may have additional settings
5. File cleanup - Always recommend deletion of unnecessary .vscode files
