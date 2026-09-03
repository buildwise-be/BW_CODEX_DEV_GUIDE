# BW App Starter

Starter Buildwise pour créer des applications métier avec l’aide de Codex.

## Démarrer

1. Ouvrir ce dépôt dans Codex.
2. Décrire le besoin dans `docs/ai-context/BUSINESS_BRIEF.md` ou directement dans la conversation.
3. Lancer l’application avec `npm install`, puis `npm run dev`.
4. Demander à Codex de construire une première version limitée.

Le projet contient deux exemples autonomes : **Suivi des projets** et **Dashboard KPI**. Ils utilisent des données de démonstration clairement séparées de l’interface.

## Tester localement depuis Codex

Demander simplement à Codex :

> Lance l’application pour que je puisse la tester.

Codex prépare le projet si nécessaire, démarre l’application et ouvre la
prévisualisation locale. Le parcours détaillé se trouve dans
`docs/LOCAL_TESTING.md`.

## Parler à Codex

Commencer par le résultat métier : qui doit prendre quelle décision, avec quelles informations et à quel moment ? Codex reformule le besoin avant de modifier le projet. Les détails techniques sont documentés automatiquement mais ne sont pas nécessaires pour démarrer.

Exemple :

> Je veux aider les chefs de projet à repérer les projets en retard et à préparer leur prochaine action.

## Commandes utiles

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
