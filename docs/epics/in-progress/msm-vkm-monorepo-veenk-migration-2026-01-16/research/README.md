# Monorepo Conversion + Veenk Migration

**Created:** 2026-01-16
**Status:** In Progress

---

## Project Overview

This project converts metasaver-marketplace into a standard MetaSaver monorepo structure and migrates the veenk project as a new plugin.

**Key Objectives:**

1. Add monorepo infrastructure (pnpm-workspace, turbo, TypeScript configs)
2. Migrate veenk project into this repository as a new plugin
3. Maintain backward compatibility with existing metasaver-core plugin
4. Set up new package structure: `/packages/agentic-workflows`, `/packages/mcp-servers`

**Key Documents:**

- **Research:** `research.md` - Technical impact analysis
- **Veenk Project Doc:** TBD (to be provided)
- **PRD:** TBD (will be created from research + veenk doc)

---

## Target Structure

```
metasaver-marketplace/
├── plugins/
│   ├── metasaver-core/          # Existing, unchanged
│   └── veenk/                   # New plugin (migrated)
├── packages/
│   ├── agentic-workflows/       # New code package
│   └── mcp-servers/             # New code package
├── pnpm-workspace.yaml          # New
├── turbo.json                   # New
└── [monorepo configs]           # New (tsconfig, prettier, eslint)
```

---

## Project Phases

### Phase 1: Research & Planning ✅

- [x] Technical impact analysis completed
- [ ] Veenk project documentation received
- [ ] PRD created from combined research

### Phase 2: Monorepo Infrastructure

- [ ] Create `pnpm-workspace.yaml`
- [ ] Create `turbo.json`
- [ ] Set up TypeScript configuration hierarchy
- [ ] Configure Prettier/ESLint for monorepo
- [ ] Update root `package.json` with monorepo scripts

### Phase 3: Veenk Migration

- [ ] Create `plugins/veenk/.claude-plugin/plugin.json`
- [ ] Migrate veenk agents/skills/commands
- [ ] Update `.claude-plugin/marketplace.json` to include veenk plugin
- [ ] Create initial packages structure

### Phase 4: Documentation & Cleanup

- [ ] Update `CLAUDE.md` (repository type, structure)
- [ ] Update `README.md` (structure diagram)
- [ ] Update GitHub Actions (if needed for veenk versioning)
- [ ] Update scope-check skill (repository classification)

### Phase 5: Validation

- [ ] Test plugin discovery (both plugins)
- [ ] Verify monorepo build/lint/test
- [ ] Confirm private plugin installation works
- [ ] Update any broken scripts

---

## Key Decisions

1. **Keep `plugins/` directory structure** - No migration of existing metasaver-core plugin
2. **Add `packages/` for code** - New monorepo packages separate from plugins
3. **Private plugin support confirmed** - Can stay private, no public publishing required
4. **Minimal impact to existing plugin** - Backward compatible approach

---

## Notes

- This repo remains a marketplace but gains code capabilities
- Existing users of metasaver-core plugin see no breaking changes
- Private GitHub installation fully supported via `GITHUB_TOKEN`
