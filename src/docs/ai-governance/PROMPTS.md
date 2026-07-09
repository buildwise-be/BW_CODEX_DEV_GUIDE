# Prompts

Reusable prompts for consistent Codex work.

These prompts are framework-managed. Project-specific prompts can be added to a
separate project-owned file if a repository needs them.

## New Session

```text
Read AGENTS.md, docs/ai-governance/AI_DEVELOPMENT_GUIDE.md, and the required
project memory files under docs/ai-context/.

If docs/wiki/ exists, read the pages relevant to this task.

Inspect the current Git branch and compare it with main.
Summarize your understanding, identify risks and ambiguities, and propose a
step-by-step plan.

Do not modify files until I approve the plan.
Clearly separate observed facts from assumptions.
```

## Analyze Existing Repository

```text
Analyze the repository without modifying code.

Identify:
- source layout;
- main modules;
- build and test commands;
- configuration model;
- public APIs;
- domain concepts visible in code;
- important data flows;
- external dependencies;
- fragile areas.

Separate information that can be inferred from the repository from information
that requires human intent or decision history.

Propose updates for docs/wiki/ and docs/ai-context/ separately.
```

## Documentation Check

```text
Review the current changes and decide whether documentation needs updates.

Check:
- docs/ai-context/CURRENT_STATE.md;
- docs/ai-context/DECISIONS.md;
- docs/ai-context/ROADMAP.md;
- docs/ai-context/KNOWN_ISSUES.md;
- docs/ai-context/CHANGELOG_AI.md;
- docs/wiki/ if generated technical knowledge is present;
- README.md.

For each file, state whether an update is needed and why.
Do not modify documentation until I approve.
```

## Refresh Technical Wiki

```text
Refresh docs/wiki/ from repository facts only.

Read docs/ai-governance/WIKI_REFRESH_GUIDE.md first.

Do not include future plans, preferences, undocumented assumptions, or desired
architecture in docs/wiki/.

If you discover human decisions, risks, or roadmap items, propose updates under
docs/ai-context/ instead.
```

## Prepare Pull Request

```text
Prepare the Pull Request for this branch.

Review the diff against main.

Write a PR description including:
- summary;
- motivation;
- key changes;
- tests performed;
- documentation updates;
- risks and limitations;
- follow-up work;
- related Issue.

Do not invent completed tests. If a test was not run, say so explicitly.
```

## Finish Mission

```text
Verify that the Issue objectives are covered, tests and documentation are
complete, no unrelated changes remain, and the branch is ready for Pull
Request.

Produce:
- final summary;
- tests performed;
- risks and limitations;
- follow-up Issues recommended;
- PR description draft.
```
