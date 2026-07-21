#!/usr/bin/env bash

# Update skills in an isolated copy, then replace the tracked files only after a
# successful update. This script is safe to run both locally and in CI.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
skills_dir="$repo_root/skills"
lockfile="$repo_root/.skill-lock.json"
staging_dir="$(mktemp -d "$repo_root/.skills-update-tmp.XXXXXX")"
staging_home="$staging_dir/home"
staging_agents="$staging_home/.agents"
staging_skills="$staging_agents/skills"
staging_lockfile="$staging_agents/.skill-lock.json"
update_log="$staging_dir/update.log"
backup_skills=""
backup_lockfile=""
new_lockfile="$repo_root/.skill-lock.json.new"
completed=0

cleanup() {
  local exit_code=$?

  rm -f "$new_lockfile"

  if [[ $completed -eq 0 && -n "$backup_skills" && -d "$backup_skills" ]]; then
    rm -rf "$skills_dir"
    mv "$backup_skills" "$skills_dir"
  fi

  if [[ $completed -eq 0 && -n "$backup_lockfile" && -f "$backup_lockfile" ]]; then
    rm -f "$lockfile"
    mv "$backup_lockfile" "$lockfile"
  fi

  rm -rf "$staging_dir"
  exit "$exit_code"
}
trap cleanup EXIT

if [[ ! -d "$skills_dir" || ! -f "$lockfile" ]]; then
  echo "Expected $skills_dir and $lockfile to exist." >&2
  exit 1
fi

mkdir -p "$staging_agents"
cp "$lockfile" "$staging_lockfile"
cp -R "$skills_dir" "$staging_skills"

echo "Updating skills from $lockfile..."
set +e
HOME="$staging_home" npx -y skills update -g -y 2>&1 | tee "$update_log"
update_status=${PIPESTATUS[0]}
set -e

if [[ $update_status -ne 0 ]]; then
  echo "skills update exited with status $update_status; no repository files were changed." >&2
  exit "$update_status"
fi

if grep -E "Failed to fetch tree|✗ Failed" "$update_log"; then
  echo "skills update reported source fetch failures; no repository files were changed." >&2
  exit 1
fi

if [[ ! -d "$staging_skills" || ! -f "$staging_lockfile" ]]; then
  echo "skills update did not produce the expected skills directory and lockfile." >&2
  exit 1
fi

# Keep the replacement on the repository filesystem so directory moves are atomic.
backup_skills="$staging_dir/skills-backup"
backup_lockfile="$staging_dir/.skill-lock.json.backup"
cp "$staging_lockfile" "$new_lockfile"
mv "$lockfile" "$backup_lockfile"
mv "$new_lockfile" "$lockfile"
mv "$skills_dir" "$backup_skills"
mv "$staging_skills" "$skills_dir"
rm -rf "$backup_skills"
backup_skills=""
rm -f "$backup_lockfile"
backup_lockfile=""
completed=1

echo "Skills updated successfully."
