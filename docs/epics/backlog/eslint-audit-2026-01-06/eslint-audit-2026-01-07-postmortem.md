# ESLint Audit Postmortem - 2026-01-07

## Summary

Audited 43 ESLint config files across 6 repositories (multi-mono, metasaver-com, resume-builder, rugby-crm, sandbox, veenk).

## Results

| Metric              | Count |
| ------------------- | ----- |
| Files audited       | 43    |
| Initially compliant | 16    |
| Fixes applied       | 22    |
| Template updates    | 1     |

## Issues Fixed

### 1. Import/Spread Pattern (19 files in multi-mono)

All multi-mono packages used `import X; export default [...X]` instead of the standard `export { default } from "..."` pattern.

**Fix:** Updated all 19 files to use the re-export pattern.

### 2. Wrong Import Path (3 files in sandbox)

Sandbox projects imported from `@metasaver/eslint-config` instead of `@metasaver/core-eslint-config`.

**Fix:** Corrected import paths in calculator2, weather, and playlist-picker.

### 3. Missing Dependency (workflow-utils)

Package was missing `@metasaver/core-eslint-config` in devDependencies and using wrong config type (base instead of node).

**Fix:** Added dependency and changed to node config.

### 4. Incomplete Skill Documentation

The eslint-config skill in metasaver-marketplace only documented 4 projectTypes but repos use 13+.

**Fix:** Updated SKILL.md to include all projectTypes:

- library → node
- contracts → node
- database → node
- data-service → node
- integration-service → node
- pipeline-service → node
- workflow → node
- mcp → node
- turborepo-monorepo → base

## Workflow Issues Identified

1. **Audit command referenced wrong paths** - Used `docs/prd/` and `docs/projects/` instead of `docs/epics/`
2. **Skill documentation was incomplete** - Caused false positives during audit

## Verification

- `pnpm lint`: PASS
- `pnpm build`: PASS

## Files Modified

### multi-mono (20 files)

- eslint.config.js
- config/nodemon-config/eslint.config.js
- config/postcss-config/eslint.config.js
- config/prettier-config/eslint.config.js
- config/tailwind-config/eslint.config.js
- config/typescript-config/eslint.config.js
- config/vite-config/eslint.config.js
- config/vitest-config/eslint.config.js
- components/core/eslint.config.js
- components/layouts/eslint.config.js
- packages/agent-utils/eslint.config.js
- packages/core-database-utils/eslint.config.js
- packages/dapr-utils/eslint.config.js
- packages/mcp-utils/eslint.config.js
- packages/service-utils/eslint.config.js
- packages/task-utils/eslint.config.js
- packages/temporal-utils/eslint.config.js
- packages/utils/eslint.config.js
- packages/workflow-utils/eslint.config.js
- packages/workflow-utils/package.json

### sandbox (3 files)

- mcp/calculator2/eslint.config.js
- mcp/weather/eslint.config.js
- workflows/playlist-picker/eslint.config.js

### metasaver-marketplace (1 file)

- plugins/metasaver-core/skills/config/code-quality/eslint-config/SKILL.md
