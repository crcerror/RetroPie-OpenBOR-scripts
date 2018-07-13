#!/bin/bash
# User menu for OpenBOR configuration tool
# How to:     This automate setup of joypad for each game
#             > copy a cfg file to $MASTERCONF_DIR and name it master.bor.cfg
#             > so a once done setup file must be copied from $KEYCONF_DIR to $MASTERCONF_DIR
#
# Place file to /opt/retropie/configs/all/runcommand-menu
# Access with USER Menu in runcommand.... Press just a button during greybox is visible
#
# coded by cyperghost
# For https://retropie.org.uk/

###### --------------------- INIT ---------------------
readonly MASTERCONF_DIR="/home/pi/RetroPie/roms/ports/openbor"
readonly KEYCONF_DIR="/opt/retropie/configs/ports/openbor/Saves"
readonly MASTER_GITHUB="http://raw.githubusercontent.com/crcerror/RetroPie-OpenBOR-scripts/master/joypad/master.bor.cfg"
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




###### --------- Set master default Functions ---------

function get_file() {

    local file="$1"
    local location="$2"

    [[ ! -d "$location" ]] && show_msg "Directory not found!\n\n$location\n\nPlease correct settings!" "8" " Error! Missing directory!" && exit 0
    [[ -f "$location/${file##*/}" ]] && rm -f "$location/${file##*/}"
    wget -q "$file" -P "$location"
    if [[ -s "$location/${file##*/}" ]]; then
        show_msg "Master file successfully downloaded! Setted file to:\n\n$location/${file##*/}\n\nRestart this script again please!" "5" " Congrats! Master file setted! "
    else
        show_msg "Failed to download master config file from:\n\n$file\n\nSorry for that...." "10" " Error to setup master file! "
    fi

}


###### --------- Set master default Functions ---------



# 1. Check is emulator "openbor" running
if [[ "$emulator" != "openbor" ]]; then
    show_msg "This script is intended to work only with emulator \"openbor\"\n    not ${emulator^^}\nGoing back to runcommand now...." "5" " Error! "
    exit 0
fi

# 2.Check config files
BOR_cfg="$KEYCONF_DIR/$BOR_file.cfg"
if [[ ! -f $BOR_cfg && -f $MASTERCONF_DIR/master.bor.cfg ]]; then
    cp "$MASTERCONF_DIR/master.bor.cfg" "$BOR_cfg"
    show_msg "Copied config-file from:\n\"$MASTERCONF_DIR/master.bor.cfg\"\n    to:\n\"$BOR_cfg\"\n\nStarting game \"${BOR_file:0:-4}\" in a few seconds!" "8" " Setting up ... "
elif [[ ! -f $MASTERCONF_DIR/master.bor.cfg && -f $BOR_cfg ]]; then
    show_yesno "Setting up: \"${BOR_file:0:-4}\"\n\nConfig-file \"$MASTERCONF_DIR/master.bor.cfg\" not found!\n\nBut I detected a config from game \"${BOR_file:0:-4}\"\n\nShould I set this config as new master file?" " Create new master file! "
    [[ $? == 0 ]] && cp "$BOR_cfg" "$MASTERCONF_DIR/master.bor.cfg"
    exit 0
elif [[ ! -f $MASTERCONF_DIR/master.bor.cfg && ! -f $BOR_cfg  ]]; then
    show_yesno "Setting up: \"${BOR_file:0:-4}\"\n\nDid not found the master-file nor the game config-file:\n\"$MASTERCONF_DIR/master.bor.cfg\"\n    and\n\"$BOR_cfg\"\n\nI can try to retrieve a file via internet connection. Should I do that?" " Error! "
     [[ $? == 0 ]] && get_file "$MASTER_GITHUB" "$MASTERCONF_DIR"
     exit 0
elif [[ -f $BOR_cfg && -f $MASTERCONF_DIR/master.bor.cfg ]]; then
    show_yesno "Setting up: \"${BOR_file:0:-4}\"\n\nFound Config-file:\n\"$BOR_cfg\"\n\nDelete this? Next window will ask you to delete MASTER file!!" " Delete config file! "
    [[ $? == 0 ]] && rm -f "$BOR_cfg"
    show_yesno "Setting up: \"${BOR_file:0:-4}\"\n\nFound Master-file:\n\"$MASTERCONF_DIR/master.bor.cfg\"\n\nDelete this? In all means I will go back to runcommand!" " Delete MASTER file! "
    [[ $? == 0 ]] && rm -f "$MASTERCONF_DIR/master.bor.cfg"
    exit 0
fi

### --- Starting game
exit 2
