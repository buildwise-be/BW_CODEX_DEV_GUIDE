# Buildwise application development method

## Origin and responsibilities

This profile promotes the V2 framework's `src/` content to the repository root and adapts its workflow for a business audience. It preserves the separation between governance, human intent in `docs/ai-context/`, and observed technical facts in `docs/wiki/`.

Git remains the durable memory. No service, API account, or hook is required to start the conversation in Codex.

## Workflow

1. **Scope** — the brief is `To define`. Understand the mission, users, information, expected outcome, and limits. Ask short questions, one at a time, only when an answer changes the first version.
2. **Validate** — summarize the priority journey and no more than three to five capabilities. Ask for business approval, record it in `DECISIONS.md`, and change the brief status to `Validated`.
3. **Build** — `initialize-app.ps1` creates a neutral shell without overwriting an existing application. Codex implements the approved need with the standard stack, tests, and documentation. Initialization alone is not a delivery.
4. **Verify** — check business criteria, errors, empty data, loading, keyboard navigation, small screens, types, tests, and compilation. Correct failures within the approved scope.
5. **Test locally** — start the application with `start-local.ps1`, wait for the server to respond, open the available address, and propose business tasks to try.
6. **Iterate** — collect feedback and adjust the need and criteria. A material extension requires renewed business approval.

## Autonomy and safety

The user chooses the business outcome. Codex makes routine technical decisions and continues until it has a verified version or an explicit blocker. Do not request approval for every file or routine command.

Respect environment permissions and obtain authorization for spending, publication, private data, and risky operations. Do not automatically enable hooks, install Node globally, or publish the repository. Local scripts do not expose the application to the network; the server binds to `127.0.0.1`.

## Quality and project memory

Buildwise branding is mandatory. Read `BRAND_RULES.md` before creating any interface. `check:brand` must pass before tests and build. Record the visual review in `BRAND_REVIEW.md` before claiming visual compliance.

French and Dutch are mandatory. Read `I18N_RULES.md`. Run `check:i18n` before brand checks, tests, and build, and record the review in `I18N_REVIEW.md`.

Read `FEATURE_CHECKLIST.md` and `VALIDATION_CHECKLIST.md`. Prefer simplicity, readable code, small components, separated data access, tested business rules, useful error messages, and centralized branding. Choose a data contract suited to the brief; mocks must be replaceable and clearly labelled. Do not include example business features unless they are relevant.

Update `CURRENT_STATE.md` after every delivery with actual capabilities, verification evidence, and the next action. `DECISIONS.md` records approvals, `KNOWN_ISSUES.md` records limits, and `CHANGELOG_AI.md` records deliveries. Never turn an unverified result into a documented success.

## Detection and resuming work

`AGENTS.md` is at the root so Codex discovers it automatically. The historical V2 hook is optional; its presence does not guarantee execution.

After an interruption, reread the brief and current state and inspect the files. Do not reinitialize an existing application. A validated brief and a `package.json` do not prove that the application is complete.

## Sources

- V2 base: commit `302aedc` on `codex/v2-framework`.
- Codex instructions: https://learn.chatgpt.com/docs/agent-configuration/agents-md
