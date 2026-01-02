# Audit PRD: Vite Configuration

**Date:** 2026-01-01
**Scope:** Vite configuration files across all consumer repos
**Agent:** `core-claude-plugin:config:build-tools:vite-agent`

## Objective

Audit all vite.config.ts files against MetaSaver's 5 Vite Configuration Standards to ensure consistency and best practices across the monorepo ecosystem.

## Files in Scope

| #   | Repo           | File                              | Type    |
| --- | -------------- | --------------------------------- | ------- |
| 1   | multi-mono     | components/core/vite.config.ts    | Library |
| 2   | multi-mono     | components/layouts/vite.config.ts | Library |
| 3   | metasaver-com  | apps/admin-portal/vite.config.ts  | App     |
| 4   | resume-builder | apps/resume-portal/vite.config.ts | App     |
| 5   | rugby-crm      | apps/rugby-portal/vite.config.ts  | App     |

## The 5 Vite Standards

| Rule | Standard        | Requirement                                                |
| ---- | --------------- | ---------------------------------------------------------- |
| 1    | Correct Plugins | Must include `@vitejs/plugin-react`                        |
| 2    | Path Alias      | Must include `#src` alias pointing to `./src`              |
| 3    | Build Config    | Must include outDir, sourcemap, manualChunks               |
| 4    | Server Config   | Must include port, strictPort: true, host                  |
| 5    | Dependencies    | Must have vite and @vitejs/plugin-react in devDependencies |

## Repository Type Considerations

- **Library Repos (multi-mono)**: May have custom Vite config for component library builds
- **Consumer Repos (others)**: Must strictly follow all 5 standards unless exception declared

## Success Criteria

1. All 5 files audited against all 5 standards
2. Each discrepancy presented to user with Conform/Update/Ignore options
3. User-approved fixes applied
4. Build/lint/test passing after remediation

## User Stories

### US-1: Audit multi-mono/components/core/vite.config.ts

- **Agent:** vite-agent
- **File:** /home/jnightin/code/multi-mono/components/core/vite.config.ts
- **Type:** Library
- **AC:** All 5 rules validated, discrepancies reported

### US-2: Audit multi-mono/components/layouts/vite.config.ts

- **Agent:** vite-agent
- **File:** /home/jnightin/code/multi-mono/components/layouts/vite.config.ts
- **Type:** Library
- **AC:** All 5 rules validated, discrepancies reported

### US-3: Audit metasaver-com/apps/admin-portal/vite.config.ts

- **Agent:** vite-agent
- **File:** /home/jnightin/code/metasaver-com/apps/admin-portal/vite.config.ts
- **Type:** App (Consumer)
- **AC:** All 5 rules validated, discrepancies reported

### US-4: Audit resume-builder/apps/resume-portal/vite.config.ts

- **Agent:** vite-agent
- **File:** /home/jnightin/code/resume-builder/apps/resume-portal/vite.config.ts
- **Type:** App (Consumer)
- **AC:** All 5 rules validated, discrepancies reported

### US-5: Audit rugby-crm/apps/rugby-portal/vite.config.ts

- **Agent:** vite-agent
- **File:** /home/jnightin/code/rugby-crm/apps/rugby-portal/vite.config.ts
- **Type:** App (Consumer)
- **AC:** All 5 rules validated, discrepancies reported
