# Buildwise App Builder

Décrivez votre besoin. Codex vous aide à le préciser, puis construit votre application.

## Commencer

1. Clonez ce dépôt sur la branche `codex/business-app-starter` et ouvrez-le à la racine dans Codex.
2. Écrivez votre idée, par exemple : « Je veux suivre les demandes de mon équipe. »
3. Répondez uniquement aux questions métier nécessaires.
4. Validez la première version proposée ; Codex prend en charge sa réalisation et son test local.

Aucun long prompt, fichier à remplir ou choix technique n'est nécessaire.
Codex démarre le dialogue en réponse à votre premier message, pas simplement à l'ouverture du dossier.

## Ce que vous recevez

Une application adaptée à votre mission, une présentation Buildwise, des tests,
une documentation et un lancement local géré par Codex.
L'application n'existe pas encore dans un nouveau clone : elle est créée après votre validation.

## Ce qui reste sous votre contrôle

Le besoin métier, les changements de périmètre, les dépenses, les données privées
et toute publication externe. Le framework ne contourne pas les permissions de Codex.

## Pour la maintenance

La charte est obligatoire : voir [BRAND_RULES.md](docs/ai-governance/BRAND_RULES.md).
Les nouvelles applications exécutent `check:brand` avant leurs tests et leur build.
Une revue visuelle documentée reste requise ; le contrôle statique ne suffit pas
à certifier une conformité complète au site ou à la charte interne.

- `AGENTS.md` : entrée automatique pour Codex.
- `docs/ai-context/` : brief, décisions, avancement et limites.
- `docs/ai-governance/` : méthode héritée de V2 et règles métier.
- `templates/application/` : socle neutre pour la future application.
- `assets/brand/` : références Buildwise réutilisables.
- `examples/projects-kpi/` : exemples facultatifs, pas l'application de l'utilisateur.
- `scripts/validate-framework.ps1` : vérification du framework.
- `scripts/initialize-app.ps1` : initialisation après validation du brief.

Cette branche dérive du contenu `src/` de `codex/v2-framework` (commit
`302aedc`), promu à la racine. Les branches `main` et `codex/v2-framework`
restent intactes. Les anciens scripts de distribution du framework restent
accessibles sur ces branches et dans l'historique Git.

Voir [la méthode](docs/ai-governance/AI_DEVELOPMENT_GUIDE.md) et
[les limites connues](docs/ai-context/KNOWN_ISSUES.md).
