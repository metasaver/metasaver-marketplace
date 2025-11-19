#!/bin/sh
set -e

echo "🔒 Checking for sensitive files..."

# Detect if this is the multi-mono library repo
IS_MULTI_MONO=false
if [ -f "scripts/sync-ms-command.sh" ]; then
  IS_MULTI_MONO=true
fi

# Check for .env files (block in ALL repos)
if git diff --cached --name-only | grep -E '\.env(\..+)?$'; then
  echo "❌ ERROR: Attempting to commit .env files"
  echo "   .env files contain sensitive data and should never be committed"
  echo "   Please unstage these files:"
  echo "   git reset HEAD .env*"
  exit 1
fi

# Check for .npmrc files (smart detection)
if git diff --cached --name-only | grep -E '\.npmrc$'; then
  if [ "$IS_MULTI_MONO" = true ]; then
    # Multi-mono: Allow root .npmrc (registry config), block subdirectory .npmrc
    if git diff --cached --name-only | grep -E '^\.npmrc$'; then
      echo "ℹ️  Root .npmrc detected (multi-mono library repo - registry config allowed)"
    fi
    if git diff --cached --name-only | grep -E '.+/\.npmrc$'; then
      echo "❌ ERROR: Attempting to commit subdirectory .npmrc in multi-mono repo"
      echo "   Only root .npmrc is allowed (for registry configuration)"
      echo "   Subdirectory .npmrc files should never be committed"
      echo "   Please unstage these files:"
      echo "   git reset HEAD **/.npmrc"
      exit 1
    fi
  else
    # Consumer repos: Block ALL .npmrc files (including root)
    echo "❌ ERROR: Attempting to commit .npmrc files"
    echo "   .npmrc files contain authentication tokens and should never be committed"
    echo "   Please unstage these files:"
    echo "   git reset HEAD .npmrc"
    exit 1
  fi
fi

echo "✨ Running Prettier..."
pnpm run prettier:fix

echo "🔍 Running ESLint..."
pnpm run lint:fix

echo "📝 Auto-adding fixed files..."
git add -u

echo "✅ Pre-commit checks passed"
