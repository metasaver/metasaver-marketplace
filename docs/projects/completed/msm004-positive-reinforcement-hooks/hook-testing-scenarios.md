# Hook Testing Scenarios

## Overview

Testing scenarios for the UserPromptSubmit hook (ms-reminder-hook.js).

## Test Setup

### Manual Testing

```bash
# Navigate to plugin hooks directory
cd plugins/metasaver-core/hooks/scripts

# Run hook with test input
echo '{"prompt": "implement user auth"}' | node ms-reminder-hook.js

# Check stderr for output (FIRE case)
# Check exit code (should be 0)
```

## Test Scenarios

### Scenario 1: Complex Build Request (FIRE)

**Input:** `{"prompt": "implement user authentication with JWT"}`
**Expected:** Message on stderr, exit code 0
**Message:** `💡 For complex work, consider using \`/ms implement user authentication with JWT...\`...`

### Scenario 2: Simple Question (SKIP)

**Input:** `{"prompt": "what is the project structure?"}`
**Expected:** No output, exit code 0

### Scenario 3: Command Prefix (SKIP)

**Input:** `{"prompt": "/build add user auth"}`
**Expected:** No output, exit code 0

### Scenario 4: Opt-out Phrase (SKIP)

**Input:** `{"prompt": "just do it - implement the feature"}`
**Expected:** No output, exit code 0

### Scenario 5: Refactoring Keywords (FIRE)

**Input:** `{"prompt": "refactor the entire auth module"}`
**Expected:** Message on stderr, exit code 0

### Scenario 6: Architecture Keywords (FIRE)

**Input:** `{"prompt": "migrate from REST to GraphQL"}`
**Expected:** Message on stderr, exit code 0

### Scenario 7: Empty Prompt (SKIP)

**Input:** `{"prompt": ""}`
**Expected:** No output, exit code 0

### Scenario 8: Invalid JSON (SKIP)

**Input:** `not valid json`
**Expected:** No output, exit code 0 (graceful failure)

## Automated Test Script

```bash
#!/bin/bash
# test-hook.sh - Run all test scenarios

HOOK="node plugins/metasaver-core/hooks/scripts/ms-reminder-hook.js"

test_scenario() {
  local name="$1"
  local input="$2"
  local expect_fire="$3"

  output=$(echo "$input" | $HOOK 2>&1)
  exit_code=$?

  if [ "$exit_code" -eq 0 ]; then
    if [ "$expect_fire" = "FIRE" ] && [ -n "$output" ]; then
      echo "✅ $name: PASS (FIRE)"
    elif [ "$expect_fire" = "SKIP" ] && [ -z "$output" ]; then
      echo "✅ $name: PASS (SKIP)"
    else
      echo "❌ $name: FAIL (expected $expect_fire)"
    fi
  else
    echo "❌ $name: FAIL (exit code $exit_code)"
  fi
}

test_scenario "Complex build" '{"prompt": "implement user auth"}' "FIRE"
test_scenario "Simple question" '{"prompt": "what is auth?"}' "SKIP"
test_scenario "Command prefix" '{"prompt": "/build add auth"}' "SKIP"
test_scenario "Opt-out" '{"prompt": "just do it - add auth"}' "SKIP"
test_scenario "Refactor" '{"prompt": "refactor auth"}' "FIRE"
```
