# Spécifications UI / CSS — applications Buildwise

Version 1 — 2026-09-04. Source exécutable : `assets/brand/theme.css`.
Cette spécification est obligatoire pour les applications générées.

## Origine des choix

Bleu, turquoise, texte sombre, gris clair et logo proviennent des références
publiques de buildwise.be listées dans assets/brand/README.md.
Roboto est demandé explicitement par l'utilisateur pour les applications : ce
n'est pas la police Neue Haas Unica observée sur le site public.
Les tailles, espacements, arrondis et états ci-dessous sont des conventions du
framework, pas des valeurs certifiées par une charte interne Buildwise.

## Couleurs

| Usage / variable CSS | Valeur | Règle |
| --- | --- | --- |
| Bleu de marque `--bw-blue` | `#0087B7` | Identité et accents, pas petit texte blanc par défaut |
| Turquoise `--bw-turquoise` | `#00BFB6` | Accent décoratif, jamais seul pour exprimer un statut |
| Action `--bw-action` | `#00739C` | Bouton principal, liens et focus ; variante d'interface plus sombre |
| Survol action `--bw-action-hover` | `#005E80` | État hover |
| Texte `--bw-text` | `#1B1B1B` | Texte principal |
| Texte secondaire `--bw-muted` | `#595959` | Aides, légendes, placeholder |
| Surface `--bw-surface` | `#FFFFFF` | Cartes, champs et en-tête |
| Fond `--bw-background` | `#F2F2F2` | Page et en-têtes de tableau |
| Séparation `--bw-border` | `#D9D9D9` | Séparateurs décoratifs, pas seule limite des champs |
| Bordure champ `--bw-input-border` | `#767676` | Contour perceptible sur blanc |
| Désactivé `--bw-disabled-bg` / `--bw-disabled-text` | `#E6E6E6` / `#595959` | Pas d'opacité globale réduisant tous les contrastes |
| Information `--bw-info-bg` | `#E0F7FF` | Fond léger, texte action |
| Succès `--bw-success` / `--bw-success-bg` | `#176543` / `#EAF5EF` | Libellé obligatoire |
| Avertissement `--bw-warning` / `--bw-warning-bg` | `#805500` / `#FFF4D6` | Libellé obligatoire |
| Erreur `--bw-danger` / `--bw-danger-bg` | `#B42318` / `#FFF0EE` | Libellé et aide à la correction |
| Survol danger `--bw-danger-hover` | `#912018` | Actions destructrices seulement |

Les couleurs fonctionnelles sont des choix d'application, pas une extension
affirmée de la palette institutionnelle. Interdiction des valeurs couleur locales
dans les écrans : utiliser `var(--bw-...)`. Pas de dégradé ou de thème sombre.

## Typographie

- Police : `--bw-font: "Roboto", Arial, Helvetica, sans-serif`.
- Chargement actuel : Roboto installé localement ; sinon Arial/Helvetica. Aucun
  fichier Roboto n'est embarqué : ne pas prétendre que son rendu est garanti sur
  un poste neuf. Pour un rendu identique partout, prévoir une livraison locale
  WOFF2 avec licence et provenance, puis valider et verrouiller cette ressource.
- Aucun appel Google Fonts ou CDN au moment du rendu.
- Corps : 16px / interligne 1.5, graisse 400.
- Aide, légende, badge : 14px / 1.5, pas de texte métier inférieur à 14px.
- Introduction : 18px / 1.5 via `--bw-text-lg`.
- H1 : 32px desktop, 24px mobile ; H2 : 24px ; H3 : 20px.
- Titres : graisse 700, interligne 1.2. Labels et badges : 500.
- Base 16px ; tailles typographiques en rem pour respecter le zoom utilisateur.

## Boutons

| Variante | Classes | Dimensions / style |
| --- | --- | --- |
| Principal | `bw-button` | Hauteur minimale 48px, padding 12px 24px, rayon **999px**, Roboto 16px/700, texte blanc sur action |
| Secondaire | `bw-button bw-button--secondary` | Fond blanc, bordure 1px action, texte action ; mêmes dimensions |
| Danger | `bw-button bw-button--danger` | Fond danger, texte blanc ; uniquement une action destructive |
| Compact | `bw-button bw-button--compact` | 40px minimum, padding 8px 16px, 14px ; revient à 48px sur mobile |
| Désactivé | Attribut natif `disabled` | Fond disabled-bg, texte disabled-text, curseur not-allowed |

Largeur selon le libellé, texte jamais tronqué, retour à la ligne permis.
Icône éventuelle 20px, intervalle 8px ; icône seule avec nom accessible et
cible minimale 48 × 48px. Le style compact n'est pas utilisé pour une icône seule.
Chargement : garder le libellé et les dimensions, `aria-busy`, éviter le double clic.
Focus : contour action **3px**, décalage **3px**, jamais supprimé.
Transition couleur/bordure : **120ms**, aucune sous `prefers-reduced-motion`.

## Champs, cartes, badges et tableaux

- `bw-input` : hauteur minimale **48px**, padding **12px 16px**, rayon **8px**,
  bordure **1px** input-border, fond blanc, texte 16px. Utilisable sur input,
  select et textarea (textarea peut être plus haut).
- `bw-field`, `bw-label`, `bw-hint`, `bw-error` : label visible, intervalle 8px,
  aide/erreur 14px. `aria-invalid="true"` colore la bordure, ne remplace pas
  un message lié au champ par `aria-describedby`.
- `bw-panel` : rayon **16px**, padding **24px**, bordure **1px**, fond blanc,
  aucune ombre par défaut. Padding mobile 16px.
- `bw-badge` : rayon **999px**, padding **4px 12px**, texte 14px/500 ; variantes
  `bw-badge--success`, `--warning`, `--danger`. Ne pas faire clignoter un statut.
- `bw-table` dans `bw-table-wrap` : cellules **12px 16px**, séparateurs 1px,
  en-tête gris clair/700. Défilement horizontal dans le tableau, pas dans la page.
- Fenêtre modale : surface/padding/rayon de carte, largeur max 640px avec marge
  viewport de 16px minimum. Utiliser un dialogue accessible ; gestion focus,
  fermeture clavier et arrière-plan à valider lors de son implémentation.

## Espacements et mise en page

- Échelle `--bw-space-*` : **4, 8, 12, 16, 24, 32, 48px** ; utiliser les tokens.
- `bw-shell` : largeur max **1100px**, centré, padding **24px**.
- `bw-header` : surface blanche, padding et gap **24px**, accent inférieur
  turquoise **4px**. Logo : **210px** de large, hauteur automatique.
- Espace libre autour du logo : au moins 16px (convention applicative).
- Seuil mobile : **600px** inclus ; padding shell/header/panel **16px**,
  header peut revenir à la ligne. Pas de mise en page à largeur fixe sur mobile.
- Vérifier au minimum 390px et 1440px de largeur, zoom 200 %, navigation clavier.

## Application et contrôle

Ne pas modifier `src/brand.css` : il est copié depuis le thème verrouillé.
Les écrans réutilisent les classes ou tokens ; ne pas surcharger les composants
de marque. Exemple : `className="bw-button bw-button--secondary"`.

Exécuter `npm run check:brand`, puis tests/build et revue visuelle documentée.
Le contrôle statique ne prouve ni le rendu réel de Roboto, ni les espacements
finaux, ni les contrastes des contenus personnalisés.
