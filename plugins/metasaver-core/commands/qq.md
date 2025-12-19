---
name: qq
description: Answer questions using MetaSaver agents without full workflow overhead
---

# Quick Question Command

Answer questions using the most appropriate MetaSaver agent without building anything.

**Use when:** You have a question that needs agent expertise but doesn't require code changes.

---

## Entry Handling

When /qq is invoked, ALWAYS proceed to Phase 1 regardless of prompt content. Questions are analyzed first, then routed to the appropriate agent for answering.

---

## Phase 1: Analysis (PARALLEL)

**See:** `/skill complexity-check`, `/skill scope-check`, `/skill agent-check`

Spawn 3 agents in parallel to execute analysis skills.
Collect: `complexity_score`, `scope` (with `targets` and `references`), `recommended_agent`

---

## Phase 2: Agent Selection (Conditional)

**Routing Decision:**

- **If complexity < 15**: SKIP to Phase 3 (use agent from agent-check directly)
- **If complexity >= 15**: Execute agent validation

**See:** `/skill agent-selection`

Validate recommended agent exists in MetaSaver agent pool. Fallback to `code-explorer` if agent not found.

---

## Phase 3: Question Execution

**See:** Selected agent from Phase 1 or Phase 2

Spawn MetaSaver agent in "answer mode":

- Agent receives original question + scope context
- Agent researches using tools (Serena, Grep, Read)
- Agent analyzes codebase if needed
- Agent formulates comprehensive answer
- NO code changes allowed

---

## Phase 4: Return Answer

Agent returns answer to user with:

- Direct answer to the question
- Supporting evidence (file paths, code snippets)
- References for further reading if applicable

---

## Examples

```bash
/qq "How does authentication work in this app?"
→ Analysis → code-explorer → Answer with auth flow details

/qq "What validation patterns do we use for forms?"
→ Analysis → coder → Answer with form validation patterns + examples

/qq "Why is ESLint configured this way?"
→ Analysis → eslint-agent → Answer with ESLint config explanation

/qq "How does rugby-crm handle user roles compared to here?"
→ Analysis → code-explorer → Answer comparing role handling across repos

/qq "What's the database schema for users?"
→ Analysis → prisma-database-agent → Answer with schema details

/qq "What's our testing strategy for API endpoints?"
→ Analysis → tester → Answer with testing patterns + coverage
```

---

## Enforcement

1. ALWAYS run Analysis phase first (complexity + scope + agent check in PARALLEL)
2. Run analysis skills in PARALLEL (single message, 3 skill calls)
3. Complexity routing after Analysis:
   - < 15: Use agent-check recommendation directly (FAST PATH)
   - > = 15: Validate agent with agent-selection skill (FULL PATH)
4. ALWAYS validate agent exists before spawning
5. Use `code-explorer` as fallback if agent not found
6. Agent executes in "answer mode" - NO code changes
7. NO PRD creation - this is quick questions only
8. NO approval gates - direct answer
9. NO execution planning - just answer
10. Include file references in answers when relevant
11. Keep answers focused and concise
12. Respect scope boundaries from scope-check
13. Model selection: haiku for analysis, sonnet for agent execution (or as defined by agent)
