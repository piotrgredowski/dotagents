---
name: openspec
description: Use when the user wants spec-driven development with OpenSpec, OPSX slash-command style workflows, change proposals, delta specs, design artifacts, task plans, implementation from OpenSpec tasks, verification against artifacts, or archiving completed OpenSpec changes.
---

# OpenSpec

Use this skill to run an OpenSpec-style workflow in a repository. OpenSpec is a lightweight, brownfield-first spec layer: each change lives under `openspec/changes/<change-name>/` until it is implemented and archived, while `openspec/specs/` remains the source of truth for current system behavior.

## Core Posture

- Keep the workflow fluid. Artifacts guide the work; they are not rigid phase gates.
- Prefer one focused change per logical unit of work.
- Investigate the existing codebase before writing proposal, design, or tasks.
- Treat specs as behavior contracts, not implementation notes.
- Keep artifacts short enough to maintain and concrete enough to verify.
- Update artifacts when implementation discoveries change the plan.

## When Starting Work

1. Check whether the project already has `openspec/`, `openspec/config.yaml`, or `openspec/changes/`.
2. If OpenSpec is not initialized and the user wants a real OpenSpec project setup, run `openspec init` if the CLI is available. If it is missing, explain the install command and continue with a compatible manual folder layout if useful.
3. Choose a kebab-case change name such as `add-dark-mode`, `fix-login-redirect`, or `optimize-product-query`.
4. Create or update artifacts under `openspec/changes/<change-name>/`.

## Default Quick Path

Use this path when the user has a clear implementation request:

1. Propose: create planning artifacts for the change.
2. Apply: implement tasks, checking off completed items in `tasks.md`.
3. Verify: compare code against proposal, specs, design, and tasks.
4. Archive: sync delta specs into `openspec/specs/` and move the change to `openspec/changes/archive/YYYY-MM-DD-<change-name>/`.

## Expanded Path

Use this path when requirements are unclear, complex, or need review between artifacts:

1. Explore: investigate and compare options without creating artifacts yet.
2. New: create the change scaffold.
3. Continue: create the next ready artifact from dependencies.
4. Fast-forward: create all planning artifacts when scope is clear.
5. Apply, verify, then archive.

## Artifact Shape

For the default `spec-driven` schema, expect:

```text
openspec/changes/<change-name>/
├── proposal.md
├── specs/
│   └── <area>/spec.md
├── design.md
└── tasks.md
```

Write delta specs using requirement sections such as `ADDED`, `MODIFIED`, `REMOVED`, or `RENAMED`. Each requirement should include scenarios that are testable or inspectable.

## Implementation Rules

- Before implementing, read `tasks.md`, relevant delta specs, `design.md`, and any existing main specs in `openspec/specs/`.
- Work through tasks in order unless a dependency or codebase discovery requires reordering.
- Mark tasks complete by changing `[ ]` to `[x]` only after the code and relevant checks are done.
- If the implementation intentionally differs from the design or specs, update the artifact rather than leaving drift.
- Before archiving, verify completeness, correctness, and coherence.

## References

Read `references/openspec-workflow.md` when you need exact command semantics, archive/sync behavior, artifact guidance, or troubleshooting notes.
