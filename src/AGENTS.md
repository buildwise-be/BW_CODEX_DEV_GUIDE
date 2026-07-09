# AGENTS.md

## Mandatory Startup Instructions

Before making code changes, read:

- `docs/ai-governance/AI_DEVELOPMENT_GUIDE.md`

If they exist, also read:

- `docs/ai-governance/PROMPTS.md`
- `docs/ai-context/CURRENT_STATE.md`
- `docs/ai-context/DECISIONS.md`
- `docs/ai-context/KNOWN_ISSUES.md`
- `docs/ai-context/ROADMAP.md`

If the task depends on repository structure, APIs, build behavior, tests,
configuration, or data flow, read the relevant pages under:

- `docs/wiki/`

## Context Initialization Gate

Before starting development work, dependency installation, Docker startup, test
execution, or build execution, verify that the AI workflow context exists.

Required framework files:

- `AGENTS.md`
- `.codex/framework.json`
- `docs/ai-governance/AI_DEVELOPMENT_GUIDE.md`

Required project memory files:

- `docs/ai-context/CURRENT_STATE.md`
- `docs/ai-context/DECISIONS.md`
- `docs/ai-context/KNOWN_ISSUES.md`

If one or more required files are missing:

1. Stop after the minimal repository inspection needed to identify the missing
   files.
2. Tell the user exactly which files are missing.
3. Ask whether to initialize the missing context before continuing.
4. Wait for explicit approval.
5. Do not implement code, run Docker, install dependencies, or run tests before
   this is resolved, unless the user explicitly says to skip the initialization
   gate for the current task.

When initialization is approved, create concise, factual first versions of the
missing project memory files. Prefer framework templates when available, but
replace placeholders with facts observed in the target repository.

## Ownership Rules

- `docs/ai-governance/` is framework-managed.
- `docs/ai-context/` is project-owned operational memory.
- `docs/wiki/` is generated technical knowledge inferred from the repository.

Apply this rule consistently:

- If information can be inferred from repository files, put it in `docs/wiki/`.
- If information represents human intent, decisions, priorities, project
  status, or operational knowledge, put it in `docs/ai-context/`.

## Working Rules

Before coding:

1. Inspect the current Git branch.
2. Compare the branch with `main` when available.
3. Read the related Issue or task description.
4. Summarize your understanding.
5. Identify risks and ambiguities.
6. Propose a step-by-step plan.
7. Wait for approval before modifying files.

## Repository Setup

If the broader AI workflow structure is missing, propose installing or creating:

- `.codex/framework.json`
- `.github/ISSUE_TEMPLATE/codex-task.md`
- `.github/pull_request_template.md`
- `docs/ai-governance/AI_DEVELOPMENT_GUIDE.md`
- `docs/ai-context/CURRENT_STATE.md`
- `docs/ai-context/DECISIONS.md`
- `docs/ai-context/KNOWN_ISSUES.md`

Optional files:

- `docs/ai-governance/PROMPTS.md`
- `docs/ai-governance/WIKI_REFRESH_GUIDE.md`
- `docs/ai-context/ROADMAP.md`
- `docs/ai-context/CHANGELOG_AI.md`
- `docs/wiki/`

Do not create or modify this broader structure without approval.

## Definition of Done

A task is complete only when:

- the Issue objective is covered;
- tests are added or updated when needed;
- build, lint, typecheck, and test status is known;
- documentation is updated if required;
- risks and limitations are documented;
- the Pull Request contains a clear summary.
