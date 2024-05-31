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
