# Commit Message Guidelines

Follow Conventional Commits with these strict rules enforced by commitlint.

## Format

```
type(scope): subject

body (optional)

footer (optional)
```

## Rules

### 1. Type (Required)

Must be one of: `build`, `chore`, `ci`, `docs`, `feat`, `fix`, `perf`, `refactor`, `revert`, `style`, `test`

### 2. Scope (Optional)

Use scope to indicate the area of change (e.g., `auth`, `api`, `ui`, `db`)

### 3. Subject (Required)

- **MUST be lowercase** after the colon (e.g., `feat: add feature` not `feat: Add feature`)
- **MUST NOT** be sentence-case, Start-case, Pascal-case, or UPPER-CASE
- **MUST NOT** end with a period
- **MUST NOT** be empty
- Maximum length including type and scope: 100 characters

### 4. Body (Optional)

- Wrap lines at **120 characters maximum**
- Use bullet points with `-` for multiple changes
- Start each bullet with lowercase
- Explain what and why, not how

### 5. Footer (Optional)

- Use for breaking changes: `BREAKING CHANGE: description`
- Use for issue references: `Closes #123`

## Examples

### Good ✅

```
feat(auth): add JWT middleware

- added token validation logic
- included refresh token support
- configured expiration handling
```

```
fix(api): resolve authentication token expiration

Token refresh logic was not handling edge case where user session expired
during active request. Added proper session validation middleware.

Closes #456
```

```
chore: update dependencies to latest versions
```

### Bad ❌

```
feat: Add new feature           ❌ Subject is sentence-case (capital A)
Feat: add feature               ❌ Type must be lowercase
feat: add feature.              ❌ Subject ends with period
feat: this is a very long subject that exceeds one hundred characters  ❌ Header too long
feat: add feature

- This line is way too long and exceeds the maximum line length of 120 characters which will cause the commit to fail  ❌ Body line too long
```

## Quick Reference

| Rule                 | Value                                                                  |
| -------------------- | ---------------------------------------------------------------------- |
| Header max length    | 100 characters                                                         |
| Body line max length | 120 characters                                                         |
| Subject case         | lowercase only                                                         |
| Subject end          | no period                                                              |
| Allowed types        | build, chore, ci, docs, feat, fix, perf, refactor, revert, style, test |

## Tips for AI-Generated Messages

When generating commit messages:

1. Always start subject with lowercase letter after colon
2. Keep header under 100 chars (type + scope + colon + space + subject)
3. Wrap body bullets at 120 chars max
4. Use imperative mood: "add" not "added" or "adds"
5. Be concise but descriptive
