---
id: US-003
title: Update configuration agents for package.json and tsconfig
status: pending
assignee: null
---

# US-003: Update Configuration Agents for Package.json and TSConfig

## User Story

As a developer setting up a new TypeScript package, I want the typescript-agent and root-package-json-agent to configure the no-barrel architecture settings so that my package supports `#/` imports and explicit exports.

## Acceptance Criteria

- [ ] `typescript-agent` adds `paths` configuration for `#/` alias to tsconfig.json
- [ ] `typescript-agent` includes `baseUrl: "."` in compilerOptions
- [ ] `typescript-agent` includes `paths: { "#/*": ["./src/*"] }` in compilerOptions
- [ ] `root-package-json-agent` adds `imports` field: `{ "#/*": "./src/*.js" }`
- [ ] `root-package-json-agent` generates `exports` field with per-module entries
- [ ] `root-package-json-agent` documents export path structure (e.g., `./feature/types`)
- [ ] `root-package-json-agent` validates that exports point to both `.d.ts` and `.js` files

## Technical Notes

**TSConfig paths configuration:**

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

**Package.json imports/exports configuration:**

```json
{
  "imports": {
    "#/*": "./src/*.js"
  },
  "exports": {
    "./feature/types": {
      "types": "./dist/feature/types.d.ts",
      "import": "./dist/feature/types.js"
    }
  }
}
```

## Files

- `agents/config/workspace/typescript-agent.md`
- `agents/config/workspace/root-package-json-agent.md`

## Architecture

### Key Modifications

**File: `agents/config/workspace/typescript-agent.md`**

- Add "Path Alias Configuration" section after introduction
- Include required compilerOptions:
  - `baseUrl: "."`
  - `paths: { "#/*": ["./src/*"] }`
- Add validation logic to check for `#/` alias presence
- Update skill reference: `/skill typescript-configuration` (will be updated in US-004)
- Add example tsconfig.json snippet showing paths configuration

**File: `agents/config/workspace/root-package-json-agent.md`**

- Add "No-Barrel Package Configuration" section after introduction
- Include required fields:
  - `imports: { "#/*": "./src/*.js" }`
  - `exports: { "./feature/types": { "types": "...", "import": "..." } }`
- Add validation for imports/exports field structure
- Update skill reference: `/skill root-package-json-config` (will be updated in US-004)
- Add documentation pattern for export paths (feature/submodule naming)
- Include validation that exports have both `.d.ts` and `.js` entries

### Dependencies

- Depends on: None (can execute in parallel with US-002, US-004, US-005, US-006)
- Blocks: US-001 (commands reference config skills which reference these agents)
