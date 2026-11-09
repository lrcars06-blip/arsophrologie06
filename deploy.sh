#!/usr/bin/env bash
# Mise en ligne du site arsophrologie.com
#
#   Première fois :  bash deploy.sh --init https://github.com/<compte>/arsophrologie.git
#   Ensuite       :  bash deploy.sh "ce que j'ai changé"
#   Vérifier seul :  bash deploy.sh --check
#
# Chaque push sur la branche main est publié automatiquement par Vercel (1 à 2 min).

set -euo pipefail
cd "$(dirname "$0")"

SITE="https://arsophrologie.com"
REQUIS=(index.html 404.html vercel.json robots.txt sitemap.xml favicon-32.png apple-touch-icon.png
        Fraunces-normal-var.woff2 Fraunces-italic-400.woff2 Karla-normal-var.woff2)

rouge(){ printf '\033[31m%s\033[0m\n' "$*"; }
vert(){  printf '\033[32m%s\033[0m\n' "$*"; }
jaune(){ printf '\033[33m%s\033[0m\n' "$*"; }

verifier(){
  local ok=1
  for f in "${REQUIS[@]}"; do [[ -f "$f" ]] || { rouge "✗ fichier manquant : $f"; ok=0; }; done

  # Dossier plat : aucun sous-dossier (hors .git / .vercel)
  local sous; sous=$(find . -mindepth 1 -type d ! -path './.git*' ! -path './.vercel*' | head -n 3)
  [[ -z "$sous" ]] || { rouge "✗ sous-dossier interdit (site plat) : $sous"; ok=0; }

  # HTML : balises essentielles présentes
  for b in '</html>' '</body>' '<title>' 'id="mentions-legales"' 'id="confidentialite"' 'id="cgv"'; do
    grep -q "$b" index.html || { rouge "✗ index.html : $b introuvable"; ok=0; }
  done

  # Liens internes #ancre -> id existant
  local a
  for a in $(grep -o 'href="#[a-zA-Z0-9_-]\+"' index.html | sed 's/href="#//;s/"//' | sort -u); do
    grep -q "id=\"$a\"" index.html || { rouge "✗ lien #$a sans section correspondante"; ok=0; }
  done

  # vercel.json valide
  if command -v python3 >/dev/null; then
    python3 -c 'import json,sys;json.load(open("vercel.json"))' 2>/dev/null || { rouge "✗ vercel.json invalide"; ok=0; }
  fi

  # Avertissements (n'empêchent pas la mise en ligne)
  grep -q '\[nom et coordonnées' index.html && jaune "⚠ CGV : médiateur de la consommation encore à compléter"
  sed 's/data:[^"]*//g' index.html | grep -qiw 'lorem\|TODO\|XXX' && jaune "⚠ texte provisoire (lorem/TODO/XXX) dans index.html"
  local taille; taille=$(wc -c < index.html | tr -d ' ')
  (( taille < 4000000 )) || jaune "⚠ index.html pèse $((taille/1024)) Ko : alléger les images/audios embarqués"

  (( ok )) || { rouge "Mise en ligne annulée : corrige les erreurs ci-dessus."; exit 1; }
  vert "✓ vérifications OK"
}

case "${1:-}" in
  --check)
    verifier; exit 0 ;;
  --init)
    REPO="${2:-}"
    [[ -n "$REPO" ]] || { rouge "Indique l URL du dépôt : bash deploy.sh --init https://github.com/<compte>/arsophrologie.git"; exit 1; }
    verifier
    [[ -d .git ]] || git init -q
    git checkout -q -B main
    git remote remove origin 2>/dev/null || true
    git remote add origin "$REPO"
    git add -A
    git commit -q -m "Mise en ligne initiale du site" || true
    git push -u origin main
    vert "✓ Envoyé sur GitHub. Dernière étape : importer le dépôt sur vercel.com/new (une seule fois)."
    exit 0 ;;
esac

[[ -d .git ]] || { rouge "Pas encore de dépôt. Lance d'abord : bash deploy.sh --init <url-github>"; exit 1; }

verifier
git pull -q --rebase --autostash origin main || { rouge "✗ conflit avec GitHub : résous-le puis relance"; exit 1; }

git add -A
if git diff --cached --quiet; then
  jaune "Rien à publier : aucun fichier modifié."
  exit 0
fi

echo "Fichiers publiés :"; git diff --cached --name-status | sed 's/^/  /'
MSG="${1:-Mise à jour du site $(date '+%d/%m/%Y %H:%M')}"
git commit -q -m "$MSG"
git push -q origin main
vert "✓ Publié : « $MSG »"
echo "  Vercel met le site à jour d'ici 1 à 2 minutes → $SITE"
