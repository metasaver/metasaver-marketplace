---
name: tailwind-config
description: Tailwind CSS configuration template and validation logic for tailwind.config.js with src/index.css directives. Includes 5 required standards (required content paths for scanning, must extend default theme not replace, required plugins array, must be named tailwind.config.js, required dependencies). Ensures proper PostCSS integration and Tailwind directive setup. Use when creating or auditing tailwind.config.js files for consistent Tailwind CSS setup.
---

# Tailwind CSS Configuration Skill

**Purpose:** Provides standard Tailwind CSS configuration template and validation logic for tailwind.config.js files

## When to Use This Skill

- Creating new tailwind.config.js files
- Validating existing Tailwind CSS configurations
- Ensuring consistent Tailwind setup across monorepo
- Referenced by `tailwind-agent` for build and audit modes

## The 5 Tailwind Standards

### Rule 1: Required Content Paths

```javascript
export default {
  content: ["./index.html", "./src/**/*.{js,ts,jsx,tsx}"],
  // ...
};
```

**Validation:**

- Must have `content` array property
- Must include `"./index.html"` pattern
- Must include `"./src/**/*.{js,ts,jsx,tsx}"` pattern

### Rule 2: Extend Default Theme (Never Replace)

```javascript
theme: {
  extend: {
    // Custom theme extensions here
  }
}
```

**Validation:**

- ENSURE `theme.extend` object is present
- ALWAYS extend the default theme (do not replace it completely)

### Rule 3: Required Plugins Array

```javascript
plugins: [
  // Plugins go here
];
```

**Validation:**

- Must have `plugins` array property
- Empty array is acceptable

### Rule 4: Must Be Named tailwind.config.js

**Validation:**

- File must be named exactly `tailwind.config.js`
- NOT `tailwind.config.ts`, `tailwind.config.mjs`
- PostCSS expects `tailwind.config.js`

### Rule 5: Required Dependencies

```json
"devDependencies": {
  "tailwindcss": "^3.4.0"
}
```

**Validation:**

- `package.json` must have `tailwindcss` in `devDependencies`

## Template Structure

### Standard tailwind.config.js Template

```javascript
/** @type {import('tailwindcss').Config} */
export default {
  content: ["./index.html", "./src/**/*.{js,ts,jsx,tsx}"],
  theme: {
    extend: {},
  },
  plugins: [],
};
```

### Required CSS File Template (src/index.css)

```css
@tailwind base;
@tailwind components;
@tailwind utilities;
```

**Validation for CSS file:**

- Must exist at `src/index.css` (relative to tailwind.config.js)
- Must contain `@tailwind base` directive
- Must contain `@tailwind components` directive
- Must contain `@tailwind utilities` directive

## Validation Logic

### Core Validation Function

```typescript
function checkTailwindConfig(
  configPath: string,
  packageJson: any,
  repoType: string,
) {
  const errors: string[] = [];

  // Check file exists
  if (!fileExists(configPath)) {
    errors.push("Rule 4: Missing tailwind.config.js");
    return errors;
  }

  const config = parseTailwindConfig(configPath);

  // Rule 1: Check content paths
  if (!config.content || !Array.isArray(config.content)) {
    errors.push("Rule 1: Missing content array");
  } else {
    const hasIndexHtml = config.content.some((p) => p.includes("index.html"));
    const hasSrcPath = config.content.some((p) => p.includes("src/**/*"));

    if (!hasIndexHtml) {
      errors.push("Rule 1: content missing './index.html'");
    }
    if (!hasSrcPath) {
      errors.push("Rule 1: content missing './src/**/*.{js,ts,jsx,tsx}'");
    }
  }

  // Rule 2: Check theme.extend exists
  if (!config.theme?.extend) {
    errors.push(
      "Rule 2: ENSURE theme.extend is present - always extend the default theme",
    );
  }

  // Rule 3: Check plugins array exists
  if (!config.plugins) {
    errors.push("Rule 3: Missing plugins array");
  }

  // Rule 5: Check dependency
  if (!packageJson.devDependencies?.tailwindcss) {
    errors.push("Rule 5: Missing tailwindcss in devDependencies");
  }

  // Check CSS file exists
  const cssPath = path.join(path.dirname(configPath), "src/index.css");
  if (!fileExists(cssPath)) {
    errors.push("Missing src/index.css with Tailwind directives");
  } else {
    const cssContent = readFileSync(cssPath, "utf-8");
    if (!cssContent.includes("@tailwind base")) {
      errors.push("src/index.css missing '@tailwind base' directive");
    }
    if (!cssContent.includes("@tailwind components")) {
      errors.push("src/index.css missing '@tailwind components' directive");
    }
    if (!cssContent.includes("@tailwind utilities")) {
      errors.push("src/index.css missing '@tailwind utilities' directive");
    }
  }

  return errors;
}
```

## Build Process

### Step 1: Read package.json

Check if project is React/Vite compatible:

```bash
# Read package.json to check for React dependencies
```

### Step 2: Create tailwind.config.js

Use standard template above.

### Step 3: Create src/index.css

Create CSS file with Tailwind directives if missing.

### Step 4: Update package.json

Add `tailwindcss` to `devDependencies` if missing:

```json
"devDependencies": {
  "tailwindcss": "^3.4.0"
}
```

### Step 5: Verify

Run audit mode validation to confirm all 5 rules pass.

## Repository-Specific Behavior

### Consumer Repos (Strict Enforcement)

All 5 rules must pass unless exception is declared in `package.json`:

```json
{
  "metasaver": {
    "exceptions": {
      "tailwind-config": {
        "type": "custom-theme-config",
        "reason": "Requires custom Tailwind theme for brand-specific design"
      }
    }
  }
}
```

### Library Repo (@metasaver/multi-mono)

May have intentional differences:

- Custom content paths for component library structure
- Extended theme with design system tokens
- Component-specific plugins

**Validation:** Report differences but recommend "Ignore" option.

## Best Practices

1. **Content paths are critical** - Controls which files Tailwind scans
2. **ALWAYS extend theme** - Preserves Tailwind defaults (never replace)
3. **CSS file required** - Import point for Tailwind directives
4. **Template location** - Store in `.claude/skills/tailwind-config/templates/`
5. **Validation before build** - Check project type compatibility
6. **RE-AUDIT after changes** - Verify all rules pass after conforming

## Template Location

Templates are stored in:

```
.claude/skills/tailwind-config/
├── templates/
│   ├── tailwind.config.js.template
│   └── index.css.template
```

## Integration with tailwind-agent

The `tailwind-agent` uses this skill for:

- **Build mode**: Template retrieval and creation logic
- **Audit mode**: Validation logic and rule checking
- **Remediation**: Template-based conformance fixing
