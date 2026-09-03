# Buildwise Business App Starter

## Mission

Construire des applications simples qui aident une personne à accomplir une mission métier. L’utilisateur peut ne pas connaître le développement logiciel : les demandes et les réponses doivent donc être formulées autour du besoin, du résultat et de la décision à prendre.

## Démarrage obligatoire

Avant toute modification, lire :

- `docs/ai-context/BUSINESS_BRIEF.md`
- `docs/ai-context/FEATURE_CHECKLIST.md`
- `docs/ai-context/VALIDATION_CHECKLIST.md`

## Cadrage automatique d'une nouvelle application

Lire le champ `État` de `docs/ai-context/BUSINESS_BRIEF.md` avant toute autre
action. Quand sa valeur est `À définir`, l'application métier n'existe pas
encore : ne pas lancer l'exemple et ne pas commencer le développement.

L'utilisateur n'a pas à connaître les fichiers du starter ni à fournir un
prompt préparatoire. Une phrase comme « Je veux une application pour suivre
mes demandes » doit suffire.

Dans ce cas :

1. Commencer directement par la question métier la plus utile : « Qui utilisera
   l'application et que doit-il pouvoir faire plus facilement ? »
2. Poser une seule question à la fois, en langage courant.
3. Déduire ce qui peut l'être et ne demander que les informations qui changent
   réellement la première version.
4. Couvrir au minimum l'utilisateur, la mission, les informations nécessaires,
   le résultat attendu, la priorité et le hors-périmètre.
5. Reformuler en une mission courte et proposer une première version de trois à
   cinq capacités maximum.
6. Demander une validation métier explicite.
7. Après validation, compléter le brief, remplacer `État : À définir` par
   `État : Validé`, puis seulement commencer le développement.

Ne jamais demander à l'utilisateur de modifier lui-même le brief ou de choisir
une technologie.

## Workflow Codex

1. Vérifier que le brief métier est validé.
2. Reformuler la demande en langage métier.
3. Identifier l’utilisateur, le problème et le résultat attendu.
4. Proposer une première version limitée et vérifiable.
5. Poser seulement les questions fonctionnelles indispensables.
6. Construire la fonctionnalité avec les composants existants.
7. Vérifier les états normal, chargement, erreur et absence de données.
8. Vérifier le rendu responsive et la cohérence Buildwise.
9. Mettre à jour la documentation et les critères de validation.
10. Résumer ce qui est livré, ce qui reste à décider et la prochaine action.

## Test local pour un utilisateur métier

Quand l’utilisateur demande à tester ou à voir l’application :

1. Exécuter `scripts/start-local.ps1` dans un terminal persistant.
2. Attendre que l’adresse locale soit disponible.
3. Ouvrir `http://localhost:5173` dans la prévisualisation Codex.
4. Présenter les missions à tester, sans détailler les commandes techniques.

Quand il demande d’arrêter le test, interrompre le processus de développement.

## Règles de qualité

- Préférer la solution la plus simple qui répond au besoin.
- Ne pas ajouter de fonctionnalité sans justification métier.
- Réutiliser les composants avant d’en créer de nouveaux.
- Garder l’interface, la logique métier et les données séparées.
- Utiliser l’adaptateur de données plutôt que d’appeler une source depuis un composant d’interface.
- Présenter les erreurs avec un message compréhensible.
- Garder les données fictives identifiables et remplaçables.
- Documenter les règles métier et non seulement les choix techniques.
- Ajouter ou mettre à jour les tests pour les comportements importants.

## Réponse attendue

Chaque livraison doit commencer par le résultat obtenu. Elle doit ensuite indiquer les décisions métier, les points à valider, les limites connues et la prochaine étape. Ne pas noyer l’utilisateur dans les détails d’implémentation.
