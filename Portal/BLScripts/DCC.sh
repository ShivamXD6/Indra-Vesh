# Display Colors Control

# Config File
DCC_DIR=/data/INDRA/Configs/dcc.txt

# Check if KCAL Supported or not
if [ -d "/sys/module/msm_drm/parameters/" ]; then
    kcal_d="/sys/module/msm_drm/parameters"
    elif [ -d "/sys/devices/platform/kcal_ctrl.0" ]; then
    kcal_d="/sys/devices/platform/kcal_ctrl.0"
   write "/sys/devices/platform/kcal_ctrl.0/kcal_enable" "1"
fi

# Default Values
CONT=256
HUE=0
SAT=256
VAL=256
RED=256
GREEN=256
BLUE=256

# Only Execute if KCAL is Supported
if ! [ -z $kcal_d ]; then

if [ "$(READ "BLS3" $BLC)" = "ON" ]; then

if [ -f "$DCC_DIR" ]; then

# Custom Values 
CONT=$(READ "CONT" $DCC_DIR)
HUE=$(READ "HUE" $DCC_DIR)
SAT=$(READ "SAT" $DCC_DIR)
VAL=$(READ "VAL" $DCC_DIR)
RED=$(READ "RED" $DCC_DIR)
GREEN=$(READ "GREEN" $DCC_DIR)
BLUE=$(READ "BLUE" $DCC_DIR)
else
# Use Amoled Like Colors by Default
CONT=262
SAT=272
fi

# Set Display Colors 
write "$kcal_d/kcal_cont" "$CONT"
write "$kcal_d/kcal_hue" "$HUE"
write "$kcal_d/kcal_sat" "$SAT"
write "$kcal_d/kcal_val" "$VAL"
write "$kcal_d/kcal_red" "$RED"
write "$kcal_d/kcal_green" "$GREEN"
write "$kcal_d/kcal_blue" "$BLUE"

elif [ "$(READ "BLS3" $BLC)" = "OFF" ]; then

# Set Display Colors 
write "$kcal_d/kcal_cont" "$CONT"
write "$kcal_d/kcal_hue" "$HUE"
write "$kcal_d/kcal_sat" "$SAT"
write "$kcal_d/kcal_val" "$VAL"
write "$kcal_d/kcal_red" "$RED"
write "$kcal_d/kcal_green" "$GREEN"
write "$kcal_d/kcal_blue" "$BLUE"

fi

{
until [[ "$(getprop sys.boot_completed)" == "1" ]] && [[ -e "/sdcard/" ]]; do
		sleep 1
	done
# Reset Colors
ind "Exclude"
settings put secure night_display_activated 1
settings put secure night_display_activated 0
settings put secure accessibility_display_inversion_enabled 1
settings put secure accessibility_display_inversion_enabled 0 
}&
fi