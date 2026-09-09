# Language rules — French and Dutch are mandatory

## Minimum contract

Every generated application supports at least `fr` and `nl`. A feature is not complete until its labels, help, errors, empty states, notifications, accessibility text, and titles exist in both languages.

French is the fallback language. On first display, select Dutch when browser preferences begin with `nl`; otherwise select French. An explicit user choice is stored locally and takes precedence. The HTML document language and title must follow the active language.

## Structure and search

```text
src/i18n/
├── index.ts
└── messages/
    ├── fr.json
    └── nl.json
```

Use flat, stable, business-oriented keys such as `projects.empty.title`, `request.form.submit`, and `common.cancel`. Never use the French sentence as the key. To find a translation:

```text
rg '"projects.empty.title"' src/i18n/messages
```

A component imports `t` and uses `t("key", language)`. Do not hard-code visible text in JSX, except proper names, data values, and explicitly accepted abbreviations such as `Buildwise`, `FR`, and `NL`. Do not construct sentences by concatenation; create a complete parameterized translation when necessary.

## Translation quality

- Write natural language rather than translating word for word, while preserving the business meaning.
- Keep the exact same key set in French and Dutch and leave no value empty.
- Translate plurals, dates, numbers, and error messages. Use `Intl` with the active locale and do not store formatted numbers.
- Allow for longer Dutch text so buttons and columns do not truncate meaning.
- Keep the language selector keyboard-accessible and announce the active language.
- Never translate user-entered data automatically.

## Checks

Run `npm run check:i18n` before the brand check, tests, and build. It validates catalogs and detects obvious hard-coded JSX text. Never disable it or add a workaround merely to pass a delivery.

Static analysis does not validate linguistic accuracy. Test every journey visually in French and Dutch and record the result in `docs/ai-context/I18N_REVIEW.md`.

A third language may be added under the same contract, but French and Dutch cannot be removed without an explicit framework-level decision.
