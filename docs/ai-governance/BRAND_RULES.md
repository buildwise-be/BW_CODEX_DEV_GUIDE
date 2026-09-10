# Buildwise brand — mandatory delivery rules

## Source of truth

Read `.agents/skills/buildwise-ui-style/SKILL.md`, `docs/ai-context/BUILDWISE_UI_REQUIREMENTS.md`, this document, and `assets/brand/README.md` before creating or reviewing any interface. Exact mandatory CSS values are defined in `UI_SPEC.md`, including colors, Roboto, sizes, spacing, radii, and component states.

Use only validated assets from `assets/brand/`: the logo, `theme.css`, and `policy.json`. The public website at https://www.buildwise.be/fr/ is the visual reference, but it is not a complete internal brand guide. The historical Projects/KPI examples are not a visual reference.

## Requirements

- Use the supplied official logo with its proportions intact, on a light background, and with clear space. Do not draw a replacement, substitute a letter “b”, apply filters, or recolor it.
- Use the Buildwise blue and turquoise palette, white or grey surfaces, and dark text. All colors must use the supplied `--bw-*` variables. Do not add a competing Tailwind palette, local colors, or decorative gradients.
- Use only `--bw-font`: Roboto for applications, as requested by the user, with the declared Arial/Helvetica fallback. Do not import Google Fonts or download proprietary fonts without verified rights.
- Reuse `bw-header`, `bw-logo`, `bw-panel`, and `bw-button`. Keep headings restrained, hierarchy clear, spacing generous, buttons rounded, and focus visible.
- Prefer the supplied minimal header and editorial search, filter, grid, card, and action-link patterns where they support the approved journey.
- Do not turn the application into a dark theme or project-specific visual identity. Adapt the layout to the business need without changing the identity.
- Add status colors to the central theme only after a documented decision. Always pair color with a text label and verify contrast.

## Mandatory checks

`npm run check` must start with `npm run check:brand`. The checker compares the theme and logo with locked references, verifies the theme import, and finds competing colors and fonts in `src/`. Do not remove, disable, or bypass the checker. It is a conservative static analysis, not visual certification.

Before any UI delivery, inspect every primary screen and its loading, empty, and error states with a keyboard, on desktop and mobile. Compare the result with the official website. Record screens, dimensions, evidence, differences, font status, and corrections in `docs/ai-context/BRAND_REVIEW.md`. Without inspection, record `Not verified`, never `Compliant`. A server-rendered response is not a visual inspection.

## Exceptions

If a requirement is incompatible with the theme, explain the need and obtain explicit approval before changing central assets or their hashes in `policy.json`. Record the source, reason, and approval in `DECISIONS.md`. Functional approval does not authorize a brand change. If Buildwise supplies an internal brand guide, it takes precedence over provisional choices derived from the public website.
