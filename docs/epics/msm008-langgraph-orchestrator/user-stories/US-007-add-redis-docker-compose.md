---
story_id: "MSM008-007"
title: "Add Redis service to docker-compose"
epic: "Epic 1: Foundation"
status: "pending"
priority: "P0"
agent: "core-claude-plugin:generic:coder"
dependencies: []
---

# Story: Add Redis Service to Docker Compose

## Description

As a developer, I need Redis available via docker-compose in multi-mono so that the orchestrator has a state persistence backend for development and testing.

## Acceptance Criteria

- [ ] Redis service added to `multi-mono/docker-compose.yml`
- [ ] Redis port exposed (default: 6379)
- [ ] Health check configured for Redis
- [ ] Volume for data persistence (optional, for dev convenience)
- [ ] Service starts successfully with `docker-compose up redis`

## Architecture

- **Files to modify:**
  - `/home/jnightin/code/multi-mono/docker-compose.yml`
- **Files to create:** None
- **Database:** Redis (containerized)
- **Components:** None
- **Libraries:** None

## Implementation Notes

**Docker Compose service definition:**

```yaml
services:
  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis-data:/data
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5
    restart: unless-stopped

volumes:
  redis-data:
```

**Environment variable for apps:**

```
REDIS_URL=redis://localhost:6379
```

**Verification:**

1. `docker-compose up -d redis`
2. `docker-compose exec redis redis-cli ping` (should return PONG)
3. Test connection from Node.js app

## Dependencies

- None (can be done in parallel with other stories)

## Estimated Effort

Small (30 minutes)
