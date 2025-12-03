---
name: vscode-config
description: VS Code workspace settings template and validation logic with file cleanup enforcement. Includes 8 required standards (Prettier as default formatter, format on save enabled, ESLint auto-fix, pnpm package manager, terminal configuration, TypeScript workspace SDK, search exclusions, only settings.json required). Critical Rule 8 enforces deletion of unnecessary files (extensions.json, launch.json, tasks.json). Use when creating or auditing .vscode/settings.json files and detecting unnecessary workspace files.
---

# VS Code Workspace Configuration Skill

This skill provides VS Code settings.json template and validation logic for consistent development environment across repositories.

## Purpose

Manage .vscode/settings.json configuration to:

- Configure Prettier as default formatter for all languages
- Enable format on save and auto-fix on save
- Set up ESLint auto-fix integration
- Configure pnpm as package manager
- Set up terminal environment and profiles
- Configure TypeScript workspace SDK
- Define search and file exclusions
- Ensure only settings.json exists (no unnecessary files)

## Usage

This skill is invoked by the `vscode-agent` when:

- Creating new .vscode/settings.json files
- Auditing existing VS Code workspace settings
- Validating settings against standards
- Detecting unnecessary files in .vscode directory

## Template

The standard VS Code settings template is located at:

```
templates/settings.template.json
```

## The 8 VS Code Standards

### Rule 1: Prettier as Default Formatter

**All language-specific formatters must use Prettier:**

```json
{
  "[typescript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[typescriptreact]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[javascript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[json]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  }
}
```

**Required for all repos:**

- TypeScript (`[typescript]`)
- TypeScript React (`[typescriptreact]`)

**Optional but recommended:**

- JavaScript (`[javascript]`)
- JSON (`[json]`)

**Validation:**

```bash
# Check required formatters
jq '."[typescript]".editor.defaultFormatter' .vscode/settings.json | grep -q "prettier-vscode"
jq '."[typescriptreact]".editor.defaultFormatter' .vscode/settings.json | grep -q "prettier-vscode"
```

### Rule 2: Format on Save Enabled

**Auto-formatting must be enabled:**

```json
{
  "editor.formatOnSave": true,
  "editor.formatOnPaste": true,
  "editor.trimAutoWhitespace": true
}
```

**Exceptions (Handlebars):**

```json
{
  "[handlebars]": {
    "editor.formatOnSave": false,
    "editor.formatOnPaste": false
  }
}
```

**Validation:**

```bash
# Check format on save settings
jq '.editor.formatOnSave' .vscode/settings.json | grep -q "true"
jq '.editor.formatOnPaste' .vscode/settings.json | grep -q "true"
```

### Rule 3: ESLint Auto-Fix

**ESLint must auto-fix on save:**

```json
{
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": "explicit"
  }
}
```

**Validation:**

```bash
# Check ESLint auto-fix
jq '.editor.codeActionsOnSave."source.fixAll.eslint"' .vscode/settings.json | grep -q "explicit"
```

### Rule 4: pnpm Package Manager

**pnpm must be configured as package manager:**

```json
{
  "npm.packageManager": "pnpm"
}
```

**Validation:**

```bash
# Check package manager
jq '.npm.packageManager' .vscode/settings.json | grep -q "pnpm"
```

### Rule 5: Terminal Configuration

**Bash terminal with proper environment:**

```json
{
  "terminal.integrated.env.linux": {
    "PATH": "${env:PATH}"
  },
  "npm.scriptExplorerAction": "open",
  "npm.runInTerminal": true,
  "terminal.integrated.defaultProfile.linux": "bash",
  "terminal.integrated.profiles.linux": {
    "bash": {
      "path": "bash",
      "args": ["-l"]
    }
  }
}
```

**Validation:**

```bash
# Check terminal configuration
jq '.terminal.integrated.defaultProfile.linux' .vscode/settings.json | grep -q "bash"
jq '.terminal.integrated.profiles.linux.bash.path' .vscode/settings.json | grep -q "bash"
```

### Rule 6: TypeScript Configuration

**Use workspace TypeScript SDK:**

```json
{
  "typescript.tsdk": "node_modules/typescript/lib",
  "typescript.enablePromptUseWorkspaceTsdk": true
}
```

**Validation:**

```bash
# Check TypeScript SDK
jq '.typescript.tsdk' .vscode/settings.json | grep -q "node_modules/typescript/lib"
jq '.typescript.enablePromptUseWorkspaceTsdk' .vscode/settings.json | grep -q "true"
```

### Rule 7: Search and Files Exclusions

**Exclude build artifacts and dependencies:**

```json
{
  "search.exclude": {
    "**/node_modules": true,
    "**/.turbo": true,
    "**/coverage": true,
    "**/*.tsbuildinfo": true,
    "**/pnpm-lock.yaml": true,
    "**/dist": true,
    "**/.next": true,
    "**/build": true
  },
  "files.exclude": {
    "**/.turbo": true,
    "**/*.tsbuildinfo": true
  }
}
```

**Required patterns:**

- `**/node_modules`
- `**/.turbo`
- `**/coverage`
- `**/*.tsbuildinfo`
- `**/pnpm-lock.yaml`

**Optional patterns (project-specific):**

- `**/dist`
- `**/.next`
- `**/build`

**Validation:**

```bash
# Check required exclusions
jq '.search.exclude."**/node_modules"' .vscode/settings.json | grep -q "true"
jq '.search.exclude."**/.turbo"' .vscode/settings.json | grep -q "true"
jq '.files.exclude."**/.turbo"' .vscode/settings.json | grep -q "true"
```

### Rule 8: Only settings.json Required

**The .vscode folder should contain ONLY settings.json:**

**Required:**

- ✅ `.vscode/settings.json` - Workspace settings

**Not Required (Should be deleted):**

- ❌ `.vscode/extensions.json` - Extension recommendations (not needed)
- ❌ `.vscode/launch.json` - Debug configurations (developer-specific)
- ❌ `.vscode/tasks.json` - Task definitions (not used)

**Rationale:**

1. `settings.json` - Project-wide standards all developers must follow
2. `extensions.json` - Developers manage their own extensions
3. `launch.json` - Debug configurations are developer-specific
4. `tasks.json` - We use package.json scripts and Turborepo, not VS Code tasks

**Validation:**

```bash
# Check for unnecessary files
ls -la .vscode/

# Warn if extras found
[ -f ".vscode/extensions.json" ] && echo "WARNING: Found .vscode/extensions.json (recommend deletion)"
[ -f ".vscode/launch.json" ] && echo "WARNING: Found .vscode/launch.json (recommend deletion)"
[ -f ".vscode/tasks.json" ] && echo "WARNING: Found .vscode/tasks.json (recommend deletion)"
```

## Optional Settings (Recommended)

### Editor Preferences

```json
{
  "editor.rulers": [80],
  "editor.inlayHints.enabled": "off",
  "editor.guides.indentation": false,
  "editor.guides.bracketPairs": false,
  "editor.wordWrap": "off",
  "diffEditor.wordWrap": "off"
}
```

### GitHub Copilot Integration

```json
{
  "github.copilot.chat.commitMessageGeneration.instructions": [
    {
      "file": ".copilot-commit-message-instructions.md"
    }
  ]
}
```

**Note:** Requires `.copilot-commit-message-instructions.md` at root.

## Validation

To validate VS Code workspace settings:

1. Check that `.vscode` directory exists
2. Check that `.vscode/settings.json` exists
3. Check for unnecessary files (extensions.json, launch.json, tasks.json)
4. Read settings.json
5. Validate against 8 standards
6. Report violations and unnecessary files
7. Recommend deletion of extras

### Validation Approach

```bash
# Check directory and file exist
[ -d ".vscode" ] || echo "VIOLATION: .vscode directory missing"
[ -f ".vscode/settings.json" ] || echo "VIOLATION: .vscode/settings.json missing"

# Rule 8: Check for unnecessary files
if [ -f ".vscode/extensions.json" ] || [ -f ".vscode/launch.json" ] || [ -f ".vscode/tasks.json" ]; then
  echo "WARNING: Unnecessary files in .vscode directory"
  echo "Recommend deletion: rm .vscode/extensions.json .vscode/launch.json .vscode/tasks.json"
fi

# Rule 1: Prettier formatter
jq '."[typescript]".editor.defaultFormatter' .vscode/settings.json | grep -q "prettier-vscode" || echo "VIOLATION: TypeScript formatter not Prettier"

# Rule 2: Format on save
jq '.editor.formatOnSave' .vscode/settings.json | grep -q "true" || echo "VIOLATION: formatOnSave not enabled"

# Rule 3: ESLint auto-fix
jq '.editor.codeActionsOnSave."source.fixAll.eslint"' .vscode/settings.json | grep -q "explicit" || echo "VIOLATION: ESLint auto-fix not configured"

# Rule 4: pnpm
jq '.npm.packageManager' .vscode/settings.json | grep -q "pnpm" || echo "VIOLATION: Package manager not pnpm"

# Rule 5: Terminal
jq '.terminal.integrated.defaultProfile.linux' .vscode/settings.json | grep -q "bash" || echo "VIOLATION: Terminal not bash"

# Rule 6: TypeScript SDK
jq '.typescript.tsdk' .vscode/settings.json | grep -q "node_modules" || echo "VIOLATION: TypeScript SDK not configured"

# Rule 7: Exclusions
jq '.search.exclude."**/node_modules"' .vscode/settings.json | grep -q "true" || echo "VIOLATION: Missing search exclusions"
```

## Repository Type Considerations

- **Consumer Repos**: Strict enforcement of all 8 standards
- **Library Repos**: May have additional workspace settings
- **All Repos**: Must have only settings.json in .vscode (no extras)

## Best Practices

1. Create only .vscode/settings.json (never create extensions.json, launch.json, tasks.json)
2. Use Prettier for all language formatters
3. Enable format on save for automatic formatting
4. Configure ESLint auto-fix for automatic linting
5. Set pnpm as package manager
6. Use workspace TypeScript SDK
7. Exclude build artifacts from search
8. Report and recommend deletion of unnecessary .vscode files
9. Re-audit after making changes

## File Cleanup Workflow

When unnecessary files are detected:

1. Report which files exist
2. Explain why they're not needed
3. Provide deletion command
4. Wait for user confirmation
5. Delete if approved
6. Re-audit to verify

**Example output:**

```
⚠️  Unnecessary Files Detected

Found in .vscode/:
- extensions.json (not needed - developers manage their own extensions)
- launch.json (not needed - debug configs are developer-specific)
- tasks.json (not needed - we use package.json scripts)

Recommendation: Delete with:
  rm .vscode/extensions.json .vscode/launch.json .vscode/tasks.json

Would you like me to delete these files? (y/n)
```

## Integration

This skill integrates with:

- Repository type provided via `scope` parameter. If not provided, use `/skill scope-check`
- `/skill audit-workflow` - Bi-directional comparison workflow
- `/skill remediation-options` - Conform/Update/Ignore choices
- `prettier-agent` - For formatter configuration
- `eslint-agent` - For auto-fix configuration
- `typescript-agent` - For TypeScript SDK configuration
- `pnpm-workspace-agent` - For package manager setup
