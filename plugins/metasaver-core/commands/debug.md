---
name: debug
description: Browser debugging and E2E testing workflow using Chrome DevTools MCP (NOT READY - DO NOT USE)
---

# /debug Command

> **STATUS: NOT READY - DO NOT USE**
>
> This command is a placeholder for future browser debugging workflow.

---

## Planned Features

When implemented, this command will provide:

1. **Browser Automation** - Chrome DevTools MCP integration for browser control
2. **E2E Testing** - End-to-end user workflow validation
3. **Visual Debugging** - Screenshots and DOM snapshots
4. **Network Inspection** - API call monitoring and validation
5. **Performance Profiling** - Page load and interaction metrics

---

## Skills to Reference (When Implemented)

| Skill                              | Purpose                                            |
| ---------------------------------- | -------------------------------------------------- |
| `/skill chrome-devtools-testing`   | Chrome setup, MCP tools reference, troubleshooting |
| TBD: `/skill e2e-testing-workflow` | E2E test patterns and workflows                    |
| TBD: `/skill visual-regression`    | Screenshot comparison testing                      |

---

## Planned Workflow

```
/debug [target]

1. Setup Phase
   - Start Chrome with remote debugging
   - Verify MCP connection
   - Start dev server if needed

2. Navigation Phase
   - Navigate to target URL
   - Take DOM snapshot
   - Capture baseline screenshot

3. Interaction Phase (if testing)
   - Execute user workflow
   - Capture evidence at each step
   - Monitor network requests

4. Validation Phase
   - Compare against expected state
   - Report console errors
   - Generate test report

5. Cleanup Phase
   - Store results in memory
   - Close browser session
```

---

## Current Alternative

For manual browser debugging now, use:

```bash
# Start Chrome with debugging
./scripts/start-chrome-debug.sh

# Or manually:
google-chrome --remote-debugging-port=9222 --user-data-dir=/tmp/chrome-debug-profile

# Then use Chrome DevTools MCP tools directly:
# - navigate_page, take_snapshot, click, fill, etc.
```

See `/skill chrome-devtools-testing` for detailed setup and troubleshooting.

---

## Implementation Notes

- Requires Chrome DevTools MCP server configured
- GUI Chrome recommended (headless has known issues in WSL)
- Dev server must use `--host 0.0.0.0` for container access
