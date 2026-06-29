Use extremely concise language and sacrifice grammar for the sake of concision.
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
