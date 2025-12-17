---
name: vitest-config
description: Vitest configuration template and validation logic for test configuration that merges with vite.config.ts. Includes 5 required standards (must merge with vite.config using mergeConfig, required test configuration with globals and jsdom environment, required setup file at src/test/setup.ts with @testing-library/jest-dom, required dependencies, required npm test scripts). Use when creating or auditing vitest.config.ts files to ensure proper test environment setup.
---

# Vitest Configuration Skill

This skill provides vitest.config.ts template and validation logic for Vitest test configuration.

## Purpose

Manage vitest.config.ts configuration to:

- Merge with existing vite.config.ts
- Configure test environment and globals
- Set up test setup files
- Configure coverage reporting

## Usage

This skill is invoked by the `vitest-agent` when:

- Creating new vitest.config.ts files
- Auditing existing Vitest configurations
- Validating Vitest configs against standards

## Templates

Standard templates are located at:

```
templates/vitest.config.ts.template       # Vitest configuration
templates/setup.ts.template               # Test setup file
```

## The 5 Vitest Standards

### Rule 1: Must Merge with vite.config.ts

Must use `mergeConfig` to merge with existing Vite config:

```typescript
import { mergeConfig } from "vite";
import { defineConfig } from "vitest/config";
import viteConfig from "./vite.config";

export default mergeConfig(
  viteConfig,
  defineConfig({
    test: {
      /* ... */
    },
  }),
);
```

### Rule 2: Required Test Configuration

Must include test configuration:

```typescript
test: {
  globals: true,
  environment: 'jsdom',
  setupFiles: './src/test/setup.ts',
  coverage: {
    provider: 'v8',
    reporter: ['text', 'json', 'html'],
    exclude: ['node_modules/', 'src/test/'],
  },
},
resolve: {
  alias: {
    '#': resolve(__dirname, './src'),
  },
}
```

**Path Alias Resolution**: The `#` alias enables no-barrel imports (e.g., `import { foo } from '#/module'`) by mapping to the `src` directory.

### Rule 3: Required Setup File

Must have `src/test/setup.ts` with:

```typescript
import "@testing-library/jest-dom";
import { afterEach } from "vitest";
import { cleanup } from "@testing-library/react";

afterEach(() => {
  cleanup();
});
```

### Rule 4: Required Dependencies

Must have in package.json devDependencies:

```json
{
  "devDependencies": {
    "vitest": "^1.0.0",
    "@vitest/ui": "^1.0.0",
    "@testing-library/react": "^14.0.0",
    "@testing-library/jest-dom": "^6.0.0",
    "jsdom": "^23.0.0"
  }
}
```

### Rule 5: Required npm Scripts

Must have in package.json scripts:

```json
{
  "scripts": {
    "test": "vitest run",
    "test:ui": "vitest --ui",
    "test:coverage": "vitest run --coverage"
  }
}
```

## Validation

To validate a vitest.config.ts file:

1. Check that vitest.config.ts exists
2. Check that vite.config.ts exists (required for merging)
3. Verify mergeConfig usage
4. Check test configuration properties
5. Verify setup file exists at src/test/setup.ts
6. Check required dependencies
7. Verify npm scripts
8. Report violations

### Validation Approach

```typescript
// Rule 1: Check mergeConfig usage
if (!configContent.includes("mergeConfig")) {
  errors.push("Rule 1: Not merging with vite.config.ts (use mergeConfig)");
}
if (
  !configContent.includes("viteConfig") &&
  !configContent.includes("./vite.config")
) {
  errors.push("Rule 1: Not importing vite.config");
}

// Rule 2: Check test configuration
const testConfig = config.test;
if (!testConfig) {
  errors.push("Rule 2: Missing test configuration object");
} else {
  if (testConfig.globals !== true) {
    errors.push("Rule 2: test.globals must be true");
  }
  if (testConfig.environment !== "jsdom") {
    errors.push("Rule 2: test.environment must be 'jsdom'");
  }
  if (!testConfig.setupFiles) {
    errors.push("Rule 2: Missing test.setupFiles");
  }
  if (!testConfig.coverage) {
    errors.push("Rule 2: Missing test.coverage configuration");
  }
}

// Rule 2: Check path alias resolution
if (!config.resolve?.alias?.["#"]) {
  errors.push("Rule 2: Missing resolve.alias['#'] for no-barrel imports");
}

// Rule 3: Check setup file exists
const setupPath = path.join(configDir, "src/test/setup.ts");
if (!fs.existsSync(setupPath)) {
  errors.push("Rule 3: Missing src/test/setup.ts file");
} else {
  const setupContent = fs.readFileSync(setupPath, "utf-8");
  if (!setupContent.includes("@testing-library/jest-dom")) {
    errors.push("Rule 3: setup.ts must import @testing-library/jest-dom");
  }
  if (!setupContent.includes("cleanup")) {
    errors.push("Rule 3: setup.ts must call cleanup() in afterEach");
  }
}

// Rule 4: Check dependencies
const deps = packageJson.devDependencies || {};
const requiredDeps = [
  "vitest",
  "@vitest/ui",
  "@testing-library/react",
  "@testing-library/jest-dom",
  "jsdom",
];
const missingDeps = requiredDeps.filter((dep) => !deps[dep]);
if (missingDeps.length > 0) {
  errors.push(`Rule 4: Missing dependencies: ${missingDeps.join(", ")}`);
}

// Rule 5: Check npm scripts
const scripts = packageJson.scripts || {};
if (!scripts.test || !scripts.test.includes("vitest")) {
  errors.push("Rule 5: Missing 'test' script with vitest");
}
if (!scripts["test:ui"]) {
  errors.push("Rule 5: Missing 'test:ui' script");
}
if (!scripts["test:coverage"]) {
  errors.push("Rule 5: Missing 'test:coverage' script");
}
```

## Repository Type Considerations

- **Consumer Repos**: Must strictly follow all 5 standards unless exception declared
- **Library Repos**: May have custom test configuration for component library testing

### Exception Declaration

Consumer repos may declare exceptions in package.json:

```json
{
  "metasaver": {
    "exceptions": {
      "vitest-config": {
        "type": "custom-test-setup",
        "reason": "Requires custom test environment setup for specialized testing"
      }
    }
  }
}
```

## Best Practices

1. Place vitest.config.ts at workspace root (where vite.config.ts is)
2. Always merge with vite.config.ts using mergeConfig
3. Setup file required for @testing-library/jest-dom
4. Coverage configuration for quality metrics
5. Use jsdom environment for React component testing
6. Re-audit after making changes

## Integration

This skill integrates with:

- Repository type provided via `scope` parameter. If not provided, use `/skill scope-check`
- `/skill audit-workflow` - Bi-directional comparison workflow
- `/skill remediation-options` - Conform/Update/Ignore choices
- `vite-agent` - Ensure vite.config.ts exists for merging
- `package-scripts-agent` - Ensure test scripts exist
