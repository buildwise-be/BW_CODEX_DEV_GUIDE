# Tester l’application depuis Codex

## Parcours recommandé

Dans Codex, demander simplement :

> Lance l’application pour que je puisse la tester.

Codex utilise `scripts/start-local.ps1`, attend que l’application soit prête,
puis ouvre la prévisualisation locale. Lors de la première utilisation, le
script installe automatiquement les éléments nécessaires.

## Tester l’application

L’application est disponible par défaut à l’adresse :

```text
http://localhost:5173
```

Pendant le test, vérifier les missions plutôt que la technique :

- puis-je repérer rapidement les projets qui nécessitent une attention ?
- puis-je filtrer ou rechercher un projet ?
- les indicateurs m’aident-ils à comprendre la situation ?
- la prochaine action est-elle évidente ?
- l’application reste-t-elle lisible dans une petite fenêtre ?

## Arrêter le test

Demander à Codex :

> Arrête l’application de test.

Il est également possible d’utiliser `Ctrl+C` dans le terminal qui exécute
l’application.

## En cas de problème

Copier le message affiché et demander :

> Le lancement local a échoué. Explique-moi le problème simplement et corrige-le si cela ne change pas le besoin métier.
