# AGENTS.md

## Mandatory Startup Instructions

Before making any code changes, read:

- docs/ai-context/AI_DEVELOPMENT_GUIDE.md

If they exist, also read:

- docs/ai-context/CURRENT_STATE.md
- docs/ai-context/ARCHITECTURE.md
- docs/ai-context/DECISIONS.md
- docs/ai-context/KNOWN_ISSUES.md
- docs/ai-context/PROMPTS.md

## AI Context Initialization Gate

Before starting any development work, coding, dependency installation, Docker run, test run, or build, verify that the AI workflow context exists.

Required AI context files:

- docs/ai-context/PROMPTS.md
- docs/ai-context/CURRENT_STATE.md
- docs/ai-context/ARCHITECTURE.md
- docs/ai-context/DECISIONS.md
- docs/ai-context/KNOWN_ISSUES.md
- docs/ai-context/CHANGELOG_AI.md

If one or more of these files are missing:

1. Stop after the minimal repository inspection needed to identify the missing files.
2. Tell the user exactly which files are missing.
3. Ask whether to initialize the missing AI context files before continuing.
4. Wait for explicit approval.
5. Do not implement code, run Docker, install dependencies, or run tests before this is resolved, unless the user explicitly says to skip the initialization gate for the current task.

When initialization is approved, create concise, factual first versions of the missing files before starting feature work.

## Working Rules

Before coding:

1. Inspect the current Git branch.
2. Compare the branch with `main`.
3. Read the related Issue or task description.
4. Summarize your understanding.
5. Identify risks and ambiguities.
6. Propose a step-by-step plan.
7. Wait for approval before modifying files.

## Repository Setup

If the broader AI workflow structure is missing, propose creating:

- .github/ISSUE_TEMPLATE/codex-task.md
- .github/pull_request_template.md
- docs/ai-context/PROMPTS.md
- docs/ai-context/CURRENT_STATE.md
- docs/ai-context/ARCHITECTURE.md
- docs/ai-context/DECISIONS.md
- docs/ai-context/KNOWN_ISSUES.md
- docs/ai-context/CHANGELOG_AI.md

Do not create or modify this broader structure without approval.

## Definition of Done

A task is complete only when:

- the Issue objective is covered;
- tests are added or updated when needed;
- build/lint/typecheck/test status is known;
- documentation is updated if required;
- risks and limitations are documented;
- the Pull Request contains a clear summary.
