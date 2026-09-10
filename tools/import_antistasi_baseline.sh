#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
UPSTREAM="${1:-/home/ubuntu/antistasi-upstream}"
TAG="${2:-3.11.1}"
OUT="$ROOT/upstream/antistasi"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

cd "$UPSTREAM"
git archive "$TAG" | tar -x -C "$TMP"
rm -rf "$OUT"
mkdir -p "$OUT"
# Exclude components identified by upstream LICENSE as APL-ND.
tar -C "$TMP" --exclude='A3A/addons/garage' --exclude='Tools/StreetArtist' -cf - . | tar -C "$OUT" -xf -
rm -f "$OUT/A3A/addons/garage/APL-ND.pdf"
cat > "$OUT/ARMAS_IMPORT.txt" <<EOF
Source repository: https://github.com/official-antistasi-community/A3-Antistasi
Tag: $TAG
Commit: $(git rev-parse "$TAG")
Imported by ARMAS as an internal baseline.
Excluded upstream APL-ND components: A3A/addons/garage and Tools/StreetArtist.
Do not add excluded components without a separate license decision.
EOF
printf 'Imported %s at %s into %s\n' "$TAG" "$(git rev-parse "$TAG")" "$OUT"
