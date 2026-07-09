# AI Development Guide

## Purpose

This repository uses the BW Codex Development Framework to make AI-assisted
software work repeatable, reviewable, and recoverable.

Codex conversations are temporary. Git is the durable project memory.

Important context must live in the repository, GitHub Issues, Pull Requests,
commits, and versioned Markdown files. A Codex thread should be able to end
without the project losing decisions, status, or technical knowledge.

## Responsibility Model

The framework separates AI collaboration knowledge into three areas.

### AI Governance

Location:

```text
AGENTS.md
docs/ai-governance/
```

Governance defines how AI coding agents and developers work together.

It includes:

- startup rules;
- development workflow;
- Git and Pull Request workflow;
- review expectations;
- reusable prompts;
- wiki refresh rules.

Governance is framework-managed. It is updated by installing a new framework
version.

### Operational Project Memory

Location:

```text
docs/ai-context/
```

Project memory records information that cannot be reliably inferred from the
source code.

It includes:

- current project state;
- decisions and rationale;
- roadmap and priorities;
- known issues and technical debt;
- human-readable AI-assisted change summaries.

Project memory is project-owned. The installer may create missing starter
files, but it must not overwrite existing project memory.

### Technical Knowledge

Location:

```text
docs/wiki/
```

Technical knowledge records what actually exists in the repository.

It should be refreshed by analyzing the source tree, build files, tests,
configuration, and public interfaces. It must not describe future plans,
undocumented assumptions, or desired architecture.

Technical wiki files are generated or refreshed on demand. They are optional
for small repositories, but useful when a project has enough structure that
Codex and developers benefit from a stable technical map.

## Core Rule

If information can be inferred from the repository, it belongs in
`docs/wiki/`.

If information represents human intent, engineering decisions, priorities,
project status, or operational knowledge, it belongs in `docs/ai-context/`.

The two trees should complement each other without duplicating information.

## Recommended Target Structure

```text
/
├── AGENTS.md
├── .codex/
│   ├── framework.json
│   ├── hooks.json
│   └── hooks/session_start.ps1
├── .github/
│   ├── ISSUE_TEMPLATE/codex-task.md
│   └── pull_request_template.md
├── docs/
│   ├── ai-governance/
│   │   ├── AI_DEVELOPMENT_GUIDE.md
│   │   ├── PROMPTS.md
│   │   └── WIKI_REFRESH_GUIDE.md
│   ├── ai-context/
│   │   ├── CURRENT_STATE.md
│   │   ├── DECISIONS.md
│   │   ├── ROADMAP.md
│   │   ├── KNOWN_ISSUES.md
│   │   └── CHANGELOG_AI.md
│   └── wiki/
│       ├── INDEX.md
│       ├── OVERVIEW.md
│       ├── MODULES.md
│       ├── API.md
│       ├── DOMAIN.md
│       ├── DATA_FLOW.md
│       ├── DEPENDENCIES.md
│       ├── BUILD.md
│       ├── TESTING.md
│       └── CONFIGURATION.md
```

## Context Initialization Gate

Before development work begins, Codex should verify the required workflow
context.

Required framework files:

- `AGENTS.md`;
- `.codex/framework.json`;
- `docs/ai-governance/AI_DEVELOPMENT_GUIDE.md`.

Required project memory files:

- `docs/ai-context/CURRENT_STATE.md`;
- `docs/ai-context/DECISIONS.md`;
- `docs/ai-context/KNOWN_ISSUES.md`.

Recommended project memory files:

- `docs/ai-context/ROADMAP.md`;
- `docs/ai-context/CHANGELOG_AI.md`.

If required files are missing, Codex should stop before implementation,
dependency installation, Docker startup, test execution, or build execution.
It should report the missing files and ask whether to initialize them.

Only minimal inspection is allowed before the gate is resolved: reading
`AGENTS.md`, reading this guide, checking Git branch/status, and listing
missing context files.

## Git Workflow

Use Git as the coordination system:

```text
GitHub Issue
    -> branch or worktree
    -> Codex session
    -> commits
    -> Pull Request
    -> documentation update
    -> merge
```

Recommended mapping:

```text
one Issue = one branch = one Codex thread = one Pull Request
```

Keep branches focused. Split work when a mission grows beyond a reviewable
change.

## Issues

A Codex-ready Issue should include:

- context;
- objective;
- scope and non-goals;
- acceptance criteria;
- expected tests;
- affected areas;
- documentation expectations;
- risks and open questions.

The Issue is the mission brief. Codex should not need hidden chat context to
understand the goal.

## Pull Requests

A Pull Request is the durable handoff record.

It should explain:

- what changed;
- why it changed;
- how it was tested;
- which documentation changed;
- what risks remain;
- which Issue it closes.

Do not invent tests. If a check was not run, say so explicitly.

## Documentation Update Rules

Update `docs/ai-context/` when the work changes project status, decisions,
roadmap, known issues, or AI-assisted handoff history.

Refresh `docs/wiki/` when generated technical descriptions are stale after
code, build, test, dependency, configuration, API, or module changes.

Update `docs/ai-governance/` only when the framework workflow itself changes.

## Installation and Validation

Install from the framework repository:

```powershell
.\scripts\install.ps1 -TargetPath C:\path\to\target-repo -DryRun
.\scripts\install.ps1 -TargetPath C:\path\to\target-repo
```

Install optional wiki starter files when a project is ready to maintain them:

```powershell
.\scripts\install.ps1 -TargetPath C:\path\to\target-repo -IncludeWiki
```

Validate a target repository:

```powershell
.\scripts\validate-target.ps1 -TargetPath C:\path\to\target-repo
```

Run a fuller validation profile when optional project memory matters:

```powershell
.\scripts\validate-target.ps1 -TargetPath C:\path\to\target-repo -Profile full
```

## File Ownership

The framework manifest at `.codex/framework.json` defines file ownership and
install behavior.

Ownership classes:

- `Framework`: managed by this framework and updated by installer.
- `Project`: created if missing, then owned by the target project.
- `Generated`: created or refreshed on demand from repository analysis.

Install modes:

- `managed`: compare hashes and update only when safe or forced.
- `create-if-missing`: create a starter file only if the target path is absent.

## Finishing a Mission

A Codex-assisted mission is complete only when:

- the Issue objective is covered;
- the branch is focused;
- build, lint, typecheck, and test status is known;
- documentation is updated when required;
- decisions are recorded when required;
- known risks and follow-up work are captured;
- the Pull Request explains the work clearly.

## Final Principle

The goal is not to make Codex remember everything.

The goal is to make Codex able to reconstruct what it needs from the
repository.
