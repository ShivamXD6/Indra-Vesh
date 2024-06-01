#!/system/bin/sh

touch /data/media/0/#INDRA/Logs/reboot.log
INDLOG="/data/media/0/#INDRA/Logs/reboot.log"
exec 2>>"$INDLOG"

# Defines
DB=/data/INDRA
CONF=$DB/Configs
BLC=$CONF/blc.txt
MODPATH=${0%/*}

# Read Files (Without Space)
READ() {
  value=$(sed -e '/^[[:blank:]]*#/d;s/[\t\n\r ]//g;/^$/d' "$2" | grep -m 1 "^$1=" | cut -d'=' -f 2)
  echo "$value"
  return $?
}

# Indra's Reboot Logs
echo "##### INDRA - Post Reboot Logs - [$(date)] #####" > "$INDLOG"
ind () {
    if [ "$1" = "Exclude" ]; then
      exec 2>/dev/null;
    else
      echo "" >> "$INDLOG"
      echo "$1 - [$(date)]" >> "$INDLOG"
      exec 2>>"$INDLOG" 
    fi
}

if [ "$(READ "BLS1" $BLC)" = "ON" ]; then
ind "# Applying Network Enhancements Tweaks by rawe_etc"
sysctl -p "$DB/sysctl.conf"
fi

echo "" >> "$INDLOG"