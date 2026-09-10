# Decisions

## Framework structure — 2026-09-03

At the user's request, this branch starts from the V2 `src/` content promoted to the repository root. The future root `src/` directory is reserved for business application code. The Projects/KPI examples live under `examples/` and do not impose a mission.

## Mandatory brand identity — 2026-09-04

At the user's request, the Buildwise logo and theme are locked by hash. A blocking static check runs before tests and build. Competing palettes and fonts are forbidden; a visual review is mandatory, and exceptions require approval.

Public sources do not replace a validated internal brand guide. Font fallback must remain explicitly documented.

## UI specification and Roboto — 2026-09-04

The user explicitly requested documented colors, radii, sizes, and Roboto. Roboto therefore replaces the Neue Haas Unica stack for applications only. Buttons use a 999px radius and 48px height, fields use an 8px radius and 48px height, and cards use a 16px radius. Values and states are documented in `UI_SPEC.md` and implemented in the central theme.

These conventions are not represented as an official internal Buildwise brand guide. The theme hash was updated for the authorized change.

## French and Dutch are mandatory — 2026-09-07

Every application supports at least French and Dutch from initialization. It uses central JSON catalogs with stable keys, French fallback, browser-language detection, a persisted preference, an accessible selector, and a blocking pre-delivery check. Human linguistic review remains mandatory in `I18N_REVIEW.md`.

## English-only Markdown documentation — 2026-09-09

All tracked Markdown files, including governance, context, examples, and generated wiki or feature templates, are maintained in English. This keeps framework maintenance consistent and searchable. It does not change the mandatory French and Dutch languages of generated application interfaces.

## Portable Buildwise UI skill — 2026-09-10

The Buildwise UI guidance is embedded as a repository skill under `.agents/skills/buildwise-ui-style/`, the repository location officially discovered by Codex. Users opening a clone or extracted ZIP do not need to install a personal skill or plugin. `AGENTS.md` also requires the guidance before interface work.

Reusable editorial patterns from the supplied proposal were adopted. BuildLoop-specific product names, taglines, and calls to action were excluded because this starter must derive content from each validated business brief. Roboto and the existing framework component dimensions remain the approved application typography and control contract.

## Business application approval

No application scope has been validated. Record the first explicit approval here before changing the brief status.
