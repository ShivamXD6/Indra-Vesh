# Network Enhancement
if [ "$(READ "BLS1" $BLC)" = "ON" ]; then
write "/proc/sys/net/ipv4/tcp_ecn" "1"
write "/proc/sys/net/ipv4/tcp_fastopen" "3"
write "/proc/sys/net/ipv4/tcp_syncookies" "0"
elif [ "$(READ "BLS1" $BLC)" = "OFF" ]; then
write "/proc/sys/net/ipv4/tcp_ecn" "0"
write "/proc/sys/net/ipv4/tcp_fastopen" "0"
write "/proc/sys/net/ipv4/tcp_syncookies" "0"
fi
if [ -e "/sdcard/" ]; then
settings put global airplane_mode_on 1 > /dev/null;
am broadcast -a android.intent.action.AIRPLANE_MODE --ez state true > /dev/null;
settings put global airplane_mode_on 0 > /dev/null;
am broadcast -a android.intent.action.AIRPLANE_MODE --ez state false > /dev/null;
fi