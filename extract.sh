#!/bin/bash
# PAK EXTRACT v0.55
# by cyperghost for retropie.org.uk
# 1. PLACE  BARE PAK FILES to /home/pi/RetroPie/roms/ports/openbor/pak
# 2. RUN THE SCRIPT (with user pi!)
# Change pathes as you like!

EXTRACT_BOREXE="/opt/retropie/ports/openbor/borpak"
BORROM_DIR="/home/pi/RetroPie/roms/ports/openbor"
BORPAK_DIR="$BORROM_DIR/pak"

if [[ -f $EXTRACT_BOREXE ]]; then
    mkdir -p "$BORPAK_DIR"
    cd "$BORPAK_DIR"
    FILES="$(ls *.[pP][aA][kK] 2> /dev/null)"
else
    echo "borpak executive file not found in $EXTRACT_BOREXE"
    echo "Exit now...."
    exit
fi

if [[ -z $FILES ]]; then
    echo "Aborting... No files to extract in $BORPAK_DIR!"
    exit
fi

for i in "${FILES[@]}"; do
    FILE="${i%%.*}"

    mkdir -p "$BORROM_DIR/$FILE.bor"
    echo "Extracting file: $i"
    echo "to dir: $BORROM_DIR/$FILE.bor"
    sleep 3
    "$EXTRACT_BOREXE" -d "$BORROM_DIR/$FILE.bor" "$i"
    echo "-------- Done Extracting: $i ---------"
    echo "-- Backup $i >> $i.original --"
    mv "$i" "$i.original"
    sleep 5
done
