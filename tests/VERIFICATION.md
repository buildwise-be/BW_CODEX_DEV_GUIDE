# V3 Verification

Verified on 2026-10-02 on Windows with PowerShell 7.6.5 and Windows PowerShell
5.1.26100.9444. All 14 regression scenarios passed under both runtimes.

## Automated Checks

Run `tests/framework.Tests.ps1` from the framework repository. The standalone
suite uses disposable Git repositories, has no Pester dependency, and retains
fixtures in the system temporary directory for inspection. It does not change
the framework checkout or publish anything.

All 14 regression scenarios passed:

- Fresh installation, shared instruction entry points, and manifest version.
- Initial and forced dry runs without file writes or backup creation.
- Idempotent reinstallation.
- Custom instruction conflicts without partial file copies.
- Explicit forced updates with backups and project-memory preservation.
- Optional hooks absent in both validation profiles.
- Required memory and full-profile optional memory checks.
- Optional wiki installation and validation.
- V2-only validation with a migration warning.
- Read-only V1/V2 migration reporting.
- V2 migration preserving memory and legacy files.
- Neutral manifest priority, including ignoring malformed legacy JSON.
- Invalid neutral manifest rejection without fallback.
- Direct startup-hook execution with present and missing required context.

The V2 fixture models the legacy manifest and file layout; it is not a live
customer repository. The neutral manifest also passed validation against the
existing JSON schema, and the Codex hook configuration parsed as valid JSON.

## Interactive Checks Not Performed

Claude Code was not available as a command in this environment. No connected
Cowork session was available for exercising the local repository workflow.
Consequently, a real Codex -> Claude Code/Cowork -> Codex handoff and Claude
startup have **not** been verified. No simulated persona run is counted as an
independent assistant test.

The Claude import was checked as a file and against the documented import
syntax. The startup hook was executed as a script, not dispatched by Codex's
hook engine. This does not establish runtime hook loading or trust behavior.

Use the manual acceptance procedure in
[ASSISTANT_SETUP.md](../src/docs/ai-governance/ASSISTANT_SETUP.md) in each actual
application, and record tool versions, observed results, unavailable commands,
and stale-checkpoint handling. Conversations, credentials, permissions, and
connectors are outside these tests and outside the migration's scope.
