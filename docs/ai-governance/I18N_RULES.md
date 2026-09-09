# Règles linguistiques — français et néerlandais obligatoires

## Contrat minimal

Toute application générée propose au minimum `fr` et `nl`. Aucune fonctionnalité
n'est terminée tant que ses libellés, aides, erreurs, états vides, notifications,
textes d'accessibilité et titres existent dans les deux langues.

Le français est la langue de repli. Au premier affichage, l'application choisit
le néerlandais si les préférences du navigateur commencent par `nl`, sinon le
français. Le choix explicite de l'utilisateur est conservé localement et prime.
Le document HTML et son titre doivent suivre la langue active.

## Structure et recherche

```text
src/i18n/
├── index.ts
└── messages/
    ├── fr.json
    └── nl.json
```

Utiliser des clés plates, stables et métier : `projects.empty.title`,
`request.form.submit`, `common.cancel`. Ne jamais utiliser la phrase française
comme clé. Pour retrouver une traduction :

```text
rg '"projects.empty.title"' src/i18n/messages
```

Un composant importe `t` et utilise `t("clé", langue)`. Aucun texte visible en
dur dans JSX, sauf noms propres, valeurs issues des données et abréviations
explicitement acceptées (`Buildwise`, `FR`, `NL`). Ne pas construire une phrase
par concaténation : créer une traduction complète avec paramètres si nécessaire.

## Qualité des traductions

- Rédiger dans la langue naturelle, pas mot à mot ; conserver le même sens métier.
- Même ensemble exact de clés dans FR et NL, aucune valeur vide.
- Traduire aussi pluriels, dates, nombres et messages d'erreur ; utiliser `Intl`
  avec la locale active pour les formats, sans stocker des nombres formatés.
- Prévoir l'allongement néerlandais : boutons et colonnes ne tronquent pas le sens.
- Le sélecteur de langue reste accessible au clavier et annonce la langue active.
- Les données utilisateur ne sont jamais traduites automatiquement.

## Contrôle

`npm run check:i18n` s'exécute avant le contrôle graphique, les tests et le build.
Il vérifie les catalogues et recherche les textes JSX évidents en dur. Ne jamais
le désactiver ou ajouter un contournement pour faire passer une livraison.
Cette analyse statique ne valide pas la justesse linguistique : chaque parcours
doit être testé visuellement en FR et NL, avec résultat noté dans
`docs/ai-context/I18N_REVIEW.md`.

Une troisième langue peut être ajoutée avec le même contrat, mais FR et NL ne
peuvent jamais être retirés sans décision explicite au niveau du framework.
