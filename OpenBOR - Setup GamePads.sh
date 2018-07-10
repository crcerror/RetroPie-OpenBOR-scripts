#!/bin/bash
# User menu for OpenBOR configuration tool
# How to:     This automate setup of joypad for each game
#             > copy a cfg file to $BORBASE_DIR and name it master.bor.cfg
#             > so a once done setup file must be copied from $KEYCONF_DIR to $BORBASE_DIR
#
# Place file to /opt/retropie/configs/all/runcommand-menu
# Access with USER Menu in runcommand.... Press just a button during greybox is visible
#
# coded by cyperghost
# For https://retropie.org.uk/

###### --------------------- INIT ---------------------
readonly BORBASE_DIR="/home/pi/RetroPie/roms/ports/openbor"
readonly ROOTDIR="/opt/retropie"
readonly KEYCONF_DIR="$ROOTDIR/configs/ports/openbor/Saves"
###### --------------------- INIT ---------------------

BOR_file="${3##*/}"
emulator="${1,,}"

###### --------------- Dialog Functions ---------------

# Show Infobox // $1 = Textmessage, $2 = seconds box will appear, $3 = Boxtitlemessage

function show_msg() {
    dialog --title "$3" --backtitle " cyperghosts OpenBOR easy Joypad config " --infobox "$1" 0 0
    sleep "$2"; clear
}

# Show yesnobox // $1 = Textmessage, $2 = Boxtitlemessage

function show_yesno() {
    dialog --title "$2" --backtitle " cyperghosts OpenBOR easy Joypad config " --yesno "$1" 0 0
}

###### --------------- Dialog Functions ---------------

# 1. Check is emulator "openbor" running
if [[ "$emulator" != "openbor" ]]; then
    show_msg "This script is intended to work only with emulator \"openbor\"\n    not ${emulator^^}\nGoing back to runcommand now...." "5" " Error! "
    exit 0
fi

# 2.Check config files
BOR_cfg="$KEYCONF_DIR/${BOR_file#.*}.cfg"
if [[ ! -f $BOR_cfg && -f $BORBASE_DIR/master.bor.cfg ]]; then
    cp "$BORBASE_DIR/master.bor.cfg" "$BOR_cfg"
    show_msg "Copied config-file from:\n\"$BORBASE_DIR/master.bor.cfg\"\n    to:\n\"$BOR_cfg\"\n\nStarting game \"${BOR_file:0:-4}\" in a few seconds!" "8" " Setting up ... "
elif [[ ! -f $BORBASE_DIR/master.bor.cfg && -f $BOR_cfg ]]; then
    show_yesno "Config-file \"$BORBASE_DIR/master.bor.cfg\" not found!\n\nBut I detected a config from game \"${BOR_file:0:-4}\"\n\nShould I set this config as new master file?" " Create new master file "
    [[ $? == 0 ]] && cp "$BOR_cfg" "$BORBASE_DIR/master.bor.cfg"
    exit 0
elif [[ ! -f $BORBASE_DIR/master.bor.cfg && ! -f $BOR_cfg  ]]; then
    show_msg "Config-file: \"$BORBASE_DIR/master.bor.cfg\"\n    and\n\"$BOR_cfg\"\nnot found!\n\nNothing done! Terminating .... " "3" " Error! "
    exit 0
elif [[ -f $BOR_cfg && -f $BORBASE_DIR/master.bor.cfg ]]; then
    show_yesno "Config-file \"$BOR_cfg\" found!\n\nDelete this? In all means I will go back to runcommand!" " Delete config file! "
    [[ $? == 0 ]] && rm -f "$BOR_cfg"
    show_yesno "Master-file \"$BORBASE_DIR/master.bor.cfg\" found!\n\nDelete this? In all means I will go back to runcommand!" " Delete MASTER file! "
    [[ $? == 0 ]] && rm -f "$BORBASE_DIR/master.bor.cfg"
    exit 0
else
    show_msg "Fatal error!\nThis should never happen!" " Fatal error! " "10"
    exit 0
fi

### --- Starting game
exit 2
