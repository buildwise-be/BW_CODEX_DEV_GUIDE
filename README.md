# BW Codex Development Framework

Lightweight, repository-centric framework for Codex-assisted software
engineering in Buildwise repositories.

The framework installs a small set of AI governance files, GitHub templates,
Codex hooks, and starter project-memory templates into a target repository.

Git remains the single source of truth.

For the full operating model, read
[AI_DEVELOPMENT_GUIDE.md](src/docs/ai-governance/AI_DEVELOPMENT_GUIDE.md).
For a concise project overview, read [ABOUT.md](ABOUT.md).

## Core Model

The framework separates three responsibilities:

- AI governance: how Codex and developers should work.
- Operational project memory: human-maintained state, decisions, priorities,
  and known issues.
- Technical knowledge: generated `docs/wiki/` pages inferred from repository
  facts.

Core rule:

```text
Repository-inferred facts -> docs/wiki/
Human intent and operational knowledge -> docs/ai-context/
```

## Business App Starter

The `codex/business-app-starter` branch adds an autonomous `starter/` pilot for
Buildwise business applications. It is designed for colleagues who describe a
business mission in natural language while Codex handles the technical
translation, implementation, documentation, and quality checks.

The current repository remains the stable governance framework for specific
development projects. The starter is intentionally isolated so it can later
be published as the `bw-app-starter` GitHub Template.

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
.codex/framework.json
.codex/hooks.json
.codex/hooks/session_start.ps1
.github/ISSUE_TEMPLATE/codex-task.md
.github/pull_request_template.md
docs/ai-governance/
docs/ai-context/
docs/wiki/
```

## File Ownership

The manifest at `src/.codex/framework.json` defines every installed file.

Ownership classes:

- `Framework`: managed by this repository and updated by the installer.
- `Project`: created if missing, then owned by the target repository.
- `Generated`: optional wiki files created or refreshed from repository
  analysis.

Install modes:

- `managed`: compare hashes and update only when safe or forced.
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
Get-Content C:\path\to\target-repo\.codex\framework.json
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

## Migration from V1

Use the migration report before updating an existing V1 target:

```powershell
.\scripts\migration-report.ps1 -TargetPath C:\path\to\target-repo
```

V2 replaces `.codex/guide-version.json` with `.codex/framework.json`.

V2 also moves reusable workflow content from `docs/ai-context/` to
`docs/ai-governance/` and moves repository-inferred architecture facts to
`docs/wiki/`.

Do not automatically delete old project files. Review them and migrate useful
content deliberately.

## Codex Hook Trust

The installed payload includes optional Codex hook configuration under
`.codex/`.

Depending on the Codex environment, hooks may require explicit trust or
approval before they run. Review hook behavior before enabling it in a target
repository.

## License

This repository is licensed under the [MIT License](LICENSE).
