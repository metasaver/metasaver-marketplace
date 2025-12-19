---
name: editorconfig-config
description: EditorConfig file validation and template for enforcing consistent coding styles across editors and IDEs in monorepos. Includes 4 required standards (root declaration, universal settings with UTF-8 and LF line endings, language-specific indentation for JS/TS/Markdown/Python, root-only placement in monorepos). Use when creating or auditing .editorconfig files to ensure consistent code formatting.
---

# EditorConfig Configuration Skill

This skill provides .editorconfig template and validation logic for maintaining consistent coding styles across editors and IDEs.

## Purpose

Manage .editorconfig configuration to:

- Enforce consistent character encoding and line endings
- Define language-specific indentation rules
- Preserve trailing whitespace where needed (Markdown)
- Ensure monorepo consistency with single root configuration

## Usage

This skill is invoked by the `editorconfig-agent` when:

- Creating new .editorconfig files
- Auditing existing EditorConfig configurations
- Validating EditorConfig files against standards

## Template

The standard EditorConfig template is located at:

```
templates/.editorconfig.template
```

## The 4 EditorConfig Standards

### Rule 1: Root Declaration

File must start with root declaration:

```ini
root = true
```

This stops EditorConfig from searching parent directories, ensuring the monorepo has a single source of truth.

### Rule 2: Universal Settings

Must include `[*]` section with these four settings:

```ini
[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true
```

These settings apply to all files unless overridden by language-specific rules.

### Rule 3: Language-Specific Indentation

Must include sections for JavaScript/TypeScript (2 spaces), Markdown (preserve trailing), and Python (4 spaces):

```ini
[*.{js,jsx,ts,tsx,json,jsonc,yml,yaml}]
indent_style = space
indent_size = 2

[*.md]
trim_trailing_whitespace = false

[*.py]
indent_style = space
indent_size = 4
```

### Rule 4: Root Location Only

In monorepos, .editorconfig must exist ONLY at repository root:

- Place at monorepo root (alongside pnpm-workspace.yaml)
- Individual packages must only reference the root .editorconfig file
- Single configuration ensures consistency across all packages

## Validation

Validation steps:

1. Check file exists at repository root
2. Verify root declaration is present
3. Check universal settings section `[*]` with all 4 settings
4. Verify language-specific sections exist (JS/TS, Markdown, Python)
5. Scan for package-level .editorconfig files (monorepo only)
6. Report violations

### Validation Logic

```javascript
// Rule 1: Root declaration
if (!content.includes("root = true")) {
  errors.push("Rule 1: Missing 'root = true' declaration");
}

// Rule 2: Universal settings (check all 4)
[
  "[*]",
  "charset = utf-8",
  "end_of_line = lf",
  "insert_final_newline = true",
  "trim_trailing_whitespace = true",
].forEach((setting) => {
  if (!content.includes(setting)) errors.push(`Rule 2: Missing ${setting}`);
});

// Rule 3: Language sections
if (!/\[\*\.\{[^}]*js[^}]*\}\]/.test(content)) {
  errors.push("Rule 3: Missing JS/TS indentation rules");
}
if (!/\[\*\.md\]/.test(content)) {
  errors.push("Rule 3: Missing Markdown section");
}
if (!/\[\*\.py\]/.test(content)) {
  errors.push("Rule 3: Missing Python section");
}

// Rule 4: Package-level configs (monorepo only)
const packageConfigs = glob("packages/**/.editorconfig");
if (packageConfigs.length > 0) {
  errors.push(
    `Rule 4: Remove package-level configs: ${packageConfigs.join(", ")}`,
  );
}
```

## Exception Declaration

Repos may declare exceptions in package.json:

```json
{
  "metasaver": {
    "exceptions": {
      "editorconfig-config": {
        "type": "custom-language-rules",
        "reason": "Requires 4-space indentation for legacy YAML files"
      }
    }
  }
}
```

## Best Practices

1. Place .editorconfig at repository root (monorepo or standalone)
2. Use template as starting point
3. Preserve Markdown trailing whitespace (for double-space line breaks)
4. Add language-specific rules as needed (follow template pattern)
5. Re-audit after making changes

## Integration

This skill integrates with:

- Repository type provided via `scope` parameter. If not provided, use `/skill scope-check`
- `/skill audit-workflow` - Bi-directional comparison workflow
- `/skill remediation-options` - Conform/Update/Ignore choices
- `prettier-agent` - Coordination with Prettier formatting rules
- `eslint-agent` - Coordination with ESLint style rules
