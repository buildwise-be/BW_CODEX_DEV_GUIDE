# Essai local

Après validation et construction de votre première version, dites :

> Je veux tester mon application.

Codex prépare les dépendances, lance le serveur local et ouvre son adresse une fois prêt.
Aucun fichier à modifier ni commande à connaître. Avant la construction, il commence par le cadrage.
Dites « Arrête le test » pour arrêter le serveur de votre session.

Maintenance : scripts/start-local.ps1 lance uniquement le package à la racine,
avec le port 5173 strict et l'écoute 127.0.0.1. scripts/check-local.ps1 vérifie l'application.
