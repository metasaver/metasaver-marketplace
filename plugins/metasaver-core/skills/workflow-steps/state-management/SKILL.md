---
name: state-management
description: Helper methods for PM agents to read, write, and update workflow-state.json files consistently during workflow execution. Use when managing workflow state persistence, tracking wave progress, handling HITL stops, or resuming workflows.
---

# State Management Skill

## Purpose

Provides consistent operations for workflow-state.json management during `/ms` workflow execution. Ensures PM agents have standardized methods for reading, writing, and updating workflow state files.

## File Location

`{projectFolder}/workflow-state.json`

**Example:** `docs/projects/msm004-positive-reinforcement-hooks/workflow-state.json`

## Core Methods

### 1. readWorkflowState(projectFolder)

Read and parse workflow state from project folder.

**Input:** Absolute path to project folder
**Output:** State object or null if not found
**Error Handling:** Returns null with warning if file missing or corrupt

**Pseudocode:**

```javascript
function readWorkflowState(projectFolder):
  statePath = join(projectFolder, "workflow-state.json")

  if not fileExists(statePath):
    log.warn("No workflow state found at {statePath}")
    return null

  try:
    content = readFile(statePath)
    state = JSON.parse(content)
    return state
  catch (JSONError):
    log.error("Invalid JSON in workflow state: {statePath}")
    return null
```

### 2. writeWorkflowState(projectFolder, state)

Write complete state object to file with validation.

**Input:**

- projectFolder: Absolute path to project folder
- state: Complete state object

**Output:** Success boolean
**Validation:** Schema validation before write

**Pseudocode:**

```javascript
function writeWorkflowState(projectFolder, state):
  statePath = join(projectFolder, "workflow-state.json")

  // Validate required fields
  if not validateSchema(state):
    log.error("Invalid state schema")
    return false

  // Update timestamp
  state.lastUpdate = new Date().toISOString()

  try:
    writeFile(statePath, JSON.stringify(state, null, 2))
    log.info("Workflow state updated: {statePath}")
    return true
  catch (WriteError):
    log.error("Failed to write workflow state: {error}")
    return false
```

### 3. updateWorkflowState(projectFolder, updates)

Merge partial updates into existing state.

**Input:**

- projectFolder: Absolute path to project folder
- updates: Partial state object with fields to update

**Output:** Updated state object or null on failure
**Behavior:** Read existing → merge updates → write

**Pseudocode:**

```javascript
function updateWorkflowState(projectFolder, updates):
  state = readWorkflowState(projectFolder)

  if state is null:
    log.error("Cannot update: no existing workflow state")
    return null

  // Deep merge updates into state
  mergedState = deepMerge(state, updates)

  if writeWorkflowState(projectFolder, mergedState):
    return mergedState
  else:
    return null
```

## Helper Methods

### 4. getCurrentWave(state)

Returns current wave number from state.

**Input:** State object
**Output:** Current wave number (0 if not in execution)

**Pseudocode:**

```javascript
function getCurrentWave(state):
  return state.currentWave || 0
```

### 5. getNextStories(state, wave)

Returns array of story IDs scheduled for wave.

**Input:**

- state: State object
- wave: Wave number (optional, defaults to currentWave + 1)

**Output:** Array of story IDs from pending array

**Pseudocode:**

```javascript
function getNextStories(state, wave = null):
  // This is a simplified version - actual implementation
  // would read wave assignments from execution plan

  if wave is null:
    wave = state.currentWave + 1

  // Return subset of pending stories for this wave
  // (wave assignments should be in execution plan)
  return state.stories.pending.slice(0, 3) // Example: 3 stories per wave
```

### 6. markStoryComplete(state, storyId)

Moves story from inProgress to completed array, updates epic progress.

**Input:**

- state: State object
- storyId: Story identifier (e.g., "US-003")

**Output:** Updated state object

**Pseudocode:**

```javascript
function markStoryComplete(state, storyId):
  // Remove from inProgress
  state.stories.inProgress = state.stories.inProgress.filter(id => id !== storyId)

  // Add to completed
  if not state.stories.completed.includes(storyId):
    state.stories.completed.push(storyId)

  // Update epic progress
  // (Assumes epic mapping exists in PRD or state)
  epicId = findEpicForStory(storyId)
  if epicId:
    epic = state.epics.find(e => e.id === epicId)
    if epic:
      epic.storiesCompleted += 1
      if epic.storiesCompleted === epic.storiesTotal:
        epic.status = "complete"

  state.lastUpdate = new Date().toISOString()
  return state
```

### 7. setHITL(state, question, resumeAction)

Sets HITL fields for workflow pause.

**Input:**

- state: State object
- question: Question to ask user
- resumeAction: Action identifier for resumption

**Output:** Updated state object

**Pseudocode:**

```javascript
function setHITL(state, question, resumeAction):
  state.status = "hitl_waiting"
  state.hitlQuestion = question
  state.resumeAction = resumeAction
  state.lastUpdate = new Date().toISOString()
  return state
```

### 8. validateSchema(state)

Validates state object against schema rules.

**Input:** State object
**Output:** Boolean (true if valid)

**Validation Rules:**

- Required fields: command, phase, phaseName, step, currentWave, totalWaves, status, lastUpdate
- command: Must be "build", "audit", "architect", or "debug"
- phase: Must be 1-5
- status: Must match enum (analysis, requirements, design, approval_waiting, executing, hitl_waiting, validating, complete, error)
- currentWave: Must be 0 or positive integer <= totalWaves
- totalWaves: Must be positive integer
- lastUpdate: Must be valid ISO 8601 timestamp

## Usage Examples

### Example 1: PM updating state after wave completion

```javascript
// After wave execution completes
const state = readWorkflowState("/absolute/path/to/project");

if (state) {
  // Mark wave 2 stories complete
  ["US-003", "US-004", "US-005"].forEach((storyId) => {
    markStoryComplete(state, storyId);
  });

  // Set HITL for user approval
  setHITL(state, "Wave 2 complete. Proceed with wave 3?", "spawn-wave-3");

  // Write updated state
  writeWorkflowState("/absolute/path/to/project", state);
}
```

### Example 2: Checking for active workflow

```javascript
// PM checks if workflow exists and is active
const state = readWorkflowState("/absolute/path/to/project");

if (state === null) {
  console.log("No active workflow found");
} else if (state.status === "complete") {
  console.log("Workflow already complete");
} else if (state.status === "hitl_waiting") {
  console.log(`Waiting for user response: ${state.hitlQuestion}`);
  console.log(`Resume action: ${state.resumeAction}`);
} else {
  console.log(`Active workflow at phase ${state.phase}: ${state.phaseName}`);
}
```

### Example 3: Updating state during wave execution

```javascript
// PM starts wave 3
const updates = {
  currentWave: 3,
  status: "executing",
  stories: {
    ...state.stories,
    inProgress: ["US-006", "US-007", "US-008"],
  },
};

const updatedState = updateWorkflowState("/absolute/path/to/project", updates);

if (updatedState) {
  console.log(
    `Wave ${updatedState.currentWave} started with ${updatedState.stories.inProgress.length} stories`,
  );
}
```

## Error Handling

| Error Condition          | Response                                   |
| ------------------------ | ------------------------------------------ |
| Missing file             | Return null, log warning                   |
| Invalid JSON             | Return null, log error with parse details  |
| Schema validation failed | Return false from write, log error details |
| Write permission denied  | Return false, log error                    |
| Corrupted state          | Return null, suggest manual inspection     |
| Duplicate story IDs      | Log warning, deduplicate before processing |

## Integration

**Referenced by:**

- `/skill pm-build-workflow` - Uses all methods for workflow management
- `/skill pm-wave-coordinator` - Uses markStoryComplete, setHITL
- `/skill pm-resume-workflow` - Uses readWorkflowState, getCurrentWave

**Schema reference:** `docs/workflow-state-spec.md`

## Best Practices

1. **Always read before update** - Use updateWorkflowState() instead of direct writes
2. **Validate before write** - Schema validation prevents corruption
3. **Update timestamps** - All write operations auto-update lastUpdate
4. **Handle nulls gracefully** - Check return values before proceeding
5. **Log all state changes** - Maintain audit trail of workflow progress
6. **Deep merge for updates** - Preserve nested objects when updating
