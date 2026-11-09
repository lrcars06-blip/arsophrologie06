# arsophrologie.com — Angélique Rosier, sophrologue à Menton

Site une page, statique, **dossier plat** : tous les fichiers à la racine, aucun framework, aucun build.
Hébergement : **Vercel**, déployé automatiquement à chaque push sur `main`.

| Fichier | Rôle |
|---|---|
| `index.html` | Le site entier (photos, couvertures et extraits audio embarqués) + mentions légales, confidentialité/RGPD et CGV en fenêtres (`#mentions-legales`, `#confidentialite`, `#cgv`) |
| `404.html` | Page introuvable |
| `vercel.json` | URLs propres, redirections des anciennes pages WordPress, en-têtes de sécurité et de cache |
| `*.woff2` | Polices auto-hébergées (Fraunces, Karla) — aucun appel à Google Fonts |
| `favicon-32.png`, `apple-touch-icon.png` | Icônes |
| `robots.txt`, `sitemap.xml` | Référencement |
| `deploy.sh` | Commande de mise en ligne |

## Mise en ligne — première fois

1. Créer un dépôt **vide** sur GitHub (ex. `arsophrologie`), sans README.
2. Dans ce dossier : `bash deploy.sh --init https://github.com/<compte>/arsophrologie.git`
3. Sur vercel.com/new → importer le dépôt → Framework preset : **Other** → Build command : vide → Output directory : `./` → Deploy.
4. Vercel → Project → Settings → Domains → ajouter `arsophrologie.com` et `www.arsophrologie.com` (www redirigé vers arsophrologie.com).
5. Chez le registrar du domaine, DNS :
   - `A` `@` → `76.76.21.21`
   - `CNAME` `www` → `cname.vercel-dns.com`
   (Vercel affiche les valeurs exactes à utiliser ; elles priment sur celles-ci.)
6. Supprimer l'ancien site WordPress seulement après vérification que le nouveau répond sur le domaine.

## Modifier le site ensuite

1. Modifier `index.html` (à la main ou avec Claude Code).
2. `bash deploy.sh --check` → vérifie fichiers, liens internes, vercel.json.
3. `bash deploy.sh "ce que j'ai changé"` → vérifie, commit, push. En ligne en 1 à 2 minutes.

Revenir en arrière : Vercel → Deployments → version précédente → **Promote to Production** (instantané).

## Repères dans index.html

- Prix et liens boutique : rechercher `sophro-au-fil-de-la-vie.com` ou le montant (`17&nbsp;€`).
- Réservation : rechercher `liberlo.com`.
- Textes légaux : rechercher `id="mentions-legales"`, `id="confidentialite"`, `id="cgv"`.

## Règles

- Rester plat : pas de sous-dossier (`deploy.sh` refuse sinon).
- Pas de Google Fonts, Google Analytics, pixel Meta ou Vercel Analytics sans mettre à jour la politique de confidentialité **et** ajouter une bannière de consentement.
- Changer d'hébergeur = mettre à jour la section « Hébergeur » des mentions légales.

## Reste à compléter

- [ ] CGV art. 8 : médiateur de la consommation (`[nom et coordonnées du médiateur]`).
- [ ] TVA : confirmer la franchise (art. 293 B du CGI) avec Angélique.
- [ ] Plan Vercel : le plan gratuit Hobby est réservé à un usage non commercial.
