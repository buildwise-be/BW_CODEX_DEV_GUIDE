# Why Use This Framework?

BW AI Development Framework gives a project a shared way to record its rules,
decisions, current state, and verification results. Its main benefit is making
work easier to resume and review across sessions, people, and assistants.

A plain Git repository is a valid starting point. You can add a README,
instructions, tests, and decision notes yourself. This framework packages a
particular workflow so each project does not have to design and maintain that
structure independently. It complements Git; its benefits depend on keeping
the installed documents useful and accurate.

## What Changes Compared with a Plain Repository?

Here, "plain repository" means a Git repository without an established AI
workflow or project-memory convention. An existing well-documented repository
may already provide many of the same benefits.

| Need | Plain repository | With this framework |
| --- | --- | --- |
| Understand how to work | Rules must be supplied or discovered as needed. | Shared startup and development instructions are provided. |
| Remember why a choice was made | Rationale may be in commits, issues, or conversations. | `DECISIONS.md` gives durable decisions an explicit home. |
| Resume incomplete work | Inspect files and history, then recover missing intent. | `CURRENT_STATE.md` adds progress, blockers, checks, and next actions to verify. |
| Distinguish facts from plans | Documentation structure is chosen locally. | Governance, operational memory, and technical wiki have separate roles. |
| Switch assistants | Arrange access to files and supply the working instructions. | Shared instructions, a Claude Code entry point, and Cowork setup guidance are supplied. |
| Review a change | Define the expected task and PR information locally. | Issue and PR templates prompt for scope, evidence, and remaining risks. |
| Update the workflow | Maintain local conventions manually. | A versioned manifest, installer, migration report, and validator support updates. |

These are workflow affordances, not guarantees that an assistant will obey every
instruction or that the application will be correct.

## Main Advantages

### Less context to explain again

The next session can read what the project is trying to achieve, what is already
working, and what remains unresolved. Information that matters should survive
the end of a conversation. This is especially useful for work spread across
several days or handed to another developer.

### More independence from the assistant

The durable context is stored as ordinary files in your repository. You can
review, edit, version, and use those files with another tool. Switching normally
requires opening the same project and asking the next assistant to resume;
an explicit handoff is optional, mainly useful during unfinished work.

This is portability of project context. Accounts, conversations, permissions,
connectors, and available execution tools are not transferred by the framework.

### More consistent review and collaboration

The workflow asks for explicit objectives, focused branches, verification
results, and known limitations. The ownership model also separates shared
framework rules from project-owned memory, which the installer preserves.
Across several projects, this provides a common structure for onboarding and
review without requiring every project to share the same application stack.

## Costs and Disadvantages

- **Documentation needs maintenance.** Stale state can mislead the next session.
  Assistants are instructed to update it during authorized work, but people
  still need to review important claims.
- **There is process overhead.** Startup reading, planning, approval rules,
  issues, and PR expectations may be excessive for a disposable experiment.
- **More context is consumed.** Instructions and memory take time and context
  to read. Keep them concise; use relevant wiki pages rather than accumulating
  unnecessary documentation. No token or productivity savings are measured here.
- **Updates can require manual merging.** Different managed files are reported
  as conflicts, including ordinary differences between framework versions.
  There is no automatic merge of project-specific instructions.
- **The workflow has opinions and dependencies.** It uses PowerShell scripts
  and a Git/GitHub-oriented process. Adaptation may be needed for other working
  environments; file access alone does not provide shell or build capabilities.
- **There is a risk of false confidence.** A populated template, a green
  presence check, or a generated wiki page does not prove factual correctness.

## Pitfalls It Helps Avoid

| Pitfall | What helps | What still needs attention |
| --- | --- | --- |
| An important constraint exists only in chat | Record decisions and rationale in project memory. | Someone must actually capture the constraint. |
| Work restarts from an outdated assumption | Read and verify current state at resumption. | Compare it with actual files and Git; a crash may prevent the last update. |
| A future plan is described as an existing feature | Separate operational intent from repository-derived wiki facts. | Review the evidence behind each claim. |
| A task is declared complete without checks | Record checks performed, failures, and checks not run. | The framework does not execute application tests or replace CI. |
| A workflow update overwrites project memory | Existing project-owned files use create-if-missing installation. | `-Force` can replace managed instructions; review and back them up. |
| A new clone is assumed to contain all work | Document local-only changes and verify the checkout. | Transfer uncommitted files and unpushed commits deliberately. |
| Two assistants act on conflicting state | Shared files make the state inspectable. | They are not a lock; coordinate concurrent edits and branches yourself. |

## A Concrete Example

Suppose you are adding an Excel export. A decision requires stable column names
because another system consumes them. The export works, but its date filter
still needs testing.

In a repository without a memory convention, the column constraint and unfinished
check might remain in conversation history. With this framework, the constraint
belongs in `DECISIONS.md`; the current implementation, outstanding check, and
next action belong in `CURRENT_STATE.md`. A later assistant reads both and
checks the code before continuing.

The improvement comes from maintaining those facts, not from the presence of
the filenames. A plain repository with equally good documentation can support
the same recovery.

## When Is It Worth Using?

Use it when a project will span multiple sessions, involve several people or
assistants, or benefit from repeatable review and shared working conventions.
It is particularly useful when decisions are costly to reconstruct from code.

A plain repository with a concise README and a few project instructions may be
enough for a short experiment. If an existing project already has effective
governance and memory, compare the conventions before installing a second set;
duplicate or contradictory instructions can make collaboration worse.

For adoption, start with factual required memory and keep optional wiki content
proportionate to the project. Replace template placeholders with observed facts.
Do not put credentials or secrets in versioned context files. Use the dry run
and review existing instructions before adopting framework-managed versions.

## Practical Limits and Further Reading

The framework is a set of files and scripts, not a background synchronization
service or an enforcement system. It cannot guarantee state updates after a
forced stop, resolve concurrent work, make a model error-free, or replace human
review, application tests, backups, and access controls.

- [Install, update, and migrate the framework](README.md)
- [Shared development workflow](src/docs/ai-governance/AI_DEVELOPMENT_GUIDE.md)
- [Start and switch assistants](src/docs/ai-governance/ASSISTANT_SETUP.md)
- [What has actually been tested](tests/VERIFICATION.md), including the limits
  of validation and the interactive assistant checks not performed.
