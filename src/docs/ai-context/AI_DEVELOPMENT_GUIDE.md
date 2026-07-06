# AI Development Guide

## 1. Purpose

Codex is a powerful development assistant, but it should not be treated as the
long-term memory of a project.

A Codex conversation is temporary.
It has limited context, does not automatically know what happened in other
conversations, and does not reliably preserve decisions made across different
laptops, branches, or sessions.

When several developers, Codex threads, Git branches, or machines are involved,
the risk is not only code conflict.

The larger risk is context drift: different conversations may make different
assumptions about the architecture, roadmap, conventions, or current state of
the project.

To avoid this, the repository must become the source of truth.

The basic principle is:

> Codex is a temporary collaborator.
> Git is the permanent memory of the project.

Important information must not remain hidden in a Codex thread.
It must be captured in Git, GitHub, Pull Requests, Issues, and versioned
Markdown documentation.

A Codex thread should be able to disappear without the project losing knowledge.

## 2. Core Principles

- A conversation is temporary.
- A branch represents a focused mission.
- An Issue describes the mission.
- A Pull Request documents the change.
- Markdown files preserve project knowledge.
- Git is the source of truth.

Every important decision, constraint, assumption, architecture rule, or handoff
must be stored in the repository or in GitHub, not only in chat history.

## 3. Recommended Repository Structure

A simple structure is usually enough:

```text
/
├── AGENTS.md
├── README.md
├── docs/
│   ├── ai-context/
│   │   ├── AI_DEVELOPMENT_GUIDE.md
│   │   ├── CURRENT_STATE.md
│   │   ├── ARCHITECTURE.md
│   │   ├── DECISIONS.md
│   │   ├── ROADMAP.md
│   │   ├── KNOWN_ISSUES.md
│   │   ├── CHANGELOG_AI.md
│   │   └── PROMPTS.md
│   └── adr/
│       └── 0001-example-decision.md
├── issues/
│   └── ISSUE-001.md
└── src/
```

This structure is not mandatory, but it creates a clear place for project
memory.

The goal is not perfect documentation.
The goal is enough context for a new Codex session, a new developer, or a
future reviewer to understand the project without relying on previous
conversations.

When this workflow is installed from a shared guide repository, the installed
payload should include `.codex/guide-version.json`.

This file records which version of the shared Codex guide was copied into the
target repository.

### Context Initialization Gate

Before starting development work in a repository that uses this workflow, Codex
should verify that the minimum AI context files exist.

Minimum required files:

- `docs/ai-context/PROMPTS.md`;
- `docs/ai-context/CURRENT_STATE.md`;
- `docs/ai-context/ARCHITECTURE.md`;
- `docs/ai-context/DECISIONS.md`;
- `docs/ai-context/KNOWN_ISSUES.md`;
- `docs/ai-context/CHANGELOG_AI.md`.

If any of these files are missing, Codex should stop before implementation,
dependency installation, Docker startup, test execution, or build execution.

It should report the missing files, ask the user whether to initialize them,
and wait for explicit approval.

Only minimal inspection is allowed before this gate is resolved: reading
`AGENTS.md`, reading this guide, checking Git branch/status, and listing the
missing context files.

When the user approves initialization, Codex should create concise first
versions of the missing files and then continue with the normal planning
workflow.

If starter templates are available from the shared guide repository, Codex
should use them as structure only and replace placeholders with facts observed
in the target repository.

If the user explicitly asks to skip the gate for a task, Codex should mention
the skipped documentation risk in the final summary.

### Installation and Validation

For repositories that receive this workflow from a shared guide repository, use
the provided installation script as the distribution mechanism.

The installer should be conservative:

- run in dry-run mode before updating an existing repository;
- refuse to overwrite changed target files unless forced;
- refuse to install into a dirty target Git working tree unless explicitly allowed;
- create backups before intentional overwrites when requested.

After installation, run the validator from the guide repository to check that
the target repository contains the required payload files, version metadata,
and project context files.

## 4. Role of Each Document

### `CURRENT_STATE.md`

`CURRENT_STATE.md` describes the real functional state of the project. It should answer:

> Where is the project today?

It may include:

- completed features;
- partially implemented features;
- known limitations;
- unstable areas;
- pending migrations;
- temporary technical compromises.

This file is especially useful when multiple Codex threads work in parallel.

### `ARCHITECTURE.md`

`ARCHITECTURE.md` describes the main components of the system. It should focus on:

- modules;
- responsibilities;
- boundaries;
- dependencies;
- main data flows;
- integration points.

It should not duplicate the code. It should explain the structure behind the code.

### `DECISIONS.md`

`DECISIONS.md` records important technical and product decisions. For each decision, capture:

- the decision;
- the context;
- alternatives considered;
- the reason for the chosen approach;
- consequences;
- date;
- related Issue or Pull Request.

For larger decisions, use ADR files under `docs/adr/`.

### `ROADMAP.md`

`ROADMAP.md` contains upcoming work, planned features, priorities, deferred
ideas, milestones, and dependencies between initiatives.

This helps Codex avoid implementing ideas that are not aligned with the project
direction.

### `KNOWN_ISSUES.md`

`KNOWN_ISSUES.md` captures known problems: bugs, technical debt, fragile
modules, flaky tests, performance issues, and incomplete migrations.

This prevents Codex from repeatedly rediscovering the same problems.

### `CHANGELOG_AI.md`

`CHANGELOG_AI.md` provides a concise summary of meaningful AI-assisted changes.
It is not a replacement for Git history.
It is a human-readable handoff log.

### `PROMPTS.md`

`PROMPTS.md` stores reusable prompts for the team.
This makes Codex usage more consistent across developers and machines.

It can include prompts for:

- starting a new session;
- onboarding an existing project;
- analyzing a branch;
- reviewing a Pull Request;
- finishing a mission;
- updating documentation;
- debugging;
- refactoring;
- acting as architect;
- acting as reviewer.

## 5. Starting a New Project from Scratch

When starting a new project, define the working framework before writing production code.

Codex can help design the initial structure, but the framework must be reviewed
and accepted by the human developer.

At this stage, use Codex as an architecture and methodology assistant, not as a
code generator.

Recommended first outputs:

- `AGENTS.md`;
- `ARCHITECTURE.md`;
- `ROADMAP.md`;
- initial repository structure;
- testing strategy;
- Git strategy;
- coding conventions;
- documentation conventions.

### Prompt: Bootstrap a New Project

```text
Analyze the project requirements and propose an initial technical framework.

Define:
- the repository structure;
- development conventions;
- Git workflow;
- testing strategy;
- naming conventions;
- documentation structure;
- initial architecture;
- initial risks and assumptions.

Create draft versions of:
- AGENTS.md
- docs/ai-context/ARCHITECTURE.md
- docs/ai-context/ROADMAP.md
- docs/ai-context/CURRENT_STATE.md
- docs/ai-context/PROMPTS.md

Do not implement business logic yet.

First produce the proposed structure and methodology, then wait for validation.
```

## 6. Onboarding an Existing Project

Most projects do not start with this discipline. That is normal.

For an existing project, do not try to reconstruct the entire history.
Instead, create a reliable snapshot of the current state.

The objective is to capture enough knowledge so future Codex sessions can work
coherently.

Recommended process:

1. Ask Codex to analyze the repository without changing code.
2. Generate the first documentation set:
   - `CURRENT_STATE.md`;
   - `ARCHITECTURE.md`;
   - `DECISIONS.md`;
   - `KNOWN_ISSUES.md`;
   - `PROMPTS.md`.
3. Run the target repository validator from the shared guide repository and resolve any missing required files.

This documentation will be incomplete at first. That is acceptable. It should improve over time.

### Prompt: Analyze an Existing Repository

```text
Analyze the entire repository without modifying any code.

Identify:
- the general architecture;
- the main modules;
- the responsibilities of each module;
- internal dependencies;
- external dependencies;
- implicit coding conventions;
- test strategy;
- build and development commands;
- sensitive or fragile technical areas;
- architectural decisions that seem to have been made;
- missing documentation;
- potential risks.

After the analysis, propose draft versions of:
- AGENTS.md
- docs/ai-context/CURRENT_STATE.md
- docs/ai-context/ARCHITECTURE.md
- docs/ai-context/DECISIONS.md
- docs/ai-context/KNOWN_ISSUES.md
- docs/ai-context/PROMPTS.md

Do not modify production code.
Clearly separate facts observed in the repository from assumptions.
```

## 7. Consolidating Information from Previous Codex Threads

When multiple Codex conversations have already worked on a project, knowledge
is often scattered.

Before continuing, perform a consolidation phase.

Sources to review:

- recent Pull Requests;
- active Issues;
- recently merged branches;
- commits on active branches;
- existing documentation;
- ADR files;
- release notes;
- saved summaries from previous Codex sessions.

The goal is to extract durable knowledge and place it in the repository.

### Prompt: Consolidate Prior AI Work

```text
Consolidate the current project context from existing repository sources.

Review:
- recent commits;
- active branches if available;
- Pull Request descriptions;
- Issues;
- existing Markdown documentation;
- ADR files;
- CHANGELOG_AI.md if it exists.

Identify:
- decisions that should be documented;
- behavior that changed recently;
- incomplete or abandoned work;
- inconsistencies between documentation and code;
- risks introduced by parallel work;
- missing context needed by future Codex sessions.

Update or propose updates to:
- docs/ai-context/CURRENT_STATE.md
- docs/ai-context/DECISIONS.md
- docs/ai-context/CHANGELOG_AI.md
- docs/ai-context/KNOWN_ISSUES.md

Do not change production code during this consolidation step.
```

## 8. Git as the Coordination System

In a Codex-heavy workflow, Git is not only a version control system.
It is the coordination system between humans and agents.

Use this model:

```text
GitHub Issue
    ↓
Git branch
    ↓
Codex session
    ↓
Commits
    ↓
Pull Request
    ↓
Documentation update
    ↓
Merge
```

The conversation is not the durable artifact.
The durable artifacts are the Issue, branch, commits, Pull Request, and updated
documentation.

## 9. One Issue = One Mission

Each meaningful development should be linked to a GitHub Issue. The Issue is the mission brief.

It should contain:

- context;
- objective;
- constraints;
- acceptance criteria;
- related files or modules;
- dependencies;
- open questions;
- expected tests;
- documentation expectations.

### Prompt: Turn an Idea into a Codex-Ready Issue

```text
Transform the following feature idea into a clear GitHub Issue suitable for a Codex development session.

Include:
- context;
- objective;
- scope;
- non-goals;
- constraints;
- acceptance criteria;
- expected tests;
- affected modules;
- documentation updates required;
- open questions.

Do not implement anything yet.

Feature idea:
[PASTE IDEA HERE]
```

## 10. One Branch = One Thread

Avoid having multiple Codex conversations work on the same branch.

A safer mapping is:

```text
one Issue
=
one branch
=
one Codex conversation
=
one Pull Request
```

Recommended branch names:

```text
feature/pdf-export
feature/auth-refresh-token
bugfix/issue-245-date-parsing
refactor/report-service
docs/ai-development-guide
```

Branches should be short-lived and focused. If a task grows too large, split it into multiple Issues and branches.

## 11. Commit Discipline

Commit messages are context for future Codex sessions.

Avoid vague commits:

```text
fix
changes
update
wip
test
```

Prefer explicit messages:

```text
feat(auth): add automatic JWT refresh
fix(pdf): correct landscape margin calculation
refactor(api): extract quote validation service
test(auth): cover expired session handling
docs(ai): document Codex workflow
```

### Prompt: Prepare a Commit

```text
Review the current staged and unstaged changes.

Check:
- whether the changes are focused;
- whether unrelated files were modified;
- whether generated or temporary files are present;
- whether tests or documentation should be updated;
- whether the change matches the current Issue.

Then propose:
- which files should be staged;
- whether the change should be split into multiple commits;
- a clear commit message following the project conventions.

Do not commit automatically unless explicitly instructed.
```

## 12. Pull Requests as Durable Handoff Documents

A Pull Request is more than a merge request. It is the handoff record of a mission.

A good PR should explain:

- what changed;
- why it changed;
- what alternatives were considered;
- what risks remain;
- how it was tested;
- what documentation was updated;
- which Issue it closes.

### Pull Request Template

```markdown
## Summary

Briefly describe the change.

## Motivation

Explain why this change is needed.

## Changes

- Change 1
- Change 2
- Change 3

## Tests

- [ ] Unit tests
- [ ] Integration tests
- [ ] Manual testing
- [ ] Build
- [ ] Lint/typecheck

## Documentation

- [ ] AGENTS.md updated if needed
- [ ] CURRENT_STATE.md updated if needed
- [ ] DECISIONS.md updated if needed
- [ ] CHANGELOG_AI.md updated if needed

## Risks

Describe known risks or limitations.

## Follow-up

List follow-up Issues if needed.

Closes #[issue-number]
```

### Prompt: Prepare a Pull Request

```text
Prepare the Pull Request for this branch.

Review the diff against main.

Write a PR description including:
- summary;
- motivation;
- key changes;
- files and modules affected;
- tests performed;
- documentation updates;
- risks and limitations;
- follow-up work;
- related Issue.

Also check whether the following files need updates:
- AGENTS.md
- docs/ai-context/CURRENT_STATE.md
- docs/ai-context/DECISIONS.md
- docs/ai-context/CHANGELOG_AI.md
- docs/ai-context/KNOWN_ISSUES.md

Do not invent completed tests. If a test was not run, say so explicitly.
```

## 13. Using Git Worktrees

When working on several branches at the same time, use Git worktrees instead of repeatedly switching branches.

Example layout:

```text
project-main/
project-auth-refresh/
project-pdf-export/
project-dashboard/
```

Each worktree corresponds to one branch, one Issue, and one Codex conversation.

### Prompt: Start Work in a Worktree

```text
You are working in a dedicated Git worktree for this mission.

Before modifying code:
- identify the current branch;
- compare it with main;
- read AGENTS.md;
- read docs/ai-context/CURRENT_STATE.md;
- read docs/ai-context/DECISIONS.md;
- read the related Issue;
- summarize the current branch state;
- identify risks;
- propose a plan.

Do not modify files until the plan is approved.
```

## 14. Starting a New Codex Conversation

Every new Codex conversation should begin with context reconstruction.
Start with: read the context and explain your understanding.

### Prompt: New Codex Session

```text
Before making any code changes:

1. Read AGENTS.md.
2. Read docs/ai-context/CURRENT_STATE.md.
3. Read docs/ai-context/ARCHITECTURE.md.
4. Read docs/ai-context/DECISIONS.md.
5. Read docs/ai-context/KNOWN_ISSUES.md if it exists.
6. Read the Issue associated with this branch.
7. Inspect the current Git branch.
8. Compare this branch with main.
9. Review recent commits relevant to this task.
10. Summarize your understanding of the project context.
11. Summarize the mission.
12. Identify risks, ambiguities, and missing information.
13. Propose a step-by-step implementation plan.

Do not modify any files until I approve the plan.
Clearly separate facts from assumptions.
```

## 15. Resuming an Existing Branch

Sometimes a branch already contains work, but the Codex conversation is new.
In that case, ask Codex to reconstruct what happened.

### Prompt: Resume an Existing Branch

```text
Analyze this existing branch without modifying code.

Compare it with main and summarize:
- commits added on this branch;
- files changed;
- functionality already implemented;
- tests added or modified;
- documentation updated;
- remaining work;
- possible conflicts with main;
- architectural decisions implied by the changes;
- risks or inconsistencies.

Then propose a continuation plan.

Do not write code yet.
```

## 16. Daily Synchronization

If development is active, a short synchronization step before coding can prevent mistakes.

### Prompt: Start-of-Day Sync

```text
Perform a project synchronization check.

Review:
- the current branch;
- changes on main since this branch diverged;
- recent commits;
- recently merged Pull Requests if available;
- relevant Issues;
- project documentation.

Summarize:
- what changed recently;
- whether this branch is stale;
- whether documentation appears outdated;
- whether there are likely conflicts;
- recommended actions before continuing.

Do not modify files yet.
```

## 17. Co-Development Best Practices

Codex should be treated like a developer on the team. The same engineering rules apply:

- work in small increments;
- avoid unrelated refactors;
- keep PRs reviewable;
- ask for a plan before implementation;
- ask for explanation before accepting architectural changes;
- require tests for behavior changes;
- update documentation with the code;
- use Git as the handoff mechanism.

## 18. During Co-Development

During implementation, avoid giving Codex broad uncontrolled instructions. Prefer incremental prompts.

### Prompt: Implement One Step

```text
Implement only the first step of the approved plan.

Constraints:
- keep the change focused;
- follow existing project conventions;
- do not introduce unrelated refactoring;
- do not change public behavior outside the task scope;
- add or update tests if behavior changes;
- update documentation only if this step requires it.

After the change, summarize:
- files modified;
- behavior changed;
- tests added or updated;
- remaining work.
```

### Prompt: Continue to the Next Step

```text
Continue with the next step of the approved plan.

Before coding, verify that the previous step is complete and still aligned with the Issue.

Do not expand the scope.
If you discover a related but separate problem, report it as a follow-up instead of fixing it automatically.
```

### Prompt: Pause and Reassess

```text
Pause implementation.

Review the current changes and summarize:
- what has been completed;
- what remains;
- whether the solution still matches the Issue;
- whether the implementation introduced new risks;
- whether the plan should be adjusted.

Do not make additional changes during this review.
```

## 19. Preventing Scope Creep

Codex may detect nearby problems and start fixing them.
This can be useful, but it can also make branches noisy and hard to review.

Use explicit constraints.

### Prompt: Stay Within Scope

```text
Review the current work against the Issue scope.

Identify any changes that are outside the requested scope.

For each out-of-scope change:
- explain why it is outside scope;
- recommend whether to revert it, keep it, or create a follow-up Issue.

Do not perform the cleanup until I approve.
```

## 20. Asking for Architectural Review

Before a significant change, use Codex as an architect rather than a coder.

### Prompt: Architect Mode

```text
Act as the software architect for this project.

Do not write code.

Evaluate the proposed change against:
- the existing architecture;
- module boundaries;
- current conventions;
- long-term maintainability;
- testing strategy;
- known technical debt;
- documented decisions.

Provide:
- recommended approach;
- alternatives considered;
- trade-offs;
- risks;
- documentation that should be updated.

Wait for approval before implementation.
```

## 21. Asking for Debugging Help

When debugging, prevent Codex from randomly rewriting code.

### Prompt: Debugging Mode

```text
Act as a debugging assistant.

Do not refactor code yet.

Analyze the failure and provide:
- likely root causes;
- evidence for each hypothesis;
- files to inspect;
- minimal diagnostic steps;
- tests or commands to run;
- the smallest safe fix.

Only propose code changes after the root cause is identified.
```

## 22. Asking for Refactoring

Refactoring should be isolated from feature work whenever possible.

### Prompt: Refactoring Mode

```text
Act as a refactoring assistant.

Goal:
[DESCRIBE REFACTORING GOAL]

Constraints:
- preserve existing behavior;
- do not add new features;
- keep public APIs stable unless explicitly requested;
- update tests only where needed;
- avoid formatting-only churn;
- keep changes reviewable.

Before modifying code:
- identify affected files;
- explain the refactoring strategy;
- identify risks;
- propose a step-by-step plan.

Wait for approval before applying changes.
```

## 23. Self-Review Before Completion

Before considering a Codex task complete, ask for a self-review.

### Prompt: Self-Review

```text
Review your own changes before we consider this task complete.

Check for:
- bugs;
- regressions;
- missing tests;
- weak error handling;
- duplicated logic;
- unnecessary complexity;
- inconsistent naming;
- violations of AGENTS.md;
- documentation gaps;
- out-of-scope changes.

For each issue found:
- explain the problem;
- classify its severity;
- recommend whether to fix now or create a follow-up Issue.

Do not make changes until I approve the fixes.
```

## 24. Using a Second Codex Thread as Reviewer

A strong pattern is to use one Codex thread as the developer and another as the
reviewer.

The reviewer should critique the change, not continue implementation.

### Prompt: Reviewer Thread

```text
You are not the developer of this Pull Request.

You are the reviewer.

Analyze only the changes in this branch compared with main.

Review for:
- correctness;
- regressions;
- missing tests;
- security issues;
- performance issues;
- architecture violations;
- inconsistent conventions;
- unclear naming;
- excessive complexity;
- documentation gaps;
- out-of-scope changes.

Do not propose new features.
Do not rewrite the implementation unless necessary.

Return:
- blocking issues;
- non-blocking suggestions;
- questions for the author;
- recommended tests;
- documentation updates needed.
```

## 25. Updating Documentation During Development

Documentation should evolve with the code, not after the project is finished.

### Prompt: Documentation Check

```text
Review the current changes and determine whether documentation must be updated.

Check:
- AGENTS.md;
- docs/ai-context/CURRENT_STATE.md;
- docs/ai-context/ARCHITECTURE.md;
- docs/ai-context/DECISIONS.md;
- docs/ai-context/KNOWN_ISSUES.md;
- docs/ai-context/CHANGELOG_AI.md;
- README.md.

For each file:
- state whether an update is needed;
- explain why;
- propose the exact update.

Do not modify documentation until I approve.
```

### Prompt: Update Documentation

```text
Update the relevant documentation for the current changes.

Rules:
- keep updates concise;
- document behavior and decisions, not implementation noise;
- include the date where appropriate;
- reference the related Issue or Pull Request if possible;
- do not rewrite unrelated documentation.

After updating, summarize which files changed and why.
```

## 26. Finishing a Mission

A mission is complete only when the code, tests, documentation, and Git history are coherent.

### Prompt: Finish Mission

```text
Consider this mission nearly complete.

Perform a final completion review.

Verify:
- all Issue objectives are covered;
- acceptance criteria are satisfied;
- tests exist for behavior changes;
- build, lint, typecheck, and test commands have been run or are clearly listed as not run;
- documentation is up to date;
- decisions are documented;
- CHANGELOG_AI.md is updated if needed;
- no temporary files remain;
- no debug code remains;
- no unrelated changes are included;
- the branch is ready for Pull Request.

Then produce:
- final summary;
- tests performed;
- risks and limitations;
- follow-up Issues recommended;
- PR description draft.
```

## 27. Resuming Work Weeks Later

When work has been paused for a long time, assume the context is stale.

### Prompt: Resume After a Long Pause

```text
Resume this work after a long pause.

Before coding:
- read AGENTS.md;
- read docs/ai-context/CURRENT_STATE.md;
- read docs/ai-context/ARCHITECTURE.md;
- read docs/ai-context/DECISIONS.md;
- inspect this branch;
- compare it with main;
- review commits made since this branch was last active;
- identify changes that may affect this work;
- detect conflicts or stale assumptions.

Then produce:
- updated understanding of the task;
- what is still valid;
- what may need to change;
- recommended next steps.

Do not modify code yet.
```

## 28. Handling Multiple Laptops

When working across several laptops, avoid relying on local state.

Before continuing work on another machine:

```bash
git fetch --all --prune
git status
git branch --show-current
git log --oneline --decorate --graph --all -n 30
```

### Prompt: Cross-Laptop Continuation

```text
I am continuing this work from another machine.

Before modifying code:
- inspect the current Git branch;
- compare it with origin/main;
- check whether the local branch is ahead, behind, or diverged;
- summarize recent commits;
- identify whether the worktree appears clean;
- detect possible stale context.

Then recommend the safest next action.
Do not modify files yet.
```

## 29. Handling Parallel Codex Threads

Parallel Codex threads are useful but must be isolated.

Use:

```text
one thread
=
one branch
=
one worktree
=
one Issue
```

Avoid:

- two Codex threads on the same branch;
- one large branch for unrelated tasks;
- hidden decisions in chat;
- undocumented architecture changes;
- merging branches without PR descriptions.

### Prompt: Parallel Work Conflict Check

```text
Check whether this branch may conflict with other ongoing work.

Review:
- changed files;
- recent changes on main;
- related Issues;
- known active branches if visible;
- architecture documents.

Identify:
- likely merge conflicts;
- logical conflicts;
- duplicated work;
- inconsistent design decisions;
- documentation that should be synchronized.

Do not change code.
```

## 30. Recommended AI Collaboration Patterns

Several collaboration patterns work well with Codex:

- Architect + Developer: one session designs the approach, another implements it.
- Developer + Reviewer: one session codes, another reviews.
- Debugger + Implementer: one session identifies the root cause, another applies the fix.
- Refactorer + Test Guardian: one session performs refactoring, another checks behavior preservation and test coverage.
- Documentation Guardian: one session reviews whether project memory is up to date.

## 31. Minimal Daily Workflow

```text
1. Fetch latest Git state.
2. Open the correct worktree.
3. Start or resume the Codex session.
4. Ask Codex to read project context.
5. Validate the Codex workflow files when adopting or updating the guide.
6. Ask for a plan.
7. Approve one step at a time.
8. Commit focused changes.
9. Ask for self-review.
10. Ask for documentation check.
11. Prepare Pull Request.
12. Use a second Codex thread for review.
13. Merge only when code, tests, and documentation are coherent.
```

## 32. Minimal Prompt Set

### New Session

```text
Read AGENTS.md, CURRENT_STATE.md, ARCHITECTURE.md, DECISIONS.md, and the
related Issue.
Compare this branch with main.
Summarize your understanding, identify risks, and propose a plan.
Do not modify files yet.
```

### Implement Step

```text
Implement only the next approved step.
Keep the change focused, follow project conventions, avoid unrelated refactors,
and summarize the result afterward.
```

### Self-Review

```text
Review your changes for bugs, regressions, missing tests, documentation gaps,
convention violations, and out-of-scope changes.
Do not fix anything until I approve.
```

### Documentation Check

```text
Check whether AGENTS.md, CURRENT_STATE.md, ARCHITECTURE.md, DECISIONS.md,
KNOWN_ISSUES.md, CHANGELOG_AI.md, or README.md need updates for this change.
Propose exact updates.
```

### Finish Mission

```text
Verify that the Issue objectives are covered, tests and documentation are
complete, no unrelated changes remain, and the branch is ready for Pull Request.
Produce a PR description with summary, tests, risks, and follow-up work.
```

## 33. Definition of Done for Codex Work

A Codex-assisted mission is done only when:

- the Issue objective is satisfied;
- the branch is focused;
- the code builds;
- tests pass or unrun tests are clearly disclosed;
- lint/typecheck pass if applicable;
- documentation is updated;
- architectural decisions are recorded;
- the Pull Request explains the work;
- known risks are listed;
- follow-up work is captured as Issues;
- the Codex conversation can be closed without losing project knowledge.

## 34. Final Principle

The goal is not to make Codex remember everything.

The goal is to make Codex able to reconstruct what it needs from the repository.

When this workflow is followed, any Codex session can join the project,
understand the current state, perform a focused mission, document its work, and
exit without taking knowledge away with it.

That is the key difference between using Codex as a chat assistant and using
Codex as a disciplined software engineering collaborator.
