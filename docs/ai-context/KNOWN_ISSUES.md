# Known limitations

- Business scoping is an instruction followed by Codex, not a standalone engine. A first message and an active session are required.
- End-to-end generation still needs evaluation with a non-technical colleague and a real business brief.
- A previous example dependency installation was interrupted, so its build and tests are not certified.
- The neutral shell has pinned versions and a lockfile. Compilation and server rendering were verified in a temporary fixture. Future business rules need their own tests.
- Applications request Roboto but do not bundle it. They use locally installed Roboto or fall back to Arial/Helvetica. Identical Roboto rendering on every workstation requires licensed local font files.
- Branding is based on public resources rather than a complete, validated internal brand guide.
- The French/Dutch checker detects incomplete catalogs, empty values, and obvious hard-coded JSX text or attributes. It does not guarantee linguistic quality, complex plurals, or dynamically generated text.
- Authentication, external hosting, and access to internal data are outside the pilot.
