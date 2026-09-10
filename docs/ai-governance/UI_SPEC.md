# UI and CSS specification — Buildwise applications

Version 2 — 2026-09-10. Executable source: `assets/brand/theme.css`.
This specification is mandatory for generated applications.

## Origin of the choices

Blue, turquoise, dark text, light grey, and the logo come from the public buildwise.be references listed in `assets/brand/README.md`. Roboto was explicitly requested for applications; it differs from Neue Haas Unica observed on the public website.

The sizes, spacing, radii, and states below are framework conventions, not values certified by an internal Buildwise brand guide.

## Colors

| Use / CSS variable | Value | Rule |
| --- | --- | --- |
| Brand blue `--bw-blue` | `#0087B7` | Identity and accents; not for small white text by default |
| Turquoise `--bw-turquoise` | `#00BFB6` | Decorative accent; never the only status indicator |
| Action `--bw-action` | `#00739C` | Primary button, links, and focus; darker interface variant |
| Action hover `--bw-action-hover` | `#005E80` | Hover state |
| Text `--bw-text` | `#1B1B1B` | Primary text |
| Secondary text `--bw-muted` | `#595959` | Help, captions, and placeholders |
| Surface `--bw-surface` | `#FFFFFF` | Cards, fields, and header |
| Background `--bw-background` | `#F2F2F2` | Page and table headers |
| Divider `--bw-border` | `#D9D9D9` | Decorative dividers; not the only field boundary |
| Search `--bw-search-bg` | `#F1F1F1` | Rounded search surface |
| Action link `--bw-link-bg` | `#DFF4FB` | Light-blue pill behind a prominent view action |
| Input border `--bw-input-border` | `#767676` | Perceptible outline on white |
| Disabled `--bw-disabled-bg` / `--bw-disabled-text` | `#E6E6E6` / `#595959` | Do not reduce global opacity and weaken all contrasts |
| Information `--bw-info-bg` | `#E0F7FF` | Light background with action-colored text |
| Success `--bw-success` / `--bw-success-bg` | `#176543` / `#EAF5EF` | Text label required |
| Warning `--bw-warning` / `--bw-warning-bg` | `#805500` / `#FFF4D6` | Text label required |
| Error `--bw-danger` / `--bw-danger-bg` | `#B42318` / `#FFF0EE` | Label and correction guidance required |
| Danger hover `--bw-danger-hover` | `#912018` | Destructive actions only |

Functional colors are application choices, not a claimed extension of the institutional palette. Do not use local color values in screens; use `var(--bw-...)`. Do not add gradients or a dark theme.

## Typography

- Font: `--bw-font: "Roboto", Arial, Helvetica, sans-serif`.
- Current loading: locally installed Roboto, then Arial/Helvetica. No Roboto file is bundled, so do not claim guaranteed Roboto rendering on a new workstation. For identical rendering everywhere, supply local WOFF2 files with verified license and provenance, then validate and lock the assets.
- Do not load Google Fonts or a CDN at render time.
- Body: 16px, line-height 1.5, weight 400.
- Help, caption, and badge: 14px, line-height 1.5. Business text must not be smaller than 14px.
- Introduction: 18px, line-height 1.5 through `--bw-text-lg`.
- H1: 32px desktop and 24px mobile; H2: 24px; H3: 20px.
- Headings: weight 700, line-height 1.2. Labels and badges: weight 500.
- Base size: 16px. Define type sizes in `rem` to respect user zoom.

## Buttons

| Variant | Classes | Dimensions and style |
| --- | --- | --- |
| Primary | `bw-button` | Minimum height 48px, padding 12px 24px, **999px** radius, Roboto 16px/700, white text on action color |
| Secondary | `bw-button bw-button--secondary` | White background, 1px action border, action text; same dimensions |
| Danger | `bw-button bw-button--danger` | Danger background and white text; destructive actions only |
| Compact | `bw-button bw-button--compact` | Minimum 40px, padding 8px 16px, 14px text; returns to 48px on mobile |
| Disabled | Native `disabled` attribute | Disabled background and text tokens, `not-allowed` cursor |

Size buttons to their labels, never truncate text, and allow wrapping. Optional icons are 20px with an 8px gap. An icon-only control needs an accessible name and a minimum 48 × 48px target; do not apply the compact style to it.

For loading, preserve the label and dimensions, set `aria-busy`, and prevent duplicate activation. Focus uses a **3px** action-colored outline with a **3px** offset and is never removed. Color and border transitions last **120ms** and are disabled under `prefers-reduced-motion`.

## Fields, cards, badges, and tables

- `bw-input`: minimum height **48px**, padding **12px 16px**, radius **8px**, **1px** input-border, white background, and 16px text. Apply to input, select, and textarea; a textarea may be taller.
- `bw-field`, `bw-label`, `bw-hint`, `bw-error`: visible label, 8px gap, and 14px help or error text. `aria-invalid="true"` changes the border but does not replace a field message connected through `aria-describedby`.
- `bw-panel`: radius **16px**, padding **24px**, **1px** border, white background, and no shadow by default. Mobile padding is 16px.
- `bw-badge`: radius **999px**, padding **4px 12px**, and 14px/500 text. Variants: `bw-badge--success`, `--warning`, and `--danger`. Never make a status blink.
- `bw-table` inside `bw-table-wrap`: cells **12px 16px**, 1px dividers, and a light-grey/700 header. Horizontal scrolling belongs inside the table, not the page.
- Modal: card surface, padding, and radius; maximum width 640px with at least 16px viewport margin. Use an accessible dialog and verify focus management, keyboard closing, and background behavior when implemented.

## Spacing and layout

- `--bw-space-*` scale: **4, 8, 12, 16, 24, 32, 48px**. Use the tokens.
- `bw-shell`: maximum width **1320px**, centered, with **24px** padding.
- `bw-header`: white surface, **24px** padding and gap, with a **1px** grey bottom border. Keep the header minimal: logo left and language selector right. Add navigation, search, or account controls only when required by the validated journey. Logo width: **210px**, automatic height.
- Keep at least 16px clear space around the logo as an application convention.
- Mobile breakpoint: up to and including **600px**. Shell, header, and panel padding becomes **16px**; the header may wrap. Do not use fixed-width mobile layouts.
- Verify at minimum 390px and 1440px widths, 200% zoom, and keyboard navigation.

## Search, filters, and editorial cards

- `bw-toolbar` groups one dataset search and its filter action. It wraps vertically on mobile.
- `bw-search` is a light-grey pill that contains a visible label or accessible name, an optional blue icon, and a borderless `bw-input`. Do not duplicate it in the header.
- Use the primary `bw-button` treatment for opening filters. `bw-filter-panel` uses the light-grey background, fine horizontal borders, and simple rectangular controls.
- `bw-card-grid` uses four columns above 1000px, two columns up to 1000px, and one column up to 600px.
- `bw-card` is an editorial grouping with fine horizontal rules, no shadow, and no heavy enclosing border. Use `bw-card__meta` for secondary information.
- `bw-card__action` is a light-blue pill with bold action text. Its optional `bw-card__action-arrow` is a blue circular arrow. Both parts require an accessible link name and must fit French and Dutch without truncation.
- Use tables instead of cards when users need dense comparison across repeated fields.

## Application and verification

Do not modify `src/brand.css`; it is copied from the locked theme. Screens reuse the classes or tokens and do not override brand components. Example: `className="bw-button bw-button--secondary"`.

Run `npm run check:brand`, then tests and build, followed by a documented visual review. Static analysis does not prove actual Roboto rendering, final spacing, or the contrast of custom content.
