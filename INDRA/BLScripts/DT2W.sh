# Double Tap To Wake Up
if [ "$(READ "BLS1" $BLC)" = "ON" ]; then
write "/proc/touchpanel/double_tap_enable" "1"
 elif [ "$(READ "BLS1" $BLC)" = "OFF" ]; then
write "/proc/touchpanel/double_tap_enable" "0"
fi