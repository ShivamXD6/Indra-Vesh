#!/system/bin/sh

touch /data/INDRA/reboot.log
INDLOG="/data/INDRA/reboot.log"
exec 2> >(tee -ai $INDLOG >/dev/null)

# Defines
DB=/data/INDRA
SRT=$DB/BLScripts
CONF=$DB/Configs
BLC=$CONF/blc.txt
CFGC=$CONF/cfgc.txt
MODPATH="${0%/*}"

# Read Files (Without Space)
READ() {
  value=$(sed -e '/^[[:blank:]]*#/d;s/[\t\n\r ]//g;/^$/d' "$2" | grep -m 1 "^$1=" | cut -d'=' -f 2)
  echo "$value"
  return $?
}

# Read Files (With Space)
READS() {
  value=$(grep -m 1 "^$1=" "$2" | sed 's/^.*=//')
  echo "${value//[[:space:]]/ }"
}

# Indra's Reboot Logs
echo "##### INDRA - Reboot Logs - [$(date)] #####" >> "$INDLOG"
ind () {
      if [ "$1" = "Exclude" ]; then
      echo "" >> /dev/null;
      else
      echo "" >> "$INDLOG"
      echo "$1 - [$(date)]" >> "$INDLOG"
      exec 2> >(tee -ai $INDLOG >/dev/null)
      fi
}

# Write
write() {
 [[ ! -f "$1" ]] && return 1
 chmod +w "$1" 2> /dev/null
 if ! echo "$2" > "$1"   2> /dev/null
 then
  return 1  
 fi
}

# Execute Scripts
EXSC() {
    local script="$1"
    local comment="$2"
    chmod +x "$script"
    ind "# $comment"
    . "$script"
}

if [ "$(READ "BTLOOP" "$CFGC")" = "Enabled" ]; then
# Check for Bootloop
# Credit - HuskyDG
ind "# Checking for Bootloop"
disable_modules(){
   ind " - Bootloop Detected, Disabling Modules"
   list="$(find /data/adb/modules/* -prune -type d)"
   for module in $list
   do
      touch $module/disable
   done
   ind " - Disabled all modules Including Myself :)"
   rm -rf /cache/.system_booting /data/unencrypted/.system_booting /metadata/.system_booting /persist/.system_booting /mnt/vendor/persist/.system_booting
   ind " - Rebooting Now"
   reboot
   exit
}

# Gather Process IDs & Disable Modules if zygote not started or PID didn't match
sleep 15
ZYGOTE_PID1=$(getprop init.svc_debug_pid.zygote)
sleep 15
ZYGOTE_PID2=$(getprop init.svc_debug_pid.zygote)
sleep 15
ZYGOTE_PID3=$(getprop init.svc_debug_pid.zygote)
if [ -z "$ZYGOTE_PID1" ]
then
   ind " - Zygote didn't start? Disabling Modules"
   disable_modules
fi
if [ "$ZYGOTE_PID1" != "$ZYGOTE_PID2" -o "$ZYGOTE_PID2" != "$ZYGOTE_PID3" ]
then
   ind " - PID mismatch, checking again $ZYGOTE_PID1 ≠ $ZYGOTE_PID2 ≠ $ZYGOTE_PID3"   
   sleep 10
   ZYGOTE_PID4=$(getprop init.svc_debug_pid.zygote)
   if [ "$ZYGOTE_PID3" != "$ZYGOTE_PID4" ]
   then
      ind " - Still Process ID not matched $ZYGOTE_PID3 ≠ $ZYGOTE_PID4..."
      disable_modules
   fi
fi
ind "# No Bootloop Found :)"
fi

# Start Executing Indra's Scripts 
cnt=1
while :; do
    id=$(READ "BLID$cnt" "$BLC")
    [ -z "$id" ] && break
    for file in "$SRT"/*.sh; do
        [ -f "$file" ] || continue
        filename=$(basename "$file" .sh)
        if [ "$filename" = "$id" ]; then
            name=$(READS "BLN$cnt" "$BLC")
            status=$(READ "BLS$cnt" "$BLC")
            EXSC "$file" "Turning $status $name"
            break
        fi
    done
    cnt=$((cnt + 1))
done

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
sed -i "/ro.build.version.security_patch/s/.*/ro.build.version.security_patch=$SP/" "$MODPATH/system.prop"
sed -i "/ro.vendor.build.security_patch/s/.*/ro.vendor.build.security_patch=$SP/" "$MODPATH/system.prop"
sed -i "/ro.build.version.real_security_patch/s/.*/ro.build.version.real_security_patch=$SP/" "$MODPATH/system.prop"

# Ram Management Tweaks
ind "# Applying Ram Management Tweaks"
write "/sys/module/lowmemorykiller/parameters/enable_adaptive_lmk" "0"
write "/sys/module/lowmemorykiller/parameters/vmpressure_file_min" "33280"
write "/sys/module/lowmemorykiller/parameters/minfree" "2048,4096,8192,16384,24576,32768"

# After Boot Complete 
{
 until [[ -e "/sdcard/" ]]; do
        sleep 1
    done

ind "# Mobile Turned on, Applying Remaining Changes"
if [ "$(READ "CSST" "$CFGC")" = "Enabled" ]; then
CS="$(READ "CSDI" "$CFGC")"
mkdir -p "$DB/Custom"
# Copy Custom Scripts to Database Dir
for script in "$CS"/*.sh; do
    if [ -f "$script" ]; then
        filename=$(basename "$script")
        cp "$script" "$DB/Custom/$filename"
    fi
done

# Start Executing Custom Scripts
for file in "$DB/Custom"/*.sh; do
    if [ -f "$file" ]; then
    filename=$(basename "$file")
   EXSC "$file" "Successfully Executed your Custom $filename Script"
    fi
done
rm -rf "$DB/Custom"
fi

# Indra's Menu Logs
touch /sdcard/#INDRA/Logs/menu.log
INDMLOG="/sdcard/#INDRA/Logs/menu.log"
echo "##### INDRA - Menu Logs - [$(date)] #####" > "$INDMLOG"
echo "" >> "$INDMLOG"
echo "# Write 'su -c indra' in Termux to access menu" >> "$INDMLOG"
if [ "$(READ "LOGS" "$CFGC")" = "Disabled" ]; then
rm -rf /sdcard/#INDRA/Logs/*
fi

# Copy Logs to Sdcard
cp -af "/data/INDRA/reboot.log" "/sdcard/#INDRA/Logs/reboot.log"
rm -rf /data/INDRA/reboot.log
}&
