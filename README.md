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

### Direct upgrade from 2.0.0 or 2.0.1

A project using framework **2.0.0 can upgrade directly to 3.0.0**. Installing
2.0.1 first is not required. The same procedure applies to 2.0.1. This upgrades
the AI instructions and supporting files, not the application's source code.

Use a checkout of this framework at version 3.0.0. Run the following commands
from its root, not from the target project. Replace the example path with the
existing project's path. Run each step separately and inspect its result before
continuing. Save any target-project changes first; the installer normally
refuses to write into a dirty Git working tree.

```powershell
# 1. Report legacy files and migration actions; no files are changed.
.\scripts\migration-report.ps1 -TargetPath "C:\path\to\target-repo"

# 2. Preview creates, preserves, and conflicts; no files are changed.
.\scripts\install.ps1 -TargetPath "C:\path\to\target-repo" -DryRun

# 3. Install only after reviewing the preview and resolving conflicts below.
.\scripts\install.ps1 -TargetPath "C:\path\to\target-repo"

# 4. Check required framework and project-memory files.
.\scripts\validate-target.ps1 -TargetPath "C:\path\to\target-repo"
```

### If the installer reports conflicts

Changed V2 governance files normally differ from V3 and can therefore appear
as conflicts even without project customizations. Any conflict stops the
installation **before any file is copied** (exit code 2, including in a dry run).
The scripts do not automatically merge old and new instructions.

Compare each conflicting target file with its V3 source under `src/`. Identify
project-specific rules that must survive. Either merge the V3 changes into the
target files manually, or deliberately replace the managed files with backups:

```powershell
# Preview the replacements and review ALL affected managed files first.
.\scripts\install.ps1 -TargetPath "C:\path\to\target-repo" -Force -Backup -DryRun

# Apply the reviewed replacements and save timestamped backups.
.\scripts\install.ps1 -TargetPath "C:\path\to\target-repo" -Force -Backup
```

`-Force` applies to all differing managed files, not just one selected conflict.
If using replacement, reapply the necessary project-specific rules from the
backups to the new files before resuming development. If manually merging,
install any remaining new files according to the manifest; the installer will
still flag intentionally customized managed files on subsequent runs.
Then run validation, review the target project's `git diff`, and commit the
reviewed migration in that project. Review backups before committing; they are
local recovery copies, not additional active instructions.

### What is preserved and what changes

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
`-Force`. The same applies to existing project-memory templates such as
`DECISIONS.md`, `KNOWN_ISSUES.md`, and `ROADMAP.md`: missing files are created,
existing files are preserved. Add the optional `Session handoff` section from
[the template](templates/context/CURRENT_STATE.md) while preserving project
content. Assistants maintain the current state at meaningful milestones and
check it before their final response. Normal switching needs no preparation
command; the prepare/resume prompts are optional shortcuts for unfinished work.
The install also supplies `CLAUDE.md` and the Cowork setup instructions. It does
not transfer conversations or configure accounts, permissions, or connectors.

Compatibility is based on the V2 manifest and layout; the existing automated
migration fixture is labeled 2.0.1, not a separate historical 2.0.0 checkout.
Always review the report and preview for the actual target project. See
[verification notes](tests/VERIFICATION.md) for the exact test coverage.

### Additional considerations for V1

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
