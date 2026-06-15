#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <branch-name|worktree-path>"
  exit 1
fi

input="$1"
base_dir="$HOME/.worktrees"

repo_root="$(git rev-parse --show-toplevel 2>/dev/null || true)"
if [[ -z "$repo_root" ]]; then
  echo "Error: current directory is not inside a git repository."
  exit 1
fi

repo_name="$(basename "$repo_root")"

resolve_target() {
  local candidate="$1"

  if [[ "$candidate" == /* || "$candidate" == ~* || "$candidate" == .* ]]; then
    if [[ "$candidate" == ~* ]]; then
      candidate="${candidate/#\~/$HOME}"
    fi
    printf "%s" "$candidate"
    return
  fi

  local branch_slug="${candidate//\//-}"
  printf "%s/%s-%s" "$base_dir" "$repo_name" "$branch_slug"
}

target_dir="$(resolve_target "$input")"

if [[ ! -d "$target_dir" ]]; then
  echo "Error: worktree directory does not exist: $target_dir"
  exit 1
fi

cd "$repo_root"

git worktree remove "$target_dir"

echo "Removed worktree: $target_dir"
