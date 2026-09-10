# Buildwise UI requirements

This document defines the default visual direction for applications created with the Buildwise App Builder. It translates observable patterns from the public Buildwise identity into reusable application conventions. It does not copy website content or replace an official internal brand guide.

The requirements apply to interface changes by default. An explicit user request for another visual direction takes precedence and must be recorded as a project decision.

## Desired outcome

Create a clean, editorial, accessible interface suited to construction-sector work. The result should feel recognizably Buildwise through color, typography, spacing, and restrained components while remaining focused on the application's own mission.

## Sources of truth

- `assets/brand/theme.css` is the executable source for tokens and shared classes.
- `docs/ai-governance/UI_SPEC.md` defines exact values and component behavior.
- `docs/ai-governance/BRAND_RULES.md` defines delivery and exception rules.
- `assets/brand/buildwise-logo.svg` is the supplied logo asset.

Do not redefine tokens or recreate the logo inside application code.

## Visual principles

- Use Buildwise blue for primary actions, links, and active elements.
- Use turquoise as a restrained accent rather than a large decorative background.
- Use dark text on white and light-grey surfaces.
- Favor generous white space, fine horizontal dividers, and minimal shadows.
- Avoid heavy generic cards, decorative gradients, dark themes, and competing color systems.
- Keep headings direct, dark, and visually strong.
- Use a wide responsive content area: up to 1320px on large screens, with responsive side margins.
- For repeated editorial content, use four columns on wide screens, two on tablets, and one on mobile when the content supports that density.

## Header

The default application header is deliberately minimal:

- place the supplied Buildwise logo on the left;
- place the French/Dutch language control on the right;
- use a white background and a fine grey bottom border;
- do not add search, account controls, or navigation links unless required by the validated journey;
- never duplicate a page-level search field in the header.

## Search and filters

When the application needs search or filters:

- provide one clearly labelled search field per dataset;
- use the light-grey rounded search treatment supplied by the theme;
- use a blue pill-shaped filter action with bold white text;
- present expanded filters on a very light-grey surface;
- keep filter controls simple, rectangular, and easy to scan;
- show active filters in text, not through color alone;
- preserve the search term and active filters when switching between French and Dutch.

## Editorial cards and lists

Use cards only when they improve scanning or grouping:

- avoid thick borders and pronounced shadows;
- use strong dark titles and readable supporting information;
- keep metadata visually secondary;
- place category, audience, or status information close to the action when relevant;
- align the primary card action consistently;
- use the supplied light-blue pill link with a blue circular arrow for a prominent “view” action;
- ensure the French and Dutch labels fit without truncation.

Tables remain appropriate for dense comparison tasks. Do not force all business data into cards.

## Product content

Use the approved product name, mission, labels, and translations from the business brief. Product-specific names, taglines, calls to action, or navigation from another application are not reusable style rules and must not be copied automatically.

## Responsive and accessible behavior

- Verify layouts at 390px, tablet width, and 1440px.
- Verify keyboard navigation, visible focus, 200% zoom, and meaningful reading order.
- Do not use color as the only indicator of status or selection.
- Preserve labels and meaning in French and Dutch.
- Record the actual visual review in `BRAND_REVIEW.md`.

## Portability

The repository embeds its skill under `.agents/skills/buildwise-ui-style/`. Codex discovers repository skills from `.agents/skills`, so a user opening this project does not need to install a personal skill or configure a plugin. If Codex was already open when the skill was added, restarting Codex may be required for it to appear.
