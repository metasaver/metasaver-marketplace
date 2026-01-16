---
story_id: "MSM-VKM-E02-004"
epic_id: "MSM-VKM-E02"
title: "Add Docker Compose configuration with Redis"
status: "pending"
complexity: 3
wave: 0
agent: "core-claude-plugin:generic:coder"
dependencies: []
created: "2026-01-16"
updated: "2026-01-16"
---

# MSM-VKM-E02-004: Add Docker Compose configuration with Redis

## User Story

**As a** developer running LangGraph workflows locally
**I want** a Docker Compose configuration that starts Redis for workflow checkpointing
**So that** LangGraph workflows can persist state and resume execution

---

## Acceptance Criteria

- [ ] File `docker-compose.yml` created or updated at repository root
- [ ] Redis service defined with version 7 or higher
- [ ] Redis port 6379 exposed to host
- [ ] Redis data persisted to volume for durability
- [ ] Service named appropriately (e.g., "redis" or "veenk-redis")
- [ ] Health check configured for Redis service
- [ ] Environment variables configurable (if needed)
- [ ] File format is valid YAML
- [ ] `docker-compose up redis` starts service successfully
- [ ] Unit tests cover acceptance criteria
- [ ] All tests pass

---

## Technical Details

### Location

- **Repo:** metasaver-marketplace
- **Package:** root level

### Files to Create

| File                 | Purpose                                |
| -------------------- | -------------------------------------- |
| `docker-compose.yml` | Define Redis service for checkpointing |

### Files to Modify

If `docker-compose.yml` already exists in marketplace, merge services rather than replace.

---

## Implementation Notes

Add or merge Docker Compose configuration:

**Source location:** `/home/jnightin/code/veenk/docker-compose.yml`
**Target location:** `/home/jnightin/code/metasaver-marketplace/docker-compose.yml`

### Expected Configuration

```yaml
version: "3.8"

services:
  redis:
    image: redis:7-alpine
    container_name: metasaver-redis
    ports:
      - "6379:6379"
    volumes:
      - redis-data:/data
    command: redis-server --appendonly yes
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 5s
      timeout: 3s
      retries: 5
    restart: unless-stopped

volumes:
  redis-data:
    driver: local
```

### Service Configuration Details

- **Image**: Redis 7 Alpine (lightweight)
- **Persistence**: AOF (append-only file) for durability
- **Health check**: Ensures service is ready
- **Volume**: Persists data across container restarts
- **Port**: Standard Redis port 6379

### Dependencies

None - this is a standalone service configuration.

---

## Architecture

(Added by architect-agent - technical annotations pending)

**Key Files:**

- `docker-compose.yml` - Docker service orchestration

**Service Integration:**

- LangGraph workflows connect to redis://localhost:6379
- Checkpointing saves workflow state to Redis
- Allows workflow resumption after interruption

---

## Definition of Done

- [ ] Implementation complete
- [ ] Unit tests passing
- [ ] TypeScript compiles
- [ ] Lint passes
- [ ] Acceptance criteria verified
- [ ] File validated with `docker-compose config`
- [ ] Redis starts successfully: `docker-compose up redis`
- [ ] Redis health check passes
- [ ] Can connect to Redis with redis-cli

---

## Notes

- Redis is required for LangGraph workflow state persistence
- Service should start cleanly without errors
- Volume ensures data persists across container restarts
- Health check prevents workflows from attempting connection before Redis is ready
- Does not affect existing plugin structure at plugins/metasaver-core/
