#!/system/bin/sh

# Abort in Recovery 
if ! $BOOTMODE; then
  ui_print " ! Only uninstall is supported in recovery"
  ui_print " - Uninstalling INDRA VESH!"
  touch $MODPATH/remove
  sh $MODPATH/uninstall.sh
  recovery_cleanup
  rm -rf $NVBASE/modules_update/$MODID $TMPDIR 2>/dev/null
  exit 0
fi

# Defines & Functions
mkdir -p /sdcard/#INDRA/Logs
if [ -f "/data/INDRA/Configs/blc.txt" ]; then
  mv "/data/INDRA/Configs/blc.txt" "/data/INDRA/Configs/old-blc.txt" 
fi 
cp -af $MODPATH/INDRA /data
DB=/data/INDRA

# INDRA LOGS
ui_print " 📝 For logs - /sdcard/#INDRA/Logs"
touch /sdcard/#INDRA/Logs/install.log
INDLOG="/sdcard/#INDRA/Logs/install.log"
echo "##### INDRA - Installation Logs #####" > "$INDLOG"
ind () {
  if [ -n "$1" ]; then
    echo "" >> "$INDLOG"
    echo "$1 - [$(date)]" >> "$INDLOG"
    ui_print "$1"
    ui_print ""
  fi
  exec 2> >(tee -ai $INDLOG >/dev/null)
}

# Read Files
READ() {
  value=$(sed -e '/^[[:blank:]]*#/d;s/[\t\n\r ]//g;/^$/d' "$2" | grep -m 1 "^$1=" | cut -d'=' -f 2)
  echo "$value"
  return $?
} 

# Write Function
write() {
 [[ ! -f "$1" ]] && return 1
 chmod +w "$1" 2> /dev/null
 if ! echo "$2" > "$1"   2> /dev/null
 then
  return 1  
 fi
}

# Installation Begins
ui_print ""
ind "          ⚡ INDRA-VESH ⚡"
ind "          🧑‍💻 By @ShastikXD 💠"
ind "          ℹ️ Version :- Amrit💧"
ind "          🔐 Auto Security Patch"
ind "          💿 Ram Management"
ind "          🌟 Many Things in Indra's Menu"
ind "⌨️ Type 'su -c indra' to access Menu and features of Module"

# Preserve User Settings of Toggle Control
if [ -f "/data/INDRA/Configs/old-blc.txt" ]; then
cnt=1
while true; do
  status=$(READ "BLS$cnt" "/data/INDRA/Configs/old-blc.txt")
  if [ -z "$status" ]; then
  break
  fi
  sed -i "/BLS$cnt/s/.*/BLS$cnt=$status/" "/data/INDRA/Configs/blc.txt"
  cnt=$((cnt + 1))
done 
fi

# Permissions and Cleanup
chmod 755 "$MODPATH/service.sh"
rm -rf $MODPATH/INDRA

ind "          ⚡ Indra Dev Arrives ✨"