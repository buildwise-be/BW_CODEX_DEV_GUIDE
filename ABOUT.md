# About BW Codex Dev Guide

BW Codex Dev Guide is a reusable governance package for Codex-assisted software development.

It provides a versioned set of repository files that can be installed into Buildwise development repositories so Codex sessions start with the same operating rules, project-memory structure, GitHub task templates, and validation tooling.

## What This Repository Contains

- A canonical install payload under `src/`.
- A short Codex bootstrap file through `AGENTS.md`.
- A complete workflow manual through `docs/ai-context/AI_DEVELOPMENT_GUIDE.md`.
- GitHub Issue and Pull Request templates for Codex-ready work.
- PowerShell scripts to install and validate the guide in target repositories.
- Starter templates for project-specific AI context files.

## What This Repository Is Not

- It is not application code.
- It is not a replacement for project-specific architecture documentation.
- It does not create project memory automatically without human review.

## Distribution Model

Target repositories receive this guide through the installation script:

```powershell
.\scripts\install.ps1 -TargetPath C:\path\to\target-repo -DryRun
.\scripts\install.ps1 -TargetPath C:\path\to\target-repo
```

After installation, target repositories can be checked with:

```powershell
.\scripts\validate-target.ps1 -TargetPath C:\path\to\target-repo
```

## Repository About Metadata

Suggested GitHub description:

```text
Reusable Codex governance layer for Buildwise development repositories.
```

Suggested topics:

```text
codex, agents-md, ai-development, github-workflow, developer-tools, powershell
```

## License

This repository is licensed under the MIT License.
