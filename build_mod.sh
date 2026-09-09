#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
OUT="${1:-$ROOT/dist}"
MOD="$OUT/@LivingWar"
rm -rf "$MOD"
mkdir -p "$MOD/addons"
python3 "$ROOT/tools/build_pbo.py" \
  "$ROOT/addons/living_war" \
  "$MOD/addons/living_war.pbo" \
  "living_war"
cp "$ROOT/mod.cpp" "$MOD/mod.cpp"
cat > "$MOD/README.txt" <<'EOF'
Living War

Launch the server with: -mod=@LivingWar
This addon is an isolated campaign-state layer for compatible Antistasi missions.
EOF
printf 'Built %s\n' "$MOD"
