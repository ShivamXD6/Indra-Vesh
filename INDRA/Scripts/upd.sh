#!/system/bin/sh
 
# Check for Updates
UPC=$CONF/upc.txt
mv "$UPC" "$CONF/old-upc.txt"
OLDUPC=$CONF/old-upc.txt
Download "https://gitlab.com/shivamashokdhage6/indra-vesh/-/raw/main/Configs/upc.txt?inline=false" "$UPC"
if [ "$(READ "UPDA-V" "$UPC")" -gt "$(READ "UPDA-V" "$OLDUPC")" ]; then
echo "will download latest updater bin"
elif [ "$(READ "CORE-V" "$UPC")" -gt "$(READ "CORE-V" "$OLDUPC")" ]; then
echo "will download latest CORES"
sed -i "0,/^CORE-S=/s|^CORE-S=.*|CORE-S=(Update Available!!)|" "$UPC"
elif [ "$(READ "MENU-V" "$UPC")" -gt "$(READ "MENU-V" "$OLDUPC")" ]; then
echo "will download latest MENU"
sed -i "0,/^MENU-S=/s|^MENU-S=.*|MENU-S=(Update Available!!)|" "$UPC"
elif [ "$(READ "TOGG-V" "$UPC")" -gt "$(READ "TOGG-V" "$OLDUPC")" ]; then
echo "will download latest TOGG"
sed -i "0,/^TOGG-S=/s|^TOGG-S=.*|TOGG-S=(Update Available!!)|" "$UPC"
elif [ "$(READ "TUNE-V" "$UPC")" -gt "$(READ "TUNE-V" "$OLDUPC")" ]; then
echo "will download latest TUNE"
sed -i "0,/^TUNE-S=/s|^TUNE-S=.*|TUNE-S=(Update Available!!)|" "$UPC"
elif [ "$(READ "MAGI-V" "$UPC")" -gt "$(READ "MAGI-V" "$OLDUPC")" ]; then
echo "will download latest MAGI"
sed -i "0,/^MAGI-S=/s|^MAGI-S=.*|MAGI-S=(Update Available!!)|" "$UPC"
elif [ "$(READ "CONF-V" "$UPC")" -gt "$(READ "CONF-V" "$OLDUPC")" ]; then
echo "will download latest CONF"
sed -i "0,/^CONF-S=/s|^CONF-S=.*|CONF-S=(Update Available!!)|" "$UPC"
else
echo "No Updates available "
fi
 sleep 5
# Menu
Menu() {
    echo -e '\n'
    printf "\033c"
    
    indc "${C} ✦✧✦✧✦✧✦✧✦✧ Indra Vesh - Updater ✧✦✧✦✧✦✧✦✧✦ ${N}"
    indc "${W} ✶ A system to update module core, Sub-menus etc without Updating the Module or Rebooting Mobile. ✶ ${N}"
    indc "${Y} ✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦ ${N}"
    indc "${W} ❐ [1] Update Module Core ${G}"$(READS "CORE-S" "$UPC")" ${N}"
    indc "${W} ❐ [2] Update Main Menu ${G}"$(READS "MENU-S" "$UPC")" ${N}"
    indc "${W} ❐ [3] Update Toggle Control ${G}"$(READS "TOGG-S" "$UPC")" ${N}"
    indc "${W} ❐ [4] Update Tune Dynamics ${G}"$(READS "TUNE-S" "$UPC")" ${N}"
    indc "${W} ❐ [5] Update Magic Kit ${G}"$(READS "MAGI-S" "$UPC")" ${N}"
    indc "${W} ❐ [6] Update Configuration ${G}"$(READS "CONF-S" "$UPC")" ${N}"
    indc "${R} ✖ [0] Exit ${N}"
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
        0) GoOut ;;
        *) Menu ;;
    esac    
    }

Option1 () {
    printf "\033c"
    sed -i "0,/^CORE-S=/s|^CORE-S=.*|CORE-S=|" "$UPC"
}

Option2 () {
    printf "\033c"
    . /$DB/Scripts/cfs
}

Option3 () {
    printf "\033c"
    . /$DB/Scripts/mks
}

Return() {
    printf "\033c"
    Menu
    printf "\033c"
}

Reboot() {
    printf "\033c"
    reboot system
    printf "\033c"
}

GoOut() {
    printf "\033c"
    ind "${G} ✓ All Done, See You next Time.${N}"
    exit
}

printf "\033c"
Menu