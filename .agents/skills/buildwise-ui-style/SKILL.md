---
name: buildwise-ui-style
description: Apply this repository's Buildwise visual system when creating, changing, or reviewing an application interface, unless the user explicitly requests another visual direction.
---

# Buildwise UI style

Use the repository's portable Buildwise visual system for every interface task by default.

Before changing or reviewing an interface, read:

1. [`docs/ai-context/BUILDWISE_UI_REQUIREMENTS.md`](../../../docs/ai-context/BUILDWISE_UI_REQUIREMENTS.md)
2. [`docs/ai-governance/UI_SPEC.md`](../../../docs/ai-governance/UI_SPEC.md)
3. [`docs/ai-governance/BRAND_RULES.md`](../../../docs/ai-governance/BRAND_RULES.md)

Use the locked assets and tokens under `assets/brand/`. Apply the required header, responsive layout, search, filter, card, action, typography, language, and accessibility patterns only where they support the validated business journey.

Keep the application's own approved mission and content. Do not copy Buildwise website content, photography, or navigation labels into the application. Do not infer Buildwise affiliation for a third-party product.

An explicit user request for another visual direction overrides this default. Record a material visual exception in `docs/ai-context/DECISIONS.md` and describe its effect in `BRAND_REVIEW.md`.

Before delivery, run the brand check and visually inspect the relevant screens and states at the required desktop and mobile sizes. Static checks alone do not establish visual compliance.
