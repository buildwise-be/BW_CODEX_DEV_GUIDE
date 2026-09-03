# Méthode de construction Buildwise

## Origine et responsabilités

Ce profil promeut le contenu src/ du framework V2 à la racine et adapte son
workflow à un public métier. Il conserve sa séparation :
gouvernance, mémoire humaine (docs/ai-context/) et faits techniques (docs/wiki/).
Git reste la mémoire durable. Aucun service, compte API ou hook n'est requis
pour démarrer le dialogue dans Codex.

## Étapes

1. **Cadrage** : brief « À définir ». Comprendre la mission, les utilisateurs,
   les informations, le résultat attendu et les limites. Questions courtes,
   une à la fois, seulement si la réponse change la première version.
2. **Validation** : résumer le parcours prioritaire et 3 à 5 capacités maximum ;
   demander l'accord métier. Noter l'accord dans DECISIONS.md, passer le brief à « Validé ».
3. **Construction** : initialize-app.ps1 crée un socle neutre sans écraser une
   application existante. Codex implémente le besoin validé avec la stack standard,
   des tests et la documentation. L'initialisation seule n'est pas une livraison.
4. **Vérification** : contrôler les critères métier, erreurs, données vides,
   chargement, navigation clavier, petits écrans, types, tests et compilation.
   Corriger les échecs dans le périmètre approuvé.
5. **Essai local** : lancer avec start-local.ps1, attendre que le serveur réponde,
   ouvrir l'adresse disponible et proposer des tâches métier à essayer.
6. **Itération** : recueillir le retour, ajuster le besoin et les critères ;
   une extension importante exige une nouvelle validation.

## Autonomie et sécurité

L'utilisateur choisit le résultat métier, Codex prend les décisions techniques
ordinaires et poursuit jusqu'à une version vérifiée ou un blocage explicite.
Ne pas demander une approbation à chaque fichier ou commande courante.
Respecter toutefois les permissions de l'environnement et les autorisations
requises pour les dépenses, publications, données privées et opérations risquées.
Ne pas activer automatiquement les hooks, installer Node globalement ou publier
le dépôt. Les scripts locaux n'ouvrent pas le réseau : serveur lié à 127.0.0.1.

## Qualité et mémoire

Lire les checklists FEATURE_CHECKLIST.md et VALIDATION_CHECKLIST.md.
Privilégier simplicité, code lisible, petits composants, données séparées,
tests des règles métier, messages d'erreur utiles et branding centralisé.
L'application choisit un contrat de données adapté au brief ; les mocks sont
remplaçables et étiquetés. Ne pas intégrer les exemples métier sans pertinence.

Mettre à jour CURRENT_STATE.md après chaque livraison : capacités réelles,
preuves de contrôle, prochaine action. DECISIONS.md garde les accords,
KNOWN_ISSUES.md les limites et CHANGELOG_AI.md les livraisons.
Ne pas transformer un résultat non vérifié en succès dans la documentation.

## Détection et reprise

AGENTS.md est placé à la racine pour être découvert par Codex.
Le hook historique V2 est optionnel ; sa présence ne garantit pas son exécution.
Après interruption, relire brief et état courant, inspecter les fichiers :
ne pas réinitialiser une application déjà créée.
Un brief validé et un package.json ne prouvent pas que l'application est terminée.

## Sources

- Base V2 : commit 302aedc de codex/v2-framework.
- Instructions Codex : https://learn.chatgpt.com/docs/agent-configuration/agents-md
