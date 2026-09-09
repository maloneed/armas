#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
OUT="$ROOT/release/LivingWar-EasyInstall.zip"
cd "$ROOT/release"
rm -f "$OUT"
zip -qr "$OUT" @LivingWar INSTALL_RU.txt
printf 'Created %s\n' "$OUT"
