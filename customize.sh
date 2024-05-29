#!/system/bin/sh
touch /sdcard/#INDRA/Logs/install.log
INDLOG="/sdcard/#INDRA/Logs/install.log"
exec 2>>"$INDLOG" 

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
cp -af "$MODPATH/INDRA" "/data"
DB=/data/INDRA

# INDRA LOGS
ui_print " 📝 For logs - /sdcard/#INDRA/Logs"
echo "##### INDRA - Installation Logs #####" > "$INDLOG"
ind () {
    if [ "$1" = "Exclude" ]; then
      exec 2>/dev/null;
    else
      echo "" >> "$INDLOG"
      echo "# $1 - [$(date)]" >> "$INDLOG"
      exec 2>>"$INDLOG" 
      ui_print "$1"
      ui_print ""
    fi
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

# Check which Rooting Tool were used to Root Mobile
if [ -d "/data/adb/magisk" ] && magisk -V >/dev/null 2&>1 || magisk -v >/dev/null 2&>1; then
ROOT="Magisk"
elif [ -d "/data/adb/ksu" ] && ksud -V >/dev/null 2&>1 || ksud -v >/dev/null 2&>1; then
ROOT="KSU"
elif [ -d "/data/adb/ap" ] && apd -V >/dev/null 2&>1 || apd -v >/dev/null 2&>1; then
ROOT="APatch"
else
ROOT="INVALID, Contact @ShastikXD On Telegram"
fi

# Installation Begins
ui_print ""
ind "          ⚡ INDRA-VESH ⚡"
ind "          🧑‍💻 By @ShastikXD 💠"
ind "          ℹ️ Version :- $(READ version "$MODPATH"/module.prop) "
ind "          🔧 Tool Used For Rooting :- $ROOT"
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

# Auto Security Patch Level
YEAR=$(date +%Y)
MONTH=$(date +%m)
MONTH=$((10#$MONTH))
NEXT_MONTH=$((MONTH))
if [ $NEXT_MONTH -gt 12 ]; then
    NEXT_MONTH=1
    YEAR=$((YEAR + 1))
fi
MONTH=$(printf "%02d" $NEXT_MONTH)
YEAR=$(printf "%04d" $YEAR)

# Latest Security Patch
SP="${YEAR}-${MONTH}-05"

# Updates Security Patch
sed -i "/ro.build.version.security_patch/s/.*/ro.build.version.security_patch=$SP/" "$MODPATH/system.prop"
sed -i "/ro.vendor.build.security_patch/s/.*/ro.vendor.build.security_patch=$SP/" "$MODPATH/system.prop"
sed -i "/ro.build.version.real_security_patch/s/.*/ro.build.version.real_security_patch=$SP/" "$MODPATH/system.prop"

# Permissions and Cleanup
chmod 755 "$MODPATH/service.sh"
rm -rf $MODPATH/INDRA

ind "          ⚡ Indra Dev Arrives ✨"