#!/system/bin/sh

# Defines
SD=/sdcard/#INDRA
DB=/data/INDRA
SRT=$DB/BLScripts
CONF=$DB/Configs
BLC=$CONF/blc.txt
MODPATH="${0%/*}"

# Read Files (Without Space)
READ() {
  value=$(sed -e '/^[[:blank:]]*#/d;s/[\t\n\r ]//g;/^$/d' "$2" | grep -m 1 "^$1=" | cut -d'=' -f 2)
  echo "$value"
  return $?
}

# Indra's Reboot Logs
touch /$DB/reboot.log
INDLOG="/$DB/reboot.log"
echo "##### INDRA - Reboot Logs #####" > "$INDLOG"
ind () {
  if [ -n "$1" ]; then
    echo "" >> "$INDLOG"
    echo " # $1 - [$(date)]" >> "$INDLOG"
  fi
  exec 2> >(tee -ai $INDLOG >/dev/null)
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

# Function to Execute Scripts
EXSC() {
    local script="$1"
    id="Successfully Executed Your Custom Script $2 File"
    source "$script"
    echo ""
    echo "$id"
    echo ""
}

# Copy Custom Scripts to Database Dir   
for script in "$SD"/*.sh; do
    if [ -f "$script" ]; then
        filename=$(basename "$script")
        cp "$script" "$SRT/$filename"
    fi
done

# Start Executing Custom and Indra Scripts 
for file in "$SRT"/*.sh; do
    if [ - "$file" ]; then
    filename=$(basename "$file")
    chmod +x "$file"
    EXSC "$SRT/$filename" "$SRT/$filename"
    fi
done

# Auto Security Patch Level
ind "Updating Security Patch Level"
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

# Network Enhancement
ind "Applying Network Tweaks"
write "/proc/sys/net/ipv4/tcp_ecn" "1"
write "/proc/sys/net/ipv4/tcp_fastopen" "3"
write "/proc/sys/net/ipv4/tcp_syncookies" "0"

# Ram Management Tweaks
ind "Applying Ram Management Tweaks"
write "/sys/module/lowmemorykiller/parameters/enable_adaptive_lmk" "0"
write "/sys/module/lowmemorykiller/parameters/vmpressure_file_min" "33280"
write "/sys/module/lowmemorykiller/parameters/minfree" "2048,4096,8192,16384,24576,32768"

# After Boot Complete 
{
 until [[ -e "/sdcard/" ]]; do
        sleep 1
    done

# Indra's Menu Logs
touch /sdcard/#INDRA/menu.log
INDMLOG="/sdcard/#INDRA/menu.log"
echo "##### INDRA - Menu Logs #####" > "$INDMLOG"
echo "---------- Write 'su -c indra' in Termux to access menu ----------" >> "$INDMLOG"

# Copy Logs to Sdcard
cp -af "/data/INDRA/reboot.log" "/sdcard/#INDRA/reboot.log"
}&
