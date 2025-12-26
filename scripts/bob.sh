#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
GRAY='\033[0;90m'
NC='\033[0m' # No Color

# Step definitions
STEPS=(
    "Cleaning project"
    "Installing dependencies"
    "Auto-fixing lint issues"
    "Auto-formatting code"
    "Running TypeScript checks"
    "Running unit tests"
    "Building all packages"
    "Publishing locally"
)
TOTAL_STEPS=${#STEPS[@]}
CURRENT_STEP=0

# Function to show failure summary with skipped steps
show_failure_summary() {
    local failed_step=$1
    local failed_name="${STEPS[$failed_step]}"

    echo ""
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${RED}BOB FAILED${NC}"
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${CYAN}Summary:${NC}"

    # Show completed steps
    for ((i=0; i<failed_step; i++)); do
        echo -e "  ${GREEN}✓${NC} ${STEPS[$i]}"
    done

    # Show failed step
    echo -e "  ${RED}✗ ${failed_name}${NC}"

    # Show skipped steps
    for ((i=failed_step+1; i<TOTAL_STEPS; i++)); do
        echo -e "  ${GRAY}⊘ ${STEPS[$i]} (skipped)${NC}"
    done

    echo ""
}

# Function to run a step with error handling
run_step() {
    local step_num=$1
    local step_name="${STEPS[$step_num]}"
    shift
    local cmd="$@"

    echo -e "${BLUE}Step $((step_num+1))/${TOTAL_STEPS}: ${step_name}...${NC}"

    if ! eval "$cmd"; then
        echo -e "${RED}❌ ${step_name} failed${NC}"
        show_failure_summary $step_num
        exit 1
    fi

    CURRENT_STEP=$((step_num+1))
}

echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}BOB: Build, Optimize, and Bundle${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Step 1: Clean
run_step 0 "pnpm clean"

# Step 2: Install dependencies
echo -e "${BLUE}Step 2/${TOTAL_STEPS}: Installing dependencies...${NC}"
if [ -f "pnpm-lock.yaml" ]; then
    echo -e "${CYAN}   Using strict mode (frozen-lockfile)${NC}"
    if ! pnpm install --frozen-lockfile; then
        echo -e "${RED}❌ Installing dependencies failed${NC}"
        echo -e "${YELLOW}💡 Tip: Your pnpm-lock.yaml may be out of sync. Run 'pnpm install' to update it.${NC}"
        show_failure_summary 1
        exit 1
    fi
else
    echo -e "${YELLOW}   No pnpm-lock.yaml found - generating it...${NC}"
    if ! pnpm install; then
        echo -e "${RED}❌ Installing dependencies failed${NC}"
        show_failure_summary 1
        exit 1
    fi
fi
CURRENT_STEP=2

# Step 3: Auto-fix lint issues
run_step 2 "pnpm lint:fix"

# Step 4: Auto-format code with Prettier
run_step 3 "pnpm prettier:fix"

# Step 5: TypeScript type checking
run_step 4 "pnpm turbo lint:tsc"

# Step 6: Run tests
run_step 5 "pnpm turbo test:unit"

# Step 7: Build
run_step 6 "pnpm turbo build"

# Step 8: Publish locally
run_step 7 "pnpm publish:local"

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}BOB COMPLETED SUCCESSFULLY${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${CYAN}Summary:${NC}"
for ((i=0; i<TOTAL_STEPS; i++)); do
    echo -e "  ${GREEN}✓${NC} ${STEPS[$i]}"
done
echo ""
