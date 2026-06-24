---
name: pi-delegate
description: "Delegate bounded coding subtasks to the local Pi coding agent CLI. Use when the user says /pi, slash pi, ask Pi, delegate to Pi, use Pi for this, have Pi investigate or implement, get a second pass from Pi, or when Codex needs a local agent worker after first defining clear expectations, tests, or acceptance criteria."
---

# Pi Delegate

Use the local `pi` CLI as a coding-agent worker while Codex remains the orchestrator. Pi may use its full toolset, including read, bash, edit, and write, so Codex must define the task carefully, inspect Pi's output and file changes, and decide the next step.

## Command

Prefer the local `pi` binary when it is installed. Before the first Pi run in a task, check:

```bash
command -v pi
```

If `pi` is available, use it directly. If it is not available, run the same Pi command through `npx -y --package @earendil-works/pi-coding-agent pi`.

Prefer non-interactive sync runs:

```bash
pi -p "<task brief>"
npx -y --package @earendil-works/pi-coding-agent pi -p "<task brief>"
```

When the user asks to use the preferred Pi model, pass it explicitly:

```bash
pi --model ocg/glm-5.2 -p "<task brief>"
npx -y --package @earendil-works/pi-coding-agent pi --model ocg/glm-5.2 -p "<task brief>"
```

This flag was verified locally: `pi --model ocg/glm-5.2 -p "Return exactly this text: PI_MODEL_FLAG_OK"` completed successfully and returned `PI_MODEL_FLAG_OK`.

For long-running collaboration, use a named or explicit session:

```bash
pi --name "<short task name>" "<initial task brief>"
pi --continue "<follow-up>"
pi --session-id "<stable-id>" "<follow-up>"
npx -y --package @earendil-works/pi-coding-agent pi --name "<short task name>" "<initial task brief>"
npx -y --package @earendil-works/pi-coding-agent pi --continue "<follow-up>"
npx -y --package @earendil-works/pi-coding-agent pi --session-id "<stable-id>" "<follow-up>"
```

If command usage is unclear, run `pi --help` or `npx -y --package @earendil-works/pi-coding-agent pi --help`, using the same local-vs-`npx` selection rule.

## When To Delegate

Delegate bounded subtasks with clear outputs, such as:

- investigate a likely cause in a module
- implement a narrow helper or small feature slice
- write or update tests for a specified behavior
- review a diff or design for risks
- summarize a subsystem before Codex edits it

Do not hand Pi broad ownership like "refactor the app" without first breaking the work into small tasks. Codex should create expectations before delegation: a compact task brief, acceptance criteria, verification commands, and, when useful, failing tests or OpenSpec artifacts.

## Workflow

1. Inspect context enough to write a grounded task brief.
2. Check `git status --short` before running Pi.
3. Check whether `pi` is installed with `command -v pi`; if not, use `npx -y --package @earendil-works/pi-coding-agent pi` for the delegated run.
4. Choose sync mode by default. Use a long-running session only when the work benefits from memory across multiple turns.
5. Run Pi from the relevant repo/worktree. Pi is allowed full tools.
6. Require Pi to end with the result format below.
7. After Pi returns, inspect stdout, `git status --short`, and relevant diffs.
8. Run verification commands when practical, or explain why they were not run.
9. Decide whether to keep iterating with Pi, patch the work directly, or report the result.

Codex must not treat Pi's edits as accepted just because Pi says they are done. Review first.

## Task Brief Format

Give Pi a compact brief. Include only the context it needs.

```text
You are the Pi coding agent working as a delegated local worker.

Goal:
<one bounded objective>

Context:
- Repo/worktree: <path>
- Relevant files: <paths>
- Important constraints: <style, APIs, ownership boundaries>

Acceptance criteria:
- <observable behavior>
- <tests/specs/commands that should pass>

Verification:
- Run: <command>
- If you cannot run it, explain why.

Output:
End your response with:
RESULT:
- Changed files:
- Commands run:
- Tests run:
- Findings:
- Risks / follow-ups:
```

## Sync Mode

Use sync mode for most delegated work:

```bash
pi -p "<task brief>"
npx -y --package @earendil-works/pi-coding-agent pi -p "<task brief>"
```

Keep sync tasks small enough that Codex can wait for completion and review the result. If the command runs too long, stop and reassess whether to continue as a session.

## Session Mode

Use session mode when Pi needs continuity:

- multi-step debugging where prior attempts matter
- larger implementation slices that need follow-up
- conversational review where Codex expects to send corrections

Name the session clearly and keep follow-ups precise. Codex should still inspect git status and diffs after each meaningful Pi step.

## Review Contract

After every Pi edit run, Codex must:

- compare pre-run and post-run `git status --short`
- inspect changed files and diffs
- verify acceptance criteria when practical
- note any commands/tests Pi ran
- call out risks or incomplete verification

If Pi changes unrelated files, produces unclear output, or fails verification, Codex should either issue a focused follow-up to Pi or repair the work directly.
