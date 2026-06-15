#!/usr/bin/env bash
set -euo pipefail

repo_root="$(git rev-parse --show-toplevel 2>/dev/null || true)"
if [[ -z "$repo_root" ]]; then
  echo "Error: current directory is not inside a git repository."
  exit 1
fi

cd "$repo_root"
git worktree list
