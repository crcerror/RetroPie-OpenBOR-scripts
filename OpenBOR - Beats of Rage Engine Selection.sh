#!/bin/bash
# Graphical Menu to select OpenBOR custom files
# Thank to @darknior for working on OpenBOR on RetroPie forum
# Follow him @chronocrash official forum
# For setup read more here
# https://retropie.org.uk/forum/topic/13784
#
# I'm using @darkniors file nameing convention so every game episode uses
# gameepisode.bor/data directory structure
#
# The purposes?
# Reason 1: To make use of runcommand.sh for better compatibility to RetroPie setups
# Reason 2: To automate setup of joypad for each game
#             > copy a cfg file to $BORBASE_DIR and name it master.bor.cfg
# Reason 3: Seemless integration into JoyPad configuration tool
#
#             > so a once done setup file must be copied from $KEYCONF_DIR to $BORBASE_DIR
# coded by cyperghost
# For https://retropie.org.uk/

###### --------------------- INIT ---------------------
readonly VERSION="1.33_072318"
readonly TITLE="OpenBOR - cyperghosts BOR'n'more selector"
readonly ROOTDIR="/opt/retropie"
readonly BORBASE_DIR="/home/pi/RetroPie/roms/ports/openbor"
readonly MASTERCONF_DIR="/home/pi/RetroPie/roms/ports/openbor"
readonly KEYCONF_DIR="$ROOTDIR/configs/ports/openbor/Saves"
readonly JOYPAD_SCRIPT="/opt/retropie/configs/all/runcommand-menu/OpenBOR - Ultimate GamePad Setup.sh"
###### --------------------- INIT ---------------------




###### --------------------- JOY00 ---------------------

function start_joy(){

   ### >>>> RIPPED OUT OF RUNCOMMAND.SH ---- Please improve!
   ### >>>> Added support for multiple Joypads now!

        # call joy2key.py: arguments are curses capability names or hex values starting with '0x'
        # see: http://pubs.opengroup.org/onlinepubs/7908799/xcurses/terminfo.html
        local joy_find; local i
        joy_find=$(find /dev/input/js?)
        for i in ${joy_find[@]}; do
            "$ROOTDIR/supplementary/runcommand/joy2key.py" "$i" kcub1 kcuf1 kcuu1 kcud1 0x0a 0x09 &
            JOY2KEY_PID+=("$!")
        done
}

function end_joy(){

   ### >>>> RIPPED OUT OF RUNCOMMAND.SH ---- Please improve!


    if [[ -n "$JOY2KEY_PID" ]]; then
        kill -INT "${JOY2KEY_PID[@]}"
    fi

}

###### --------------- Dialog Functions ---------------

# Show Infobox // $1 = Textmessage, $2 = seconds box will appear, $3 = Boxtitlemessage

function show_msg() {
    dialog --title "$3" --backtitle " $TITLE - $VERSION " --infobox "$1" 0 0
    sleep "$2"; clear
}

# Show yesnobox // $1 = Textmessage, $2 = Boxtitlemessage

function show_yesno() {
dialog --title "$2" --backtitle " $TITLE - $VERSION " --yesno "$1" 0 0
}

# This builds dialog for OpenBOR directories
# We need to create valid array (dialog_array) before
# I disabled tags, so selections are showen exactly as in ES ROM section

function dialog_selectBOR() {

    # Create array for dialog
    local dialog_array; local i
    local cmd; local choices; local status
    for i in "${array[@]}"; do
        dialog_array+=("$i" "${i:2:-4}")
    done

    # old file array isn't needed anymore!
    unset array

    # -- Begin Dialog

    cmd=(dialog --backtitle " $TITLE - $VERSION " \
                --title " Select your Beats of Rage Episode " \
                --ok-label " Select " \
                --cancel-label " Exit to ES " \
                --extra-button --extra-label " JoyPad Config "
                --no-tags --stdout \
                --menu "There are $((${#dialog_array[@]}/2)) games available\nWhich you want to play:" 16 70 16)
    choices=$("${cmd[@]}" "${dialog_array[@]}")
    echo "$?----$choices"

    # -- End Dialog
}

###### --------------- Dialog Functions ---------------




###### --------------- Array Functions ---------------

# Rebuild Filenames, if $i starts with "./" an new filename is found
# Array postion 1 is always empty, we can use that later

function build_find_array() {

    local i;local ii
    local filefind="$1"

    for i in $filefind; do
        if [[ ${i:0:2} == "./" ]]; then
            array+=("$ii")
            ii=
            ii="$i"
         else
            ii="$ii $i"
         fi
    done
    array+=("$ii")
    unset array[0]

}

###### --------------- Array Functions ---------------




###### -------------- M A I N B U I L D --------------

# Get OpenBOR-directories and build valid array, make precheck

if [[ -d $BORBASE_DIR ]]; then
    cd "$BORBASE_DIR"
    bor_files=$(find -maxdepth 1 -iname "*.bor" -type d | sort 2>/dev/null)
else
    show_msg "No $BORBASE_DIR found!" "3" " Fatal error! "
    exit
fi

# Are there any BOR Directories available?

if [[ -z $bor_files ]]; then
    show_msg "No BOR directories found in location:\n\n$BORBASE_DIR" "3" " Error! "
    exit
fi

# Start Selection Dialog

start_joy

while true; do

    build_find_array "$bor_files"
    BOR_file=$("dialog_selectBOR")
    clear

        case "${BOR_file%%----*}" in
            0)  # Select Button
                BOR_cfg="$KEYCONF_DIR${BOR_file#*.}.cfg"
                if [[ ! -f $BOR_cfg && -f $MASTERCONF_DIR/master.bor.cfg  ]]; then
                    cp "$MASTERCONF_DIR/master.bor.cfg" "$BOR_cfg"
                    show_msg "Copied config-file from:\n$MASTERCONF_DIR/master.bor.cfg\n    to:\n$BOR_cfg\n\nStarting game \"${BOR_file:7:-4}\" in a few seconds!" "8" " Setup controller! "
                    break
                elif [[ ! -f $BOR_cfg && ! -f $MASTERCONF_DIR/master.bor.cfg  ]]; then
                    show_yesno "Game \"${BOR_file:7:-4}\" is unconfigurated!\n\nPlease setup JoyPads before going to BRAWL\n\nSelect NO if you want to start an unconfigurated game....\nRemember to configurate your inputs in OpenBOR! This selection box will only appear on first startup!" " Setup controller! "
                    [[ $? == 1 ]] && break
                else
                    break
                fi
            ;;

            1) # Cancel Button
               end_joy
               show_msg "No Selection made...Returning to ES!" "2" " Really? :( "
               exit
            ;;

            3) # JoyPad Selection
                if [[ -s $JOYPAD_SCRIPT ]]; then
                    bash "$JOYPAD_SCRIPT" "openbor" "configscript" "$BORBASE_DIR${BOR_file#*.}"
                else
                    show_msg "JoyPad configuration script not found in:\n\n$JOYPAD_SCRIPT" "5" " Error: Script missing! "
                fi
            ;;
        esac

done

# End Selection Dialog


end_joy; sleep 0.5

# Finally using RUNCOMMAND.SH to initiate prober start of games

BOR_file="$BORBASE_DIR${BOR_file#*.}"
"$ROOTDIR/supplementary/runcommand/runcommand.sh" 0 _PORT_ "openbor" "$BOR_file"
