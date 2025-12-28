# US-003: Update scope-check-agent

**Status:** 🔵 Pending
**Priority:** Medium
**Estimated Effort:** Low
**File:** `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/agents/generic/scope-check-agent.md`

---

## Story

As a scope-check agent, I need to update my description and output format references to reflect the new file detection capability so that I'm properly documented for the new audit workflow.

---

## Acceptance Criteria

### Update Description

- [ ] Update frontmatter description to mention file detection
- [ ] Old: "Text analysis specialist for repository scope detection (targets vs references)"
- [ ] New: "Text analysis specialist for repository and file detection in audit scope"

### Update Purpose Section

- [ ] Update Purpose statement to emphasize file detection
- [ ] Old: "You analyze user prompts and return target repositories (where changes happen) vs reference repositories (for pattern learning)."
- [ ] New: "You analyze user prompts and return repository paths AND specific file paths for audit execution."

### Update Output Format Reference

- [ ] Update Output section from `scope: { targets: [...], references: [...] }` to `scope: { repos: [...], files: [...] }`
- [ ] Update example output format

### Verify No Breaking Changes

- [ ] Ensure agent still invokes `/skill scope-check` correctly
- [ ] Ensure agent metadata (model: haiku, tools: TodoWrite, permissionMode: bypassPermissions) unchanged
- [ ] Ensure "How to Execute" section remains accurate

---

## Dependencies

- **Depends on:** US-002 (scope-check skill must be updated first)
- **Blocks:** US-001 (audit.md references this agent)

---

## Technical Notes

### Minimal Changes Required

This is a lightweight update to align agent documentation with skill changes. The agent itself doesn't implement the logic (the skill does), so this is primarily documentation alignment.

**Current Structure (Keep):**

- name: scope-check-agent
- model: haiku
- tools: TodoWrite
- permissionMode: bypassPermissions

**How to Execute (Keep):**

```
/skill scope-check
```

**Only Update:**

1. Frontmatter description
2. Purpose statement
3. Output format example

---

## Definition of Done

- [ ] Description mentions file detection
- [ ] Purpose statement emphasizes repos AND files
- [ ] Output format reference updated to `{ repos[], files[] }`
- [ ] No breaking changes to agent metadata or execution
- [ ] File validates as proper markdown
