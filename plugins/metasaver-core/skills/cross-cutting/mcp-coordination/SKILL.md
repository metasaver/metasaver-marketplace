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

## Used By

- ALL agents in the swarm
- Swarm coordinator/orchestrator
- Task scheduler
- Dependency manager
- Progress monitoring dashboard
