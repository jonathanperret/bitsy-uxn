#!/bin/bash

set -euo pipefail

GAMEPAGE=${1:?}

IFRAMESRC=https:$(http "$GAMEPAGE"|grep -Eo '//[^/]+hwcdn\.net[^&]+')

FILENAME=games/${GAMEPAGE##*/}.bitsy

>&2 echo "Downloading to ${FILENAME}"

(
  http "$IFRAMESRC" | LANG=C fgrep 'exportedGameData ='
  echo 'process.stdout.write(Buffer.from([...exportedGameData].map((x)=>x.charCodeAt(0))))'
) | node > "$FILENAME" 2>/dev/null || (rm "$FILENAME"; exit 1)

printf "\n# downloaded from %s\n" "$GAMEPAGE" >> "$FILENAME"
