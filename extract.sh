#!/bin/bash
# PAK EXTRACT v0.67
#
# by cyperghost for retropie.org.uk
# 1. PLACE  BARE PAK FILES to /home/pi/RetroPie/roms/ports/openbor/pak
# 2. RUN THE SCRIPT (with user pi!)
# 3. Data will be extracted to ./openbor/gamename.bor/data
# 4. pak files will be backuped from gamename.pak to gamename.pak.original
# Change pathes as you like!

EXTRACT_BOREXE="/opt/retropie/ports/openbor/borpak"
BORROM_DIR="/home/pi/RetroPie/roms/ports/openbor"
BORPAK_DIR="$BORROM_DIR/pak"

if [[ -f $EXTRACT_BOREXE ]]; then

    mkdir -p "$BORPAK_DIR"
    cd "$BORPAK_DIR"

    for i in *.[Pp][Aa][Kk]; do

        FILE="${i%%.*}"
        if [[ $FILE == '*' ]]; then
            echo "Aborting... No files to extract in $BORPAK_DIR!"
            exit
        fi

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

    echo "Extraction done without errors!"

else

    echo "borpak executive file not found in $EXTRACT_BOREXE"
    echo "Exit now...."

fi

sleep 5
