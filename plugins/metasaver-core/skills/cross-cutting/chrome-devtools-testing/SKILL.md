---
name: chrome-devtools-testing
description: Use when testing web applications with Chrome DevTools MCP. Covers GUI Chrome setup and dev server configuration. Required reading before any browser automation.
---

# Chrome DevTools Testing Skill

## Purpose

Automate testing of web applications using Chrome DevTools Protocol (CDP) with GUI Chrome browser.

## Standard Setup

### Step 1: Start Chrome (GUI Browser)

```bash
/usr/bin/google-chrome \
  --remote-debugging-port=9222 \
  --user-data-dir=/tmp/chrome-debug-profile \
  --no-first-run \
  --no-default-browser-check \
  "about:blank" &

sleep 3
curl -s http://127.0.0.1:9222/json/version
```

**MANDATORY FLAGS:**

- `--user-data-dir=/tmp/chrome-debug-profile` - Remote debugging REQUIRES a non-default profile
- `--remote-debugging-port=9222` - Standard CDP port

**NOTE:** Headless mode (`--headless=new`) has known issues. Use GUI browser instead.

### Step 2: Start Dev Server

```bash
pnpm exec vite --host 0.0.0.0
```

### Step 3: Navigate and Test

```
navigate_page(url: "http://localhost:PORT", type: "url")
take_snapshot()
```

---

## Complete Workflow

### Clean Start

```bash
# Kill existing Chrome sessions
pkill -f "chrome.*remote-debugging" || true

# Kill process on dev port if needed
fuser -k 3000/tcp || true
```

### Start Services

```bash
# 1. Start Chrome (GUI)
/usr/bin/google-chrome \
  --remote-debugging-port=9222 \
  --user-data-dir=/tmp/chrome-debug-profile \
  --no-first-run \
  --no-default-browser-check \
  "about:blank" &

sleep 3
curl -s http://127.0.0.1:9222/json/version

# 2. Start dev server
cd /path/to/app
pnpm exec vite --host 0.0.0.0 &

sleep 5
```

### MCP Connection

If chrome-devtools MCP shows "Not connected":

1. Ask user to run `/mcp` to reconnect
2. Wait for confirmation
3. Retry

---

## Troubleshooting

| Symptom                                    | Fix                                                          |
| ------------------------------------------ | ------------------------------------------------------------ |
| "requires non-default data directory"      | Add `--user-data-dir=/tmp/chrome-debug-profile`              |
| "Not connected" from MCP                   | User runs `/mcp` to reconnect                                |
| `ERR_CONNECTION_REFUSED`                   | Start dev server with `--host 0.0.0.0`                       |
| Chrome won't start                         | `pkill -f "chrome.*remote-debugging"`                        |
| `EADDRINUSE` on port 9222                  | `lsof -ti:9222 \| xargs kill -9` then restart Chrome         |
| Stale UIDs (elements not found)            | Take fresh snapshot with `take_snapshot()`                   |
| MCP timeout errors                         | Verify Chrome responded to curl, user runs `/mcp` to restart |
| Display server issues (WSL/Linux headless) | Set `DISPLAY=:0` or use native browser instead               |
| Certificate warnings on localhost          | Use `http://` (not `https://`) for localhost testing         |

---

## MCP Tools Quick Reference

### Navigation

| Tool            | Purpose                               | Parameters                                 |
| --------------- | ------------------------------------- | ------------------------------------------ |
| `list_pages`    | List open tabs with page IDs and URLs | (none)                                     |
| `select_page`   | Switch active tab                     | `page_id` - from `list_pages` output       |
| `new_page`      | Open new tab                          | (none) - defaults to about:blank           |
| `navigate_page` | Navigate to URL in active tab         | `url` (required), `timeout` (optional, ms) |
| `close_page`    | Close tab/page                        | `page_id` - from `list_pages` output       |
| `get_url`       | Get current page URL                  | (none)                                     |

### Inspection

| Tool                    | Purpose                             | Notes                                 |
| ----------------------- | ----------------------------------- | ------------------------------------- |
| `take_snapshot`         | Get DOM tree with unique IDs (UIDs) | Returns page structure + element UIDs |
| `take_screenshot`       | Capture visual screenshot           | Full page or viewport                 |
| `list_console_messages` | Get JavaScript console logs         | Includes errors, warnings, logs       |
| `list_network_requests` | Get network activity                | Requests, responses, timing           |
| `get_page_source`       | Get raw HTML source                 | Full document HTML                    |

### Interaction

| Tool        | Purpose                    | Parameters                                               |
| ----------- | -------------------------- | -------------------------------------------------------- |
| `click`     | Click element by UID       | `uid` - from `take_snapshot()` output                    |
| `fill`      | Enter text in input        | `uid` (target element), `text` (input value)             |
| `hover`     | Hover over element         | `uid` - from `take_snapshot()` output                    |
| `press_key` | Send keyboard input        | `key` - alphanumeric, or special (Return, Escape, Enter) |
| `wait`      | Wait for element/condition | `timeout` (ms), `selector` or `uid`                      |

---

## Understanding UIDs

**What is a UID?**

Every DOM element in a page snapshot receives a unique identifier (UID). UIDs are used to reference specific elements for interaction (click, fill, hover).

**When UIDs become stale:**

- After page navigation
- After DOM mutations (elements added/removed/reordered)
- After JavaScript dynamically modifies the page
- After timeout waiting for elements

**Best practice:** Always run `take_snapshot()` before attempting interactions. This refreshes UIDs to match current page state.

**Example workflow:**

```
1. navigate_page(url: "http://localhost:3000")
2. take_snapshot()                          # Get fresh UIDs
3. click(uid: "button-123")                 # Use UID from snapshot
4. take_snapshot()                          # Refresh after action
5. fill(uid: "input-456", text: "search")   # Use new UID
```

---

## Pre-Flight Checklist

- [ ] Chrome started with `--user-data-dir` flag
- [ ] `curl http://127.0.0.1:9222/json/version` returns JSON
- [ ] Dev server started with `--host 0.0.0.0`
- [ ] MCP chrome-devtools connected

---

## Common Mistakes

1. **Missing `--user-data-dir`** → Remote debugging fails immediately. Always use `--user-data-dir=/tmp/chrome-debug-profile`
2. **Using stale UIDs** → Click/fill fail silently. Run `take_snapshot()` after every navigation or DOM change
3. **Multiple Chrome instances** → Port 9222 conflicts. Use `lsof -ti:9222 | xargs kill -9` to clean up
4. **Multiple dev servers** → Port conflicts. Use `fuser -k 3000/tcp` before starting new server
5. **Not waiting for services** → Connection fails. Always `sleep 3-5` after starting Chrome/server
6. **Not checking MCP status** → Tools fail silently. Have user run `/mcp` if tools don't respond
7. **Using headless mode** → Known issues with display/MCP. Use GUI browser with `--user-data-dir` instead
8. **Not using `--host 0.0.0.0`** → Dev server unreachable. Required for Docker/remote access

---

## Chrome Version Compatibility

**Supported versions:** Chrome 90+ (CDP Protocol v1.3+)

**Check version:**

```bash
/usr/bin/google-chrome --version
```

**Known issues by version:**

- **Chrome < 90** → CDP protocol too old, tools may not work
- **Chrome 90-100** → Stable, most common
- **Chrome 101+** → Supports newer CDP features, recommended
- **Chromium (headless)** → Not supported, use GUI Chrome instead

**If version is too old:**

```bash
# Option 1: Update Chrome
sudo apt-get update && sudo apt-get install google-chrome-stable

# Option 2: Use different installation
/snap/bin/chromium --version
/snap/bin/chromium --remote-debugging-port=9222 --user-data-dir=/tmp/chrome-debug &
```

---

## Known Failures (WSL Environment)

### Problem: Chrome Starts But MCP Tools Fail

**Symptoms:**

- `curl http://127.0.0.1:9222/json/version` returns valid JSON
- MCP chrome-devtools tools return "Not connected"
- Chrome window never appears visually for user
- Multiple background processes accumulate

**Root Cause:** In WSL2 environments, Chrome may technically start with debugging enabled but fail to establish proper GUI display or MCP connection. The CDP endpoint responds to curl but the MCP integration cannot connect.

**What To Do:**

1. **Acknowledge the failure immediately:**

   ```
   Chrome DevTools automation failed. You can restart manually.
   ```

2. **Do NOT:**
   - Keep retrying indefinitely
   - Spawn more background processes
   - Pretend it might work next time

3. **Tell user to verify manually:**
   - Open Chrome on Windows side
   - Navigate to `http://localhost:PORT`
   - Check browser console for errors

### When This Happens

If MCP tools fail after Chrome appears to start:

```
Chrome DevTools automation failed.
HTTP verification shows servers are responding.
Please verify manually in your browser:
- http://localhost:3000 (main app)
- http://localhost:5173 (dev server)
```

Then stop attempting browser automation.
