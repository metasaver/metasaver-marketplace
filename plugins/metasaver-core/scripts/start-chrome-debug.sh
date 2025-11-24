#!/bin/bash
# Start Chrome with remote debugging for MCP Chrome DevTools
# Linux-only version - for use in WSL or native Linux

# Check if Chrome is already running on debug port
if timeout 1 bash -c 'cat < /dev/null > /dev/tcp/127.0.0.1/9222' 2>/dev/null; then
    echo "✓ Chrome already running with debugging on port 9222"
    exit 0
fi

echo "Starting Chrome with remote debugging..."

# Find Chrome executable
if command -v google-chrome &> /dev/null; then
    CHROME_BIN="google-chrome"
elif command -v google-chrome-stable &> /dev/null; then
    CHROME_BIN="google-chrome-stable"
elif command -v chromium-browser &> /dev/null; then
    CHROME_BIN="chromium-browser"
elif command -v chromium &> /dev/null; then
    CHROME_BIN="chromium"
else
    echo "❌ ERROR: Chrome not found"
    echo "   Install: sudo apt install google-chrome-stable"
    exit 1
fi

# Start Chrome with remote debugging
$CHROME_BIN \
  --remote-debugging-port=9222 \
  --user-data-dir="/tmp/chrome-debug-mcp" \
  --no-first-run \
  --no-default-browser-check \
  > /dev/null 2>&1 &

# Wait for Chrome to start
sleep 2

# Verify it started
if timeout 1 bash -c 'cat < /dev/null > /dev/tcp/127.0.0.1/9222' 2>/dev/null; then
    echo "✓ Chrome started successfully on port 9222"
else
    echo "⚠ Chrome may not have started. Check manually if needed."
    exit 1
fi
