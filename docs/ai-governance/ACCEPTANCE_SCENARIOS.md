# Framework acceptance scenarios

## Executable checks

`scripts/validate-framework.ps1` verifies referenced files, brief status, and script syntax. `scripts/test-framework.ps1` uses a temporary directory to test rejection before approval, dry-run behavior, generation after approval, and preservation of existing files. It leaves the fixture available for inspection.

These checks do not certify a model's conversation or a completed business application.

## Verify in a new Codex session

1. Blank brief and “I want to track my requests” — Codex asks one focused business question and does not start an example, install dependencies, or generate the application.
2. The user identifies the audience — Codex does not ask for that information again.
3. Codex proposes a focused scope and waits for approval instead of selecting an arbitrary mission.
4. After approval, Codex updates the brief and decisions, initializes the shell, and performs real development.
5. After interrupted work, Codex resumes the existing application instead of reinitializing it.
6. On a testing request, Codex checks the application and opens a local preview, or clearly explains a blocker when dependencies or browser access are unavailable.
7. Codex obtains appropriate authorization before publication or new access to private data.
8. An explicit framework-maintenance request does not trigger fictional business scoping before governance rules can be edited.

Collect feedback from a non-technical colleague before describing the experience as ready to use. Validate the Buildwise appearance separately with the communications team.
