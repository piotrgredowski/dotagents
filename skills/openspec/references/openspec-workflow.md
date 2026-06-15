# OpenSpec Workflow Reference

Source basis: Fission-AI/OpenSpec main branch documentation viewed May 4, 2026.

## CLI Setup

OpenSpec requires Node.js 20.19.0 or newer.

```bash
npm install -g @fission-ai/openspec@latest
cd your-project
openspec init
```

Refresh generated agent instructions inside a project:

```bash
openspec update
```

Enable expanded workflow commands:

```bash
openspec config profile
openspec update
```

Useful inspection commands:

```bash
openspec list
openspec status --change <change-name>
openspec schemas
```

## OPSX Command Map

Default `core` profile:

| Command | Purpose |
| --- | --- |
| `/opsx:propose` | Create a change and planning artifacts in one step |
| `/opsx:explore` | Investigate ideas before committing to a change |
| `/opsx:apply` | Implement tasks from the change |
| `/opsx:sync` | Merge delta specs into main specs |
| `/opsx:archive` | Archive a completed change |

Expanded workflow:

| Command | Purpose |
| --- | --- |
| `/opsx:new` | Start a change scaffold |
| `/opsx:continue` | Create the next ready artifact based on dependencies |
| `/opsx:ff` | Fast-forward through all planning artifacts |
| `/opsx:verify` | Validate implementation against artifacts |
| `/opsx:bulk-archive` | Archive multiple completed changes and resolve spec conflicts |
| `/opsx:onboard` | Guided tutorial using the actual codebase |

Tool syntax varies. Claude Code uses `/opsx:propose`; Cursor, Windsurf, and Copilot-style integrations may use `/opsx-propose`; skill-based tools may expose names like `/skill:openspec-propose`.

## Common Patterns

Quick feature or bug fix:

```text
/opsx:propose -> /opsx:apply -> /opsx:sync -> /opsx:archive
```

Expanded clear-scope flow:

```text
/opsx:new -> /opsx:ff -> /opsx:apply -> /opsx:verify -> /opsx:archive
```

Exploratory flow:

```text
/opsx:explore -> /opsx:new -> /opsx:continue -> /opsx:apply
```

Completion flow:

```text
/opsx:apply -> /opsx:verify -> /opsx:archive
```

## Artifact Guidance

`proposal.md`:
- Explain why the change exists.
- State what changes and what does not.
- Keep scope tight.

`specs/<area>/spec.md`:
- Describe behavior deltas.
- Use `ADDED`, `MODIFIED`, `REMOVED`, or `RENAMED` sections.
- Include concrete scenarios for each requirement.

`design.md`:
- Capture technical approach, affected modules, tradeoffs, migrations, and risk.
- Keep it synchronized with implementation discoveries.

`tasks.md`:
- Use checkboxes.
- Split work into verifiable tasks.
- Include tests or validation tasks when behavior changes.

## Verify Checklist

Completeness:
- All tasks are checked only when done.
- Requirements have implementation evidence.
- Scenarios are covered by tests or manual verification.

Correctness:
- Code matches spec intent.
- Edge cases and errors from scenarios are handled.
- User-facing behavior matches the proposal.

Coherence:
- Implementation follows the design or the design has been updated.
- Names, modules, and patterns fit the codebase.
- Specs and code have not drifted.

## Archive Behavior

Archiving should:

1. Check required artifacts exist.
2. Warn if tasks are incomplete.
3. Prompt or decide whether to sync delta specs into `openspec/specs/`.
4. Move the change to `openspec/changes/archive/YYYY-MM-DD-<change-name>/`.
5. Preserve artifacts as an audit trail.

For multiple completed changes, archive in chronological order and inspect implementation to resolve conflicting spec deltas.

## Troubleshooting

Change not found:
- Specify the change name.
- Check `openspec list`.
- Confirm the current directory is the intended project.

No artifacts ready:
- Run `openspec status --change <change-name>`.
- Check for missing dependency artifacts.

Schema not found:
- Run `openspec schemas`.
- Check spelling or initialize the schema if custom.

Commands not recognized:
- Ensure `openspec init` has run.
- Run `openspec update`.
- Restart the AI tool if command files are generated but not picked up.

Artifacts are incomplete:
- Add project context to `openspec/config.yaml`.
- Add more detail to the change request.
- Prefer `/opsx:continue` over `/opsx:ff` for review-heavy work.
