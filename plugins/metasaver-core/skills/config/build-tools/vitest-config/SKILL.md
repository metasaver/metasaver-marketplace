---
name: vitest-config
description: Vitest configuration template and validation logic for test configuration. Standards differ by package type - frontend (jsdom, jest-dom, test:ui) vs backend (node, no setup file). Use when creating or auditing vitest.config.ts files.
---

# Vitest Configuration Skill

This skill provides vitest.config.ts templates and validation logic for Vitest test configuration.

## Purpose

Manage vitest.config.ts configuration to:

- Configure test environment based on package type
- Set up test setup files (frontend only)
- Configure coverage reporting
- Add required dependencies and scripts

## Usage

This skill is invoked by the `vitest-agent` when:

- Creating new vitest.config.ts files
- Auditing existing Vitest configurations
- Validating Vitest configs against standards

## Templates

Templates are located at:

```
templates/vitest.config.ts.template         # Frontend (React apps, components)
templates/vitest-backend.config.ts.template # Backend (libraries, APIs, contracts, database)
templates/vitest.setup.ts.template          # Setup file (frontend only)
```

## The 5 Vitest Standards

### Standard 1: Merge with vite.config.ts (if it exists)

**Frontend packages with vite.config.ts:** Use mergeConfig

```typescript
import { mergeConfig, defineConfig } from "vitest/config";
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

**Backend packages (no vite.config.ts):** Use shared config

```typescript
import baseConfig from "@metasaver/core-vitest-config/base";
import { defineConfig } from "vitest/config";

export default defineConfig({
  ...baseConfig,
  test: {
    ...baseConfig.test,
    environment: "node",
  },
});
```

### Standard 2: Test Configuration (by package type)

| Package Type        | Environment | setupFiles              |
| ------------------- | ----------- | ----------------------- |
| React apps          | jsdom       | `["./vitest.setup.ts"]` |
| Frontend components | jsdom       | `["./vitest.setup.ts"]` |
| Backend libraries   | node        | None                    |
| API services        | node        | None                    |
| Contracts packages  | node        | None                    |
| Database packages   | node        | None                    |

### Standard 3: Setup File (frontend only)

**Location:** `./vitest.setup.ts` (at package root, per Vitest docs)

**Content:**

```typescript
import "@testing-library/jest-dom";
```

Backend packages do NOT need a setup file.

### Standard 4: Required Dependencies (by package type)

**Frontend packages:**

```json
{
  "devDependencies": {
    "vitest": "^3.2.4",
    "@vitest/coverage-v8": "^3.2.4",
    "@vitest/ui": "^3.2.4",
    "@testing-library/react": "^16.0.0",
    "@testing-library/jest-dom": "^6.0.0",
    "jsdom": "^26.0.0"
  }
}
```

**Backend packages:**

```json
{
  "devDependencies": {
    "vitest": "^3.2.4",
    "@vitest/coverage-v8": "^3.2.4",
    "@metasaver/core-vitest-config": "workspace:*"
  }
}
```

### Standard 5: Required npm Scripts (by package type)

**All packages:**

```json
{
  "scripts": {
    "test:unit": "vitest run",
    "test:watch": "vitest",
    "test:coverage": "vitest run --coverage"
  }
}
```

**Frontend packages (additional):**

```json
{
  "scripts": {
    "test:ui": "vitest --ui"
  }
}
```

## Package Type Rules Summary

| Package Type        | Environment | Setup File | test:ui | @testing-library/jest-dom |
| ------------------- | ----------- | ---------- | ------- | ------------------------- |
| React apps          | jsdom       | Yes        | Yes     | Yes                       |
| Frontend components | jsdom       | Yes        | Yes     | Yes                       |
| Backend libraries   | node        | No         | No      | No                        |
| API services        | node        | No         | No      | No                        |
| Contracts packages  | node        | No         | No      | No                        |
| Database packages   | node        | No         | No      | No                        |

## Validation

To validate a vitest.config.ts file:

1. Determine package type (frontend vs backend)
2. Check vitest.config.ts exists
3. For frontend: verify mergeConfig with vite.config.ts
4. For backend: verify shared config usage
5. Check environment matches package type
6. For frontend: verify ./vitest.setup.ts exists with jest-dom import
7. Check required dependencies for package type
8. Verify npm scripts (test:unit, test:watch, test:coverage, + test:ui for frontend)
9. Report violations

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

1. Place vitest.config.ts at workspace root
2. Frontend: merge with vite.config.ts using mergeConfig
3. Backend: use @metasaver/core-vitest-config/base shared config
4. Frontend only: create ./vitest.setup.ts with jest-dom import
5. Use correct environment (jsdom for frontend, node for backend)
6. Re-audit after making changes

## Integration

This skill integrates with:

- Repository type provided via `scope` parameter. If not provided, use `/skill scope-check`
- `/skill audit-workflow` - Bi-directional comparison workflow
- `/skill remediation-options` - Conform/Update/Ignore choices
- `vite-agent` - Ensure vite.config.ts exists for frontend packages
- `package-scripts-agent` - Ensure test scripts exist
