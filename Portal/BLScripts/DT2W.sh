# Double Tap To Wake Up
if [ "$(READ "BLS2" $BLC)" = "ON" ]; then
write "/proc/touchpanel/double_tap_enable" "1"
 elif [ "$(READ "BLS2" $BLC)" = "OFF" ]; then
write "/proc/touchpanel/double_tap_enable" "0"
fi