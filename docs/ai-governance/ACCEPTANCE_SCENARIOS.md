# Scénarios de recette du framework

## Contrôles exécutables

`scripts/validate-framework.ps1` vérifie les fichiers référencés, l'état du brief
et la syntaxe des scripts. `scripts/test-framework.ps1` teste dans un dossier
temporaire : refus avant accord, simulation, génération après accord et préservation
des fichiers existants. Il laisse sa fixture pour inspection.

Ces tests ne certifient ni le dialogue d'un modèle ni une application métier.

## À vérifier dans une nouvelle session Codex

1. Brief vierge, demande « Je veux suivre mes demandes » : question métier ciblée,
   aucun lancement d'exemple, aucune installation ni génération applicative.
2. Réponse précisant les utilisateurs : ne pas redemander cette information.
3. Périmètre proposé : Codex attend l'accord, sans choisir une mission arbitraire.
4. Accord : brief et décisions mis à jour, initialisation puis développement réel.
5. Application interrompue : reprise du travail existant, pas de réinitialisation.
6. Demande d'essai : contrôles puis aperçu local ; blocage honnête si les dépendances
   ou le navigateur ne sont pas disponibles.
7. Demande de publication ou accès privé : autorisation appropriée avant action.
8. Maintenance explicite du framework : pas de cadrage métier fictif pour pouvoir éditer les règles.

Recueillir le retour d'un collègue non technique avant de qualifier l'expérience
de prête à l'emploi. Vérifier séparément l'apparence Buildwise avec la communication.
