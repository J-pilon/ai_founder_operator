# Git Conventions

## Commit Policy

**Working tree changes should ONLY be committed if:**

1. **Explicitly requested**: The user asks to commit changes (e.g., "commit these changes", "make a commit")
2. **Explicitly approved**: The user approves committing changes for a specific feature development

## Default Behavior

- **DO NOT commit changes automatically** after completing feature work
- **DO stage changes** to show what was modified (`git add` is acceptable for review)
- **DO show git status** to let the user see what changed
- **ALWAYS wait for user approval** before running `git commit`

## Commit Message Format

**Required structure:**

```
<type>: <one line message>
```

### Rules

- Use the format exactly as shown above
- **NEVER add a commit trailer with "Co-authored-by: Cursor>"** or similar attribution lines
- Keep the message concise and on one line

### Examples

```
feat: add user authentication
fix: resolve database connection timeout
chore: update dependencies
docs: add API documentation
```

## Rationale

The user wants to maintain control over:
- When commits are made
- Commit message content and formatting
- Grouping of changes into logical commits
- Review of changes before they are committed

## Exceptions

None. Always ask or wait for explicit approval before committing.
