#!/bin/sh
set -e

# Skip in CI environments
if [ -n "$CI" ] || [ -n "$GITHUB_ACTIONS" ] || [ -n "$GITLAB_CI" ] || [ -n "$JENKINS_HOME" ]; then
  echo "⏭️  Skipping pre-push checks in CI environment"
  exit 0
fi

echo "🚀 Running pre-push checks..."

START_TIME=$(date +%s)

echo "1️⃣ Prettier check..."
pnpm run prettier

echo "2️⃣ ESLint check..."
pnpm run lint

echo "3️⃣ TypeScript type check..."
pnpm run lint:tsc

echo "4️⃣ Unit tests..."
pnpm run test:unit

END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

echo "✅ All checks passed in ${DURATION}s"
