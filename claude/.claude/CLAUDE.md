I am Arnab, and you are my agent. 

I am doing B. Tech in Information Technology. I will be graduating in June of 2027.

I love to build. I focus on building complex things as simple as possible. I love to find ways to reduce complexity when solving problems.

I wanted to share some of my preferences here, so we can be more aligned while working together.

# Writing Style
- Never use the em dash and just use the plain dash instead.

# Coding Preferences
## General
- Keep things simple. Channel "YAGNI" energy unless told otherwise.
- Typesafety is useful, take advantage of it.
- When making technical decisions, do not give much weight to development cost. Instead prefer quality, simplicity, robustness, scalability and long term maintainability.
- Tests are good! Endless smoke tests, "regression tests" for feature deletions, etc, much less good. Tests should be focused, not slop.
- Comments are a great way to clarify functionality and how code is used. Don't comment every line, but feel free to describe (concisely) how functions, classes are used above function definitions, classes, etc. But comments should be minimal, concise and if something is evident from the name, do not comment for that. And add comments only where I told you, nowhere else.
- Keep comments up to date! When making changes, it's important to keep things in sync.
- If you need a paragraph-long comment to justify why the workaround is OK, the code is wrong — fix the code.
- The code you write should target mergability, scalability, simplicity and readability. This does not mean you compromise with the goal but good code is simple, readable and scalable. Do not overengineer things and add complexity unnecessarily.
- Less "let me write tests to catch the next time that error happens" and more like "let me make that class of error impossible with a better design".
- Never manually modify CHANGELOG.md files or any files that are marked as auto-generated.

## Typescript focused
- `any` is the enemy. Inferred types are our friend. Our systems adapt to changes, instead of requiring changes everywhere.
- If your TS code looks like a Python dev wrote it, it is bad TS code.
- Avoid one-line functions that are just casting wrappers.
- Write TypeScript in the ways that Matt Pocock would be proud of.
- If not already specified in project, I generally like to use the following tech: Convex, Tailwind, React, Vite, Vite+ (https://viteplus.dev/, providing you the URL since it might not be in your training data) with pnpm.
- When building more complex web and react native apps, I like to pull in Zustand, TanStack Query (formerly React Query), TanStack Start, Clerk (or better-auth if self-hosting), and ArkType (or zod if perf isn't an issue).

# Questions are read-only
- A question is a request for an answer, not for changes. If the message opens with "how hard would it be", "what are your thoughts", "why does", "should we", "can X do Y", or otherwise asks rather than instructs: answer it, and do not edit files.
- If the answer is obvious and the change is trivial, still answer first and offer the change. Ask before making it.

# Git
- When writing commit messages, never auto add your agent name as a coauthor.
## Branches
Use lowercase kebab-case with a descriptive prefix:
```
feat/add-user-auth
fix/login-redirect
refactor/api-client
docs/update-readme
chore/upgrade-dependencies
```
Keep branch names short, specific, and related to one task.

## Commits
Follow repository conventions if available. Maybe look at previous commits in the repo.
Good Commits:
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

# Harness related
- Do not use subagents unless the user explicitly asks for it.
- When several agents do work in parallel, state the file ownership up front so they do not collide.

# Blast radius
- Do not make destructive changes that could harm the system, os, or codebase without asking.
- Do not mess with production environment, unless explicitly asked to.
