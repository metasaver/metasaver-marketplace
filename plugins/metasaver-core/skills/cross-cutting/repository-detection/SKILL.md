---
name: repository-detection
description: Repository type detection for identifying library vs consumer repositories. Analyzes directory structure, package.json dependencies, and monorepo indicators to classify repositories and detect multi-mono relationships. Returns metadata about workspace type, monorepo tool (Turborepo, nx, lerna, pnpm-workspace), and library consumption patterns. Use when agents need to adapt behavior based on repository type or validate architecture-specific patterns.
---

# Repository Detection Skill

## Purpose

Detects whether the current repository is a library (like @metasaver/multi-mono) or a consumer repository, and returns metadata about its structure.

## Input Parameters

- `workspaceRoot`: Absolute path to workspace root (required)
- `checkParentMonorepo`: Boolean, check if part of larger monorepo (default: true)

## Output Format

```typescript
interface RepositoryInfo {
  type: "library" | "consumer" | "standalone";
  isMonorepo: boolean;
  monorepoTool?:
    | "turborepo"
    | "nx"
    | "lerna"
    | "pnpm-workspace"
    | "npm-workspace";
  workspaces?: string[];
  packageName?: string;
  isLibraryConsumer?: boolean; // Consumes @metasaver/multi-mono or similar
  metadata: {
    hasPackageJson: boolean;
    hasTurboJson: boolean;
    hasNxJson: boolean;
    hasLernaJson: boolean;
    hasPnpmWorkspace: boolean;
    rootPackageJson?: any;
  };
}
```

## Detection Logic

### 1. Check for Library Indicators

```bash
# Library repositories typically have:
# - packages/agents, packages/components, packages/workflows
# - No apps/ directory or minimal apps for demos
# - package.json with "private": true and workspaces
# - Focus on exports and reusable code

if [ -d "packages/agents" ] && [ -d "packages/components" ] && [ ! -d "apps" ]; then
  echo "library"
fi
```

### 2. Check for Consumer Indicators

```bash
# Consumer repositories typically have:
# - apps/ directory with actual applications
# - Dependencies on library packages (@metasaver/*)
# - services/ directory for backend services
# - Focus on application logic

if [ -d "apps" ] && [ -f "package.json" ]; then
  grep -q "@metasaver/" package.json && echo "consumer"
fi
```

### 3. Detect Monorepo Tool

```bash
# Check for monorepo configuration files
[ -f "turbo.json" ] && echo "turborepo"
[ -f "nx.json" ] && echo "nx"
[ -f "lerna.json" ] && echo "lerna"
[ -f "pnpm-workspace.yaml" ] && echo "pnpm-workspace"
```

## Usage Examples

### Example 1: Basic Detection

```typescript
const repoInfo = await detectRepository({
  workspaceRoot: "/mnt/f/code/resume-builder",
});

console.log(repoInfo.type); // 'consumer'
console.log(repoInfo.isMonorepo); // true
console.log(repoInfo.monorepoTool); // 'turborepo'
```

### Example 2: Check Library Status

```typescript
const repoInfo = await detectRepository({
  workspaceRoot: process.cwd(),
});

if (repoInfo.type === "library") {
  console.log("This is a library repository");
  console.log("Workspaces:", repoInfo.workspaces);
} else if (repoInfo.isLibraryConsumer) {
  console.log("This repository consumes library packages");
}
```

## Implementation Pattern

```bash
#!/bin/bash
# repository-detection.sh

detect_repository() {
  local workspace_root="$1"
  cd "$workspace_root" || exit 1

  # Initialize result
  local repo_type="standalone"
  local is_monorepo=false
  local monorepo_tool=""

  # Detect monorepo tool
  if [ -f "turbo.json" ]; then
    is_monorepo=true
    monorepo_tool="turborepo"
  elif [ -f "nx.json" ]; then
    is_monorepo=true
    monorepo_tool="nx"
  elif [ -f "pnpm-workspace.yaml" ]; then
    is_monorepo=true
    monorepo_tool="pnpm-workspace"
  fi

  # Detect repository type
  if [ -d "packages/agents" ] && [ -d "packages/components" ]; then
    # Strong indicator of library repo
    if [ ! -d "apps" ] || [ $(ls -1 apps 2>/dev/null | wc -l) -lt 2 ]; then
      repo_type="library"
    fi
  fi

  if [ -d "apps" ] && [ -d "services" ]; then
    # Strong indicator of consumer repo
    repo_type="consumer"
  fi

  # Check if consumes library packages
  local is_library_consumer=false
  if [ -f "package.json" ]; then
    if grep -q "@metasaver/" package.json; then
      is_library_consumer=true
    fi
  fi

  # Output JSON
  cat <<EOF
{
  "type": "$repo_type",
  "isMonorepo": $is_monorepo,
  "monorepoTool": "$monorepo_tool",
  "isLibraryConsumer": $is_library_consumer
}
EOF
}

detect_repository "$1"
```

## Integration with Agents

```typescript
// In any agent that needs repository detection
import { detectRepository } from ".claude/skills/repository-detection.skill";

export async function configureAgent() {
  const repoInfo = await detectRepository({
    workspaceRoot: process.cwd(),
  });

  if (repoInfo.type === "library") {
    // Apply library-specific configuration
    return {
      scope: "@metasaver",
      exports: true,
      createApps: false,
    };
  } else {
    // Apply consumer-specific configuration
    return {
      scope: "@metasaver",
      exports: false,
      createApps: true,
    };
  }
}
```

## Used By

- All config agents (prettier, typescript, eslint, etc.)
- Domain agents (frontend, backend, testing)
- Project manager agent
- Base template generator
