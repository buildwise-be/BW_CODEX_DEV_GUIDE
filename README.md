# BW Codex Dev Guide

This repository centralizes the files that define how Codex should work in development repositories.

The goal is simple: version a single source of best practices, then integrate these files into every application repository that should follow the same workflow.

## Structure

```text
/
|-- src/                         Files to install in target repositories
|   |-- AGENTS.md                Working rules read by Codex
|   |-- .github/                 Issue and Pull Request templates
|   |-- .codex/hooks.json        Codex startup hook
|   |-- .codex/hooks/            Scripts executed by hooks
|   `-- docs/ai-context/         Guide and project memory for Codex
`-- scripts/install.ps1          Integration script for a target repository
```

`src/` is the canonical payload. Any change intended for development repositories should be made in `src/`, then propagated to target repositories.

## Install in a Target Repository

From this repository:

```powershell
.\scripts\install.ps1 -TargetPath C:\path\to\target-repo -DryRun
.\scripts\install.ps1 -TargetPath C:\path\to\target-repo
```

By default, the script refuses to overwrite a different target file. To intentionally update existing files:

```powershell
.\scripts\install.ps1 -TargetPath C:\path\to\target-repo -Force
```

## After Integration

In the target repository, Codex should then initialize or update the project-specific context files:

- `docs/ai-context/PROMPTS.md`
- `docs/ai-context/CURRENT_STATE.md`
- `docs/ai-context/ARCHITECTURE.md`
- `docs/ai-context/DECISIONS.md`
- `docs/ai-context/KNOWN_ISSUES.md`
- `docs/ai-context/CHANGELOG_AI.md`

These files are intentionally project-specific. The shared guide is versioned here, but the concrete project memory must live in the application repository.

## Recommended Workflow

1. Modify shared files in `src/`.
2. Review the expected impact in target repositories.
3. Commit the new version of this repository.
4. Install or update target repositories with `scripts/install.ps1`.
5. In each target repository, review the `git diff`, adapt the project context, then commit.

The principle to keep in mind: Codex can be temporary, but rules, decisions, and context must remain in Git.
