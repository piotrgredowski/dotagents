---
name: worktree-create
description: Create a new git worktree for the current repository under ~/.worktrees.
user-invocable: true
---

# Worktree Create

Use this skill to create a new git worktree for the repository in the current working directory.

## Default location

- Base directory: `~/.worktrees`
- Worktree directory name: `<repo-name>-<branch-name>`

## Behavior

1. Verify current directory is inside a git repository.
2. Determine repository root and repository name.
3. Normalize branch name for folder usage (`/` -> `-`).
4. Create worktree at:
   - `~/.worktrees/<repo-name>-<normalized-branch-name>`
5. If local branch exists, attach worktree to it.
6. If local branch does not exist:
   - if `origin/<branch>` exists, create local tracking branch
   - otherwise create a new local branch from current `HEAD`

## Commands

```bash
# Create worktree
~/.agents/skills/worktree-create/create-worktree.sh <branch-name>

# List worktrees for current repository
~/.agents/skills/worktree-create/list-worktrees.sh

# Remove worktree by branch name (mapped to ~/.worktrees/<repo>-<branch-slug>)
~/.agents/skills/worktree-create/remove-worktree.sh <branch-name>

# Remove worktree by explicit path
~/.agents/skills/worktree-create/remove-worktree.sh /full/path/to/worktree
```

## Examples

```bash
# Create worktree for a new feature branch
~/.agents/skills/worktree-create/create-worktree.sh feat/login-flow

# Create worktree for an existing remote branch
~/.agents/skills/worktree-create/create-worktree.sh fix/api-timeout
```

## Notes

- This skill is repository-agnostic and always uses the current repo.
- It will create `~/.worktrees` if it does not exist.
- It fails if the target worktree directory already exists.

## Agent Instructions

When a user asks to create a worktree for an issue or feature, you must strictly follow these steps:
1. Figure out a good, concise branch name based on the user's description.
2. Create the worktree using the `create-worktree.sh` script.
3. Update your context to ensure that all subsequent work in this session uses the newly created worktree directory.
4. **DO NOT start working on the issue itself.** Only create the worktree, acknowledge that the context is set for the upcoming work, and propose a command for the user to `cd` into the new worktree directory.
