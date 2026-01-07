---
name: eslint-config
description: ESLint flat config validation and templates for eslint.config.js files in MetaSaver monorepos. Includes 5 required standards (correct config type for projectType, simple re-export pattern from shared library, flat config filename eslint.config.js, shared config dependency, required npm scripts). Use when creating or auditing eslint.config.js files to ensure correct linting configuration.
---

# ESLint Configuration Skill

This skill provides eslint.config.js templates and validation logic for ESLint flat config setup.

## Purpose

Manage eslint.config.js configuration to:

- Configure correct ESLint setup per projectType
- Use shared configuration from @metasaver/core-eslint-config
- Maintain simple re-export pattern (complexity in shared library)
- Ensure consistent linting across monorepo
- Provide required npm scripts for linting

## Usage

This skill is invoked by the `eslint-agent` when:

- Creating new eslint.config.js files
- Auditing existing ESLint configurations
- Validating ESLint configs against standards

## Templates

Standard templates are located at:

```
templates/eslint.config.template.js
```

## The 5 ESLint Standards

### Rule 1: Correct Config Type for ProjectType

Each projectType maps to a specific config type from @metasaver/core-eslint-config:

| projectType         | Config Type   | Description                   |
| ------------------- | ------------- | ----------------------------- |
| base                | base          | Minimal config (utilities)    |
| node                | node          | Node.js backend services      |
| web-standalone      | vite-web      | Vite React web applications   |
| react-library       | react-library | React component libraries     |
| library             | node          | Node.js utility libraries     |
| contracts           | node          | Zod contracts packages        |
| database            | node          | Prisma database packages      |
| data-service        | node          | REST API data services        |
| integration-service | node          | External integration services |
| pipeline-service    | node          | Data pipeline services        |
| workflow            | node          | Temporal workflow packages    |
| mcp                 | node          | MCP server packages           |
| turborepo-monorepo  | base          | Monorepo root configuration   |

The config type determines which shared configuration is imported.

### Rule 2: Simple Re-Export Pattern

Configuration files must use simple re-export only:

```javascript
export { default } from "@metasaver/core-eslint-config/{type}";
```

Where `{type}` is one of: `base`, `node`, `vite-web`, `react-library`

All ESLint rules and configuration complexity lives in the shared @metasaver/core-eslint-config library. Individual projects should keep re-exports simple and delegate custom logic to the shared library.

### Rule 3: Flat Config Filename

Must be named exactly `eslint.config.js`:

- ESLint flat config expects this filename
- NOT `eslint.config.ts`, `eslint.config.mjs`, `.eslintrc.js`
- Located at workspace root (where package.json is)

### Rule 4: Shared Config Dependency

Must have in package.json devDependencies:

```json
{
  "devDependencies": {
    "@metasaver/core-eslint-config": "workspace:*"
  }
}
```

For monorepos, use `workspace:*` protocol to reference the shared config package.

### Rule 5: Required npm Scripts

Must include lint scripts in package.json:

**For packages:**

```json
{
  "scripts": {
    "lint": "eslint .",
    "lint:fix": "eslint . --fix"
  }
}
```

**For monorepo root:**

```json
{
  "scripts": {
    "lint": "turbo run lint",
    "lint:fix": "turbo run lint:fix"
  }
}
```

Monorepo root delegates to Turborepo for parallel linting across packages.

## Validation

To validate an eslint.config.js file:

1. Read package.json to get `metasaver.projectType`
2. Map projectType to expected config type
3. Check that eslint.config.js exists at workspace root
4. Parse config and verify re-export pattern
5. Verify shared config dependency exists
6. Check npm scripts (lint and lint:fix)
7. Report violations

### Validation Approach

```javascript
// Rule 1: Map projectType to config type
const typeMap = {
  base: "base",
  node: "node",
  "web-standalone": "vite-web",
  "react-library": "react-library",
  library: "node",
  contracts: "node",
  database: "node",
  "data-service": "node",
  "integration-service": "node",
  "pipeline-service": "node",
  workflow: "node",
  mcp: "node",
  "turborepo-monorepo": "base",
};
const expectedType = typeMap[projectType];

// Rule 2: Check re-export pattern
const reExportPattern = new RegExp(`export\\s*{\\s*default\\s*}\\s*from\\s*["']@metasaver/core-eslint-config/${expectedType}["']`);
if (!reExportPattern.test(content)) {
  errors.push(`Rule 2: Must use re-export pattern for config type "${expectedType}"`);
}

// Rule 3: Check filename
if (!path.endsWith("eslint.config.js")) {
  errors.push("Rule 3: Must be named eslint.config.js (flat config)");
}

// Rule 4: Check dependency
const deps = packageJson.devDependencies || {};
if (!deps["@metasaver/core-eslint-config"]) {
  errors.push("Rule 4: Missing @metasaver/core-eslint-config in devDependencies");
}

// Rule 5: Check npm scripts
const scripts = packageJson.scripts || {};
const isMonorepoRoot = packageJson.name === undefined; // Root has no name
if (isMonorepoRoot) {
  if (!scripts.lint?.includes("turbo")) {
    errors.push('Rule 5: Monorepo root must use "turbo run lint"');
  }
} else {
  if (!scripts.lint?.includes("eslint")) {
    errors.push('Rule 5: Missing "lint" script with eslint');
  }
  if (!scripts["lint:fix"]?.includes("eslint")) {
    errors.push('Rule 5: Missing "lint:fix" script with eslint --fix');
  }
}
```

## Repository Type Considerations

- **Consumer Repos**: Must strictly follow all 5 standards unless exception declared
- **Library Repos**: May have custom configs for specialized linting needs

### Exception Declaration

Consumer repos may declare exceptions in package.json:

```json
{
  "metasaver": {
    "exceptions": {
      "eslint-config": {
        "type": "custom-rules",
        "reason": "Requires custom import ordering rules for legacy codebase"
      }
    }
  }
}
```

## Best Practices

1. Place eslint.config.js at workspace root (where package.json is)
2. Use template matching your projectType
3. Keep re-export simple - delegate complexity to shared config
4. Add shared config dependency with workspace protocol
5. Include both lint and lint:fix scripts
6. Re-audit after making changes

## Integration

This skill integrates with:

- Repository type provided via `scope` parameter. If not provided, use `/skill scope-check`
- `/skill audit-workflow` - Bi-directional comparison workflow
- `/skill remediation-options` - Conform/Update/Ignore choices
- `typescript-agent` - Coordination with TypeScript configuration
- `prettier-agent` - Coordination with Prettier formatting
