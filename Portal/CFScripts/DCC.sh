# Display Colors Control

# Config File
DCC_DIR=/data/INDRA/Configs/cfc.txt

# Before Opening Menu, Check if KCAL Supported or not
if [ -d "/sys/module/msm_drm/parameters/" ]; then
    kcal_d="/sys/module/msm_drm/parameters/"
    elif [ -d "/sys/devices/platform/kcal_ctrl.0/" ]; then
    kcal_d="/sys/devices/platform/kcal_ctrl.0/"
   write "/sys/devices/platform/kcal_ctrl.0/kcal_enable" "1"
   else
    ind "${R} ✖ KCAL is Not Supported, tell kernel dev to add support for KCAL ${N}" & sleep 3
    . $DB/Scripts/cfs.sh
    exit
fi

# Function to Restart Display and Apply Colors
Reset() {
ind "Exclude"
settings put secure night_display_activated 1
settings put secure night_display_activated 0
settings put secure accessibility_display_inversion_enabled 1
settings put secure accessibility_display_inversion_enabled 0
}

# Function to Set Display Colors
SetColors() {
write "$kcal_d/kcal_cont" "$CONT"
write "$kcal_d/kcal_hue" "$HUE"
write "$kcal_d/kcal_sat" "$SAT"
write "$kcal_d/kcal_val" "$VAL"
write "$kcal_d/kcal_red" "$RED"
write "$kcal_d/kcal_green" "$GREEN"
write "$kcal_d/kcal_blue" "$BLUE"
Reset
}

Default () {
CONT=256
HUE=0
SAT=256
VAL=256
RED=256
GREEN=256
BLUE=256 
}

# Menu
Menu() {
    echo -e '\n'
    printf "\033c"
    
    indc "${C} ✦✧✦✧✦✧✦✧✦✧ Indra Vesh - Display Colors ✧✦✧✦✧✦✧✦✧✦ ${N}"
    indc "${Y} ✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦ ${N}"
    indc "${G} ✦✧✦✧✦✧✦✧✦✧ Display Colors Presets ✧✦✧✦✧✦✧✦✧✦ ${N}"
    indc "${W} ❐ [C] Custom Preset ${N}"
    indc "${W} ❐ [1] Default ${N}"
    indc "${W} ❐ [2] Amoled Color ${N}"
    indc "${W} ❐ [3] Natural ${N}"
    indc "${W} ❐ [4] Night Light ${N}"
    indc "${V} • On Reboot Apply - $(READ "BLS3" $BLC) ${N}"
    indc "${V} - To Apply on Reboot
 - Turn on this option in Toggle Option Menu ${N}"
    indc "${R} ✖ [0] Return to Tune Dynamics Menu ${N}"
    indc "${R} ✖ [+] Exit Directly ${N}"
    indc "${Y} ✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦ ${N}"
    indc "${C} ✷ Enter Number to Select Preset or To Use Custom:  ${N}"
    read option
    case $option in
        C) Custom ;;
        1) Option1 ;;
        2) Option2 ;;
        3) Option3 ;;
        4) Option4 ;;
        0) Return ;;
        +) GoOut ;;
        *) Menu ;;
    esac    
    }

Custom () {
indc "${G} > Leave Empty anytime to Skip that Value ${N}"
indc "${R} > Press 'CTRL + C' to exit anytime ${N}"
indc "${G} > Enter Custom Contrast to Set: ${N}"
read CUS
if [ -n "$CUS" ]; then
while [ "$CUS" -lt "130" ] || [ "$CUS" -ge "380" ]; do
    indc "${R} ✖ Please use Value Between 130 to 380.${N}"
    read CUS
done
CONT=$CUS
sed -i "/CONT/s/.*/CONT=$CONT/" "$DCC_DIR"
SetColors
fi

indc "${G} > Enter Custom Hue to Set: ${N}"
read CUS
if [ -n "$CUS" ]; then
while [ "$CUS" -lt "0" ] || [ "$CUS" -ge "380" ]; do
    indc "${R} ✖ Please use Value Between 0 to 380.${N}"
    read CUS
done
HUE=$CUS
sed -i "/HUE/s/.*/HUE=$HUE/" "$DCC_DIR"
SetColors
fi

indc "${G} > Enter Custom Saturation to Set: ${N}"
read CUS
if [ -n "$CUS" ]; then
while [ "$CUS" -lt "130" ] || [ "$CUS" -ge "380" ]; do
    indc "${R} ✖ Please use Value Between 130 to 380.${N}"
    read CUS
done
SAT=$CUS
sed -i "/SAT/s/.*/SAT=$SAT/" "$DCC_DIR"
SetColors
fi

indc "${G} > Enter Custom Screen Value to Set: ${N}"
read CUS
if [ -n "$CUS" ]; then
while [ "$CUS" -lt "130" ] || [ "$CUS" -ge "380" ]; do
    indc "${R} ✖ Please use Value Between 130 to 380.${N}"
    read CUS
done
VAL=$CUS
sed -i "/VAL/s/.*/VAL=$VAL/" "$DCC_DIR"
SetColors
fi

indc "${G} > Enter Custom Red Color to Set: ${N}"
read CUS
if [ -n "$CUS" ]; then
while [ "$CUS" -lt "70" ] || [ "$CUS" -ge "256" ]; do
    indc "${R} ✖ Please use Value Between 70 to 256.${N}"
    read CUS
done
RED=$CUS
sed -i "/RED/s/.*/RED=$RED/" "$DCC_DIR"
SetColors
fi

indc "${G} > Enter Custom Green Color to Set: ${N}"
read CUS
if [ -n "$CUS" ]; then
while [ "$CUS" -lt "70" ] || [ "$CUS" -ge "256" ]; do
    indc "${R} ✖ Please use Value Between 70 to 256.${N}"
    read CUS
done
GREEN=$CUS
sed -i "/GREEN/s/.*/GREEN=$GREEN/" "$DCC_DIR"
SetColors
fi

indc "${G} > Enter Custom Blue Color to Set: ${N}"
read CUS
if [ -n "$CUS" ]; then
while [ "$CUS" -lt "70" ] || [ "$CUS" -ge "256" ]; do
    indc "${R} ✖ Please use Value Between 70 to 256.${N}"
    read CUS
done
BLUE=$CUS
sed -i "/BLUE/s/.*/BLUE=$BLUE/" "$DCC_DIR"
SetColors
fi

Menu
}

Option1 () {
Default
sed -i "/CONT/s/.*/CONT=$CONT/" "$DCC_DIR"
sed -i "/HUE/s/.*/HUE=$HUE/" "$DCC_DIR"
sed -i "/SAT/s/.*/SAT=$SAT/" "$DCC_DIR"
sed -i "/VAL/s/.*/VAL=$VAL/" "$DCC_DIR"
sed -i "/RED/s/.*/RED=$RED/" "$DCC_DIR"
sed -i "/GREEN/s/.*/GREEN=$GREEN/" "$DCC_DIR"
sed -i "/BLUE/s/.*/BLUE=$BLUE/" "$DCC_DIR"
SetColors
Menu
}

Option2 () {
Default
CONT=262
SAT=272
sed -i "/CONT/s/.*/CONT=$CONT/" "$DCC_DIR"
sed -i "/SAT/s/.*/SAT=$SAT/" "$DCC_DIR"
SetColors
Menu
}

Option3 () {
CONT=250
HUE=0
SAT=240
VAL=245
RED=250
GREEN=250
BLUE=250
sed -i "/CONT/s/.*/CONT=$CONT/" "$DCC_DIR"
sed -i "/HUE/s/.*/HUE=$HUE/" "$DCC_DIR"
sed -i "/SAT/s/.*/SAT=$SAT/" "$DCC_DIR"
sed -i "/VAL/s/.*/VAL=$VAL/" "$DCC_DIR"
sed -i "/RED/s/.*/RED=$RED/" "$DCC_DIR"
sed -i "/GREEN/s/.*/GREEN=$GREEN/" "$DCC_DIR"
sed -i "/BLUE/s/.*/BLUE=$BLUE/" "$DCC_DIR"
SetColors
Menu
} 

Option4 () {
Default
RED=256
GREEN=156
BLUE=100
sed -i "/RED/s/.*/RED=$RED/" "$DCC_DIR"
sed -i "/GREEN/s/.*/GREEN=$GREEN/" "$DCC_DIR"
sed -i "/BLUE/s/.*/BLUE=$BLUE/" "$DCC_DIR"
SetColors
Menu
}

Return() {
    printf "\033c"
    . /data/INDRA/Scripts/cfs.sh
    exit 
    printf "\033c"
}

printf "\033c"
Menu