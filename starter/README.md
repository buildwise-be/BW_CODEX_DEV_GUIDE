# BW App Starter

Starter Buildwise pour créer des applications métier avec l’aide de Codex.

## Démarrer

1. Ouvrir ce dépôt dans Codex.
2. Dire en une phrase ce que l'application devrait permettre de faire.
3. Répondre aux quelques questions métier posées par Codex.
4. Valider la mission et la première version proposées.
5. Laisser Codex construire puis lancer l'application pour la tester.

Exemple de premier message :

> Je veux une application pour mieux suivre les demandes de mon équipe.

Il n'est pas nécessaire de connaître la technologie, les fichiers du projet ou
les commandes de lancement. Codex conduit le cadrage et prépare le projet.

Le projet contient deux exemples autonomes : **Suivi des projets** et **Dashboard KPI**. Ils utilisent des données de démonstration clairement séparées de l’interface.

## Tester localement depuis Codex

Demander simplement à Codex :

> Lance l’application pour que je puisse la tester.

Codex prépare le projet si nécessaire, démarre l’application et ouvre la
prévisualisation locale. Le parcours détaillé se trouve dans
`docs/LOCAL_TESTING.md`.

## Décrire le besoin

Commencer par le résultat métier. Codex demandera qui utilisera l'application,
ce qui doit devenir plus simple et comment reconnaître un résultat réussi. Il
reformule la mission et attend une validation avant de développer.

Exemple :

> Je veux aider les chefs de projet à repérer les projets en retard et à préparer leur prochaine action.

## Informations pour la maintenance

```text
npm install     Installer les dépendances
npm run dev     Ouvrir l’application en développement
npm run build   Vérifier la compilation de production
npm test        Exécuter les tests
npm run check   Vérifier les tests et la compilation
```

## Contrat de données

L’interface dépend de `BusinessDataAdapter` dans `src/data/adapters.ts`. Les données de démonstration peuvent être remplacées par une API sans réécrire les écrans.

## Statut

Ce dépôt est un pilote. Les intégrations Buildwise réelles, l’authentification avancée et le déploiement d’entreprise ne sont pas inclus dans cette première version.
