# Règles de codage

## Simplicité et structure

Stack par défaut : React, TypeScript strict, Vite, Tailwind.
Éviter les frameworks ou dépendances supplémentaires sans nécessité concrète.
Pas d'architecture générique anticipant des besoins non validés.

Le code applicatif est créé dans src/ après accord :
- composants UI petits et réutilisables ;
- fonctionnalités métier regroupées par mission ;
- règles/calculs métier séparés et testables ;
- accès aux données derrière un contrat adapté au brief, jamais dispersé dans les vues.

Ne pas copier un exemple entier sans pertinence métier. Exclure les exemples
de la compilation de l'application. Reprendre les composants nécessaires seulement.
Nommer clairement, documenter les intentions et contraintes ; éviter les commentaires
qui répètent le code. Garder les fichiers lisibles et formatés.

## Données, interactions et sécurité

Données fictives clairement indiquées, pas de faux indicateurs présentés comme réels.
Prévoir chargement, absence de données, erreur et reprise.
Valider les saisies ; ne jamais stocker secrets ou données privées dans le client ou Git.
Ne pas inventer une authentification sécurisée à partir d'un simple écran de connexion.
Utiliser un adaptateur asynchrone pour remplacer les mocks par une source réelle.

## Présentation Buildwise

Lire assets/brand/README.md. Réutiliser logo et tokens fournis ; ne pas recréer
le logo ni utiliser une palette de marque improvisée.
Polices locales ou fichiers avec droits vérifiés, pas de dépendance réseau visuelle.
Contrastes lisibles, libellés accessibles, clavier, focus visible, petits écrans.
Les couleurs de statut ne remplacent jamais les libellés.

## Installation et lancement

Initialiser le socle avec scripts/initialize-app.ps1 après validation métier.
Vérifier les versions compatibles des dépendances ; créer et versionner le lockfile.
Préférer npm ci une fois le lockfile présent. Ne pas installer d'outils globaux sans accord.
Utiliser start-local.ps1 pour l'application racine, jamais automatiquement examples/.
Attendre l'adresse réellement disponible ; ouvrir l'aperçu avec l'outil Codex si disponible.
Ne pas ouvrir un port public : écoute locale 127.0.0.1. Arrêter seulement son propre serveur.

## Vérification et documentation

Ajouter des tests des règles métier, composants et parcours critiques selon le risque.
Exécuter npm run check (tests, types, build). Tester le navigateur si disponible.
Corriger les régressions avant livraison ; sinon documenter précisément le blocage.
Mettre à jour état, décisions, limites et checklist métier.
Pour docs/wiki/, lire WIKI_REFRESH_GUIDE.md et ne décrire que des faits observés.
Les changements purement framework se vérifient avec scripts/validate-framework.ps1
et scripts/test-framework.ps1, sans fabriquer une application métier.
