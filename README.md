# BW Codex Dev Guide

This repository version-controls a reusable governance layer for Codex-assisted development.

It is not application code. It contains the shared instructions, hooks, templates, and documentation that make Codex work consistently across multiple repositories, branches, machines, and conversations.

See [ABOUT.md](ABOUT.md) for a concise project overview.

The core principle is:

```text
Codex is temporary.
Git is the durable project memory.
```

## Guiding Model

This repository follows a small bootstrap plus full manual model:

- `AGENTS.md` is the short operational entry point for Codex.
- `docs/ai-context/AI_DEVELOPMENT_GUIDE.md` is the full workflow manual.
- GitHub Issues define focused missions.
- Pull Requests are the review and handoff checkpoint.
- `docs/ai-context/` stores project-specific memory.
- Repeated feedback should become a rule, document, template, or check.

The workflow should not depend on someone remembering the right prompt at the start of every session. The repository must carry enough context for a new Codex thread to reconstruct how to work.

## Why Not One Big File

A single long guide is easy to maintain, but it is not enough on its own.

Codex needs a short, predictable bootstrap file at the repository root. That file should tell Codex what to read, what gates to respect, and when to stop for approval. Longer explanations belong in referenced Markdown files under `docs/ai-context/`.

This keeps the high-priority instructions small while still preserving the complete workflow in Git.

In this model:

```text
/
|-- AGENTS.md                         Short bootstrap, operational rules
`-- docs/
    `-- ai-context/
        `-- AI_DEVELOPMENT_GUIDE.md   Full manual, rationale, prompts, patterns
```

When a target repository matures, Codex can also maintain the fuller project memory set:

```text
/
|-- AGENTS.md
|-- .github/
|   |-- ISSUE_TEMPLATE/
|   |   `-- codex-task.md
|   `-- pull_request_template.md
`-- docs/
    `-- ai-context/
        |-- AI_DEVELOPMENT_GUIDE.md
        |-- PROMPTS.md
        |-- CURRENT_STATE.md
        |-- ARCHITECTURE.md
        |-- DECISIONS.md
        |-- KNOWN_ISSUES.md
        `-- CHANGELOG_AI.md
```

## Repository Structure

```text
/
|-- README.md                    This repository guide
|-- scripts/
|   |-- install.ps1              Integration script for target repositories
|   `-- validate-target.ps1      Readiness check for target repositories
|-- templates/
|   `-- ai-context/              Starter templates for project-specific memory
`-- src/                         Canonical payload installed into target repositories
    |-- AGENTS.md                Working rules read by Codex
    |-- .codex/
    |   |-- guide-version.json   Installed payload version metadata
    |   |-- hooks.json           Codex startup hook configuration
    |   `-- hooks/
    |       `-- session_start.ps1
    |-- .github/
    |   |-- ISSUE_TEMPLATE/
    |   |   `-- codex-task.md
    |   `-- pull_request_template.md
    `-- docs/
        `-- ai-context/
            `-- AI_DEVELOPMENT_GUIDE.md
```

`src/` is the canonical payload. Any change intended for development repositories should be made in `src/`, then propagated to target repositories.

## What Gets Installed

The installer copies the shared payload into a target repository:

- `AGENTS.md`, the mandatory bootstrap file.
- `.codex/guide-version.json`, the installed guide version metadata.
- `.codex/hooks.json`, the Codex hook configuration.
- `.codex/hooks/session_start.ps1`, the startup context checker.
- `.github/ISSUE_TEMPLATE/codex-task.md`, the Codex task template.
- `.github/pull_request_template.md`, the PR handoff template.
- `docs/ai-context/AI_DEVELOPMENT_GUIDE.md`, the full AI development workflow.

The installer does not invent project-specific context. Files such as `CURRENT_STATE.md`, `ARCHITECTURE.md`, and `DECISIONS.md` must be initialized from facts in each target repository. Starter templates are available under `templates/ai-context/`, but they are not copied as part of the default payload.

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

Use `-DryRun` first when updating an existing repository. The installer also refuses to install into a dirty Git working tree unless `-AllowDirtyTarget` is used. When overwriting with `-Force`, add `-Backup` to create timestamped `.bak` copies beside overwritten files.

## Validate a Target Repository

Use the validator to check whether a repository has the required Codex payload and project context files:

```powershell
.\scripts\validate-target.ps1 -TargetPath C:\path\to\target-repo
```

The validator does not modify files. It exits with `0` when the target is Codex-ready and `1` when required files are missing or invalid.

## After Integration

In the target repository, Codex should initialize or update the project-specific context files when they are missing:

- `docs/ai-context/PROMPTS.md`
- `docs/ai-context/CURRENT_STATE.md`
- `docs/ai-context/ARCHITECTURE.md`
- `docs/ai-context/DECISIONS.md`
- `docs/ai-context/KNOWN_ISSUES.md`
- `docs/ai-context/CHANGELOG_AI.md`

These files are intentionally project-specific. The shared guide is versioned here, but the concrete project memory must live in the application repository.

Use the starter templates in `templates/ai-context/` as a first draft only. Replace placeholders with facts observed in the target repository before treating the files as project memory.

## Operating Rules

Use these rules as the practical contract for Codex work:

- No Codex thread starts development work without reading `AGENTS.md`.
- No meaningful task starts without a related Issue or explicit task brief.
- No code change starts before Codex summarizes the context, risks, and plan.
- No task ends without known test status, documentation check, and PR-ready summary.
- No repeated Codex mistake should remain only in chat; turn it into a rule, template, check, or document update.

The minimum viable target setup is:

- `AGENTS.md`
- `docs/ai-context/AI_DEVELOPMENT_GUIDE.md`
- `.github/ISSUE_TEMPLATE/codex-task.md`
- `.github/pull_request_template.md`

The richer project memory can grow progressively as the repository needs it.

## Recommended Workflow

1. Modify shared files in `src/`.
2. Review the expected impact in target repositories.
3. Commit the new version of this repository.
4. Install or update target repositories with `scripts/install.ps1`.
5. Validate target repositories with `scripts/validate-target.ps1`.
6. In each target repository, review the `git diff`, adapt project-specific context, then commit.

For target repositories:

1. Create or select one Issue for the mission.
2. Work on one focused branch or worktree.
3. Let Codex reconstruct context from Git and Markdown before coding.
4. Keep changes small and reviewable.
5. Update project memory when behavior, architecture, decisions, or known risks change.
6. Use the PR as the durable handoff document.

## Public Inspirations

This repository is adapted to a Buildwise workflow, but it is aligned with public agentic-coding practices:

- [agentsmd/agents.md](https://github.com/agentsmd/agents.md), an open format for guiding coding agents.
- [shinpr/agentic-code](https://github.com/shinpr/agentic-code), an AGENTS.md-based workflow framework with quality gates.
- [obviousworks/agentic-coding-rulebook](https://github.com/obviousworks/agentic-coding-rulebook), a collection of AI-assisted coding rules and templates.
- [DenisSergeevitch/agents-best-practices](https://github.com/DenisSergeevitch/agents-best-practices), provider-neutral guidance for agent skills and harness design.

These are inspirations, not vendored dependencies. The purpose of this repository is narrower: define a practical Codex + GitHub + Markdown memory workflow that can be copied into Buildwise development repositories.

## License

This repository is licensed under the [MIT License](LICENSE).
