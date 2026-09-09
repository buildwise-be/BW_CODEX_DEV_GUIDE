# Local testing

After approving and building the first version, tell Codex:

> Let me test the application.

Codex prepares the dependencies, verifies the application, starts the local server, and opens the available address when it is ready. You do not need to edit files or know any commands. If the application has not yet been defined, Codex starts with business scoping instead.

Tell Codex `Stop the test` to stop the server started in the current session.

## Maintainer notes

`scripts/start-local.ps1` starts only the package at the repository root, uses port 5173 strictly, and binds to `127.0.0.1`. `scripts/check-local.ps1` verifies the application.
