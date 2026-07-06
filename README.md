# BW Codex Dev Guide

Reusable governance layer for Codex-assisted development in Buildwise
repositories.

This repository contains the shared Codex bootstrap file, full workflow guide,
GitHub templates, hooks, scripts, and starter AI-context templates used to make
Codex work consistently across repositories.

For the full rationale and operating model, read
[AI_DEVELOPMENT_GUIDE.md](src/docs/ai-context/AI_DEVELOPMENT_GUIDE.md).
For a concise project overview, read [ABOUT.md](ABOUT.md).

## Core Model

- `AGENTS.md` is the bootstrap file Codex should read first in target
  repositories.
- `docs/ai-context/AI_DEVELOPMENT_GUIDE.md` is the full guide.
- GitHub Issues define focused missions.
- Pull Requests provide the durable handoff.
- Project-specific memory lives in each target repository, not in this source
  repository.

## Adopt in a Target Repository

Run commands from this repository.

First inspect what would be copied:

```powershell
.\scripts\install.ps1 -TargetPath C:\path\to\target-repo -DryRun
```

Then install the guide:

```powershell
.\scripts\install.ps1 -TargetPath C:\path\to\target-repo
```

Validate the target repository:

```powershell
.\scripts\validate-target.ps1 -TargetPath C:\path\to\target-repo
```

The installer also creates missing starter AI-context files from
`templates/ai-context/`. Existing project context files are preserved and must
be maintained from target repository facts.

The installer refuses to overwrite changed target files unless `-Force` is
used. When forcing updates, add `-Backup` if you want timestamped `.bak` copies
beside overwritten files.

## Update Strategy

To detect the installed guide version in a target repository:

```powershell
Get-Content C:\path\to\target-repo\.codex\guide-version.json
```

Files managed by this repository are copied from `src/`:

- `AGENTS.md`
- `.codex/guide-version.json`
- `.codex/hooks.json`
- `.codex/hooks/session_start.ps1`
- `.github/ISSUE_TEMPLATE/codex-task.md`
- `.github/pull_request_template.md`
- `docs/ai-context/AI_DEVELOPMENT_GUIDE.md`

Update an already-installed repository like this:

1. Commit and push the guide update in this repository.
2. Run `install.ps1 -DryRun` against the target repository.
3. Review every planned `create`, `update`, and `conflict`.
4. Use the real install for clean creates and unchanged managed files.
5. Use `-Force -Backup` only when you intentionally accept overwriting managed
   files with the latest guide version.
6. Run `validate-target.ps1`.
7. In the target repository, review `git diff` and commit the adopted changes.

Preserve target-repository edits when a file contains project-specific
decisions, local policy, or hand-written project memory. In that case, merge
the guide update manually instead of overwriting it.

## Project-Specific Files

The installer creates missing project-memory files from
`templates/ai-context/`, but it never overwrites existing ones.

Files such as `CURRENT_STATE.md`, `ARCHITECTURE.md`, `DECISIONS.md`,
`KNOWN_ISSUES.md`, `PROMPTS.md`, and `CHANGELOG_AI.md` must be initialized from
facts observed in the target repository.

These files should remain project-specific and should not be overwritten from
this repository during routine guide updates.

Use the installed starter templates as a first draft only.

## Codex Hook Trust

The installed payload includes Codex hook configuration under `.codex/`.
Depending on the Codex environment, hooks may require explicit trust or approval
before they run.

Review hook behavior before enabling it in a target repository.

## License

This repository is licensed under the [MIT License](LICENSE).
