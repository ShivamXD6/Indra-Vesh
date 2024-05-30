#!/system/bin/sh
 
# Check for Updates
UPC=$CONF/upc.txt
mv "$UPC" "$CONF/old-upc.txt"
OLDUPC=$CONF/old-upc.txt
Download "https://raw.githubusercontent.com/FlaxCube/Indra-Vesh/main/INDRA/Configs/upc.txt" "$UPC"
if [ "$(READ "UPDA-V" "$UPC")" -gt "$(READ "UPDA-V" "$OLDUPC")" ]; then
Download "https://raw.githubusercontent.com/FlaxCube/Indra-Vesh/main/INDRA/Scripts/upd.sh" "$SRT/upd.sh"
elif [ "$(READ "CORE-V" "$UPC")" -gt "$(READ "CORE-V" "$OLDUPC")" ]; then
sed -i "0,/^CORE-S=/s|^CORE-S=.*|CORE-S=(Update Available!!)|" "$UPC"
elif [ "$(READ "MENU-V" "$UPC")" -gt "$(READ "MENU-V" "$OLDUPC")" ]; then
sed -i "0,/^MENU-S=/s|^MENU-S=.*|MENU-S=(Update Available!!)|" "$UPC"
elif [ "$(READ "TOGG-V" "$UPC")" -gt "$(READ "TOGG-V" "$OLDUPC")" ]; then
sed -i "0,/^TOGG-S=/s|^TOGG-S=.*|TOGG-S=(Update Available!!)|" "$UPC"
elif [ "$(READ "TUNE-V" "$UPC")" -gt "$(READ "TUNE-V" "$OLDUPC")" ]; then
sed -i "0,/^TUNE-S=/s|^TUNE-S=.*|TUNE-S=(Update Available!!)|" "$UPC"
elif [ "$(READ "MAGI-V" "$UPC")" -gt "$(READ "MAGI-V" "$OLDUPC")" ]; then
sed -i "0,/^MAGI-S=/s|^MAGI-S=.*|MAGI-S=(Update Available!!)|" "$UPC"
elif [ "$(READ "CONF-V" "$UPC")" -gt "$(READ "CONF-V" "$OLDUPC")" ]; then
sed -i "0,/^CONF-S=/s|^CONF-S=.*|CONF-S=(Update Available!!)|" "$UPC"
fi
rm -rf "$OLDUPC"

# Menu
Menu() {
    echo -e '\n'
    printf "\033c"
    
    indc "${C} ✦✧✦✧✦✧✦✧✦✧ Indra Vesh - Updater ✧✦✧✦✧✦✧✦✧✦ ${N}"
    indc "${W} ✶ A system to update module core, Sub-menus etc without Updating the Module or Rebooting Mobile. ✶ ${N}"
    indc "${W} ✶ Changelogs - $(READS "CHANGELOG-S" "$UPC")✶ ${N}"
    indc "${Y} ✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦ ${N}"
    indc "${W} ❐ [1] Update Module Core ${G}$(READS "CORE-S" "$UPC")${N}"
    indc "${W} ❐ [2] Update Main Menu ${G}$(READS "MENU-S" "$UPC")${N}"
    indc "${W} ❐ [3] Update Toggle Control ${G}$(READS "TOGG-S" "$UPC")${N}"
    indc "${W} ❐ [4] Update Tune Dynamics ${G}$(READS "TUNE-S" "$UPC")${N}"
    indc "${W} ❐ [5] Update Magic Kit ${G}$(READS "MAGI-S" "$UPC")${N}"
    indc "${W} ❐ [6] Update Configuration ${G}$(READS "CONF-S" "$UPC")${N}"
    indc "${R} ✖ [0] Return to Indra's Menu ${N}"
    indc "${R} ✖ [+] Exit Directly ${N}"
    indc "${Y} ✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦ ${N}"
    indc "${C} ✷ Enter Number Respective to its Option:  ${N}"
    read option
    case $option in
        1) Option1 ;;
        2) Option2 ;;
        3) Option3 ;;
        4) Option4 ;;
        5) Option5 ;;
        6) Option6 ;;
        0) Return ;;
        +) GoOut ;;
        *) Menu ;;
    esac    
    }

Option1 () {
    printf "\033c"
    if [ "$(READS "CORE-S" "$UPC")" = "(Update Available!!)" ]; then
    Download "https://raw.githubusercontent.com/FlaxCube/Indra-Vesh/main/service.sh" "$MODPATH/service.sh"
    Download "https://raw.githubusercontent.com/FlaxCube/Indra-Vesh/main/system.prop" "$MODPATH/system.prop"
    sed -i "0,/^CORE-S=/s|^CORE-S=.*|CORE-S=|" "$UPC"
    indc "${G} Updated Cores parts to "$(READ "CORE-V" "$UPC")" ${N}"
    indc "${R} Reboot Required to Apply Changes ${N}"
    sleep 4
    else
   indc "${R} ✖ There's no update available for Core parts of the Module ${N}" 
   sleep 2
    fi
Menu
}

Option2 () {
    printf "\033c"
if [ "$(READS "MENU-S" "$UPC")" = "(Update Available!!)" ]; then
    Download "https://raw.githubusercontent.com/FlaxCube/Indra-Vesh/main/INDRA/indra.sh" "$DB/indra.sh"
    Download "https://raw.githubusercontent.com/FlaxCube/Indra-Vesh/main/INDRA/mod-util.sh" "$DB/mod-util.sh"
    sed -i "0,/^MENU-S=/s|^MENU-S=.*|MENU-S=|" "$UPC"
    indc "${G} Updated Main Menu to "$(READ "MENU-V" "$UPC")"${N}"
    sleep 2
    else
   indc "${R} ✖ There's no update available for Main Menu ${N}"
   sleep 2
    fi
Menu
}

Option3 () {
    printf "\033c"
if [ "$(READS "TOGG-S" "$UPC")" = "(Update Available!!)" ]; then
    Download "https://raw.githubusercontent.com/FlaxCube/Indra-Vesh/main/INDRA/Configs/blc.txt" "$CONF/blc.txt"
    Download "https://raw.githubusercontent.com/FlaxCube/Indra-Vesh/main/INDRA/Scripts/bls.sh" "$SRT/bls.sh"
    sed -i "0,/^TOGG-S=/s|^TOGG-S=.*|TOGG-S=|" "$UPC"
    indc "${G} Updated Toggle Control Menu to "$(READ "TOGG-V" "$UPC")"${N}"
    sleep 2
    else
   indc "${R} ✖ There's no update available for Toggle Control Menu ${N}"
   sleep 2
    fi
Menu
}

Option4 () {
    printf "\033c"
if [ "$(READS "TUNE-S" "$UPC")" = "(Update Available!!)" ]; then
    Download "https://raw.githubusercontent.com/FlaxCube/Indra-Vesh/main/INDRA/Configs/cfc.txt" "$CONF/cfc.txt"
    Download "https://raw.githubusercontent.com/FlaxCube/Indra-Vesh/main/INDRA/Scripts/cfs.sh" "$SRT/cfs.sh"
    sed -i "0,/^TUNE-S=/s|^TUNE-S=.*|TUNE-S=|" "$UPC"
    indc "${G} Updated Toggle Control Menu to "$(READ "TUNE-V" "$UPC")"${N}"
    sleep 2
    else
   indc "${R} ✖ There's no update available for Tune Dynamics Menu ${N}"
   sleep 2
    fi
Menu
}

Option5 () {
    printf "\033c"
if [ "$(READS "MAGI-S" "$UPC")" = "(Update Available!!)" ]; then
    Download "https://raw.githubusercontent.com/FlaxCube/Indra-Vesh/main/INDRA/Scripts/mks.sh" "$SRT/mks.sh"
    sed -i "0,/^MAGI-S=/s|^MAGI-S=.*|MAGI-S=|" "$UPC"
    indc "${G} Updated Magic Kit Menu to "$(READ "MAGI-V" "$UPC")"${N}"
    sleep 2
    else
   indc "${R} ✖ There's no update available for Magic Kit Menu ${N}"
   sleep 2
    fi
Menu
}

Option6 () {
    printf "\033c"
if [ "$(READS "CONF-S" "$UPC")" = "(Update Available!!)" ]; then
    Download "https://raw.githubusercontent.com/FlaxCube/Indra-Vesh/main/INDRA/Scripts/cfgs.sh" "$SRT/cfgs.sh"
    sed -i "0,/^CONF-S=/s|^CONF-S=.*|CONF-S=|" "$UPC"
    indc "${G} Updated Configuration Menu to "$(READ "CONF-V" "$UPC")"${N}"
    sleep 2
    else
   indc "${R} ✖ There's no update available for Configuration Menu ${N}"
   sleep 2
    fi
Menu
}

Return() {
    printf "\033c"
    indra
    exit
    printf "\033c"
}

printf "\033c"
Menu