# Site arsophrologie.com — consignes pour Claude Code

- Site statique, un seul `index.html` à la racine. Dossier plat : ne jamais créer de sous-dossier, ni de framework, ni d'étape de build.
- Ne jamais ajouter de ressource externe (Google Fonts, CDN, scripts d'analytics, pixels) : le site est conforme RGPD sans bannière cookies parce qu'il n'appelle aucun tiers.
- Les images et audios sont embarqués en base64 dans `index.html` : ne jamais afficher ni réécrire ces blocs, modifier le fichier par remplacements ciblés.
- Les textes légaux sont dans `index.html` (`id="mentions-legales"`, `id="confidentialite"`, `id="cgv"`). Une nouvelle section avec ancre `#xxx` doit avoir un `id="xxx"` correspondant.
- Après chaque modification : `bash deploy.sh --check`, puis, si l'utilisateur demande la mise en ligne, `bash deploy.sh "<résumé court de la modification>"`.
- Mettre à jour `<lastmod>` de `sitemap.xml` quand le contenu change de façon notable.
