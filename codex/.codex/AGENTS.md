# Personal Preferences
- Never use the em dash and just use the plain dash instead.
- When writing commit messages, never auto add your agent name as a coauthor.
- Never manually modify CHANGELOG.md files or any files that are marked as auto-generated.
- When making technical decisions, do not give much weight to development cost. Instead prefer quality, simplicity, robustness, scalability and long term maintainability.
- If you need a paragraph-long comment to justify why the workaround is OK, the code is wrong — fix the code.
- Do not use subagents unless the user explicitly asks for it.
- Keep things simple. Channel "YAGNI" energy unless told otherwise.
- Don't be scared to propose bold ideas if they can meaningfully benefit our work.
- Be careful with destructive actions that are not explicitly requested by the user.
- Tests are good! Endless smoke tests, "regression tests" for feature deletions, etc, much less good. Tests should be focused, not slop.
- Comments are a great way to clarify functionality and how code is used. Don't comment every line, but feel free to describe (concisely) how functions, classes are used above function definitions, classes, etc. But comments should be minimal, concise and if something is evident from the name, do not comment for that. And add comments only where I told you, nowhere else.
- The code you write should target mergability, scalability, simplicity and readability. This does not mean you compromise with the goal but good code is simple, readable and scalable. 

## Git Naming Conventions
### Branches
Use lowercase kebab-case with a descriptive prefix:
```
feat/add-user-auth
fix/login-redirect
refactor/api-client
docs/update-readme
chore/upgrade-dependencies
```
Keep branch names short, specific, and related to one task.

### Commits
Use Conventional Commits:
```
<type>(optional-scope): <imperative description>

Examples:

feat(auth): add Google sign-in
fix(api): handle expired tokens
refactor(ui): simplify modal state
docs: update installation instructions
chore: upgrade dependencies
```
Use lowercase, write in the imperative mood, do not end with a period, and keep each commit focused on one logical change.

### Pull Requests
Use the same format as commit messages:
```
<type>(optional-scope): <clear summary>

Examples:

feat(auth): add Google sign-in
fix(api): prevent duplicate requests
refactor(ui): simplify modal handling
```
PR titles should summarize the complete change, not individual implementation steps. Keep them concise, use lowercase, and do not end with a period.
