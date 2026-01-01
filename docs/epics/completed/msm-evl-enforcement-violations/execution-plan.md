# Execution Plan: MSM008 AskUserQuestion Enforcement

**Stories:** 3
**Waves:** 2
**Duration:** ~10 minutes

---

## Gantt Chart

```
Time -->    0    5    10
            |    |    |
Wave 1 (Sequential)
msm-evl-001      [====]
                 |
                 v
Wave 2 (Parallel)
msm-evl-002           [====]
msm-evl-003           [====]
                      |
                      v
                 COMPLETE
```

---

## Wave 1: Foundation

| Story  | Description      | Agent       | Duration |
| ------ | ---------------- | ----------- | -------- |
| msm-evl-001 | Update CLAUDE.md | manual-edit | 3-5 min  |

**File:** `CLAUDE.md`

---

## Wave 2: /ms Command Updates (Parallel)

| Story  | Description                     | Agent          | Duration |
| ------ | ------------------------------- | -------------- | -------- |
| msm-evl-002 | Make Phase 2b mandatory         | command-author | 3-5 min  |
| msm-evl-003 | Add AskUserQuestion enforcement | command-author | 3-5 min  |

**File:** `plugins/metasaver-core/commands/ms.md`

---

## Success Criteria

- [ ] CLAUDE.md no longer has "answer directly" guidance
- [ ] /ms Phase 2b runs for ALL new workflows
- [ ] /ms Enforcement section includes AskUserQuestion rule
