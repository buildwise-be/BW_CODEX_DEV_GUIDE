# About BW Codex Development Framework

BW Codex Development Framework is a lightweight governance and memory layer for
Codex-assisted software development.

It provides a versioned set of repository files that can be installed into
Buildwise development repositories so Codex sessions and developers share the
same workflow, project-memory structure, GitHub handoff model, and validation
tooling.

## What This Repository Contains

- A canonical install payload under `src/`.
- A short Codex bootstrap file through `AGENTS.md`.
- Framework governance under `docs/ai-governance/`.
- GitHub Issue and Pull Request templates for Codex-ready work.
- PowerShell scripts to install, validate, and inspect migrations.
- Starter templates for project-owned operational memory.
- Optional starter templates for generated technical wiki pages.
- A manifest schema for framework-managed files.

## Responsibility Model

- AI governance defines how Codex should work.
- Operational project memory records human intent, decisions, priorities, and
  current state.
- Technical wiki pages describe what can be inferred from the repository.

## What This Repository Is Not

- It is not application code.
- It is not a replacement for project-specific decisions.
- It does not overwrite project memory during routine updates.
- It does not require an external wiki generator.

## Distribution Model

Target repositories receive this framework through the installation script:

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
Repository-centric AI development framework for Codex-assisted engineering.
```

Suggested topics:

```text
codex, agents-md, ai-development, github-workflow, developer-tools, powershell
```

## License

This repository is licensed under the MIT License.
