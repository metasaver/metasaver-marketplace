# PRD: No-Barrel Module Architecture Implementation

**Project:** 20251216-no-barrel-architecture
**Version:** 1.0
**Created:** 2025-12-16
**Status:** Approved for Implementation
**Reference:** [Original Architecture PRD](../../no-barrel-module-architecture-prd.md)

---

## 1. Overview

Implement the No-Barrel Module Architecture standard across all core-claude-plugin artifacts. This ensures all generated TypeScript code follows the no-barrel pattern with `#/` imports and explicit `exports` field configuration.

---

## 2. Business Requirements

### 2.1 Scope Decision

**Full Implementation** - Update ALL artifacts in one comprehensive effort:

- Commands (3)
- Code Generation Agents (3)
- Configuration Agents (2)
- Skills (4+)
- Templates (7+)

### 2.2 Compatibility Decision

**Hard-cut** - Only generate no-barrel code going forward:

- No dual-pattern support
- No backward compatibility shims
- Existing projects migrate independently

### 2.3 Audit Strictness Decision

**Strict Mode** - All violations are critical:

- Barrel files → CRITICAL violation
- `export *` statements → CRITICAL violation
- Relative `../` imports (should use `#/`) → CRITICAL violation
- Missing `imports` field → CRITICAL violation
- Missing `exports` field → CRITICAL violation

---

## 3. Technical Requirements

### 3.1 Import Pattern Standards

```typescript
// INTERNAL imports (within same package) - use #/
import type { User } from "#/users/types.js";
import { validateUser } from "#/users/validation.js";

// EXTERNAL imports (from other packages) - direct to module
import type { User } from "@metasaver/contracts/users/types";
```

### 3.2 Export Pattern Standards

```typescript
// ALLOWED
export type X = { ... };
export interface Y { ... }
export function fn() { ... }
export const CONST = "value";

// PROHIBITED
export * from "./types.js";           // NEVER
export default function() { ... }    // NEVER
```

### 3.3 File Naming Standards

| Content          | Filename        |
| ---------------- | --------------- |
| Types/Interfaces | `types.ts`      |
| Zod schemas      | `validation.ts` |
| Constants        | `constants.ts`  |
| Enums            | `enums.ts`      |
| Implementation   | `{feature}.ts`  |

### 3.4 Package.json Requirements

```json
{
  "imports": {
    "#/*": "./src/*.js"
  },
  "exports": {
    "./*": {
      "types": "./dist/*.d.ts",
      "import": "./dist/*.js"
    }
  }
}
```

**Wildcard Exports:** Single entry covers all modules with zero maintenance.

### 3.5 TSConfig Requirements

```json
{
  "compilerOptions": {
    "baseUrl": ".",
    "paths": {
      "#/*": ["./src/*"]
    }
  }
}
```

---

## 4. Artifacts to Update

### 4.1 Commands

| File                | Changes                                          |
| ------------------- | ------------------------------------------------ |
| `commands/build.md` | Generate code following no-barrel pattern        |
| `commands/audit.md` | Add barrel file detection as CRITICAL violations |
| `commands/ms.md`    | Route to updated agents                          |

### 4.2 Code Generation Agents

| File                                        | Changes                                               |
| ------------------------------------------- | ----------------------------------------------------- |
| `agents/generic/backend-dev.md`             | Generate `#/` imports, no `export *`, no barrel files |
| `agents/generic/coder.md`                   | Generate `#/` imports, no `export *`, no barrel files |
| `agents/domain/frontend/react-app-agent.md` | Use `#/` for internal, direct paths for external      |

### 4.3 Configuration Agents

| File                                                 | Changes                                     |
| ---------------------------------------------------- | ------------------------------------------- |
| `agents/config/workspace/typescript-agent.md`        | Add `paths` config for `#/` alias           |
| `agents/config/workspace/root-package-json-agent.md` | Add `imports` and `exports` field standards |

### 4.4 Skills

| File                                                        | Changes                            |
| ----------------------------------------------------------- | ---------------------------------- |
| `skills/config/workspace/root-package-json-config/SKILL.md` | Add `imports`/`exports` validation |
| `skills/config/build-tools/vitest-config/SKILL.md`          | Add `#/` alias in resolve config   |
| `skills/config/workspace/typescript-configuration/SKILL.md` | Add `#/` paths requirement         |
| Domain skills                                               | Update import pattern examples     |

### 4.5 Templates

| File                                        | Changes                                          |
| ------------------------------------------- | ------------------------------------------------ |
| `templates/common/tsconfig-*.template.json` | Add `paths: { "#/*": ["./src/*"] }`              |
| Domain templates                            | Remove barrel examples, add `#/` import patterns |

---

## 5. Acceptance Criteria

### 5.1 Code Generation

- [ ] All generated code uses `#/` for internal imports
- [ ] All generated code uses direct export paths for external imports
- [ ] No generated code contains `export *`
- [ ] No generated code contains barrel index.ts files
- [ ] All generated package.json files have `imports` and `exports` fields
- [ ] All generated tsconfig.json files have `paths` for `#/`

### 5.2 Audit Detection

- [ ] `/audit` detects barrel files as CRITICAL violations
- [ ] `/audit` detects `export *` as CRITICAL violations
- [ ] `/audit` detects relative `../` imports as CRITICAL violations
- [ ] `/audit` detects missing `imports` field as CRITICAL violations
- [ ] `/audit` detects missing `exports` field as CRITICAL violations

### 5.3 Documentation

- [ ] All agent instructions include no-barrel methodology
- [ ] All skill documentation updated
- [ ] Template examples follow standard

---

## 6. Out of Scope

- Migration tooling for existing projects
- ESLint rule implementation
- Backward compatibility support
- Deprecation warnings

---

## 7. Dependencies

- No external dependencies
- Self-contained plugin updates

---

## 8. Risks

| Risk                                   | Mitigation                                        |
| -------------------------------------- | ------------------------------------------------- |
| Breaking changes for existing projects | Hard-cut decision - not our concern               |
| Large scope                            | Full implementation chosen - comprehensive update |
| Testing coverage                       | Validation phase will verify all changes          |

---

**Document Owner:** BA Agent
**Approved By:** User (2025-12-16)
