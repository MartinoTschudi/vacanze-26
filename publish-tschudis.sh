#!/bin/zsh
# Publish the dashboard to tschudis.ch/gc2026 by committing it into the tschudis-website repo (Netlify auto-deploys).
set -e
SRC="$HOME/Desktop/vacanze 26"
TMP="$(mktemp -d)"
git clone -q --depth 1 https://github.com/MartinoTschudi/tschudis-website "$TMP/site"
mkdir -p "$TMP/site/gc2026"
cp "$SRC/index.html" "$SRC/map.html" "$SRC/poi.json" "$TMP/site/gc2026/"
rm -f "$TMP/site/gc2026"/*.kml
# make relative links inside gc2026 work when served under /gc2026/
sed -i '' 's|href="./"|href="/gc2026/"|g' "$TMP/site/gc2026/map.html"
# _redirects: /gc2026 -> /gc2026/ (Netlify serves folder index automatically)
touch "$TMP/site/_redirects"
grep -q '^/gc2026 ' "$TMP/site/_redirects" || echo '/gc2026  /gc2026/  301' >> "$TMP/site/_redirects"
cd "$TMP/site"
git add gc2026 _redirects
git -c user.name="Martino Tschudi" -c user.email="noreply@users.noreply.github.com" commit -q -m "gc2026: vacation dashboard + full-screen map" || { echo "nothing to commit"; exit 0; }
git push -q origin main
echo "Pushed. Netlify deploys in ~1 min → https://tschudis.ch/gc2026/"
rm -rf "$TMP"
