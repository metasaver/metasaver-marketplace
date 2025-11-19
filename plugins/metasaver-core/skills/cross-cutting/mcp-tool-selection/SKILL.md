---
name: mcp-tool-selection
description: Determines which MCP tools to use based on task type and complexity. Provides trigger conditions for Context7 (technical docs), Sequential Thinking (complex reasoning), Zen (multi-model consensus), Serena (code navigation), Recall (session memory), Tavily (web search), Playwright/Chrome DevTools (browser automation). Use when determining which external tools apply to current task.
---

# MCP Tool Selection

Lightweight trigger rules for determining which MCP servers to use.

## Core Principle

**Trust Claude's judgment.** These are trigger patterns, not rigid requirements. If context suggests a tool would help, use it.

## Trigger Rules

### Context7 (Technical Documentation)

**USE WHEN:**
- Technical library/framework mentioned AND confidence <100%
- Need up-to-date API documentation
- Implementing features with specific dependencies

**EXAMPLES:**
- "implement JWT authentication with jsonwebtoken"
- "use Prisma migrations for this schema"
- "setup Tailwind CSS with custom config"
- "integrate Stripe payment processing"

**PATTERN:** `IF (tech_library_detected AND uncertainty_exists) → Use Context7`

**AVOID:**
- Basic JavaScript/TypeScript (Claude already knows)
- Well-documented internal code
- Simple npm install tasks

---

### Sequential Thinking (Complex Multi-Step Reasoning)

**USE WHEN:**
- Complexity score ≥20
- User explicitly requests "step-by-step" or "think through"
- Debugging complex race conditions or architectural issues
- Multi-phase analysis with dependencies

**EXAMPLES:**
- "debug this race condition in the payment flow"
- "analyze why the cache invalidation isn't working"
- "trace through the authentication middleware chain"
- "step-by-step plan for migrating to new architecture"

**PATTERN:** `IF (complexity ≥20 OR explicit_request OR complex_debugging) → Use Sequential Thinking`

**AVOID:**
- Simple tasks (complexity <15)
- Straightforward implementations
- Quick questions
- Documentation requests

**CRITICAL:** Don't overuse. Sequential thinking adds significant token overhead.

---

### Zen (Multi-Model Orchestration)

**USE WHEN:**
- Architecture decisions needing validation
- Technology selection with tradeoffs
- User wants "second opinion" or "what would you recommend"
- Strategic choices with multiple valid approaches

**EXAMPLES:**
- "should we use GraphQL or REST for this API?"
- "best approach for real-time data: WebSockets or SSE?"
- "review this architecture design"
- "evaluate MongoDB vs PostgreSQL for this use case"

**PATTERN:** `IF (strategic_decision OR architecture_choice OR explicit_validation) → Use Zen`

**CAPABILITIES:**
- `chat` - General collaborative thinking
- `thinkdeep` - Multi-stage investigation with hypothesis testing
- `planner` - Sequential planning with revision capability
- `consensus` - Multi-model structured debate
- `codereview` - Systematic code review
- `debug` - Root cause analysis
- `analyze` - Code analysis
- `refactor` - Refactoring analysis

**AVOID:**
- Implementation tasks (use directly)
- Simple questions
- Already-decided approaches

---

### Serena (Semantic Code Navigation)

**USE WHEN:**
- Exploring unfamiliar codebase
- Finding symbols, classes, functions by name
- Understanding code architecture
- Searching for patterns across files

**EXAMPLES:**
- "where is authentication handled?"
- "find all API endpoints"
- "show me the User model definition"
- "find references to this function"

**PATTERN:** `IF (code_exploration OR symbol_search OR architecture_understanding) → Use Serena`

**NOTE:** Serena is already available in this environment. Use naturally via `mcp__serena__*` tools.

**CAPABILITIES:**
- Symbol search and navigation
- Find references
- Code pattern search
- Semantic understanding
- Memory storage for codebase knowledge

---

### Recall (Cross-Session Memory)

**USE WHEN:**
- Continuing work from previous session
- Referencing past architectural decisions
- Checking for established patterns
- Retrieving prior context

**EXAMPLES:**
- "continue work from yesterday on the auth feature"
- "what patterns did we establish for error handling?"
- "recall our decision about database schema"
- "retrieve context on the payment integration"

**PATTERN:** `IF (session_continuation OR pattern_reference OR prior_decision) → Use Recall`

**CAPABILITIES:**
- Store/retrieve memories across sessions
- Search by context and relevance
- Maintain architectural decisions
- Pattern persistence

**AVOID:**
- Current session context (already in conversation)
- Information available in codebase
- Fresh tasks with no history

---

### Tavily (Web Search)

**USE WHEN:**
- Need current/recent information
- Information post-training cutoff (after Jan 2025)
- Latest framework releases or best practices
- Real-time data or current events

**EXAMPLES:**
- "latest Next.js 15 features"
- "current best practices for React Server Components"
- "recent security vulnerabilities in Express"
- "current TypeScript 5.6 recommendations"

**PATTERN:** `IF (needs_current_info OR post_cutoff OR latest_release) → Use Tavily`

**AVOID:**
- Stable, well-established technologies
- Information within training data
- Internal company knowledge

---

### Playwright / Chrome DevTools (Browser Automation)

**USE WHEN:**
- Web testing and automation
- Browser interaction required
- Visual regression testing
- E2E test scenarios

**EXAMPLES:**
- "test the login flow in the browser"
- "automate form submission testing"
- "check responsive design at different viewports"
- "capture screenshots for regression testing"

**PATTERN:** `IF (browser_testing OR web_automation OR visual_testing) → Use Playwright/Chrome DevTools`

**AVOID:**
- Unit tests (use Jest/Vitest)
- API testing (use Supertest)
- Non-browser testing

---

## Decision Matrix

| Task Type | Primary Tool | Secondary Tools |
|-----------|--------------|-----------------|
| Implement feature with library | Context7 | Recall (patterns) |
| Complex debugging | Sequential Thinking | Serena (code nav) |
| Architecture decision | Zen | Context7 (tech research) |
| Explore codebase | Serena | Recall (knowledge) |
| Continue previous work | Recall | Serena (code nav) |
| Research current tech | Tavily | Context7 (docs) |
| Web testing | Playwright | None |
| Multi-step analysis | Sequential Thinking | Zen (validation) |

## Best Practices

1. **Default to no tools** - Claude is very capable without external tools
2. **Use tools for gaps** - Only when Claude's knowledge/context is insufficient
3. **Combine tools** - Context7 for docs + Zen for architecture decisions
4. **Respect token budgets** - Sequential Thinking is expensive, use sparingly
5. **Check availability** - Not all MCPs may be running in all environments

## Integration with Commands

This skill is referenced by:
- `/ms` - For determining MCP tool usage based on complexity
- `/audit` - For research and validation tools
- `/build` - For technical documentation and architecture validation

Commands should invoke this skill when determining which external tools to use for their specific workflows.
