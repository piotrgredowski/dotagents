---
name: implement
description: "Implement a piece of work based on a spec or set of tickets."
disable-model-invocation: true
---

Implement the work described by the user in the spec or tickets.

Use /tdd where possible, at pre-agreed seams.

If the task touches UI: read the design truth first — the ticket's "Design:" line points at it (`design-system/*/MASTER.md` plus the page override), else the project's design tokens. Treat it as brand: never invent new colors, fonts, or spacing scales. If no design spec and no recorded decision exists, ask the user once and record the answer (e.g. in CONTEXT.md: "design: existing tokens only") so later tickets do not ask again; in an unattended run, do not stop — flag the gap in the output.

After UI work, run design-adherence before /code-review.

Run typechecking regularly, single test files regularly, and the full test suite once at the end.

Once done, use /code-review to review the work.

Commit your work to the current branch.
