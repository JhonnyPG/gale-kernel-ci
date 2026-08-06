#!/usr/bin/env bash
# Empaqueta y flashea el kernel en el Redmi 13C (gale) con magiskboot.
# CORRER CON ROOT en el telefono (Termux + su) o en PC con magiskboot binario.
set -ueo pipefail

NEW_IMAGE=./Image.gz      # kernel compilado (bajado del artifact)
ORIG=orig_boot.img        # copia del boot actual (respaldo)
OUT=new_boot.img

which magiskboot >/dev/null 2>&1 || { echo "instala magiskboot (buscalo en GitHub)"; exit 1; }

echo "-> Respaldo del boot actual"
dd if=/dev/block/by-name/boot of="$ORIG" 2>/dev/null

echo "-> Desempaquetar boot.img"
magiskboot unpack "$ORIG"

echo "-> Reemplazar kernel"
magiskboot split "$NEW_IMAGE" 2>/dev/null || true
[ -f "$NEW_IMAGE" ] && cp -f "$NEW_IMAGE" kernel

echo "-> Reempaquetar"
magiskboot repack "$ORIG" "$OUT"

echo "-> Flashear a la particion boot"
dd if="$OUT" of=/dev/block/by-name/boot

echo "Listo: $OUT flasheado. Reinicia para probar."