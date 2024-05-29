#!/system/bin/sh
touch /data/media/0/#INDRA/Logs/reboot.log
INDLOG="/data/media/0/#INDRA/Logs/reboot.log"
exec 2>>"$INDLOG" 

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
echo "##### INDRA - Reboot Logs #####" > "$INDLOG"
ind () {
    if [ "$1" = "Exclude" ]; then
      exec 2>/dev/null;
    else
      echo "" >> "$INDLOG"
      echo "# $1 - [$(date)]" >> "$INDLOG"
      exec 2>>"$INDLOG" 
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
    . "$script"
    ind "$comment"
}

# Start Executing Indra's Scripts 
cnt=1
for file in "$SRT"/*.sh; do
    if [ -f "$file" ]; then
    filename=$(basename "$file")
    name=$(READS "BLN$cnt" $BLC)
    status=$(READ "BLS$cnt" $BLC)
    EXSC "$file" "Turning $status $name"
    cnt=$((cnt + 1))
    fi
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
ind "Updating Security Patch Level to $SP"

# Updates Security Patch
sed -i "/ro.build.version.security_patch/s/.*/ro.build.version.security_patch=$SP/" "$MODPATH/system.prop"
sed -i "/ro.vendor.build.security_patch/s/.*/ro.vendor.build.security_patch=$SP/" "$MODPATH/system.prop"
sed -i "/ro.build.version.real_security_patch/s/.*/ro.build.version.real_security_patch=$SP/" "$MODPATH/system.prop"

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

ind "Mobile Turned on, Applying Remaining Changes"
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
echo "##### INDRA - Menu Logs #####" > "$INDMLOG"
echo "# Write 'su -c indra' in Termux to access menu" >> "$INDMLOG"
if [ "$(READ "LOGS" "$CFGC")" = "Disabled" ]; then
rm -rf /sdcard/#INDRA/Logs/*
fi
}&
