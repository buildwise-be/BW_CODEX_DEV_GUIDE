# Charte Buildwise — règle obligatoire de livraison

## Source de vérité

Lire ce document et assets/brand/README.md avant toute interface.
Les valeurs CSS obligatoires sont détaillées dans `UI_SPEC.md` (couleurs,
Roboto, tailles, espacements, arrondis et états de composants).
Utiliser exclusivement les ressources validées dans assets/brand/ : logo,
theme.css et policy.json. Le site https://www.buildwise.be/fr/ est la référence
visuelle ; il ne constitue pas une charte interne exhaustive.
Les exemples historiques Projets/KPI ne sont PAS une référence graphique.

## Obligations

- Logo officiel fourni, proportions intactes, fond clair et espace libre.
  Aucun logo dessiné, lettre « b » substituée, filtre ou recoloration.
- Palette bleu/turquoise Buildwise, surfaces blanches/grises et texte sombre.
  Toutes les couleurs passent par les variables --bw-* du thème fourni.
  Aucune palette Tailwind concurrente, couleur locale ou dégradé décoratif ajouté.
- Typographie unique --bw-font : Roboto, choix utilisateur pour les applications,
  avec repli Arial/Helvetica déclaré. Aucun import Google Fonts ou
  téléchargement de police propriétaire sans droits vérifiés.
- Réutiliser bw-header, bw-logo, bw-panel, bw-button ; titres sobres,
  hiérarchie claire, espace suffisant, boutons arrondis et focus visible.
- Ne pas transformer l'application en thème sombre ou en design propre au projet.
  Adopter la mise en page métier nécessaire sans modifier l'identité visuelle.
- Les couleurs de statut doivent être ajoutées au thème central après décision
  documentée ; associer toujours un libellé et vérifier le contraste.

## Contrôle obligatoire

`npm run check` doit commencer par `npm run check:brand`.
Le contrôle compare thème et logo aux références verrouillées, vérifie l'import
du thème et recherche les couleurs/polices concurrentes dans src/.
Ne pas supprimer, désactiver ou contourner ce contrôle pour obtenir un succès.
Il s'agit d'une analyse statique conservatrice, pas d'une certification visuelle.

Avant toute livraison UI, inspecter chaque écran principal et les états erreur,
chargement et vide au clavier, sur desktop et mobile. Comparer au site officiel.
Consigner dans docs/ai-context/BRAND_REVIEW.md les écrans, dimensions, preuves,
écarts, statut de la police et corrections. Sans inspection : écrire « non vérifié »,
jamais « conforme ». Une vue rendue côté serveur ne vaut pas inspection visuelle.

## Exceptions

Pour un besoin incompatible avec le thème, expliquer le besoin et obtenir un accord
explicite avant de changer les ressources centrales et leur empreinte dans policy.json.
Noter la source, le motif et l'accord dans DECISIONS.md. Une validation fonctionnelle
ne vaut pas autorisation de modifier la charte. La charte interne Buildwise, si fournie,
prime sur les choix provisoires issus du site public.
