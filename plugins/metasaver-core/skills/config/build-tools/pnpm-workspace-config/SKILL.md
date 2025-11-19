---
name: pnpm-workspace-config
description: pnpm workspace YAML configuration templates and validation logic for monorepo workspace patterns. Includes 5 required standards (architecture-specific patterns for consumer vs library repos, exact path matching, no missing directories, no extra patterns, alphabetical ordering). Critical distinction between consumer repos (specific paths like packages/contracts/*) and library repos (broad patterns like packages/*). Use when creating or auditing pnpm-workspace.yaml files.
---

# pnpm Workspace Configuration Skill

This skill provides pnpm-workspace.yaml templates and validation logic for monorepo workspace configuration.

## Purpose

Manage pnpm-workspace.yaml configuration to:

- Define correct workspace patterns for library vs consumer repos
- Support standard and MFE-grouped app patterns
- Ensure exact path matching and alphabetical ordering
- Prevent missing directories and extra patterns

## Usage

This skill is invoked by the `pnpm-workspace-agent` when:

- Creating new pnpm-workspace.yaml files
- Auditing existing workspace configurations
- Validating workspace patterns against standards

## Templates

Standard templates are located at:

```
templates/consumer-standard.yaml     # Consumer repos with standard app pattern
templates/consumer-mfe.yaml          # Consumer repos with MFE grouped pattern
templates/library.yaml               # Library repos with broad patterns
```

## The 5 pnpm-workspace Standards

### Rule 1: Architecture-Specific Patterns (CRITICAL)

**Consumer Repos - Standard Pattern:**

- `apps/*` (NOT `apps/admin/*` unless MFE)
- `packages/contracts/*` (specific)
- `packages/database/*` (specific)
- `services/data/*` (specific)
- Optional: `packages/agents/*`, `packages/mcps/*`, `packages/workflows/*`

**Consumer Repos - MFE Grouped Pattern:**

- `apps/admin/*` (MFE group)
- `apps/consumer/*` (MFE group)
- `apps/mobile/*` (optional MFE group)
- `packages/contracts/*` (specific)
- `packages/database/*` (specific)
- `services/data/*` (specific)

**Library Repos:**

- `components/*` (broad)
- `config/*` (broad)
- `packages/*` (broad - ONLY for library repos)

❌ **NEVER**: Use generic `packages/*` in consumer repos

### Rule 2: Exact Path Matching

- ✅ CORRECT: `packages/contracts/*`
- ❌ WRONG: `packages/*` (in consumer repos)
- ❌ WRONG: `packages/**/*`

### Rule 3: No Missing Directories

All workspace paths must exist on filesystem (except during BUILD mode for new projects)

### Rule 4: No Extra Patterns

Only include patterns that match actual directories (except during BUILD mode)

### Rule 5: Alphabetical Ordering

Workspace patterns must be alphabetically ordered

## MFE Architecture Detection

Detect MFE architecture by checking if:

1. `apps/` directory exists
2. Contains subdirectories (admin, consumer, mobile)
3. Each subdirectory contains multiple apps (host + remotes)

```bash
# Check if MFE pattern
if [ -d "apps/admin" ] && [ $(find apps/admin -mindepth 1 -maxdepth 1 -type d | wc -l) -gt 1 ]; then
  echo "MFE pattern detected"
fi
```

## Validation

To validate a pnpm-workspace.yaml file:

1. Check that file exists at repository root
2. Detect repository type (library vs consumer)
3. Parse YAML and extract workspace patterns
4. Check filesystem for actual directories
5. Validate against 5 standards based on repo type
6. Report violations

### Validation Approach

```bash
# Rule 1: Check for generic patterns in consumer repos
if [[ "$REPO_TYPE" == "consumer" ]]; then
  grep -q "packages/\*$" pnpm-workspace.yaml && echo "VIOLATION: Generic packages/* pattern"
fi

# Rule 2: Exact path matching (no double wildcards)
grep -q "packages/\*\*/\*" pnpm-workspace.yaml && echo "VIOLATION: Uses **/* pattern"

# Rule 3 & 4: Check directories exist
while IFS= read -r pattern; do
  dir_path="${pattern%/*}"  # Remove trailing /*
  [ -d "$dir_path" ] || echo "VIOLATION: Directory $dir_path does not exist"
done < <(yq '.packages[]' pnpm-workspace.yaml)

# Rule 5: Check alphabetical order
original=$(yq '.packages[]' pnpm-workspace.yaml)
sorted=$(echo "$original" | sort)
[ "$original" = "$sorted" ] || echo "VIOLATION: Not alphabetically ordered"
```

## Repository Type Considerations

- **Consumer Repos**: Strict specific patterns enforced
- **Library Repos**: Broad patterns allowed and expected
- **MFE Repos**: Grouped app patterns (`apps/admin/*`) allowed

## Best Practices

1. Detect repo type first using package.json name
2. Use appropriate template (consumer-standard, consumer-mfe, or library)
3. Detect MFE architecture if present
4. Always verify workspace directories exist
5. Keep patterns alphabetically ordered
6. Re-audit after making changes

## Integration

This skill integrates with:

- `/skill repository-detection` - Detect library vs consumer repo
- `/skill audit-workflow` - Bi-directional comparison workflow
- `/skill remediation-options` - Conform/Update/Ignore choices
