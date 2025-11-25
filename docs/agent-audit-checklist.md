# Config Agent Audit Checklist

**Purpose:** Manual testing of all 28 config agents in AUDIT mode
**Test Repositories:**
- `/f/code/multi-mono`
- `/f/code/metasaver-com`
- `/f/code/rugby-crm`
- `/f/code/resume-builder`

**Testing Protocol:**
1. Ask Claude: "What's the next agent to test?"
2. Run the audit command against one or more repos
3. Evaluate results (pass/fix/fail)
4. Report back: "Complete" or describe issues
5. Move to next agent

---

## Test Status Legend

- `[ ]` Not started
- `[T]` Testing in progress
- `[P]` Passed
- `[F]` Fixed (had issues, now resolved)
- `[X]` Failed (needs investigation)

---

## Phase 1A: Build Tools (8 agents)

| # | Agent | Status | Notes | Date |
|---|-------|--------|-------|------|
| 1 | docker-compose-agent | [P] | 3/3 repos passed (multi-mono has no compose file) | 2025-11-24 |
| 2 | dockerignore-agent | [ ] | | |
| 3 | pnpm-workspace-agent | [ ] | | |
| 4 | postcss-agent | [ ] | | |
| 5 | tailwind-agent | [ ] | | |
| 6 | turbo-config-agent | [ ] | | |
| 7 | vite-agent | [ ] | | |
| 8 | vitest-agent | [ ] | | |

---

## Phase 1B: Code Quality (3 agents)

| # | Agent | Status | Notes | Date |
|---|-------|--------|-------|------|
| 9 | editorconfig-agent | [ ] | | |
| 10 | eslint-agent | [ ] | | |
| 11 | prettier-agent | [ ] | | |

---

## Phase 1C: Version Control (5 agents)

| # | Agent | Status | Notes | Date |
|---|-------|--------|-------|------|
| 12 | commitlint-agent | [ ] | | |
| 13 | gitattributes-agent | [ ] | | |
| 14 | github-workflow-agent | [ ] | | |
| 15 | gitignore-agent | [ ] | | |
| 16 | husky-agent | [ ] | | |

---

## Phase 1D: Workspace (12 agents)

| # | Agent | Status | Notes | Date |
|---|-------|--------|-------|------|
| 17 | claude-md-agent | [ ] | | |
| 18 | env-example-agent | [ ] | | |
| 19 | monorepo-root-structure-agent | [ ] | | |
| 20 | nodemon-agent | [ ] | | |
| 21 | npmrc-template-agent | [ ] | | |
| 22 | nvmrc-agent | [ ] | | |
| 23 | readme-agent | [ ] | | |
| 24 | repomix-config-agent | [ ] | | |
| 25 | root-package-json-agent | [ ] | | |
| 26 | scripts-agent | [ ] | | |
| 27 | typescript-agent | [ ] | | |
| 28 | vscode-agent | [ ] | | |

---

## Summary

| Phase | Total | Passed | Fixed | Failed | Remaining |
|-------|-------|--------|-------|--------|-----------|
| 1A Build Tools | 8 | 1 | 0 | 0 | 7 |
| 1B Code Quality | 3 | 0 | 0 | 0 | 3 |
| 1C Version Control | 5 | 0 | 0 | 0 | 5 |
| 1D Workspace | 12 | 0 | 0 | 0 | 12 |
| **TOTAL** | **28** | **1** | **0** | **0** | **27** |

---

## Test Commands Reference

### Standard Audit Command
```
/ms audit [config-type] in [repo-path]
```

### Examples
```
/ms audit docker-compose in /f/code/multi-mono
/ms audit eslint in /f/code/rugby-crm
/ms audit typescript configuration across all repos
```

---

## Issues Log

### Issue Template
```markdown
### [Agent Name] - Issue #X
**Date:** YYYY-MM-DD
**Severity:** Critical/High/Medium/Low
**Description:**
**Root Cause:**
**Fix Applied:**
**Verified:** [ ]
```

---

## Completion Criteria

Each agent passes when:
- [ ] Runs without errors on at least 2 repos
- [ ] Produces structured, actionable output
- [ ] No false positives in findings
- [ ] Uses Serena tools (not full file reads)
- [ ] Documentation matches behavior
