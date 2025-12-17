---
id: US-004
title: Update configuration skills with no-barrel validation
status: pending
assignee: null
---

# US-004: Update Configuration Skills with No-Barrel Validation

## User Story

As a skill that validates configuration files, I want to include no-barrel architecture requirements in my validation logic so that audits can detect violations and guide developers toward correct patterns.

## Acceptance Criteria

- [ ] `root-package-json-config` skill validates presence of `imports` field
- [ ] `root-package-json-config` skill validates `imports` field contains `"#/*": "./src/*.js"`
- [ ] `root-package-json-config` skill validates presence of `exports` field
- [ ] `root-package-json-config` skill validates `exports` entries have both `types` and `import` fields
- [ ] `vitest-config` skill includes `#/` alias in resolve configuration
- [ ] `vitest-config` skill generates `resolve.alias: { "#": resolve(__dirname, "./src") }`
- [ ] `typescript-configuration` skill validates `paths` includes `#/*` mapping
- [ ] `typescript-configuration` skill validates `baseUrl` is set when using paths

## Technical Notes

**Validation checks for package.json:**

- ✅ Has `imports` field
- ✅ Has `exports` field
- ✅ `imports["#/*"]` points to `./src/*.js`
- ✅ Each export entry has `types` and `import` fields

**Validation checks for tsconfig.json:**

- ✅ Has `baseUrl` in compilerOptions
- ✅ Has `paths` in compilerOptions
- ✅ `paths["#/*"]` is defined

**Vitest config pattern:**

```typescript
export default defineConfig({
  resolve: {
    alias: {
      "#": resolve(__dirname, "./src"),
    },
  },
});
```

## Files

- `skills/config/workspace/root-package-json-config/SKILL.md`
- `skills/config/build-tools/vitest-config/SKILL.md`
- `skills/config/workspace/typescript-configuration/SKILL.md`

## Architecture

### Key Modifications

**File: `skills/config/workspace/root-package-json-config/SKILL.md`**

- Add Rule 6 to "The 5 Root Package.json Standards" table (making it 6 standards)
- Rule 6: No-Barrel Architecture (`imports` and `exports` fields)
- Add validation pseudo-code for:
  - `imports["#/*"]` exists and equals `"./src/*.js"`
  - `exports` object exists with per-module entries
  - Each export entry has both `types` and `import` fields
- Add examples section showing correct imports/exports structure
- Update template reference (if template needs updating in US-005)

**File: `skills/config/build-tools/vitest-config/SKILL.md`**

- Add "Path Alias Resolution" section after existing configuration
- Include `resolve.alias` configuration:
  ```typescript
  resolve: { alias: { "#": resolve(__dirname, "./src") } }
  ```
- Add validation check for `#` alias in vitest config
- Add example showing complete vitest config with alias

**File: `skills/config/workspace/typescript-configuration/SKILL.md`**

- Update "Validation" section to include paths checking
- Add validation rules:
  - `baseUrl` must be present when using `paths`
  - `paths["#/*"]` must exist and point to `["./src/*"]`
- Add common violation: Missing paths configuration
- Add remediation: Add baseUrl and paths to compilerOptions
- Include example tsconfig snippet with paths

### Dependencies

- Depends on: None (can execute in parallel with US-002, US-003, US-005, US-006)
- Blocks: US-001 (commands reference these skills)
