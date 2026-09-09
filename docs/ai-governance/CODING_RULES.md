# Coding rules

## Simplicity and structure

Default stack: React, strict TypeScript, Vite, and Tailwind CSS. Avoid additional frameworks or dependencies without a concrete need. Do not build generic architecture for unvalidated future requirements.

Application code is created in `src/` after business approval:

- keep UI components small and reusable;
- group business features by mission;
- separate business rules and calculations so they can be tested;
- place data access behind a contract suited to the brief instead of scattering it through views.

Do not copy a complete example unless it is relevant. Exclude examples from application compilation and reuse only the components that are needed. Use clear names and document intent and constraints; avoid comments that merely repeat the code. Keep files readable and formatted.

## Data, interactions, and security

Clearly identify fictional data and never present demonstration metrics as real. Provide loading, empty, error, and retry states. Validate input. Never store secrets or private data in client code or Git. Do not present a simple login screen as secure authentication. Use an asynchronous adapter so mocks can later be replaced by a real data source.

## Buildwise presentation

Apply `docs/ai-governance/BRAND_RULES.md` and use `docs/ai-governance/UI_SPEC.md` for exact CSS values and variants. `npm run check:brand` is part of the delivery criteria. Never bypass a failure by copying a modified theme or disabling the script.

Read `assets/brand/README.md`. Reuse the supplied logo and tokens; do not redraw the logo or invent a brand palette. Use local fonts or files with verified rights, not a visual dependency loaded over the network. Provide readable contrast, accessible labels, keyboard use, visible focus, and small-screen support. Status colors never replace text labels.

## French and Dutch

Apply `I18N_RULES.md`. French and Dutch are the permanent minimum. Route every interface string through the catalogs in `src/i18n/messages/`; do not hard-code labels, help, errors, or accessible attributes in components. Run `npm run check:i18n` before brand checks, tests, and compilation.

## Installation and local start

Initialize the shell with `scripts/initialize-app.ps1` after business approval. Verify compatible dependency versions and commit the lockfile. Prefer `npm ci` once the lockfile exists. Do not install global tools without approval.

Use `start-local.ps1` for the root application and never start `examples/` automatically. Wait for the actual available address and open it with the Codex preview when available. Bind only to `127.0.0.1` and stop only the server started by the current task.

## Verification and documentation

Add tests for business rules, components, and critical journeys in proportion to risk. Run `npm run check`, and test in a browser when available. Fix regressions before delivery or document the precise blocker.

Maintain every Markdown file in English, including the business brief, decisions, reviews, changelog, wiki pages, feature specifications, and READMEs. Translate business information into English when the user communicates in another language. This documentation rule does not change the mandatory French and Dutch application interfaces.

Update project state, decisions, limitations, and the business checklist. For `docs/wiki/`, read `WIKI_REFRESH_GUIDE.md` and document only observed facts.

For framework-only changes, run `scripts/validate-framework.ps1` and `scripts/test-framework.ps1` without inventing a business application.
