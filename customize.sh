#!/system/bin/sh
mkdir -p /sdcard/#INDRA/Logs
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
DB="/data/INDRA"
if [ -f "$DB/Configs/blc.txt" ]; then
  mv "$DB/Configs/blc.txt" "$DB/Configs/old-blc.txt"
fi
cp -af "$MODPATH/INDRA"/* "$DB"

# INDRA LOGS
ui_print ""
ui_print " 📝 For logs - /sdcard/#INDRA/Logs"
echo "##### INDRA - Installation Logs - [$(date)] #####" > "$INDLOG"
ind () {
    if [ "$1" = "Exclude" ]; then
      exec 2>/dev/null;
    else
      echo "" >> "$INDLOG"
      echo "$1 - [$(date)]" >> "$INDLOG"
      exec 2>>"$INDLOG"
    fi
}

# Indra's Comments  
indc () {
  if [ -n "$1" ]; then
    ui_print "$1"
    ui_print ""
  fi
}

# READ <property> <file>
READ() {
  value=$(sed -e '/^[[:blank:]]*#/d;s/[\t\n\r ]//g;/^$/d' "$2" | grep -m 1 "^$1=" | cut -d'=' -f 2)
  echo "$value"
  return $?
}

# SET <property> <value> <file>
SET() {
  if [[ -f "$3" ]]; then
    if grep -q "$1=" "$3"; then
      sed -i "0,/^$1=/s|^$1=.*|$1=$2|" "$3"
      ind " - Setting $1 -> $2 in $3"
    else
      echo "$1=$2" >> "$3"
      ind " - Adding Variable $1=$2 in $3"
    fi
  fi
}

# write <file> <value> 
write() {
  if [[ ! -f "$1" ]]; then
    ind "- $1 doesn't exist, skipping..."
    return 1
	fi
  local curval=$(cat "$1" 2> /dev/null)
  if [[ "$curval" == "$2" ]]; then
    ind "- $1 is already set to $2, skipping..."
	return 1
  fi
  chmod +w "$1" 2> /dev/null
   if ! echo "$2" > "$1" 2> /dev/null
   then
     ind "× Failed: $1 -> $2"
	 return 0
   fi
  ind "- $1 $curval -> $2"
}

# Check which Rooting Tool were used to Root Mobile
ind "# Checking for Root Tool"
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
ind "# Installing Module"
ui_print ""
indc "          ⚡ INDRA-VESH ⚡"
indc "          🧑‍💻 By @ShastikXD 💠"
indc "          ℹ️ Version :- $(READ version "$MODPATH"/module.prop) "
indc "          🔧 Tool Used For Rooting :- $ROOT"
indc "          🔐 Auto Security Patch"
indc "          💿 Ram Management"
indc "          🌟 Many More in Indra's Menu"
indc "⌨️ Type 'su -c indra' to access Menu and features of Module"

# Preserve User Settings of Toggle Control
if [ -f "$DB/Configs/old-blc.txt" ]; then
ind "# Preserving User Settings of Toggle Control"
cnt=1
while true; do
  status=$(READ "BLS$cnt" "$DB/Configs/old-blc.txt")
  if [ -z "$status" ]; then
  break
  fi
  SET "BLS$cnt" "$status" "$DB/Configs/blc.txt"
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
ind "# Updating Security Patch Level to $SP"

# Updates Security Patch
SET "ro.build.version.security_patch" "$SP" "$MODPATH/system.prop"
SET "ro.vendor.build.security_patch" "$SP" "$MODPATH/system.prop"
SET "ro.build.version.real_security_patch" "$SP" "$MODPATH/system.prop"

# Cleanup
ind "# Performing Cleanups"
rm -rf $MODPATH/INDRA
rm -rf /data/INDRA/Configs/old-blc.txt

indc "          ⚡ Indra Dev Arrives ✨"
ind "# Indravesh Installed Successfully!!"