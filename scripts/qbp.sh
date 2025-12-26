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
    "Auto-fixing lint issues"
    "Auto-formatting code"
    "Running TypeScript checks"
    "Running unit tests"
)
TOTAL_STEPS=${#STEPS[@]}
CURRENT_STEP=0

# Function to show failure summary with skipped steps
show_failure_summary() {
    local failed_step=$1
    local failed_name="${STEPS[$failed_step]}"

    echo ""
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${RED}QBP FAILED${NC}"
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
echo -e "${YELLOW}QBP: Quality Before Push${NC}"
echo -e "${CYAN}(Complements clean-and-build and build-and-publish)${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Step 1: Auto-fix lint issues
run_step 0 "pnpm lint:fix"

# Step 2: Auto-format code with Prettier
run_step 1 "pnpm prettier:fix"

# Step 3: TypeScript type checking
run_step 2 "pnpm turbo lint:tsc"

# Step 4: Run tests
run_step 3 "pnpm turbo test:unit"

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}QBP COMPLETED SUCCESSFULLY${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${CYAN}Summary:${NC}"
for ((i=0; i<TOTAL_STEPS; i++)); do
    echo -e "  ${GREEN}✓${NC} ${STEPS[$i]}"
done
echo ""
