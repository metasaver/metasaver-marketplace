---
name: build
description: Build new features with architecture validation and technical documentation
---

# 🏗️ MetaSaver Build Command

Specialized command for building new features, components, and services with proper architecture validation and technical documentation.

**IMPORTANT:** Never do git operations without user approval.

## Purpose

The `/build` command is optimized for **creating new code** (not auditing existing code). It always involves:

1. **Architecture validation** - Ensures design decisions are sound
2. **Technical documentation** - Uses Context7 for library/framework research
3. **Pattern adherence** - Follows MetaSaver building blocks and standards
4. **Quality validation** - Code review and testing integration

## Workflow

### Phase 1: Analysis & Architecture

1. **Complexity Analysis** (same scoring as `/ms`)
2. **Model Selection**:
   - Simple (score ≤=5): **haiku** - Fast, simple operations only
   - Medium (6-29): **sonnet** - Standard development (default)
   - Complex (≥30): **opus** - Deep architectural reasoning (rare)
3. **Architecture Design**:
   - Simple (score ≤4): Direct implementation with patterns
   - Medium (5-29): Architect → Building blocks advisor
   - Complex (≥30): BA → Architect → Confidence check

### Phase 2: Research

**Always check Context7** when building with specific libraries/frameworks:

```typescript
// Trigger Context7 for:
- Authentication libraries (JWT, Passport, etc.)
- Database ORMs (Prisma, TypeORM, etc.)
- Frontend frameworks (React, Next.js, etc.)
- API frameworks (Express, Fastify, etc.)
- Testing libraries (Jest, Vitest, Supertest)
```

### Phase 3: Implementation

Based on complexity score:

#### Simple (Score ≤4)

```
/build fix TypeScript error in service
→ Direct Claude (haiku model) with:
  1. Quick fix
  2. Basic validation
```

#### Medium (Score 5-29)

```
/build JWT authentication API
→ Workflow (sonnet model for all agents):
  1. Architect (design)
  2. Context7 (JWT library research)
  3. Confidence check (≥15: verify understanding)
  4. **Vibe check** (≥15: prevent over-engineering)
     - Challenge: "Is JWT + refresh token + Redis overkill?"
     - Validate: Simpler approach exists?
  5. PM (creates Gantt with parallel tasks)
  6. Domain agents (backend-dev, unit-test) - sonnet
  7. Integration validation
```

#### Complex (Score ≥30)

```
/build multi-tenant SaaS architecture
→ Full orchestration (opus for BA/Architect, sonnet for workers):
  1. BA (requirements analysis, creates PRD) - opus
  2. Architect (system design) - opus
  3. Context7 (research all tech)
  4. Confidence check (verify architectural understanding)
  5. **Vibe check** (≥15: challenge architecture)
     - Challenge: "Do we need event sourcing or is CRUD sufficient?"
     - Validate: Are we building for scale we'll never reach?
  6. PM (multi-wave Gantt) - sonnet
  7. Domain agents (multiple waves) - sonnet
  8. Code-quality-validator (technical validation) - sonnet
  9. BA (PRD sign-off) - opus
  10. PM consolidation - sonnet

  **On error:** Call vibe_learn to capture mistake
```

### Phase 4: Validation

**Always validate at the end (two-phase validation):**

1. **Code-Quality-Validator** - Technical validation (scaled by change size)

   - Small change: Build only
   - Medium change: Build + Lint + Prettier
   - Large change: Build + Lint + Prettier + Tests

2. **Business Analyst** - PRD sign-off
   - Reviews requirements checklist
   - Validates all deliverables complete
   - Signs off on requirements fulfillment

> **Note:** Validation is separated into technical (code-quality-validator) and requirements (business-analyst) concerns.

## Domain Agents for Build

### Backend Services

- `data-service-agent` - REST APIs, CRUD operations
- `integration-service-agent` - External API integrations
- `backend-dev` - General backend development

### Frontend

- `react-component-agent` - React components
- `mfe-host-agent` - Micro-frontend host
- `mfe-remote-agent` - Micro-frontend remote

### Database

- `prisma-database-agent` - Prisma schemas, migrations

### Testing

- `unit-test-agent` - Unit tests
- `integration-test-agent` - Integration tests

## MCP Tools for Build

### Context7 (Technical Documentation)

**Always use when:**

- Implementing with specific library (e.g., "build auth with jsonwebtoken")
- Need latest API documentation
- Framework-specific features (e.g., "Next.js 15 app router")

### Sequential Thinking (Complex Planning)

**Use when:**

- Complexity score ≥20
- Multi-step architectural decisions
- Complex debugging scenarios

### Building Blocks Advisor (Pattern Selection)

**Always use for:**

- Determining correct building block (API, service, component, etc.)
- Pattern recommendations
- Structure guidance

## Examples

### Simple Build

```bash
/build GET endpoint for user profile
→ Direct Claude:
  1. Context7: Express routing docs
  2. Building blocks: Data API pattern
  3. Implement with error handling
  4. Validate
```

### Medium Build

```bash
/build authentication service with JWT
→ Workflow:
  1. Architect: Design auth flow
  2. Context7: jsonwebtoken + bcrypt docs
  3. Confidence check
  4. PM: Gantt chart
     - backend-dev: Auth service
     - backend-dev: Auth middleware
     - unit-test-agent: Service tests
     - integration-test-agent: Flow tests
  5. Production validator
```

### Complex Build

```bash
/build multi-service e-commerce platform
→ Full orchestration:
  1. BA: Requirements (user service, product service, order service, payment integration)
  2. Architect: Microservices design + API gateway
  3. Context7: Research all libraries
  4. Confidence check
  5. PM: Multi-wave Gantt
     Wave 1: Core services (data-service-agent × 3)
     Wave 2: Integration (integration-service-agent)
     Wave 3: Frontend (react-component-agent, mfe-host-agent)
     Wave 4: Testing (unit-test-agent, integration-test-agent)
  6. Production validator
  7. PM consolidation report
```

## Comparison: /build vs /ms vs /audit

| Command  | Purpose             | Focus                              | Validation           |
| -------- | ------------------- | ---------------------------------- | -------------------- |
| `/build` | Create new code     | Architecture + implementation      | Production validator |
| `/ms`    | Intelligent routing | Any task (build, fix, audit, etc.) | Context-dependent    |
| `/audit` | Validate existing   | Standards compliance               | Config agents        |

**Rule of thumb:**

- **Creating something new?** → `/build`
- **Checking existing code?** → `/audit`
- **Not sure / mixed tasks?** → `/ms` (will route optimally)

## Integration with Recall

Before building, check if patterns exist:

```typescript
try {
  const patterns = await recall_relevant_context(
    "MetaSaver patterns for [building block type]"
  );
  // Use patterns in build
} catch (error) {
  // Recall not available, read MULTI-MONO.md
}
```

**Pattern queries:**

- Database: "MetaSaver database Prisma patterns"
- REST APIs: "MetaSaver REST API Express patterns"
- Components: "MetaSaver React component patterns"
- Services: "MetaSaver microservice patterns"

## Best Practices

1. **Start with architecture** - Don't jump straight to code
2. **Use Context7 liberally** - Better to over-research than under-research
3. **Check building blocks** - Ensure you're using the right pattern
4. **Select appropriate model**:
   - haiku: Only truly simple fixes/explanations (score ≤4)
   - sonnet: All implementation work - create, build, implement, refactor (score 5-29)
   - opus: Novel architecture, ultra-complex (score ≥30, rare)
5. **Validate thoroughly** - Production validator catches issues early
6. **Leverage Recall** - Reuse established patterns from memory

## Command Invocation

```bash
# Natural language, no quotes needed
/build user authentication with JWT and refresh tokens
/build React dashboard with charts
/build Prisma schema for multi-tenant SaaS
/build integration with Stripe payment API
```

System automatically:

- Analyzes complexity
- Selects appropriate architecture level
- Researches with Context7
- Spawns domain agents
- Coordinates multi-agent workflows
- Validates against requirements
- No manual agent spawning needed

---

## Post-Workflow: Repomix Cache Refresh

**At workflow completion, invoke the `repomix-cache-refresh` skill if files were created/modified.**

**Skill:** `skills/cross-cutting/repomix-cache-refresh/SKILL.md`

**Quick reference:**
- Critical for /build - new files don't exist in cache yet
- Makes newly created code immediately discoverable
- ~2.4s overhead, ensures `/audit` can find new code immediately
