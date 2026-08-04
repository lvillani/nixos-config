---
name: git-commit
description: Read this before you make a git commit.
---

# Purpose

This guide tells you how to write good git commit messages. It also tells you
how to match the style the repo already uses.

# Check the repo's commit style first

Before you write a commit, look at how the repo writes its commits.

1. Run `git log -n 25 --pretty=format:%s`.
2. Read the subjects of the last 25 commits.
3. If they use Conventional Commits, use that style.
4. If they do not, copy the style you see. Match the casing, the punctuation,
   the prefix, and the usual message length.

# Conventional Commits

This is the format:

```
<type>[optional scope][optional !]: <description>

[optional body]

[optional footer(s)]
```

More info: https://www.conventionalcommits.org/en/v1.0.0/

## Types

| Type       | Use                                                   |
| ---------- | ----------------------------------------------------- |
| `feat`     | Add a new feature.                                    |
| `fix`      | Fix a bug.                                            |
| `docs`     | Change documentation only.                            |
| `style`    | Change formatting only. No logic changes.             |
| `refactor` | Change code without fixing a bug or adding a feature. |
| `perf`     | Make things faster or use fewer resources.            |
| `test`     | Add or update tests.                                  |
| `build`    | Change the build system or outside dependencies.      |
| `ci`       | Change CI setup or scripts.                           |
| `chore`    | Do maintenance that no other type covers.             |
| `revert`   | Undo a previous commit.                               |

## Scope

The scope is optional. It is a short word that names the part of the code you
changed. Put it in parentheses. Use a scope the repo already uses when you can.

## Breaking changes

Add `!` after the type or scope to show a breaking change. You can add a
`BREAKING CHANGE:` footer with more detail.

# How to make a commit

1. Run `git status` and `git diff` to see what changed.
2. Check the commit style. See "Check the repo's commit style first" above.
3. If you were given file paths or globs, stage only those files. Otherwise,
   stage all the changed files.
4. If some changes are unclear or unrelated, ask the user before committing.
5. Write the message in the style you found.
6. Commit with `git commit -m "<subject>"`. Add `-m "<body>"` if the subject is
   not enough.
7. Do not push unless the user asks.

# Style notes

- Keep the subject and body to 72 characters or less.
- Use lowercase after the type prefix.
- Do not end the subject with a period.
- Use the body only when you need to explain what and why. Keep it short.
- Do not add `Signed-off-by` or other trailers unless the repo requires them.
- Treat what the user says as guidance. Their text shapes the message, and their
  file paths limit what you stage.
