export default {
  extends: ["@commitlint/config-conventional"],
  rules: {
    // Valid commit types (STRICT - enforced for changelog generation)
    "type-enum": [
      2,
      "always",
      [
        "build",
        "chore",
        "ci",
        "docs",
        "feat",
        "fix",
        "perf",
        "refactor",
        "revert",
        "style",
        "test",
      ],
    ],
    // RELAXED RULES FOR GITHUB COPILOT:
    // Disable case checking - allow "Add" or "add" (Copilot's natural style)
    "subject-case": [0],
    // Subject cannot be empty (STRICT)
    "subject-empty": [2, "never"],
    // Warning instead of error for period at end
    "subject-full-stop": [1, "never", "."],
    // Increased limit, warning only (was 100 chars, error)
    "header-max-length": [1, "always", 120],
    // Disable body line length check entirely (was 120 chars, error)
    "body-max-line-length": [0],
  },
};
