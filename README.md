# BW AI Development Framework

Lightweight, repository-centric framework for AI-assisted software
engineering in Buildwise repositories.

The framework installs a small set of AI governance files, GitHub templates,
entry points for Codex and Claude, optional Codex hooks, and starter
project-memory templates into a target repository.

Git remains the single source of truth.

For the full operating model, read
[AI_DEVELOPMENT_GUIDE.md](src/docs/ai-governance/AI_DEVELOPMENT_GUIDE.md).
For a concise project overview, read [ABOUT.md](ABOUT.md).
For assistant startup and switching, read
[ASSISTANT_SETUP.md](src/docs/ai-governance/ASSISTANT_SETUP.md).

## Core Model

The framework separates three responsibilities:

- AI governance: how assistants and developers should work.
- Operational project memory: human-maintained state, decisions, priorities,
  and known issues.
- Technical knowledge: generated `docs/wiki/` pages inferred from repository
  facts.

Core rule:

```text
Repository-inferred facts -> docs/wiki/
Human intent and operational knowledge -> docs/ai-context/
```

## Repository Layout

```text
src/                 framework-managed files copied into targets
templates/context/   project-owned starter memory files
templates/wiki/      optional generated wiki starter files
scripts/             install, validate, and migration report scripts
schema/              framework manifest schema
```

The installed target layout is:

```text
AGENTS.md
CLAUDE.md
.ai/framework.json
.codex/hooks.json
.codex/hooks/session_start.ps1
.github/ISSUE_TEMPLATE/codex-task.md
.github/pull_request_template.md
docs/ai-governance/
docs/ai-context/
docs/wiki/
```

## File Ownership

The manifest at `src/.ai/framework.json` defines every installed file.

Ownership classes:

- `Framework`: managed by this repository and updated by the installer.
- `Project`: created if missing, then owned by the target repository.
- `Generated`: optional wiki files created or refreshed from repository
  analysis.

Install modes:

- `managed`: identical content is unchanged; any different existing content
  is a conflict unless explicitly forced. The installer does not track a
  previous-version baseline or merge custom instructions automatically.
- `create-if-missing`: create starter files without overwriting existing ones.

## Adopt in a Target Repository

Run commands from this framework repository.

First inspect what would be copied:

```powershell
.\scripts\install.ps1 -TargetPath C:\path\to\target-repo -DryRun
```

Then install the framework:

```powershell
.\scripts\install.ps1 -TargetPath C:\path\to\target-repo
```

Install optional wiki starter files when the project is ready to maintain them:

```powershell
.\scripts\install.ps1 -TargetPath C:\path\to\target-repo -IncludeWiki
```

Validate the target repository:

```powershell
.\scripts\validate-target.ps1 -TargetPath C:\path\to\target-repo
```

Use the full profile when optional project memory should also be present:

```powershell
.\scripts\validate-target.ps1 -TargetPath C:\path\to\target-repo -Profile full
```

## Update Strategy

To detect the installed framework version in a target repository:

```powershell
Get-Content C:\path\to\target-repo\.ai\framework.json
```

Recommended update flow:

1. Commit and push the framework update in this repository.
2. Run `install.ps1 -DryRun` against the target repository.
3. Review every planned `create`, `update`, `preserve`, and `conflict`.
4. Run the real install for clean creates and unchanged managed files.
5. Use `-Force -Backup` only when intentionally overwriting managed files.
6. Run `validate-target.ps1`.
7. In the target repository, review `git diff` and commit the adopted changes.

The installer preserves project-owned and generated files by default.

## Migration from V1 or V2 to V3

Use the migration report before updating an existing target:

```powershell
.\scripts\migration-report.ps1 -TargetPath C:\path\to\target-repo
```

V3 (3.0.0) moves the V2 manifest from `.codex/framework.json` to
`.ai/framework.json`. The manifest schema remains version 2. The neutral file
is authoritative whenever it exists, even if invalid; validation does not
silently fall back to the old file. A V2-only target can still be validated
against its legacy manifest, with a migration warning.

The installer leaves old target files in place. Review conflicts in `AGENTS.md`,
`CLAUDE.md`, and other managed files; preserve custom instructions when merging.
Use `-Force -Backup` only after reviewing all managed-file replacements. Once
the migration is verified, the old manifest may be removed manually. Do not
maintain two active manifests or use an old installer on a migrated target.

Existing `CURRENT_STATE.md` files are never overwritten, including with
`-Force`. Add the `Session handoff` section from
[the template](templates/context/CURRENT_STATE.md) while preserving project
content. Assistants maintain the current state at meaningful milestones and
check it before their final response. Normal switching needs no preparation
command; the prepare/resume prompts are optional shortcuts for unfinished work.

V2 also moves reusable workflow content from `docs/ai-context/` to
`docs/ai-governance/` and moves repository-inferred architecture facts to
`docs/wiki/`.

Do not automatically delete old project files. Review them and migrate useful
content deliberately.

The old `codex-task.md` issue-template filename is retained to avoid duplicate
templates in existing repositories; its displayed content is tool-neutral.

## Validation and Tests

The validator checks required framework files and project-memory presence.
`-Profile full` also checks optional project memory; `-IncludeWiki` checks wiki
files. Optional integrations, including hooks, are not required in either
profile. Validation does not verify memory freshness or assistant behavior.

Run the regression suite in disposable Git repositories:

```powershell
.\tests\framework.Tests.ps1
```

See [verification notes](tests/VERIFICATION.md) for results and interactive
startup checks that still require an actual Claude session.

## Codex Hook Trust

The installed payload includes optional Codex hook configuration under
`.codex/`.

Depending on the Codex environment, hooks may require explicit trust or
approval before they run. Review hook behavior before enabling it in a target
repository.

## License

This repository is licensed under the [MIT License](LICENSE).
