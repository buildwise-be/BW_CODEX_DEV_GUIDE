# Current state

## Business application

Not defined. There is no root `package.json` or application code. The blank brief is intentional, and examples are optional references.

## Framework

The governance content from the V2 `src/` directory has been promoted to the repository root. Business scoping, neutral initialization, local startup, and structural validation are available.

All Markdown documentation is maintained in English. Generated application interfaces still support French and Dutch as mandatory user languages.

## Brand checks — 2026-09-04

Mandatory brand rules, asset hashes, and static checks are integrated into future `npm run check` runs. Regression coverage lives in `scripts/check-brand.test.mjs`. No business application has received a visual review yet.

Verified: 17 brand-check tests passed, including UI values and text-pair contrast of at least 4.5:1. Generator tests passed, and `check:brand` passed in a temporary generated application. The full application build was not rerun for that specific brand change.

`UI_SPEC.md` defines colors, Roboto, sizes, spacing, radii, and states. These conventions are implemented in `assets/brand/theme.css`. Roboto is not bundled, so rendering depends on its availability on the workstation.

## Bilingual support — 2026-09-07

The neutral shell includes French and Dutch catalogs, initial language selection, a persisted preference, an accessible selector, and searchable translation keys. `check:i18n` blocks missing keys, empty values, and obvious hard-coded JSX text. A real application's linguistic review remains outstanding.

Verified on 2026-09-07: 5 language-check tests, 17 brand tests, generator safeguards, `check:i18n`, `check:brand`, 4 application tests, TypeScript compilation, and the Vite build all passed in a temporary generated application.

## Documentation — 2026-09-09

The README now provides a direct, non-technical path from a one-sentence business need to scope approval and local testing. All tracked Markdown files are written in English, including generated documentation templates.

## Repository UI skill — 2026-09-10

The repository now embeds `buildwise-ui-style` under `.agents/skills/`, so Codex can discover it without a personal installation. `AGENTS.md` requires the skill and the shared UI requirements before interface work. The central theme now includes the wider editorial layout, minimal header, search, filter, responsive grid, lightweight card, and action-link patterns.

## Next user action

Describe a business idea in one sentence.

## Framework verification — 2026-09-03

- Structural and syntax validation: passed.
- Blank brief: initialization blocked without writing files.
- Dry run: no application file created.
- Validated brief: neutral shell and brand assets created in a temporary fixture.
- Reinitialization: blocked and existing content preserved.
- Complete conversational journey with a non-technical colleague: not yet evaluated.
- Neutral shell: installation, server-render test, types, and build passed in a temporary fixture. No visual browser inspection was performed.
