---
story_id: "MSM-VKM-E07-004"
epic_id: "MSM-VKM-E07"
title: "Update GitHub Actions workflows"
status: "pending"
complexity: 3
wave: 6
agent: "core-claude-plugin:config:version-control:github-workflow-agent"
dependencies: ["MSM-VKM-E03-006"]
created: "2026-01-16"
updated: "2026-01-16"
---

# MSM-VKM-E07-004: Update GitHub Actions workflows

## User Story

**As a** repository maintainer for the metasaver-marketplace repository
**I want** GitHub Actions workflows updated to work with the hybrid monorepo structure
**So that** CI/CD pipelines run correctly for both marketplace plugins and workflow packages

---

## Acceptance Criteria

- [ ] All GitHub Actions workflows identified and reviewed
- [ ] Version bump workflow excludes `packages/` directory
- [ ] CI workflow runs tests for all packages
- [ ] CI workflow uses Turborepo for efficient caching
- [ ] Build workflow compiles all packages correctly
- [ ] Workflow triggers configured appropriately
- [ ] No workflow runs on `packages/` version bumps
- [ ] Marketplace functionality workflows unchanged
- [ ] Follows established template/pattern
- [ ] Format validated

---

## Technical Details

### Location

- **Repo:** metasaver-marketplace
- **Package:** root level

### Files to Modify

| File                                 | Purpose                                   |
| ------------------------------------ | ----------------------------------------- |
| `.github/workflows/version-bump.yml` | Exclude packages/ from auto version bumps |
| `.github/workflows/ci.yml`           | Add monorepo testing (if exists)          |
| `.github/workflows/build.yml`        | Add monorepo build (if exists)            |
| Any other workflow files             | Update as needed for monorepo             |

---

## Implementation Notes

### Key Updates Required

**1. Version Bump Workflow**

Critical: Marketplace plugins should auto-version, but workflow packages should not.

Update `.github/workflows/version-bump.yml`:

```yaml
name: Version Bump
on:
  push:
    branches:
      - main
    paths:
      - "plugins/**"
      - "commands/**"
      - ".claude-plugin/marketplace.json"
      # Explicitly exclude packages/
      - "!packages/**"
```

**2. CI/CD Workflow (if exists)**

Add monorepo-aware testing:

```yaml
name: CI
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: pnpm/action-setup@v2
        with:
          version: 8
      - name: Install dependencies
        run: pnpm install
      - name: Build all packages
        run: pnpm build
      - name: Test all packages
        run: pnpm test
      - name: Lint all packages
        run: pnpm lint
```

**3. Workflow Triggers**

Ensure workflows only run when relevant:

- Plugin changes: version bump, marketplace validation
- Workflow package changes: tests, builds, but NO version bump
- Documentation changes: skip CI if only docs

### Monorepo Optimization

Use Turborepo for caching:

```yaml
- name: Build with Turborepo
  run: pnpm turbo build
  env:
    TURBO_TOKEN: ${{ secrets.TURBO_TOKEN }}
    TURBO_TEAM: ${{ secrets.TURBO_TEAM }}
```

---

## Architecture

(Added by architect-agent - technical annotations pending)

**Key Files:**

- `.github/workflows/version-bump.yml` - Auto version marketplace plugins only
- `.github/workflows/ci.yml` - Run tests for all packages (if exists)
- `.github/workflows/build.yml` - Build all packages (if exists)

**Workflow Strategy:**

- Separate marketplace plugin versioning from workflow package versioning
- Use path filters to trigger appropriate workflows
- Leverage Turborepo caching for fast builds
- Maintain existing marketplace automation

---

## Definition of Done

- [ ] Implementation complete
- [ ] Version bump workflow excludes packages/
- [ ] CI workflow runs successfully on test push
- [ ] Build workflow compiles all packages
- [ ] No workflow failures due to monorepo changes
- [ ] Acceptance criteria verified
- [ ] Workflows tested with dry-run commits

---

## Notes

- Version bumping for `packages/` should be manual (not automated)
- Test workflows with empty commits to verify triggers work
- Consider adding Turborepo Remote Caching for performance
- Keep marketplace workflows as primary focus
- Workflow packages are secondary and should not affect marketplace automation
