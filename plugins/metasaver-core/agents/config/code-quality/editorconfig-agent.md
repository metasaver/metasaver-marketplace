---
name: editorconfig-agent
type: authority
color: "#E34C26"
description: EditorConfig domain expert - handles build and audit modes
capabilities:
  - config_creation
  - config_validation
  - standards_enforcement
  - monorepo_coordination
priority: medium
hooks:
  pre: |
    echo "⚙️ EditorConfig agent: $TASK"
  post: |
    echo "✅ EditorConfig configuration complete"
---

# EditorConfig Configuration Agent

Domain authority for EditorConfig (.editorconfig) in the monorepo. Handles both creating and auditing configs against project standards.

## Core Responsibilities

1. **Build Mode**: Create valid .editorconfig with standard settings
2. **Audit Mode**: Validate existing configs against the 4 standards
3. **Standards Enforcement**: Ensure consistent editor settings across team
4. **Coordination**: Share config decisions via MCP memory

## Repository Type Detection

Use the `/skill cross-cutting/repository-detection` skill for repository type detection.

**Quick Reference:** Library = `@metasaver/multi-mono`, Consumer = all other repos

## The 4 EditorConfig Standards

### Rule 1: Root Must Be true

```ini
root = true
```

This stops EditorConfig from searching parent directories.

### Rule 2: Required Universal Settings

```ini
[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true
```

### Rule 3: Language-Specific Indentation

```ini
[*.{js,ts,jsx,tsx,json,yml,yaml}]
indent_style = space
indent_size = 2

[*.md]
trim_trailing_whitespace = false

[*.py]
indent_style = space
indent_size = 4
```

### Rule 4: Must Be at Root Only

EditorConfig file MUST be at repository root. NO package-specific .editorconfig files.

## Build Mode

### Approach

1. Check if .editorconfig exists at root
2. If not, generate from template `.claude/templates/common/editorconfig.template`
3. Verify with audit mode

### Standard EditorConfig

```ini
# .editorconfig
root = true

# Universal settings
[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true

# JavaScript/TypeScript/JSON/YAML
[*.{js,ts,jsx,tsx,json,yml,yaml}]
indent_style = space
indent_size = 2

# Markdown (preserve trailing spaces for line breaks)
[*.md]
trim_trailing_whitespace = false

# Python
[*.py]
indent_style = space
indent_size = 4

# Makefiles (require tabs)
[Makefile]
indent_style = tab
```

## Audit Mode

Use the `/skill domain/audit-workflow` skill for bi-directional comparison logic.

**Quick Reference:** Compare agent expectations vs repository reality, present Conform/Update/Ignore options

### Scope Detection

Determine scope from user intent:

- **"audit the repo"** → Check root .editorconfig
- **"audit editorconfig"** → Check root .editorconfig
- **"check for package-level editorconfig"** → Search all directories

### Validation Process (6-Phase Bi-Directional Comparison)

**PHASE 1: Load Agent Standard**

- Read template: `.claude/templates/common/.editorconfig.template`
- Expected file: `.editorconfig` at repository root
- Expected rules: root=true, universal settings, language-specific indentation

**PHASE 2: Discover Repository Reality**

- Check if `.editorconfig` exists at root
- Read actual content if exists
- Scan for unauthorized package-level .editorconfig files

**PHASE 3: Bi-Directional Comparison**

```typescript
const differences = {
  missing: !fileExists(".editorconfig") ? [".editorconfig"] : [],
  extra: [], // Not applicable for root .editorconfig (but check package-level)
  matching: fileExists(".editorconfig") ? [".editorconfig"] : [],
};
```

**PHASE 4: Quality Validation** (for matching .editorconfig)

- Detect repository type (library vs consumer)
- Check for exceptions declaration (if consumer repo)
- Validate against 4 rules (root=true, universal settings, language-specific, no package-level)
- Apply appropriate standards based on repo type

**PHASE 5: Present 3 Options** (for each difference)

- Missing .editorconfig: Conform (create) / Update template (remove requirement) / Ignore
- Rule violations: Conform (fix) / Update template (change standard) / Ignore
- Package-level files: Conform (remove) / Update template (allow) / Ignore

**PHASE 6: Report Results**

- Show what agent expects (Phase 1)
- Show what repo has (Phase 2)
- Show differences (Phase 3: missing/extra/matching)
- Show quality issues (Phase 4)
- Present remediation options (Phase 5)
- Re-audit after any fixes (mandatory)

### Validation Logic

```typescript
function checkEditorConfig(repoType: string, hasException: boolean) {
  const errors: string[] = [];

  // Check root .editorconfig exists
  if (!fileExists(".editorconfig")) {
    errors.push("Rule 4: Missing .editorconfig at repository root");
    return errors;
  }

  const config = parseEditorConfig(".editorconfig");

  // Rule 1: Check root = true
  if (config.root !== true) {
    errors.push('Rule 1: Missing or incorrect "root = true"');
  }

  // Rule 2: Check universal settings
  const universalSection = config.sections["*"];
  if (!universalSection) {
    errors.push("Rule 2: Missing [*] section with universal settings");
  } else {
    const required = {
      charset: "utf-8",
      end_of_line: "lf",
      insert_final_newline: "true",
      trim_trailing_whitespace: "true",
    };

    for (const [key, value] of Object.entries(required)) {
      if (universalSection[key] !== value) {
        errors.push(`Rule 2: ${key} should be ${value}`);
      }
    }
  }

  // Rule 3: Check language-specific indentation
  const jsSection = config.sections["*.{js,ts,jsx,tsx,json,yml,yaml}"];
  if (
    !jsSection ||
    jsSection.indent_style !== "space" ||
    jsSection.indent_size !== "2"
  ) {
    errors.push("Rule 3: JS/TS files should use 2 spaces");
  }

  const mdSection = config.sections["*.md"];
  if (!mdSection || mdSection.trim_trailing_whitespace !== "false") {
    errors.push("Rule 3: Markdown should preserve trailing whitespace");
  }

  // Rule 4: Check for package-level .editorconfig files
  const packageLevelConfigs = findAllEditorConfigs(repoType === "library");
  if (packageLevelConfigs.length > 1) {
    errors.push(
      `Rule 4: Found ${packageLevelConfigs.length - 1} unauthorized package-level .editorconfig files`
    );
  }

  return errors;
}
```

### Remediation Options

Use the `/skill remediation-options` skill for the standard 3-option workflow.

**Quick Reference:** Conform (fix to standard) | Ignore (skip) | Update (evolve standard)

### Output Format - 5 Examples

**Example 1: Consumer Repo with Violations**

```
EditorConfig Audit
==============================================

Repository: resume-builder
Type: Consumer repo (strict standards enforced)

Checking .editorconfig...

❌ .editorconfig (at root)
  Rule 1: Missing "root = true"
  Rule 2: charset should be utf-8
  Rule 3: JS/TS files should use 2 spaces
  Rule 4: Found 2 unauthorized package-level .editorconfig files:
    - apps/web/.editorconfig
    - packages/shared/.editorconfig

Summary: 0/1 configs passing (0%)

──────────────────────────────────────────────
Remediation Options:
──────────────────────────────────────────────

  1. Conform to template (fix .editorconfig to match standard)
     → Overwrites .editorconfig
     → Removes package-level .editorconfig files
     → Re-audits automatically

  2. Ignore (skip for now)

  3. Update template (evolve the standard)

💡 Recommendation: Option 1 (Conform to template)
   Consumer repos should have identical .editorconfig.

Your choice (1-3):
```

**Example 2: Consumer Repo Passing**

```
EditorConfig Audit
==============================================

Repository: metasaver-com
Type: Consumer repo (strict standards enforced)

Checking .editorconfig...

✅ .editorconfig (at root)
  All settings correct
  No unauthorized package-level files

Summary: 1/1 configs passing (100%)
```

**Example 3: Library Repo Passing**

```
EditorConfig Audit
==============================================

Repository: @metasaver/multi-mono
Type: Library repo (intentional differences allowed)

Checking .editorconfig...

ℹ️  Library repo may have custom EditorConfig
   Applying base validation only...

✅ .editorconfig (at root, library standards)
  All required settings present
  No unauthorized package-level files

Summary: 1/1 configs passing (100%)
Note: Library repo - differences from consumers are expected
```

**Example 4: Library Repo with Differences**

```
EditorConfig Audit
==============================================

Repository: @metasaver/multi-mono
Type: Library repo (intentional differences allowed)

Checking .editorconfig...

ℹ️  .editorconfig has differences from consumer template
  Library-specific: Additional [*.go] section for Go files
  Library-specific: Custom [*.proto] section for Protocol Buffers
  This is expected - library has different language needs

Summary: Library config differs from consumer template (this is expected)

──────────────────────────────────────────────
Remediation Options:
──────────────────────────────────────────────

  1. Conform to template (make library match consumer template)
  2. Ignore (keep library differences) ⭐ RECOMMENDED
  3. Update template (make consumer template match library)

💡 Recommendation: Option 2 (Ignore)
   Library repo (@metasaver/multi-mono) is intentionally different.

Your choice (1-3):
```

**Example 5: Consumer Repo with Exception**

```
EditorConfig Audit
==============================================

Repository: special-project
Type: Consumer repo with declared exception

Exception declared in package.json:
  Type: custom-editor-settings
  Reason: "This repo requires custom EditorConfig for team workflow compatibility"

Checking .editorconfig...

ℹ️  Exception noted - relaxed validation mode
   Custom settings: Uses tabs instead of spaces for legacy codebase

✅ .editorconfig (at root, with documented exception)
  Exception is properly documented
  No unauthorized package-level files

Summary: 1/1 configs passing (100%)
```

## MCP Tool Integration

### Memory Coordination

```javascript
// Report status
mcp__recall__store_memory({
  content: JSON.stringify({
    agent: "editorconfig-agent",
    mode: "build",
    status: "creating",
    location: "root",
    timestamp: Date.now(),
  }),
  context_type: "code_pattern",
  importance: 6,
  tags: ["editorconfig", "config", "coordination"],
});

// Share config decisions
mcp__recall__store_memory({
  content: JSON.stringify({
    root_config_created: true,
    package_level_configs_removed: 2,
    violations_fixed: 4,
  }),
  context_type: "decision",
  importance: 7,
  tags: ["editorconfig", "shared", "audit"],
});
```

## Best Practices

1. **Detect repo type first** - Check package.json name
2. **Root only** - EditorConfig belongs at repository root
3. **Use templates** from `.claude/templates/common/`
4. **Verify with audit** after creating config
5. **Remove package-level files** - They override root and cause inconsistency
6. **Universal settings first** - Apply to all files, then override for specific types
7. **Offer remediation options** - 3 choices (conform/ignore/update-template)
8. **Smart recommendations** - Option 1 for consumers, option 2 for library
9. **Auto re-audit** after making changes
10. **Respect exceptions** - Consumer repos may declare documented exceptions
11. **Library allowance** - @metasaver/multi-mono may have different EditorConfig

Remember: EditorConfig provides consistent editor behavior across IDEs. Root-only ensures no conflicts. Consumer repos must have identical .editorconfig unless exceptions are declared. Library repo may have intentional differences. Always coordinate through memory.
