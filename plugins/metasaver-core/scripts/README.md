# Chrome Debug Script Setup

This directory contains scripts for starting Chrome with remote debugging enabled for MCP Chrome DevTools integration.

## Script: `start-chrome-debug.sh`

**Purpose:** Start Chrome in Linux/WSL with remote debugging on port 9222 for E2E testing and browser automation.

**Features:**

- Checks if Chrome is already running on port 9222
- Auto-detects Chrome installation (google-chrome, chromium, etc.)
- Uses isolated profile directory (`/tmp/chrome-debug-mcp`)
- Exits cleanly if already running

---

## Adding to Other Projects

### 1. Copy the Script

```bash
# From your project root
mkdir -p scripts
cp /path/to/metasaver-marketplace/plugins/metasaver-core/scripts/start-chrome-debug.sh scripts/
chmod +x scripts/start-chrome-debug.sh
```

### 2. Add npm Scripts

Add to your `package.json`:

```json
{
  "scripts": {
    "predev": "bash scripts/start-chrome-debug.sh",
    "dev": "vite"
  }
}
```

**Pattern:**

- `predev` - npm lifecycle hook that runs **automatically** before `dev`
- Chrome starts every time you run `npm run dev`

### 3. Usage

**Normal workflow:**

```bash
npm run dev
# 1. predev runs automatically (starts Chrome)
# 2. dev server starts
```

**That's it!** Chrome is always ready when you need it.

---

## How It Works

1. **Check if already running**: Uses TCP connection test to port 9222
2. **Find Chrome**: Searches for `google-chrome`, `google-chrome-stable`, `chromium-browser`, or `chromium`
3. **Launch with debugging**: Starts Chrome with `--remote-debugging-port=9222`
4. **Isolated profile**: Uses `/tmp/chrome-debug-mcp` to avoid interfering with your main Chrome profile
5. **Verify startup**: Confirms port 9222 is accessible

---

## Chrome DevTools MCP Configuration

In your `.mcp.json`:

```json
{
  "mcpServers": {
    "chrome-devtools": {
      "command": "npx",
      "args": [
        "-y",
        "chrome-devtools-mcp@latest",
        "--browserUrl=http://127.0.0.1:9222"
      ]
    }
  }
}
```

---

## Stopping Chrome Debug

```bash
# Kill all Chrome processes
pkill chrome

# Or kill specific debugging instance
pkill -f "remote-debugging-port=9222"
```

---

## Security Warning

⚠️ **When Chrome runs with remote debugging enabled, ANY application on your machine can control the browser.**

**Best practices:**

- Only enable when actively testing
- Don't browse sensitive sites (banking, passwords, etc.)
- Use isolated profile (already configured)
- Close when done testing

---

## Troubleshooting

### Chrome not found

```bash
# Install Chrome (Ubuntu/Debian)
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb

# Or install Chromium
sudo apt install chromium-browser
```

### Port already in use

```bash
# Check what's using port 9222
lsof -i :9222

# Kill the process
pkill chrome
```

### Script doesn't start Chrome

```bash
# Run script with debug output
bash -x scripts/start-chrome-debug.sh

# Check Chrome installation
which google-chrome
which chromium
```

---

## Example: Resume Builder Integration

From `/mnt/f/code/resume-builder/package.json`:

```json
{
  "scripts": {
    "predev": "bash scripts/start-brave-mcp.sh",
    "dev": "vite"
  }
}
```

**Workflow:**

```bash
npm run dev
# ✓ Brave starts automatically via predev
# ✓ Vite dev server starts
```

**Note:** Resume builder uses Brave, but the pattern is identical. Just replace `start-brave-mcp.sh` with `start-chrome-debug.sh`.

---

## Multi-Project Setup

For monorepos with multiple apps, you can:

1. **Shared script**: Keep one copy in root `scripts/` directory
2. **Per-app scripts**: Each app references `../../scripts/start-chrome-debug.sh`
3. **Package-level**: Copy to each package that needs E2E testing

**Example (monorepo app package.json):**

```json
{
  "scripts": {
    "predev": "bash ../../scripts/start-chrome-debug.sh",
    "dev": "vite"
  }
}
```

**Root level (optional - for testing):**

```json
{
  "scripts": {
    "pretest:e2e": "bash scripts/start-chrome-debug.sh",
    "test:e2e": "playwright test"
  }
}
```

---

## Related Tools

- **Chrome DevTools MCP**: https://github.com/ChromeDevTools/chrome-devtools-mcp
- **E2E Test Agent**: Uses Chrome DevTools MCP for browser automation
- **MCP Protocol**: https://modelcontextprotocol.io
