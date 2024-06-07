#!/system/bin/sh
touch /data/INDRA/reboot.log
INDLOG="/data/INDRA/reboot.log"
exec 2> >(tee -ai $INDLOG >/dev/null)

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
      echo "" >> /dev/null;
      else
      echo "" >> "$INDLOG"
      echo "$1 - [$(date)]" >> "$INDLOG"
      exec 2> >(tee -ai $INDLOG >/dev/null)
      fi
}

echo "" >> "$INDLOG"