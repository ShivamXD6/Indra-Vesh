#!/system/bin/sh
UPC=$CONF/upc.txt
OLDUPC=$CONF/old-upc.txt
 
# Check for Updates
mv "$UPC" "$CONF/old-upc.txt"
Download "https://raw.githubusercontent.com/FlaxCube/Indra-Vesh/main/INDRA/Configs/upc.txt" "$UPC"

# Get Each Changelog of the Update
cnt=1
indc "${V} ✶ CHANGELOGS - $(READS "DATE" "$UPC") ✶ ${N}"
while true; do
CHNG=$(READS "CHNG$cnt" "$UPC")
if [ -z "$CHNG" ]; then
break
fi
indc "${W} ✶ [$cnt] - $CHNG${N}"
cnt=$((cnt + 1))
done
indc ""
indc "${G} ✶ Press Enter to proceed update ${N}"
indc "${G} ✶ Type Anything and Press Enter to abort the update ${N}"
read INP
if [ -n "$INP" ]; then
mv "$CONF/old-upc.txt" "$CONF/upc.txt"
indra 
exit
fi

UPAV=0
# Check for Updater Menu Updates
if [ "$(READ "UPDA-V" "$UPC")" -gt "$(READ "UPDA-V" "$OLDUPC")" ]; then
Download "https://raw.githubusercontent.com/FlaxCube/Indra-Vesh/main/INDRA/Scripts/upd.sh" "$SRT/upd.sh"
indc "${G} Updated Updater Menu
 ${Y} Version: "$(READ "UPDA-V" "$OLDUPC")" -> "$(READ "UPDA-V" "$UPC")" ${N}"
sleep 2
fi

# Check for Module Core Updates
if [ "$(READ "CORE-V" "$UPC")" -gt "$(READ "CORE-V" "$OLDUPC")" ]; then
    Download "https://raw.githubusercontent.com/FlaxCube/Indra-Vesh/main/service.sh" "$MODPATH/service.sh"
    Download "https://raw.githubusercontent.com/FlaxCube/Indra-Vesh/main/system.prop" "$MODPATH/system.prop"
    Download "https://raw.githubusercontent.com/FlaxCube/Indra-Vesh/main/system/bin/indra" "$MODPATH/system/bin/indra"
indc "${G} Updated Core of the Module
 ${Y} Version: "$(READ "CORE-V" "$OLDUPC")" -> "$(READ "CORE-V" "$UPC")" ${N}"
indc "${R} Reboot Required to Apply Changes ${N}"
UPAV=1
sleep 4
fi

# Check for Indra's Menu Updates
if [ "$(READ "MENU-V" "$UPC")" -gt "$(READ "MENU-V" "$OLDUPC")" ]; then
    Download "https://raw.githubusercontent.com/FlaxCube/Indra-Vesh/main/INDRA/indra.sh" "$DB/indra.sh"
    Download "https://raw.githubusercontent.com/FlaxCube/Indra-Vesh/main/INDRA/mod-util.sh" "$DB/mod-util.sh"
indc "${G} Updated Indra's Menu
 ${Y} Version: "$(READ "MENU-V" "$OLDUPC")" -> "$(READ "MENU-V" "$UPC")" ${N}"
 UPAV=1
 sleep 2
fi

# Check for Toggle Control Menu Updates
if [ "$(READ "TOGG-V" "$UPC")" -gt "$(READ "TOGG-V" "$OLDUPC")" ]; then
    Download "https://raw.githubusercontent.com/FlaxCube/Indra-Vesh/main/INDRA/Configs/blc.txt" "$CONF/blc.txt"
    Download "https://raw.githubusercontent.com/FlaxCube/Indra-Vesh/main/INDRA/Scripts/bls.sh" "$SRT/bls.sh"
indc "${G} Updated Toggle Control Menu
 ${Y} Version: "$(READ "TOGG-V" "$OLDUPC")" -> "$(READ "TOGG-V" "$UPC")" ${N}"
 UPAV=1
 sleep 2
fi

# Check for Tune Dynamics Menu Updates
if [ "$(READ "TUNE-V" "$UPC")" -gt "$(READ "TUNE-V" "$OLDUPC")" ]; then
    Download "https://raw.githubusercontent.com/FlaxCube/Indra-Vesh/main/INDRA/Configs/cfc.txt" "$CONF/cfc.txt"
    Download "https://raw.githubusercontent.com/FlaxCube/Indra-Vesh/main/INDRA/Scripts/cfs.sh" "$SRT/cfs.sh"
indc "${G} Updated Tune Dynamics Menu
 ${Y} Version: "$(READ "TUNE-V" "$OLDUPC")" -> "$(READ "TUNE-V" "$UPC")" ${N}"
 UPAV=1
 sleep 2
fi

# Check for Magic Kit Menu Updates
if [ "$(READ "MAGI-V" "$UPC")" -gt "$(READ "MAGI-V" "$OLDUPC")" ]; then
Download "https://raw.githubusercontent.com/FlaxCube/Indra-Vesh/main/INDRA/Scripts/mks.sh" "$SRT/mks.sh"
indc "${G} Updated Magic Kit Menu
 ${Y} Version: "$(READ "MAGI-V" "$OLDUPC")" -> "$(READ "MAGI-V" "$UPC")" ${N}"
 UPAV=1
 sleep 2
fi

# Check for Configuration Menu Updates
if [ "$(READ "CONF-V" "$UPC")" -gt "$(READ "CONF-V" "$OLDUPC")" ]; then
Download "https://raw.githubusercontent.com/FlaxCube/Indra-Vesh/main/INDRA/Configs/cfgc.txt" "$CONF/cfgc.txt"
Download "https://raw.githubusercontent.com/FlaxCube/Indra-Vesh/main/INDRA/Scripts/cfgs.sh" "$SRT/cfgs.sh"
indc "${G} Updated Configuration Menu
 ${Y} Version: "$(READ "CONF-V" "$OLDUPC")" -> "$(READ "CONF-V" "$UPC")" ${N}"
 UPAV=1
 sleep 2
fi

# Check if Anything updated
if [ "$UPAV" -eq "1" ]; then
indc "${G} ✶ Update Finished!! ${N}"
sleep 2
else
indc "${R} ✖ Update already finished. Please check Later ${N}"
sleep 2
fi

rm -rf "$OLDUPC"
indra
exit