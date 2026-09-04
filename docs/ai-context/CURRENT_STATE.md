# État courant

## Application métier

Non définie. Aucun package.json ni code applicatif à la racine.
Le brief vierge est intentionnel. Les exemples sont des références facultatives.

## Framework

Gouvernance issue du src/ V2 promue à la racine. Cadrage intégré, initialisation
neutre, lancement local et validation structurelle fournis.

## Contrôle graphique — 2026-09-04

Règles graphiques obligatoires, empreintes des ressources et contrôle statique
intégrés aux futurs npm run check. Tests de régression du contrôle dans
scripts/check-brand.test.mjs. La revue visuelle métier reste non effectuée.

Vérifié : 17 tests du contrôle graphique réussis, dont valeurs UI et contrastes
des paires de texte (au moins 4.5:1), tests du générateur réussis,
check:brand exécuté avec succès dans une application temporaire générée.
Le build applicatif complet n'a pas été relancé pour cette modification.

UI_SPEC.md définit maintenant les couleurs, Roboto, tailles, espacements, arrondis
et états. Ces conventions sont implémentées dans assets/brand/theme.css.
Roboto n'est pas embarqué : son rendu dépend de sa présence sur le poste.

## Prochaine action utilisateur

Décrire une idée métier en une phrase.

## Vérifications du framework — 2026-09-03

- Validation structurelle et syntaxique : réussie.
- Brief vierge : initialisation bloquée sans écriture.
- Simulation : aucun fichier applicatif créé.
- Brief validé : socle neutre et ressources de marque créés dans une fixture temporaire.
- Réinitialisation : bloquée, contenu existant préservé.
- Parcours conversationnel complet avec un collègue : pas encore évalué.
- Socle neutre : installation, test de rendu serveur, types et build réussis dans une fixture temporaire. Pas d'inspection visuelle navigateur effectuée.
