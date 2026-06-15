#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <branch-name>"
  exit 1
fi

branch="$1"
base_dir="$HOME/.worktrees"

repo_root="$(git rev-parse --show-toplevel 2>/dev/null || true)"
if [[ -z "$repo_root" ]]; then
  echo "Error: current directory is not inside a git repository."
  exit 1
fi

repo_name="$(basename "$repo_root")"
branch_slug="${branch//\//-}"
target_dir="$base_dir/${repo_name}-${branch_slug}"

mkdir -p "$base_dir"

if [[ -e "$target_dir" ]]; then
  echo "Error: target directory already exists: $target_dir"
  exit 1
fi

cd "$repo_root"

if git show-ref --verify --quiet "refs/heads/$branch"; then
  git worktree add "$target_dir" "$branch"
elif git show-ref --verify --quiet "refs/remotes/origin/$branch"; then
  git worktree add -b "$branch" "$target_dir" "origin/$branch"
else
  git worktree add -b "$branch" "$target_dir"
fi

echo "Created worktree: $target_dir"
echo ""
echo "To switch to this worktree, run:"
echo "cd \"$target_dir\""
