# Buildwise App Builder

Turn a business need into a testable Buildwise application with Codex. No application is predefined in a fresh clone: Codex first helps you define a focused first version, then builds and verifies it after your approval.

## Start in Codex

1. Create a new project from this repository on branch `codex/business-app-starter`.
2. Open the project root in Codex.
3. Describe the outcome you want in one sentence, for example:

   > I want our team to track requests and know which ones need attention.

4. Answer the short business questions Codex asks. You do not need to choose a technical stack or edit a configuration file.
5. Review the proposed first version. Codex starts development only after you approve its scope.
6. When the application is ready, ask: `Let me test the application.` Codex verifies it, starts it locally, and opens the preview.

Codex automatically reads the project brief and existing decisions. It should ask only for information that changes the business outcome, priority, or scope.

## What Codex will clarify

Codex focuses the conversation on:

- who will use the application;
- the problem to solve;
- the decisions or actions to make easier;
- the information required;
- the expected result and success criteria;
- the priorities and explicit exclusions.

It then proposes one primary journey with three to five capabilities. The approved mission is recorded in `docs/ai-context/BUSINESS_BRIEF.md` before implementation begins.

## What the generated application includes

- React, TypeScript, Vite, and Tailwind CSS;
- reusable Buildwise interface components and centralized brand tokens;
- French and Dutch on every journey, with searchable translation catalogs;
- local demonstration data behind a replaceable data adapter;
- loading, empty, error, and valid-data states;
- responsive and keyboard-accessible screens;
- tests for important business behavior;
- durable documentation of scope, decisions, progress, and known limits;
- a simple local preview managed from Codex.

French and Dutch are application requirements even though all framework documentation is maintained in English.

## What remains under your control

You approve the business scope and any material change to it. Codex must also ask before external publication, spending, new access to private data, or other sensitive operations. It does not bypass Codex permissions.

## Try the optional examples

`examples/projects-kpi/` contains project-tracking and KPI demonstration views. They illustrate possible patterns; they are not your application and are never selected automatically.

## Framework map

| Location | Purpose |
| --- | --- |
| `AGENTS.md` | Entry point automatically read by Codex |
| `docs/ai-governance/` | Business-first workflow, coding, brand, and language rules |
| `docs/ai-context/` | Business brief, decisions, current state, reviews, and limits |
| `templates/application/` | Neutral application shell created after scope approval |
| `templates/wiki/` | English templates for observed technical documentation |
| `assets/brand/` | Reusable Buildwise logo, theme, and brand policy |
| `examples/projects-kpi/` | Optional demonstrations, not the generated application |
| `scripts/initialize-app.ps1` | Creates the neutral application without overwriting existing work |
| `scripts/start-local.ps1` | Starts only the application at the repository root |
| `scripts/validate-framework.ps1` | Validates framework structure and contracts |

The root `src/` directory is intentionally absent in a fresh clone and is created only after the business scope is approved. `schema/` and `starter/` are not part of the tracked framework; if they appear locally as empty directories, they are harmless workspace remnants and will not appear in a new clone.

## Maintainer workflow

Framework maintenance is allowed while the business brief is still undefined. Validate changes with:

```powershell
./scripts/validate-framework.ps1
./scripts/test-framework.ps1
```

Generated applications must run `npm run check`, which checks translations and branding before tests and build. A documented visual and linguistic review is still required because static checks cannot certify the final experience.

This branch was created from the `src/` content of `codex/v2-framework` at commit `302aedc`, promoted to the repository root. The `main` and `codex/v2-framework` branches remain unchanged.

See the [development method](docs/ai-governance/AI_DEVELOPMENT_GUIDE.md), [local testing guide](docs/LOCAL_TESTING.md), and [known limitations](docs/ai-context/KNOWN_ISSUES.md).
