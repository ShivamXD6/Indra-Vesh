# Network Enhancement
if [ "$(READ "BLS1" $BLC)" = "ON" ]; then
iptables -t nat -I OUTPUT -p tcp --dport 53 -j DNAT --to-destination 8.8.8.8:53 2>/dev/null
iptables -t nat -I OUTPUT -p udp --dport 53 -j DNAT --to-destination 8.8.8.8:53 2>/dev/null
write "/proc/sys/net/ipv4/tcp_ecn" "1"
write "/proc/sys/net/ipv4/tcp_fastopen" "3"
write "/proc/sys/net/ipv4/tcp_syncookies" "0"
write "/proc/sys/net/ipv4/tcp_fin_timeout" "5"
write "/proc/sys/net/ipv4/tcp_keepalive_intvl" "30"
write "/proc/sys/net/ipv4/tcp_keepalive_probes" "5"
write "/proc/sys/net/ipv4/tcp_tw_recycle" "1"
write "/proc/sys/net/ipv4/tcp_tw_reuse" "1"
write "/proc/sys/fs/file-max" "10000000"
write "/sys/module/nf_conntrack/parameters/hashsize" "250000"
write "/proc/sys/net/ipv4/tcp_congestion_control" "cubic"
write "/proc/sys/net/ipv4/conf/all/rp_filter" "1"
write "/proc/sys/net/ipv4/conf/default/rp_filter" "1"
write "/proc/sys/net/ipv4/tcp_sack" "1"
write "/proc/sys/net/ipv4/tcp_window_scaling" "1"
write "/proc/sys/net/ipv4/tcp_no_metrics_save" "1"
write "/proc/sys/net/core/rmem_max" "8738000"
write "/proc/sys/net/core/wmem_max" "6553600"
write "/proc/sys/net/ipv4/tcp_rmem" "8192,873800,8738000"
write "/proc/sys/net/ipv4/tcp_wmem" "4096,655360,6553600"
write "/proc/sys/net/ipv4/tcp_tw_reuse" "1"
write "/proc/sys/net/ipv4/tcp_max_tw_buckets" "360000"
write "/proc/sys/net/core/netdev_max_backlog" "30000"
write "/proc/sys/net/ipv4/tcp_max_syn_backlog" "16384"
write "/proc/sys/net/ipv4/ip_local_port_range" "30000,65535"
write "/proc/sys/net/ipv4/tcp_synack_retries" "1"
write "/proc/sys/net/ipv4/tcp_max_orphans" "400000"
write "/proc/sys/net/netfilter/nf_conntrack_max" "1000000"
elif [ "$(READ "BLS1" $BLC)" = "OFF" ]; then
indc "${R} !! Reboot Required${N}"
sleep 2
fi


{
 until [[ "$(getprop sys.boot_completed)" == "1" ]] && [[ -e "/sdcard" ]]; do
		sleep 1
	done
# Turn On & Off Airplane Mode 
ind "Exclude"
am broadcast -a android.intent.action.AIRPLANE_MODE --ez state true > /dev/null;
am broadcast -a android.intent.action.AIRPLANE_MODE --ez state false > /dev/null;
}&