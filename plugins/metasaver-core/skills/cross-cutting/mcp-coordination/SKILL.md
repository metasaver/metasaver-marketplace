---
name: mcp-coordination
description: Model Context Protocol (MCP) memory patterns for agent coordination, status sharing, and distributed decision-making across agent swarms. Provides storeAgentStatus, getAgentStatus, shareFindings, broadcastToSwarm, and handoffTask patterns with standard namespaces and coordination helpers. Use when implementing multi-agent coordination, task handoffs, or swarm communication.
---

# MCP Coordination Skill

## Purpose

Provides standard MCP (Model Context Protocol) memory patterns for agent coordination, status sharing, and distributed decision-making across the swarm.

## Input Parameters

```typescript
interface MCPCoordinationOptions {
  agentId: string; // Unique agent identifier
  namespace?: string; // Memory namespace (default: 'coordination')
  operation: "store" | "retrieve" | "update" | "broadcast";
  data?: any; // Data to store/broadcast
  ttl?: number; // Time-to-live in seconds
}

interface AgentStatus {
  agentId: string;
  status: "idle" | "working" | "blocked" | "completed" | "failed";
  currentTask?: string;
  progress?: number; // 0-100
  dependencies?: string[]; // Other agents this depends on
  outputs?: string[]; // Files/resources produced
  timestamp: string;
}
```

## Output Format

```typescript
interface MCPResponse {
  success: boolean;
  data?: any;
  error?: string;
  metadata: {
    key: string;
    namespace: string;
    timestamp: string;
  };
}
```

## Core Coordination Patterns

### 1. Store Agent Status

```typescript
async function storeAgentStatus(status: AgentStatus): Promise<MCPResponse> {
  return await mcp.memory_usage({
    action: "store",
    key: `swarm/${status.agentId}/status`,
    namespace: "coordination",
    value: JSON.stringify(status),
  });
}

// Usage
await storeAgentStatus({
  agentId: "coder-001",
  status: "working",
  currentTask: "Implementing authentication API",
  progress: 45,
  outputs: ["src/auth/auth.service.ts"],
  timestamp: new Date().toISOString(),
});
```

### 2. Retrieve Agent Status

```typescript
async function getAgentStatus(agentId: string): Promise<AgentStatus | null> {
  const response = await mcp.memory_usage({
    action: "retrieve",
    key: `swarm/${agentId}/status`,
    namespace: "coordination",
  });

  return response.success ? JSON.parse(response.data) : null;
}

// Check if dependencies are complete
async function waitForDependencies(dependencies: string[]): Promise<boolean> {
  const statuses = await Promise.all(
    dependencies.map((dep) => getAgentStatus(dep))
  );

  return statuses.every((s) => s?.status === "completed");
}
```

### 3. Share Findings Between Agents

```typescript
async function shareFindings(
  sourceAgent: string,
  findings: any,
  topic: string
): Promise<MCPResponse> {
  return await mcp.memory_usage({
    action: "store",
    key: `swarm/shared/${topic}`,
    namespace: "coordination",
    value: JSON.stringify({
      sourceAgent,
      timestamp: new Date().toISOString(),
      findings,
    }),
  });
}

// Example: Share research findings
await shareFindings(
  "researcher-001",
  {
    patterns: ["singleton", "factory", "observer"],
    libraries: ["express", "fastify"],
    recommendations: "Use Express for simplicity",
  },
  "api-framework-research"
);

// Example: Share implementation decisions
await shareFindings(
  "coder-001",
  {
    architecture: "layered",
    endpoints: ["/auth/login", "/auth/logout", "/auth/refresh"],
    authentication: "JWT with refresh tokens",
  },
  "auth-implementation"
);
```

### 4. Broadcast to All Agents

```typescript
async function broadcastToSwarm(
  sourceAgent: string,
  message: string,
  messageType: "info" | "warning" | "error" | "decision"
): Promise<MCPResponse> {
  return await mcp.memory_usage({
    action: "store",
    key: `swarm/broadcast/${Date.now()}`,
    namespace: "coordination",
    value: JSON.stringify({
      sourceAgent,
      messageType,
      message,
      timestamp: new Date().toISOString(),
    }),
  });
}

// Example: Broadcast architecture decision
await broadcastToSwarm(
  "architect-001",
  "Using layered architecture: Controller -> Service -> Repository",
  "decision"
);
```

### 5. Coordinate Task Handoff

```typescript
async function handoffTask(
  fromAgent: string,
  toAgent: string,
  taskDetails: any
): Promise<MCPResponse> {
  // Update source agent status
  await storeAgentStatus({
    agentId: fromAgent,
    status: "completed",
    currentTask: taskDetails.name,
    progress: 100,
    timestamp: new Date().toISOString(),
  });

  // Store handoff data
  return await mcp.memory_usage({
    action: "store",
    key: `swarm/${toAgent}/inbox`,
    namespace: "coordination",
    value: JSON.stringify({
      fromAgent,
      taskDetails,
      timestamp: new Date().toISOString(),
    }),
  });
}

// Example: Coder hands off to tester
await handoffTask("coder-001", "tester-001", {
  name: "Test authentication API",
  files: ["src/auth/auth.service.ts", "src/auth/auth.controller.ts"],
  endpoints: ["/auth/login", "/auth/logout"],
  testingNotes: "Focus on JWT validation and refresh token flow",
});
```

## Usage Examples

### Example 1: Researcher to Planner Coordination

```typescript
// Researcher stores findings
await shareFindings(
  "researcher-001",
  {
    frameworks: ["Express", "Fastify", "Koa"],
    recommendation: "Express - widely adopted, extensive middleware",
    considerations: "Fastify if performance is critical",
  },
  "backend-framework"
);

// Planner retrieves findings
const research = await mcp.memory_usage({
  action: "retrieve",
  key: "swarm/shared/backend-framework",
  namespace: "coordination",
});

const findings = JSON.parse(research.data);
console.log("Using framework:", findings.findings.recommendation);
```

### Example 2: Parallel Coder Coordination

```typescript
// Coder 1: Working on auth
await storeAgentStatus({
  agentId: "coder-auth",
  status: "working",
  currentTask: "Implementing authentication",
  outputs: ["src/auth/auth.service.ts"],
  timestamp: new Date().toISOString(),
});

// Coder 2: Check if auth service is ready before starting user service
const authStatus = await getAgentStatus("coder-auth");
if (authStatus?.status === "completed") {
  // Start work on user service that depends on auth
  await storeAgentStatus({
    agentId: "coder-user",
    status: "working",
    currentTask: "Implementing user management",
    dependencies: ["coder-auth"],
    timestamp: new Date().toISOString(),
  });
}
```

### Example 3: Error Coordination

```typescript
// Agent encounters blocker
await broadcastToSwarm(
  "coder-001",
  "Database connection failing - missing environment variables",
  "error"
);

// Update status to blocked
await storeAgentStatus({
  agentId: "coder-001",
  status: "blocked",
  currentTask: "Setup database connection",
  progress: 30,
  timestamp: new Date().toISOString(),
});

// DevOps agent sees broadcast and resolves
await shareFindings(
  "devops-001",
  {
    resolution: "Added .env.example with required variables",
    action: "Please copy .env.example to .env and configure",
  },
  "database-config"
);
```

## Standard Memory Namespaces

```typescript
export const MCPNamespaces = {
  COORDINATION: "coordination", // Agent status and handoffs
  SHARED: "swarm/shared", // Shared findings and decisions
  BROADCAST: "swarm/broadcast", // System-wide announcements
  INBOX: "swarm/{agentId}/inbox", // Agent-specific incoming tasks
  STATUS: "swarm/{agentId}/status", // Agent current status
  OUTPUT: "swarm/{agentId}/output", // Agent produced artifacts
};

export const MCPKeys = {
  agentStatus: (agentId: string) => `swarm/${agentId}/status`,
  sharedFinding: (topic: string) => `swarm/shared/${topic}`,
  agentInbox: (agentId: string) => `swarm/${agentId}/inbox`,
  broadcast: () => `swarm/broadcast/${Date.now()}`,
  dependency: (agentId: string, depId: string) =>
    `swarm/${agentId}/deps/${depId}`,
};
```

## Coordination Helpers

```typescript
export class SwarmCoordinator {
  constructor(private agentId: string) {}

  async reportProgress(task: string, progress: number, outputs?: string[]) {
    return storeAgentStatus({
      agentId: this.agentId,
      status: "working",
      currentTask: task,
      progress,
      outputs,
      timestamp: new Date().toISOString(),
    });
  }

  async complete(outputs: string[]) {
    return storeAgentStatus({
      agentId: this.agentId,
      status: "completed",
      progress: 100,
      outputs,
      timestamp: new Date().toISOString(),
    });
  }

  async block(reason: string) {
    await broadcastToSwarm(this.agentId, `Blocked: ${reason}`, "error");
    return storeAgentStatus({
      agentId: this.agentId,
      status: "blocked",
      timestamp: new Date().toISOString(),
    });
  }

  async share(topic: string, findings: any) {
    return shareFindings(this.agentId, findings, topic);
  }

  async retrieve(topic: string) {
    const response = await mcp.memory_usage({
      action: "retrieve",
      key: `swarm/shared/${topic}`,
      namespace: "coordination",
    });
    return response.success ? JSON.parse(response.data) : null;
  }
}
```

## Integration Pattern

```typescript
// In any agent implementation
export async function executeAgentTask(agentId: string, task: string) {
  const coordinator = new SwarmCoordinator(agentId);

  try {
    // Report starting
    await coordinator.reportProgress(task, 0);

    // Check dependencies
    const dependencies = await coordinator.retrieve("dependencies");
    if (dependencies) {
      const ready = await waitForDependencies(dependencies.required);
      if (!ready) {
        await coordinator.block("Waiting for dependencies");
        return;
      }
    }

    // Do work
    await coordinator.reportProgress(task, 50);
    const output = await performWork();

    // Share findings
    await coordinator.share("implementation-details", {
      approach: "layered architecture",
      files: output.files,
    });

    // Complete
    await coordinator.complete(output.files);
  } catch (error) {
    await coordinator.block(`Error: ${error.message}`);
    throw error;
  }
}
```

## Multi-MCP Coordination Workflows

### Workflow 1: Feature Implementation with Full MCP Stack

When implementing a complex feature, coordinate multiple MCP tools:

```javascript
// 1. Context7: Research library
const jwtDocs = await mcp__Context7__get_library_docs({
  context7CompatibleLibraryID: "/vercel/jsonwebtoken"
});

// 2. Recall: Check prior patterns
const authPatterns = await mcp__recall__search_memories({
  query: "JWT authentication implementation patterns",
  context_types: ["code_pattern", "decision"],
  limit: 5
});

// 3. Serena: Find existing auth code
const existingAuth = await mcp__serena__find_symbol({
  name_path_pattern: "auth",
  include_body: false,
  relative_path: "src"
});

// 4. Sequential Thinking: Plan implementation (if complex)
if (complexityScore >= 20) {
  await mcp__sequential_thinking__sequentialthinking({
    thought: "Step 1: Analyzing existing auth vs new JWT approach...",
    thoughtNumber: 1,
    totalThoughts: 8,
    nextThoughtNeeded: true
  });
}

// 5. Vibe Check: Validate approach
const vibeCheck = await mcp__vibe_check__vibe_check({
  goal: "Implement JWT auth with refresh tokens",
  plan: "Add JWT middleware + refresh token endpoint + Redis cache",
  progress: "Researched libraries, found existing patterns",
  taskContext: "repo: metasaver-com, feature: auth"
});

// If over-engineering detected, simplify
if (vibeCheck.risks.includes("over-engineering")) {
  // Revise plan based on feedback
}

// 6. Coordination: Share decision with team
await shareFindings("architect-001", {
  decision: "JWT + refresh tokens with httpOnly cookies",
  libraries: ["jsonwebtoken", "bcrypt"],
  architecture: "stateless auth with Redis for refresh tokens",
  rationale: vibeCheck.feedback
}, "auth-implementation");

// 7. Recall: Store architectural decision
await mcp__recall__store_memory({
  content: JSON.stringify({
    decision: "JWT authentication with refresh tokens",
    rationale: "Stateless, scalable, industry standard",
    implementation: {
      accessTokenTTL: "15m",
      refreshTokenTTL: "7d",
      storage: "Redis"
    }
  }),
  context_type: "decision",
  importance: 9,
  tags: ["auth", "jwt", "architecture"]
});
```

### Workflow 2: Debugging Complex Issue

Combine MCP tools for systematic root cause analysis:

```javascript
// 1. Serena: Find bug location
const symbols = await mcp__serena__find_symbol({
  name_path_pattern: "PaymentProcessor",
  include_body: true,
  relative_path: "src/services"
});

// 2. Sequential Thinking: Analyze issue step-by-step
await mcp__sequential_thinking__sequentialthinking({
  thought: "Hypothesis 1: Race condition in payment processing due to async operations...",
  thoughtNumber: 1,
  totalThoughts: 12,
  nextThoughtNeeded: true
});

await mcp__sequential_thinking__sequentialthinking({
  thought: "Testing hypothesis: Checking for missing await keywords or Promise.all...",
  thoughtNumber: 2,
  totalThoughts: 12,
  nextThoughtNeeded: true
});

// 3. Chrome DevTools: Reproduce in browser (if UI-related)
if (isUIBug) {
  await mcp__chrome_devtools__navigate_page({
    url: "http://localhost:5173/checkout",
    type: "url"
  });

  const networkRequests = await mcp__chrome_devtools__list_network_requests({
    resourceTypes: ["xhr", "fetch"]
  });
}

// 4. Recall: Check similar past issues
const priorBugs = await mcp__recall__search_memories({
  query: "payment race condition async bugs",
  context_types: ["error", "information"],
  limit: 3
});

// 5. Coordination: Share findings with team
await shareFindings("root-cause-analyst-001", {
  rootCause: "Missing transaction lock in payment flow",
  evidence: [
    "Two concurrent payment requests created duplicate charges",
    "No Redis lock on payment processing",
    "Race condition in database write"
  ],
  fix: "Add distributed lock using Redis SETNX"
}, "payment-bug-analysis");

// 6. Vibe Learn: Document for future
await mcp__vibe_check__vibe_learn({
  mistake: "Payment race condition due to missing distributed lock",
  category: "Complex Solution Bias",
  solution: "Added Redis distributed lock with TTL",
  type: "mistake"
});

// 7. Recall: Store solution pattern
await mcp__recall__store_memory({
  content: JSON.stringify({
    pattern: "distributed-lock-for-critical-sections",
    implementation: "Redis SETNX with TTL",
    useCase: "Prevent race conditions in payment processing",
    code: "await redisClient.set(lockKey, 'locked', 'NX', 'EX', 10)"
  }),
  context_type: "code_pattern",
  importance: 8,
  tags: ["redis", "concurrency", "payment"]
});
```

### Workflow 3: Performance Optimization

Multi-tool approach for performance analysis:

```javascript
// 1. Chrome DevTools: Start performance trace
await mcp__chrome_devtools__performance_start_trace({
  reload: true,
  autoStop: true
});

await mcp__chrome_devtools__navigate_page({
  url: "http://localhost:5173/dashboard",
  type: "url"
});

// 2. Sequential Thinking: Analyze bottleneck
await mcp__sequential_thinking__sequentialthinking({
  thought: "Step 1: APM shows p95 response time of 2.3s (target: 500ms)...",
  thoughtNumber: 1,
  totalThoughts: 10,
  nextThoughtNeeded: true
});

// 3. Serena: Find performance-critical code
const hotPath = await mcp__serena__find_symbol({
  name_path_pattern: "getUserDashboard",
  include_body: true
});

// 4. Recall: Check prior optimizations
const optimizations = await mcp__recall__search_memories({
  query: "database query optimization N+1",
  context_types: ["code_pattern"],
  limit: 5
});

// 5. Context7: Research optimization library
const prismaOptimization = await mcp__Context7__get_library_docs({
  context7CompatibleLibraryID: "/prisma/prisma",
  topic: "query optimization"
});

// 6. Coordination: Share optimization plan
await shareFindings("performance-engineer-001", {
  bottleneck: "N+1 query in getUserDashboard",
  currentPerformance: "2.3s p95",
  targetPerformance: "400ms p95",
  optimizations: [
    "Add Prisma select with relations",
    "Implement Redis cache (5min TTL)",
    "Add database index on user.email"
  ],
  expectedImprovement: "83% reduction"
}, "dashboard-performance");

// 7. Recall: Store optimization
await mcp__recall__store_memory({
  content: JSON.stringify({
    optimization: "batch-query-with-cache",
    before: "2.3s p95",
    after: "380ms p95",
    technique: "Prisma select + Redis cache + DB index"
  }),
  context_type: "code_pattern",
  importance: 7,
  tags: ["performance", "optimization", "prisma"]
});
```

### Workflow 4: E2E Test Creation

Combine browser automation with memory coordination:

```javascript
// 1. Recall: Get feature requirements
const requirements = await mcp__recall__search_memories({
  query: "user registration feature requirements",
  context_types: ["requirement", "decision"],
  limit: 3
});

// 2. Chrome DevTools: Test the flow
await mcp__chrome_devtools__navigate_page({
  url: "http://localhost:5173/register",
  type: "url"
});

await mcp__chrome_devtools__fill_form({
  elements: [
    { uid: "email-input", value: "test@example.com" },
    { uid: "password-input", value: "SecurePass123!" }
  ]
});

await mcp__chrome_devtools__click({ uid: "register-button" });

await mcp__chrome_devtools__wait_for({ text: "Registration successful" });

const screenshot = await mcp__chrome_devtools__take_screenshot({
  filePath: "./e2e-results/registration-success.png"
});

// 3. Coordination: Share test results
await shareFindings("e2e-test-agent-001", {
  test: "user-registration-flow",
  status: "passed",
  duration: "2.1s",
  assertions: ["form validation", "API call", "success message", "redirect"],
  screenshot: screenshot.filePath
}, "e2e-test-results");

// 4. Recall: Store test pattern
await mcp__recall__store_memory({
  content: JSON.stringify({
    testPattern: "registration-e2e-workflow",
    steps: ["navigate", "fill form", "submit", "verify success"],
    tools: ["chrome-devtools", "recall"],
    reusable: true
  }),
  context_type: "code_pattern",
  importance: 6,
  tags: ["e2e", "testing", "registration"]
});
```

## Key Coordination Principles

1. **Layer Tools Appropriately**: Use Context7 for docs, Serena for code, Sequential Thinking for analysis
2. **Share Decisions**: Always broadcast architectural decisions to the team
3. **Learn from Errors**: Use vibe_learn to capture mistakes
4. **Cache Knowledge**: Store patterns in recall for reuse
5. **Validate Plans**: Use vibe_check before complex implementations
6. **Coordinate Status**: Update agent status for parallel work
7. **Capture Evidence**: Use chrome-devtools screenshots for debugging

## Used By

- ALL agents in the swarm
- Swarm coordinator/orchestrator
- Task scheduler
- Dependency manager
- Progress monitoring dashboard
