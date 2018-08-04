Hello dear fellows,

first of all I want to tell you about the **OpenBOR** engine, that is installable through *RetroPie Extras* section. **BOR** mean Beats of Rage. You are right, it's an opensource gaming engine for beat'em ups in the style of *Streets of Rage* or *Double Dragon*.
Don't ask me now, how many mods (or expansions) are availiable ... but some of them are really good made and it's really lots of fun to get into teamplay.

# Good list of working OpenBOR mods

[List of games](https://retropie.org.uk/forum/topic/13784/openbor-finally-working-fine-on-retropie-with-es/57) @BiZzAr721

[Also here a second list of working games (WIP!!)](https://docs.google.com/spreadsheets/d/e/2PACX-1vQxht0_rTt1_UvaHctJaMw5snzB_3Dv7GD0DUCzBHw5LI9VyY7Z4ZYu1-LlE_mZOIcuR-iXUZ8PI9i2/pubhtml) @hansolo77 - Thx to him

For ex: Nightslashers X
https://www.youtube.com/watch?v=iA0fWpJ5PHs

# HiStory

Round about 1 year, @darknior was able to slightly change the source code to add the feature of a command line input. So it is now able to start a game just by calling it via it's filename, like every emulator here works. So with this change you can create your own **OpenBOR system** inside ES. You can take a look to [this thread to see how to install a new OpenBOR entry in ES](https://retropie.org.uk/forum/topic/13784) 
For about 1 month I took action and changed the call of ROM files. Every mod is now started like an usual emulator used to be - through runcommand. This gots the advantage of full access to log files and usual calls of `runcommand-onstart.sh` and it's counterpart `runcommand-onend.sh`. Moreover the runcommand config menu is [available if you press a button during the grey loading box appears](https://retropie.org.uk/forum/topic/13784/openbor-finally-working-fine-on-retropie-with-es/64). I think this engine is really worth a try so I created a bunch of scripts to give you best help for easy setup. 

# Part 1: Installation

I would recommend you to do following. Install **OpenBOR** via the scriptmodul. 

0. Login with SSH
1. Use scriptmodul from me, install it with `wget http://raw.githubusercontent.com/crcerror/RetroPie-OpenBOR-scripts/master/openbor.sh -O /home/pi/RetroPie-Setup/scriptmodules/ports/openbor.sh`
2. Go to ES and select Configuration (the RetroJoy), select *RetroPie Setup* or just type `sudo ./RetroPie-Setup/retropie_setup.sh` in your homedir
3. On blue dialog, navigate to *P Manage packages*
4. Select *exp Manage experimental packages*
5. Run down the list, there select *342 openbor*
6. Select *S Install from source*

Maybe the first step will be obsolute if the slight changes will be merged to *RetroPie-Setup* branch. This script just adds the `%ROM%` parameter to emulators config and uses @darkniors branch to get command line input of OpenBOR mods.

# Part 2: Scripts setup (2 routes, choose one)

## Route 1: OpenBOR - Selections menu via PORTS section (recommended for a slick setup)

I created some scripts to give you guidance through the configuration process.
At first I created the **OpenBOR - Beats of Rage Engine selection** script. This script enables a menu like interface for easy startup of downloaded mods. You can take a [look here](https://up.picr.de/33253875rm.png) to see it in working action. I recommand you to download the script just to ports section in ES.

Just type `wget "http://raw.githubusercontent.com/crcerror/RetroPie-OpenBOR-scripts/master/OpenBOR - Beats of Rage Engine Selection.sh" -O "/home/pi/RetroPie/roms/ports/OpenBOR - Beats of Rage Engine Selection.sh"`

## Route 2: OpenBOR - Selection via ES menu (nice looking to ES)

I recommend @darknior's starting thread here.
He made also an excellent instruction set [of how to setup ES](https://retropie.org.uk/forum/topic/13784)

Edit `/opt/retropie/configs/all/emulationstation/es_systems.cfg` to add this new system entry with

```
<name>openbor</name>
    <fullname>OpenBOR</fullname>
    <path>/home/pi/RetroPie/roms/ports/openbor</path>
    <extension>.bor .BOR</extension>
    <command>/opt/retropie/supplementary/runcommand/runcommand.sh 0 _PORT_ openbor %ROM%</command>
    <platform>pc</platform>
    <theme>openbor</theme>
```

Special thanks and my biggest respect to @darknior for this and the modifications he has done to C-code!

***::: Extra Tipp - Carrefour Route 1 & Route 2 :::***
::: ADD GAMES AUTO CONFIG AND LAUNCH MENU :::

* We add a new file "Access Selection Menu" with `touch "/home/pi/RetroPie/roms/ports/openbor/Access Selection Menu.bor"`
* Type `nano /opt/retropie/configs/all/runcommand-onstart.sh` and add text from codebox below ;)
```
### Access to Selection Menu
## 
# $1 = systemname > openbor
# $3 = full path of ROM-file

if [[ "$1" == "openbor" && "${3##*/}" == "Access Selection Menu.bor" ]]; then
    # pkill runcommand.sh # Maybe needed to prevent first runcommand from being messed up
    bash "/home/pi/RetroPie/roms/ports/OpenBOR - Beats of Rage Engine Selection.sh"
fi

##
### Access to Selection Menu
```

# Part 3: JoyPad Setup

Now the seconds script is intended to make JoyPad configuration as easy as possible. It will not setup a gamepad, it downloads ready configurated settings directly to your Pie or gives you control over the files itself as you can set a configuration file as **master**. The Selection menu script will look for that master file and will automatically use this as current game config. So you don't have to mess around to configurate new mods again and again.

This part lives from your engagement! You can add your configuation to any server with direct file access. And post a link and a small description to the thread here and I might add these to the setup files. **[Post with JoyPad setups is here](https://retropie.org.uk/forum/topic/18565/tutorial-openbor-the-complete-guid/2)

First create runcommand-menu folder with `mkdir /opt/retropie/configs/all/runcommand-menu` (it's possible the folder already excists).
Next: Just type `wget "http://raw.githubusercontent.com/crcerror/RetroPie-OpenBOR-scripts/master/OpenBOR - Ultimate GamePad Setup.sh" -O "/opt/retropie/configs/all/runcommand-menu/OpenBOR - Ultimate GamePad Setup.sh"`

# Part 4: Game Setup

1. First we need to extract game data from PAK files.
2. Take care of naming convention the folders are named `gamename.bor`
3. Inside `gamename.bor` is a directory `data` ... here the whole gameset is located! 

## Windows method

You can download your `.pak` files and extract them with Windows Toolsset - it is named `Openbor Makepak & Extractor`. 

1. Extract the archive
2. Place the `.pak`file and rename it `bor.pak`
3. Run Batchfile `extract.bat`
4. PAK file will be extracted in directory `data` ...
5. Now move that subfolder to `\home\pi\retropie\roms\ports\openbor\gamename.bor\`
5.1 `gamename.bor` can be choosen free
5.2 place `data` directory inside `gamename.bor`

## Linux method

I did a complete rewrite of the extraction script. The original was awful to use and failed on FAT32 and NTFS devices (because of file access rights!)
[So here it is... The extraction script for RetroPie! Please report errors and issues!](https://github.com/crcerror/RetroPie-OpenBOR-scripts/blob/master/extract.sh)

1. Place your bare PAK files to `/home/pi/RetroPie/roms/ports/openbor/pak`
2. Run the script from any place with user **PI** (recommended to avoid file access issues)
3. The script extracts all pak-files (even with mixed characters) to openbor directory. Extracted data will be stored to `./openbor/gamename.bor/data`
4. The script backups the old PAK files automatically gamename.pak will be gamename.pak.original

# Part 5: Start Game

Restart ES! (only once needed to make script file in ports visible for ES)

1. Go back to ES and go to PORTS section
2. Select there `Beats of Rage Engine Selection`
3. You will see a kind of menu that will lists all games in `/home/pi/RetroPie/roms/ports/openbor`
4. Start the selelcted game ....
5. **You will see a grey box**, now press a button on your controller
6. Go to UserMenu
7. Select `OpenBOR - Ultimate GamePad Setup`
8. Configurate your CONTROLLER!!

**0. OpenBOR Selection Menu**
![IMAGE](https://up.picr.de/33253875rm.png)

## Install JoyPads via runcommand >> User Menu >> JoyPad script

**1. AddOn not configurated: Select Github Controlle list --> Master config**
![IMAGE](https://up.picr.de/33253635oc.png)

**2. I used the setup several times, so an old joypadconfig.txt is found, overwrite if you want**
![IMAGE](https://up.picr.de/33253636rc.png)

**3. Downloaded new joypadconfig.txt with a set of controllers, select one you own**
![IMAGE](https://up.picr.de/33253638yl.png)

**4. Last warning if you want this really to do**
![IMAGE](https://up.picr.de/33253639oc.png)

**5. Success! We have a new masterfile now**
![IMAGE](https://up.picr.de/33253640kk.png)

**6. We are going back to menu, and select Set Masterfile to Gameconfig**
![IMAGE](https://up.picr.de/33253641uu.png)

**7. We see the thing operating with success!**
![IMAGE](https://up.picr.de/33253642eh.png)

**8. Finally we can launch the game - ready to BRAWL**
![IMAGE](https://up.picr.de/33253643rn.png)

