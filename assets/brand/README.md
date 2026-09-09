# Buildwise brand references

Mandatory rules: `docs/ai-governance/BRAND_RULES.md`.

Assets are protected by hashes in `policy.json`. New applications reuse these files and run `scripts/check-brand.mjs`. Do not change a reference asset or its hash without an explicit, documented brand decision.

Official sources reviewed on 2026-09-03:

- https://www.buildwise.be/fr/logos/
- https://www.buildwise.be/assets/images/icons.svg (logo symbol)
- https://www.buildwise.be/assets/css/main.css

The vector logo in `buildwise-logo.svg` was extracted without redrawing its paths. The observed palette is blue `#0087B7`, turquoise `#00BFB6`, text `#1B1B1B`, and light grey `#F2F2F2`. Interface variants are framework adaptations, not additional colors certified by an internal brand guide.

The public website uses Neue Haas Unica. Applications use Roboto, as explicitly requested on 2026-09-04. The local font stack uses Roboto when installed and falls back to Arial or Helvetica; no font file is currently distributed. Exact interface values are documented in `docs/ai-governance/UI_SPEC.md`.

Buildwise must confirm distribution rights for logos and fonts before this template is published publicly. The logo page states usage conditions.

Use the logo on a light background, preserve its proportions, and maintain clear space. Do not filter, distort, recolor, or replace it. The supplied theme is an interface baseline, not a complete brand certification.
