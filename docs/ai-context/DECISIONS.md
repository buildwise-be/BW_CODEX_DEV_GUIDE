# Décisions

## Structure du framework — 2026-09-03

À la demande de l'utilisateur, cette branche part du contenu src/ de la V2,
installé à la racine. Le futur src/ contiendra uniquement le code métier.
Les exemples Projets/KPI sont déplacés sous examples/ ; ils n'imposent pas de mission.

## 2026-09-04 — Charte obligatoire

À la demande de l'utilisateur, logo et thème Buildwise sont verrouillés par
empreinte. Contrôle statique bloquant avant tests/build, interdiction des palettes
et polices concurrentes, revue visuelle obligatoire et exceptions soumises à accord.
Les sources publiques ne remplacent pas une charte interne validée ; le repli de
police reste explicitement signalé.

## 2026-09-04 — Spécifications UI et Roboto

Demande explicite de l'utilisateur : écrire couleurs, arrondis, tailles et Roboto.
Roboto remplace donc la pile Neue Haas Unica pour les applications uniquement.
Boutons pilule 999px/48px, champs 8px/48px, cartes 16px ; valeurs et états
documentés dans UI_SPEC.md et implémentés dans le thème central.
Ces conventions ne sont pas présentées comme une charte interne officielle.
L'empreinte du thème est mise à jour pour ce changement autorisé.

## 2026-09-07 — Français et néerlandais obligatoires

Chaque application prévoit au minimum FR et NL dès son initialisation. Catalogues
JSON centralisés à clés stables, français de repli, détection navigateur,
préférence persistée, sélecteur accessible et contrôle bloquant avant livraison.
La revue linguistique humaine reste obligatoire dans I18N_REVIEW.md.

## Application métier — validation

Aucun périmètre validé. Consigner ici le premier accord avant de modifier l'état du brief.
