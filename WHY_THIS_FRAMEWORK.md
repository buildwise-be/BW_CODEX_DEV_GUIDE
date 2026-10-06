# Why Use This Framework?

BW AI Development Framework helps teams turn development practices into a
repeatable working process: define a bounded change, inspect the existing
design, review the implementation, record verification, and preserve decisions.
The objective is maintainable, traceable software with evidence that the agreed
practices were followed. Generating more code is not a measure of success.

Security, change control, and architectural consistency need to remain visible
when an assistant produces code. This repository provides shared instructions,
review templates, and durable project context to support that work. It gives
teams a common place to integrate their approved engineering and security
requirements, while keeping decisions and results inspectable in Git.

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
| Apply development practices | Expectations and completion criteria must be agreed locally. | The workflow calls for scope, a plan, known check results, and reviewable changes. |
| Control source-code growth | Design consistency depends on local review habits. | Focused tasks and recorded architecture decisions support review of necessity and fit. |
| Review security concerns | Teams must define and configure their own controls. | Risk sections provide a place to record concerns; technical security controls still require separate setup. |
| Remember why a choice was made | Rationale may be in commits, issues, or conversations. | `DECISIONS.md` gives durable decisions an explicit home. |
| Resume incomplete work | Inspect files and history, then recover missing intent. | `CURRENT_STATE.md` adds progress, blockers, checks, and next actions to verify. |
| Distinguish facts from plans | Documentation structure is chosen locally. | Governance, operational memory, and technical wiki have separate roles. |
| Switch assistants | Arrange access to files and supply the working instructions. | Shared instructions, a Claude Code entry point, and Cowork setup guidance are supplied. |
| Review a change | Define the expected task and PR information locally. | Issue and PR templates prompt for scope, evidence, and remaining risks. |
| Update the workflow | Maintain local conventions manually. | A versioned manifest, installer, migration report, and validator support updates. |

These are workflow affordances, not guarantees that an assistant will obey every
instruction or that the application will be correct.

## Making Good Practices Operational

### Define completion through evidence

The shared workflow links an objective to a focused branch, implementation,
verification results, and a PR explanation. Reviewers can ask what changed,
why it was necessary, what was tested, and what remains uncertain. A test that
was not run must be identified as such. Project state is updated during
meaningful progress, rather than reconstructed only at the end of a conversation.

For a production project, make the relevant build, tests, lint, and type checks
part of the CI pipeline and require the appropriate reviews before merging.
The framework supplies workflow expectations; repository administrators must
configure the controls that enforce them. A Markdown checkbox alone is not
evidence that a test passed or that a review took place.

### Keep API keys and credentials out of Git

Adoption should establish an explicit rule: never commit real API keys, tokens,
passwords, private keys, or credential-bearing configuration. This applies to
source code, examples, test fixtures, logs, generated files, and project-memory
documents. Use placeholders in examples and inject actual secrets at runtime
through the organization's approved secret-management mechanism.

Exclude local secret files from version control and review the staged diff
before committing. An ignore rule is only a precaution: it does not remove an
already tracked secret or erase Git history. A private repository is not a
substitute for secret management.

Use an approved local secret check before committing, with repository-side
detection and push protection where available. Local checks can be bypassed;
push protection can stop supported secret patterns before they reach the remote,
but does not prevent every local commit or detect every secret. If a credential
is exposed, revoke or rotate it promptly and follow the incident procedure;
deleting its current file is insufficient. See GitHub's documentation on
[secret scanning](https://docs.github.com/en/code-security/concepts/secret-security/secret-scanning)
and [push protection](https://docs.github.com/en/code-security/concepts/secret-security/push-protection).

**Current boundary:** this framework does not install a secret scanner, a
secret-management service, or a commit-blocking security hook. These are
recommended adoption controls, not protections activated by the installer.
The optional Codex startup hook checks project context; it is not a security scan.

### Keep the codebase proportionate and coherent

The useful outcome is the smallest coherent change that satisfies the objective
and remains understandable to the next maintainer. Focused tasks, explicit
non-goals, relevant wiki pages, and recorded decisions provide context for
challenging unnecessary code. Apply the following review questions:

- Can the existing module or dependency solve this without a parallel implementation?
- Does each new dependency, abstraction, service, or configuration option meet
  a current requirement, with an acceptable maintenance cost?
- Does the change follow established interfaces, naming, and responsibility
  boundaries? If a departure is necessary, is its rationale recorded?
- Are unrelated refactors and speculative future features excluded?
- Are obsolete code paths identified and removed when their replacement is
  verified and removal is within scope?

Avoid both premature generalization and shortcuts that duplicate logic or
obscure behavior. Smaller code is useful when it improves clarity and reduces
maintenance; line count alone is not a quality criterion. The framework provides
scope and decision discipline, not an automatic architecture or complexity check.

### Make changes and versions traceable

The Issue, branch, commits, PR, and recorded checks should let another developer
reconstruct the reason for a change and the evidence used to accept it. Keep
commits focused and distinguish completed behavior from planned work.

The framework version is recorded separately in `.ai/framework.json`. That
identifies the adopted workflow version, not the application's release version.
For application releases, define a version/tag convention and retain the commit,
build artifact, verification results, and deployment information needed to
identify what was delivered. Rollback also requires considering data and
configuration changes; a Git revert alone may not restore a running service.

Protected branches can require reviews and status checks, subject to their
configuration and bypass settings. Configure these according to project risk;
the installer does not set them. See
[GitHub's protected-branch documentation](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches).

## Responsibilities at Adoption

| Area | Provided by this repository | To configure and verify for the target project |
| --- | --- | --- |
| Working method | Shared instructions, scope and review templates, completion criteria. | Responsible reviewers and evidence that checks actually ran. |
| Secrets | A documented adoption recommendation in this guide. | Runtime secret storage, local checks, repository detection/protection, incident handling. |
| Code quality | Focused-work expectations, decisions and technical-context structure. | Applicable lint, test, dependency and security checks; architecture review. |
| Change control | Git-oriented workflow and framework-version manifest. | Branch rules, access rights, application release and deployment traceability. |

This division lets teams reuse a common working method while retaining the
organization's existing engineering controls. Adoption should demonstrate these
controls on a real change before claiming that the process is enforced. For
example, verify the handling of a failed required check and use an approved
non-sensitive scanner test fixture to verify secret detection; never use a live
credential for such a test.

## Continuity and Tool Independence

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
| An API key is copied into code or an example | Adopt explicit secret-handling rules and inspect the staged diff. | Configure detection and protection separately; this installer does not block secret commits. |
| Every request adds another helper, dependency, or service | Bound the task and compare proposed additions with existing design and decisions. | Review necessity and maintenance cost; there is no automatic complexity limit. |
| The delivered version cannot be identified | Link changes to commits and review evidence. | Establish application tags, artifact provenance, and deployment records separately. |
| A workflow update overwrites project memory | Existing project-owned files use create-if-missing installation. | `-Force` can replace managed instructions; review and back them up. |
| A new clone is assumed to contain all work | Document local-only changes and verify the checkout. | Transfer uncommitted files and unpushed commits deliberately. |
| Two assistants act on conflicting state | Shared files make the state inspectable. | They are not a lock; coordinate concurrent edits and branches yourself. |

## A Concrete Example

Suppose you are adding an Excel export using data from an authenticated API.
The project already has an API client and export library. A decision requires
stable column names because another system consumes them.

The review should confirm that the change reuses those components, keeps the
API credential outside committed files, preserves the column contract, and
includes evidence for the relevant date-filter and error-handling checks.
`DECISIONS.md` records the contract; `CURRENT_STATE.md` records progress and any
unfinished checks. The PR links the objective, implementation, and results.

With the target project's security and CI controls configured, reviewers can
combine this explanation with scan and test results before accepting the change.
A later assistant has enough context to continue without inventing a second
client, changing the contract, or assuming an unfinished check has passed.

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
