---
name: design-adherence
description: "Post-implementation visual check that built UI follows the project's design spec (design-system MASTER.md, page overrides, or design tokens). Use after building or changing any screen, component, or style — before code review and before committing. Also use when the user reports UI 'doesn't look right', 'doesn't match our design', or 'looks generic'."
---

# Design Adherence

Verify the built UI against the design spec on the **rendered output**, not only the code. If a preview is possible, open the screen and check there (browser via the `agent-browser` skill; simulator via the device tools the harness provides). If no render is possible, state "no render available — findings are code-level only" once at the top of the report, then check the code. Do not label every single finding "unverified".

## Sources of truth (in order)

1. `design-system/<slug>/pages/<page>.md` (page override)
2. `design-system/<slug>/MASTER.md`
3. Project design tokens (`tailwind.config.*` theme, global CSS variables)

Skip with "no design spec" only when none of these exist. If the change touches UI and no spec exists, say so and recommend creating one (`ui-ux-pro-max`, with `--persist`) instead of reviewing against your own taste.

## Checks

1. **Colors** — every color in the change comes from spec tokens. Flag invented hex values.
2. **Typography** — families, weights, and the heading/body pairing match the spec. No substitutions.
3. **Spacing** — padding and gap values sit on the spec's spacing scale; no arbitrary values.
4. **Corners & elevation** — radius and shadow usage match the declared depth level.
5. **Dark mode** — only when the spec defines a dark mode: both themes checked; no state that works in one and breaks in the other.
6. **Icon discipline** — no emoji as structural icons; one stroke width per layer; one filled/outline style per hierarchy level.
7. **States** — hover/pressed/focus/disabled/loading/empty/error styled, not only the happy path.
8. **Avoid list** — if the spec lists anti-patterns, none are present.

## Report

A checklist of violations, each with file + line (code) or element (render). Fix every violation before handing over. When the spec and the built UI disagree and the UI is right, do not edit the code to match a bad spec: propose a spec update — the spec changes deliberately or not at all. Never re-run palette generation to "fix" a violation.
