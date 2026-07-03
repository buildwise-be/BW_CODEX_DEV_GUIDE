# BW Codex Dev Guide

Ce depot centralise les fichiers qui pilotent la maniere dont Codex doit travailler dans les repos de developpement.

L'objectif est simple: versionner une seule source de bonnes pratiques, puis integrer ces fichiers dans chaque repo applicatif qui doit suivre le meme cadre de travail.

## Structure

```text
/
|-- src/                         Fichiers a installer dans les repos cibles
|   |-- AGENTS.md                Regles de travail lues par Codex
|   |-- .github/                 Templates Issue et Pull Request
|   |-- .codex/hooks.json        Hook de demarrage Codex
|   |-- .codex/hooks/            Scripts executes par les hooks
|   `-- docs/ai-context/         Guide et memoire projet pour Codex
`-- scripts/install.ps1          Script d'integration vers un repo cible
```

`src/` est le payload canonique. Toute modification destinee aux repos de dev doit etre faite dans `src/`, puis propagee vers les repos cibles.

## Installer dans un repo cible

Depuis ce depot:

```powershell
.\scripts\install.ps1 -TargetPath C:\chemin\vers\repo-cible -DryRun
.\scripts\install.ps1 -TargetPath C:\chemin\vers\repo-cible
```

Par defaut, le script refuse d'ecraser un fichier cible different. Pour mettre a jour volontairement les fichiers deja presents:

```powershell
.\scripts\install.ps1 -TargetPath C:\chemin\vers\repo-cible -Force
```

## Apres integration

Dans le repo cible, Codex doit ensuite initialiser ou mettre a jour les fichiers de contexte propres au projet:

- `docs/ai-context/PROMPTS.md`
- `docs/ai-context/CURRENT_STATE.md`
- `docs/ai-context/ARCHITECTURE.md`
- `docs/ai-context/DECISIONS.md`
- `docs/ai-context/KNOWN_ISSUES.md`
- `docs/ai-context/CHANGELOG_AI.md`

Ces fichiers sont volontairement specifiques a chaque projet. Le guide commun est versionne ici, mais la memoire concrete du projet doit vivre dans le repo applicatif.

## Workflow recommande

1. Modifier les fichiers communs dans `src/`.
2. Relire l'impact attendu dans les repos cibles.
3. Committer la nouvelle version de ce depot.
4. Installer ou mettre a jour les repos cibles avec `scripts/install.ps1`.
5. Dans chaque repo cible, verifier le `git diff`, adapter le contexte projet, puis commit.

Le principe a garder: Codex peut etre temporaire, mais les regles, decisions et contextes doivent rester dans Git.
