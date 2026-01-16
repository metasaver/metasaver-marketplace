#!/usr/bin/env node
/**
 * UserPromptSubmit hook - reminds users about /ms workflow
 *
 * FIRE when:
 * - No command prefix (/ms, /build, /audit, etc.)
 * - Complexity keywords detected
 * - No opt-out phrase
 *
 * SKIP when:
 * - Has command prefix
 * - Simple question (what, how, where, why, explain)
 * - Opt-out phrase present
 */

const COMMAND_PREFIXES = [
  "/ms",
  "/build",
  "/audit",
  "/debug",
  "/qq",
  "/architect",
  "/clear",
  "/help",
  "/commit",
];

const OPT_OUT_PHRASES = ["ignore /ms", "skip workflow", "just do it"];

const QUESTION_STARTERS = ["what", "how", "where", "why", "explain", "show me", "list"];

const COMPLEXITY_KEYWORDS = [
  "implement",
  "add",
  "create",
  "build",
  "fix",
  "refactor",
  "update all",
  "change everywhere",
  "restructure",
  "migrate",
  "integrate",
];

// Read user prompt from stdin
let input = "";
process.stdin.setEncoding("utf8");
process.stdin.on("data", (chunk) => {
  input += chunk;
});
process.stdin.on("end", () => {
  try {
    const data = JSON.parse(input);
    const prompt = (data.prompt || "").toLowerCase().trim();

    // SKIP: Has command prefix
    if (COMMAND_PREFIXES.some((prefix) => prompt.startsWith(prefix.toLowerCase()))) {
      process.exit(0);
    }

    // SKIP: Has opt-out phrase
    if (OPT_OUT_PHRASES.some((phrase) => prompt.includes(phrase))) {
      process.exit(0);
    }

    // SKIP: Simple question
    if (QUESTION_STARTERS.some((starter) => prompt.startsWith(starter))) {
      process.exit(0);
    }

    // CHECK: Has complexity keywords
    const hasComplexity = COMPLEXITY_KEYWORDS.some((keyword) => prompt.includes(keyword));

    if (hasComplexity) {
      // FIRE: Show reminder (non-blocking)
      const summary = data.prompt.substring(0, 50);
      process.stderr.write(
        `💡 For complex work, consider using \`/ms ${summary}...\` to enable workflow tracking and HITL approvals.\n`,
      );
    }

    // Always exit 0 (non-blocking)
    process.exit(0);
  } catch (e) {
    // On error, allow prompt to proceed
    process.exit(0);
  }
});
