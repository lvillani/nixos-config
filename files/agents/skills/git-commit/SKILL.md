---
name: git-commit
description: Read this skill before making git commits.
---

## Commit Style Detection

Before committing, check if the repository already uses Conventional Commits:

1. Run `git log -n 50 --pretty=format:%s` to inspect recent commit subjects.
2. If the history follows the Conventional Commits format (`type(scope): summary`), use
   Conventional Commits.
3. If not, analyze the existing commit style and replicate it. Match casing,
   punctuation, prefix conventions, and typical message length.

## Conventional Commits Format

Reference: https://www.conventionalcommits.org/en/v1.0.0/

```
<type>[optional scope][!]: <description>

[optional body]

[optional footer(s)]
```

### Types

| Type       | Use for                                                 |
| ---------- | ------------------------------------------------------- |
| `feat`     | New feature (correlates with SemVer MINOR)              |
| `fix`      | Bug fix (correlates with SemVer PATCH)                  |
| `docs`     | Documentation only                                      |
| `style`    | Formatting, missing semicolons, etc. (no logic change)  |
| `refactor` | Code change that neither fixes a bug nor adds a feature |
| `perf`     | Performance improvement                                 |
| `test`     | Adding or updating tests                                |
| `build`    | Build system or external dependencies                   |
| `ci`       | CI configuration and scripts                            |
| `chore`    | Maintenance tasks not covered by other types            |
| `revert`   | Reverts a previous commit                               |

### Scope

Optional. A noun describing the affected section of the codebase, enclosed in
parentheses. Choose scope based on the primary module, component, or area being changed.
Use existing scopes from the repo's history when possible.

### Breaking Changes

Append `!` after the type/scope to signal a breaking change. Optionally include a
`BREAKING CHANGE:` footer with details.

## Examples

```
feat: add user authentication
```

```
fix(parser): handle empty input without crashing
```

```
feat(api)!: change response format for /users endpoint

BREAKING CHANGE: the /users endpoint now returns { data: [...] } instead of [...]
```

```
docs: update README with installation instructions
```

```
refactor(db): extract query builder into separate module
```

```
perf: reduce render time by memoizing expensive computations
```

```
chore: update dependencies
```

```
test(auth): add integration tests for OAuth flow
```

```
ci: add GitHub Actions workflow for release automation
```

```
fix: prevent racing of requests

Introduce a request id and a reference to latest request. Dismiss
incoming responses other than from latest request.

Refs: #123
```

```
revert: let us never again speak of the noodle incident

Refs: 676104e, a215868
```

## Steps

1. Review `git status` and `git diff` to understand the current changes.
2. Detect commit style (conventional vs. existing repo style) as described above.
3. If the user specified file paths/globs, only stage those files. Otherwise, stage all
   changed files.
4. If there are ambiguous or unrelated changes, ask the user before committing.
5. Compose the commit message following the detected style.
6. Commit with `git commit -m "<subject>"`. Add `-m "<body>"` if a body is warranted.
7. Do NOT push unless explicitly asked.

## Notes

- Subject line should be <= 72 characters. Lowercase after the type prefix. No trailing
  period.
- Body is optional. Use it when the _what_ and _why_ need more context than the subject
  conveys.
- Do NOT add `Signed-off-by` or other trailers unless the repo convention requires them.
- Treat user-provided arguments as guidance: freeform text influences the message, file
  paths limit which files to stage.
