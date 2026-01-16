# Technical Impact Analysis: Monorepo Conversion + Veenk Migration

**Date:** 2026-01-16
**Epic:** MSM-VKM Monorepo & Veenk Migration

---

## Section 1: Overview & Context

### Current State

The `metasaver-marketplace` repository is currently structured as a Claude Code marketplace containing the `@metasaver/core-claude-plugin`. It contains agents, skills, commands, and templates but no executable code packages.

### Proposed Changes

1. **Add monorepo infrastructure**: `pnpm-workspace.yaml`, `turbo.json`, TypeScript configs
2. **Migrate veenk project**: Add as new plugin in `plugins/veenk/`
3. **Add code packages**: Create `packages/agentic-workflows` and `packages/mcp-servers`
4. **Maintain backward compatibility**: Existing `metasaver-core` plugin remains unchanged

### Repository Type Evolution

- **Current:** Claude Code marketplace (documentation/config only)
- **Target:** Hybrid marketplace + monorepo (marketplace with code capabilities)

---

## Section 2: Impact Analysis by Category

### 2.1 GitHub Actions

**Files:**

- `.github/workflows/publish.yml`
- `.github/workflows/version-bump.yml`

**Current Behavior:**

- Auto-bump versions on every push to `master`
- Triggers on changes to `plugins/`, `commands/`, `marketplace.json`

**Impact:** **MEDIUM**

**Analysis:**

The GitHub Actions workflows are designed for marketplace version management. Adding monorepo infrastructure will require updates to:

1. **Trigger paths** - May need to exclude `packages/` from version bumps if they have independent versioning
2. **Build steps** - If veenk plugin requires build artifacts, CI must generate them
3. **Dual versioning** - Marketplace versions vs package versions may diverge

**Required Changes:**

```yaml
# .github/workflows/version-bump.yml
on:
  push:
    branches:
      - master
    paths:
      - "plugins/**"
      - "commands/**"
      - ".claude-plugin/marketplace.json"
      # Exclude packages if they have independent versioning
      - "!packages/**"
```

**Recommendation:** Review whether veenk plugin needs build/publish steps separate from version bumping.

---

### 2.2 Marketplace Discovery Paths

**Files:**

- `.claude-plugin/marketplace.json`

**Current Structure:**

```json
{
  "plugins": [
    {
      "name": "core-claude-plugin",
      "source": "./plugins/metasaver-core",
      "strict": false,
      "skills": ["./skills/workflow-steps/analysis-phase", ...]
    }
  ]
}
```

**Impact:** **HIGH**

**Analysis:**

Adding the veenk plugin requires a new entry in the `plugins` array. The critical consideration is the `skills` array - skills MUST be explicitly listed for discovery (no auto-discovery).

**Required Changes:**

```json
{
  "plugins": [
    {
      "name": "core-claude-plugin",
      "source": "./plugins/metasaver-core",
      "strict": false,
      "skills": [...]
    },
    {
      "name": "veenk-plugin",
      "source": "./plugins/veenk",
      "strict": false,
      "skills": [
        "./skills/veenk-skill-1",
        "./skills/veenk-skill-2"
      ]
    }
  ]
}
```

**Key Rules:**

- `skills[]` array is REQUIRED for skill discovery
- Skill paths are RELATIVE to `source` directory
- Agents and commands auto-discover from `./agents/` and `./commands/`

---

### 2.3 Monorepo Tooling

**Files (NEW):**

- `pnpm-workspace.yaml`
- `turbo.json`
- `tsconfig.base.json`
- Root `package.json` (existing, requires updates)

**Impact:** **HIGH**

**Analysis:**

Adding monorepo infrastructure introduces new tooling dependencies and configuration files. This is a significant change but does NOT break existing marketplace functionality.

**Required Files:**

**`pnpm-workspace.yaml`:**

```yaml
packages:
  - "packages/*"
  - "plugins/*/packages/*" # If veenk has sub-packages
```

**`turbo.json`:**

```json
{
  "$schema": "https://turbo.build/schema.json",
  "pipeline": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": ["dist/**", ".next/**"]
    },
    "lint": {
      "cache": false
    },
    "test": {
      "dependsOn": ["build"],
      "cache": false
    }
  }
}
```

**Root `package.json` updates:**

```json
{
  "name": "@metasaver/marketplace",
  "version": "1.8.45",
  "private": true,
  "workspaces": ["packages/*", "plugins/*/packages/*"],
  "scripts": {
    "build": "turbo build",
    "test": "turbo test",
    "lint": "turbo lint",
    "dev": "turbo dev"
  },
  "devDependencies": {
    "turbo": "^2.x.x",
    "@changesets/cli": "^2.x.x"
  }
}
```

**Compatibility Notes:**

- Existing scripts (`scripts/qbp.sh`, etc.) continue to work
- New monorepo scripts are additive, not replacements
- `pnpm-workspace.yaml` does NOT conflict with marketplace discovery

---

### 2.4 Existing Scripts

**Files:**

- `scripts/qbp.sh`
- Any other shell scripts

**Current Usage:**

```bash
#!/bin/bash
# Quick build and publish script
```

**Impact:** **LOW**

**Analysis:**

Existing scripts should continue to work. However, if scripts assume a flat structure or specific paths, they may need updates.

**Recommendations:**

1. **Audit scripts** - Check if any assume non-monorepo structure
2. **Update path references** - If scripts reference `node_modules` or build artifacts
3. **Add monorepo-aware scripts** - New scripts for building/testing packages

**No Breaking Changes Expected:** Scripts in `/scripts` are independent of monorepo structure.

---

### 2.5 Documentation

**Files:**

- `CLAUDE.md`
- `README.md`
- Plugin-specific docs

**Impact:** **MEDIUM**

**Analysis:**

Documentation must be updated to reflect:

1. New repository type (hybrid marketplace + monorepo)
2. Updated structure diagram
3. New development workflows
4. Private plugin installation (if veenk is private)

**Required Updates:**

**`CLAUDE.md` - Repository Overview section:**

```markdown
## Repository Overview

**MetaSaver Official Marketplace** - A Claude Code marketplace containing plugins with agents, skills, and commands. Also serves as a monorepo for shared code packages.

- **Repository Type:** Hybrid Claude Code marketplace + monorepo
- **Primary Plugins:**
  - `@metasaver/core-claude-plugin` (public)
  - `veenk-plugin` (private)
- **Code Packages:** `@metasaver/agentic-workflows`, `@metasaver/mcp-servers`
```

**`CLAUDE.md` - Repository Structure section:**

```markdown
## Repository Structure
```

metasaver-marketplace/
├── .claude-plugin/
│ └── marketplace.json # Marketplace manifest
├── plugins/
│ ├── metasaver-core/ # Public plugin
│ │ ├── .claude-plugin/
│ │ │ └── plugin.json
│ │ ├── agents/
│ │ ├── skills/
│ │ └── commands/
│ └── veenk/ # Private plugin
│ └── [similar structure]
├── packages/
│ ├── agentic-workflows/ # Shared code package
│ └── mcp-servers/ # MCP server implementations
├── pnpm-workspace.yaml
├── turbo.json
└── tsconfig.base.json

```

```

**`README.md` - Similar updates to structure and overview**

---

### 2.6 Repository Type Classification

**File:**

- `plugins/metasaver-core/skills/config/workspace/scope-check/SKILL.md`

**Current Logic:**

The `scope-check` skill classifies repositories as:

- Library (has `@metasaver` scope in package.json)
- Consumer (no `@metasaver` scope)
- Monorepo (has workspace configuration)
- Marketplace (Claude Code marketplace)

**Impact:** **HIGH**

**Analysis:**

After this migration, the repository will be:

1. **A marketplace** (`.claude-plugin/marketplace.json` exists)
2. **A monorepo** (`pnpm-workspace.yaml` exists)
3. **Contains library code** (packages with `@metasaver` scope)

This is a **NEW COMBINATION** not currently handled by `scope-check`.

**Current Classification Logic:**

```typescript
// Pseudo-code from scope-check skill
if (hasMarketplaceJson) return "marketplace";
if (hasWorkspaceConfig) return "monorepo";
if (hasMetasaverScope) return "library";
return "consumer";
```

**Problem:** The current logic uses early returns, so a repository can only have ONE type. This prevents hybrid classification.

**Required Changes:**

The `scope-check` skill must be updated to support hybrid repositories:

```typescript
// NEW: Support multiple repository types
const types = [];
if (hasMarketplaceJson) types.push("marketplace");
if (hasWorkspaceConfig) types.push("monorepo");
if (hasLibraryPackages) types.push("library");
if (hasConsumerPackages) types.push("consumer");

return types.length > 1 ? types : types[0];
```

**Recommendation:** Update `scope-check` skill to return array of types for hybrid repositories.

---

### 2.7 pnpm-workspace Templates

**File:**

- `plugins/metasaver-core/skills/config/workspace/pnpm-workspace-config/templates/pnpm-workspace.yaml.template`

**Current Template:**

```yaml
packages:
  - "packages/*"
  - "apps/*"
```

**Impact:** **LOW**

**Analysis:**

The existing pnpm-workspace template assumes a standard `packages/` + `apps/` structure. This marketplace will use `packages/` + `plugins/*/packages/*` (if veenk has sub-packages).

**Recommendation:**

Update the template to include a "marketplace hybrid" variant:

```yaml
# Marketplace hybrid variant
packages:
  - "packages/*"
  - "plugins/*/packages/*"
```

Alternatively, create a new template specifically for marketplace repositories.

---

## Section 3: Private Plugin Support

### Current State (from claude-code-guide research)

**Private plugin installation is FULLY SUPPORTED via GitHub token authentication:**

```bash
# Installing from private GitHub repo
claude install https://github.com/org/private-plugin.git --github-token $GITHUB_TOKEN

# Or using environment variable
export GITHUB_TOKEN=ghp_xxxxx
claude install https://github.com/org/private-plugin.git
```

**Key Points:**

1. **No public publishing required** - Private plugins can stay in private GitHub repos
2. **Token-based auth** - Use GitHub personal access tokens or fine-grained tokens
3. **Same discovery rules** - Private plugins follow same `.claude-plugin/` structure
4. **No marketplace.io needed** - Installing directly from GitHub URL bypasses public marketplace

### Implications for Veenk Migration

**POSITIVE:**

- Veenk plugin can remain private in this repository
- No need to publish to public marketplace
- Users install entire marketplace repo (includes both plugins)

**CONSIDERATIONS:**

1. **Access control** - Users need repo access to install
2. **Token management** - Users must configure `GITHUB_TOKEN`
3. **Documentation** - Installation instructions must include token setup

**Installation Flow for Private Marketplace:**

```bash
# For users with repo access
export GITHUB_TOKEN=ghp_xxxxxxxxxxxxx
claude install https://github.com/metasaver/metasaver-marketplace.git

# Claude discovers BOTH plugins:
# - plugins/metasaver-core (public)
# - plugins/veenk (private)
```

**No Breaking Changes:** Private plugin support is native to Claude Code, no modifications needed.

---

## Section 4: Files Requiring Updates

### Critical Priority (MUST UPDATE)

| File                              | Change Required                | Reason                                  |
| --------------------------------- | ------------------------------ | --------------------------------------- |
| `.claude-plugin/marketplace.json` | Add veenk plugin entry         | Enable veenk plugin discovery           |
| `CLAUDE.md`                       | Update repo type and structure | Document hybrid marketplace+monorepo    |
| `README.md`                       | Update structure diagram       | Reflect new packages/ directory         |
| `scope-check/SKILL.md`            | Support hybrid repo types      | Handle marketplace+monorepo combination |

### High Priority (SHOULD UPDATE)

| File                                 | Change Required                     | Reason                                   |
| ------------------------------------ | ----------------------------------- | ---------------------------------------- |
| `.github/workflows/version-bump.yml` | Add package exclusion rules         | Prevent version bumps on package changes |
| `pnpm-workspace-config/templates/`   | Add marketplace hybrid variant      | Provide template for this structure      |
| Root `package.json`                  | Add workspaces and monorepo scripts | Enable monorepo tooling                  |

### Medium Priority (NICE TO HAVE)

| File             | Change Required                       | Reason                       |
| ---------------- | ------------------------------------- | ---------------------------- |
| `scripts/qbp.sh` | Audit for monorepo compatibility      | Ensure existing scripts work |
| GitHub Actions   | Add build steps for veenk (if needed) | Support build artifacts      |

### New Files Required

| File                                       | Purpose                    |
| ------------------------------------------ | -------------------------- |
| `pnpm-workspace.yaml`                      | Define monorepo workspaces |
| `turbo.json`                               | Configure build pipeline   |
| `tsconfig.base.json`                       | Shared TypeScript config   |
| `plugins/veenk/.claude-plugin/plugin.json` | Veenk plugin manifest      |
| `plugins/veenk/agents/`                    | Veenk agents directory     |
| `plugins/veenk/skills/`                    | Veenk skills directory     |
| `plugins/veenk/commands/`                  | Veenk commands directory   |
| `packages/agentic-workflows/package.json`  | Workflows package          |
| `packages/mcp-servers/package.json`        | MCP servers package        |

---

## Section 5: Summary of Breaking vs Non-Breaking Changes

### Non-Breaking Changes (Backward Compatible)

1. **Adding `pnpm-workspace.yaml`** - Does not affect marketplace discovery
2. **Adding `turbo.json`** - Additive, existing scripts continue working
3. **Adding `packages/` directory** - New directory, does not conflict with `plugins/`
4. **Adding veenk plugin** - New plugin entry, does not affect metasaver-core
5. **Adding monorepo scripts** - New scripts in root package.json, existing scripts unchanged

**Key Insight:** Monorepo infrastructure can be added WITHOUT breaking existing marketplace functionality. The two systems are independent and complementary.

### Potentially Breaking Changes

1. **`scope-check` skill logic** - Currently cannot handle hybrid repos (MUST UPDATE)
2. **Documentation references** - Any docs that hardcode "this is a marketplace only" (SHOULD UPDATE)
3. **GitHub Actions triggers** - May trigger version bumps on package changes (SHOULD UPDATE)

### Zero-Impact Changes

1. **Private plugin support** - Already supported, no changes needed
2. **Plugin discovery** - Works the same way with multiple plugins
3. **Existing scripts** - Continue working unless they assume flat structure

---

## Conclusion

The monorepo conversion is **largely non-breaking** and can be implemented incrementally:

1. **Phase 1:** Add monorepo infrastructure (pnpm-workspace, turbo, configs)
2. **Phase 2:** Migrate veenk plugin structure (agents, skills, commands)
3. **Phase 3:** Update marketplace.json to include veenk
4. **Phase 4:** Create code packages (agentic-workflows, mcp-servers)
5. **Phase 5:** Update documentation and scope-check skill

**Risk Level:** **LOW-MEDIUM**

**Recommendation:** Proceed with migration, prioritizing backward compatibility for existing metasaver-core plugin users.
