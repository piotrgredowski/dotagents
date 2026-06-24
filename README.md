# dotagents

A collection of **skills** (capabilities) for coding agents — such as [Pi](https://pi.dev), Codex, OpenCode, and others. The repository acts as a personal, shared catalog of skills: some hand-written, some synced from external sources on GitHub.

## What's in here

- `skills/` — the skills themselves. Each is a folder with a `SKILL.md` file (and optionally extra notes, e.g. `tests.md`, `mocking.md`). Examples:
  - `tdd` — test-driven development (red-green-refactor),
  - `diagnosing-bugs` — a diagnosis loop for hard bugs,
  - `oracle` — a second model acting as reviewer,
  - `grilling` — relentless interviews to stress-test plans/designs,
  - `pi-delegate` — delegating bounded subtasks to the local Pi agent.
- `.skill-lock.json` — a lockfile describing which skills come from which repositories and at which version. This file drives the automatic sync.
- `.github/workflows/update-skills.yml` — a GitHub Actions workflow (daily) running `skills update`, which refreshes skills per the lockfile and opens a PR with the diff.
- `knowledge/` and `knowledge-sources/` — local knowledge stores (gitignored, never committed).

## How it works

1. Skills are described in `.skill-lock.json` with `source`, `sourceType`, and a folder hash.
2. The workflow runs `npx skills update -g -y`, fetches fresh versions from upstream, and updates `skills/` and the lockfile.
3. A pull request (`update-skills`) shows what changed and lets you review it.
4. Custom skills are added manually to `skills/` (without a lockfile entry — those are not overwritten by automation).

## Quick start

```bash
# update skills manually (locally)
npx skills update -g -y
```

## Conventions

- Write skills following `skills/writing-great-skills/`.
- Commit messages follow `docs(skills): ...`, `feat(skills): ...`, `chore(skills): ...` (see `git log`).

## License

Personal collection; individual skills may carry their own licenses depending on their upstream source.