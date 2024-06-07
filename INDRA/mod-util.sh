#!/system/bin/sh

# Create logs dir if doesn't exist
if [ ! -d "/sdcard/#INDRA/Logs" ]; then
mkdir -p "/sdcard/#INDRA/Logs"
touch "/sdcard/#INDRA/Logs/menu.log"
fi
INDLOG="/sdcard/#INDRA/Logs/menu.log"
exec 2>>"$INDLOG"

# READ <property> <file>
READ() {
  value=$(sed -e '/^[[:blank:]]*#/d;s/[\t\n\r ]//g;/^$/d' "$2" | grep -m 1 "^$1=" | cut -d'=' -f 2)
  echo "$value"
  return $?
}

# READS <property> <file>
READS() {
  value=$(grep -m 1 "^$1=" "$2" | sed 's/^.*=//')
  echo "${value//[[:space:]]/ }"
}

# Indra's Logs
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
    echo -e "$1"
    echo ""
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

# Grep prop
grep_prop() {
  local REGEX="s/^$1=//p"
  shift
  local FILES=$@
  [[ -z "$FILES" ]] && FILES='/system/build.prop'
  sed -n "$REGEX" $FILES 2>/dev/null | head -n 1
}

# Defines Directories 
MODPATH="/data/adb/modules/indra-vesh"
DB=/data/INDRA
BLSRT=$DB/BLScripts
CFSRT=$DB/CFScripts
SRT=$DB/Scripts
CONF=$DB/Configs
BLC=$CONF/blc.txt
CFC=$CONF/cfc.txt
CFGC=$CONF/cfgc.txt
CYOM="$DB/Magic Kit/CYOM"
MOD="$CYOM/Module"
ROOTDIR=/data/adb/modules
MERGE="$DB/Magic Kit/MERGE"
MODPACK="$MERGE/ModPack"
UPC=$CONF/upc.txt

# Check A/B slot
if [[ -d /system_root ]]; then
  isABDevice=true
  SYSTEM=/system_root/system
  SYSTEM2=/system
  CACHELOC=/data/cache
else
  isABDevice=false
  SYSTEM=/system
  SYSTEM2=/system
  CACHELOC=/cache
fi
[[ -z "$isABDevice" ]] && { echo " ❌ Something went wrong"; exit 1; }

# mktouch <file> <content of the file>
mktouch() {
  mkdir -p "${1%/*}" 2>/dev/null
  [[ -z $2 ]] && touch "$1" || echo "$2" > "$1"
  chmod 644 "$1"
}

# Device Info
# Variables: BRAND MODEL DEVICE API ABI ABI2 ABILONG ARCH
BRAND=$(getprop ro.product.brand)
MODEL=$(getprop ro.product.model)
DEVICE=$(getprop ro.product.device)
ROM=$(getprop ro.build.display.id)
API=$(grep_prop ro.build.version.sdk)
ABI=$(grep_prop ro.product.cpu.abi | cut -c-3)
ABI2=$(grep_prop ro.product.cpu.abi2 | cut -c-3)
ABILONG=$(grep_prop ro.product.cpu.abi)
ARCH=arm
ARCH32=arm
IS64BIT=false
if [[ "$ABI" = "x86" ]]; then ARCH=x86; ARCH32=x86; fi;
if [[ "$ABI2" = "x86" ]]; then ARCH=x86; ARCH32=x86; fi;
if [[ "$ABILONG" = "arm64-v8a" ]]; then ARCH=arm64; ARCH32=arm; IS64BIT=true; fi;
if [[ "$ABILONG" = "x86_64" ]]; then ARCH=x64; ARCH32=x86; IS64BIT=true; fi;
  
# Defines
VER=$(READ version "$MODPATH"/module.prop)
REL=$(READ versionCode "$MODPATH"/module.prop)
AUTHOR=$(READS author "$MODPATH"/module.prop)
MODT=$(READS name "$MODPATH"/module.prop)

# Colors
G='\e[01;32m'		# GREEN TEXT
R='\e[01;31m'		# RED TEXT
Y='\e[01;33m'		# YELLOW TEXT
B='\e[01;34m'		# BLUE TEXT
V='\e[01;35m'		# VIOLET TEXT
Bl='\e[01;30m'		# BLACK TEXT
C='\e[01;36m'		# CYAN TEXT
W='\e[01;37m'		# WHITE TEXT
BGBL='\e[1;30;47m'	# Background W Text Bl
N='\e[0m'			# How to use (example): echo "${G}example${N}"
loadBar=' '			# Load UI
# Remove color codes if -nc or in ADB Shell
[[ -n "$1" ]] && [[ "$1" = "-nc" ]] && shift && NC=true
[[ "$NC" ]] || [[ -n "$ANDROID_SOCKET_adbd" ]] && {
  G=''; R=''; Y=''; B=''; V=''; Bl=''; C=''; W=''; N=''; BGBL=''; loadBar='=';
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

# Check for Internet Connection
test_net() {
if timeout 5 ping -q -c 1 -W 1 google.com >/dev/null 2>&1; then
    CONNECTION="${G}Online"
    NET="ON"
else
    CONNECTION="${R}Offline"
    NET="OFF"
fi
}

# ProgressBar <progress> <total>
ProgressBar() {
# Determine Screen Size
  if [[ "$COLUMNS" -le "57" ]]; then
    local var1=2
	local var2=20
  else
    local var1=4
    local var2=40
  fi
# Process data
  local _progress=$(((${1}*100/${2}*100)/100))
  local _done=$(((${_progress}*${var1})/10))
  local _left=$((${var2}-$_done))
# Build progressbar string lengths
  local _done=$(printf "%${_done}s")
  local _left=$(printf "%${_left}s")

# Build progressbar strings and print the ProgressBar line
printf "\rProgress : ${BGBL}|${N}${_done// /${BGBL}$loadBar${N}}${_left// / }${BGBL}|${N} ${_progress}%%"
}

# Downloading any File and Displaying progress using Progress Bar
# Download <url> <filepath/filename>
Download() {
local url=$1
local filepath=$2
test_net
if [ "$NET" = "ON" ]; then
online_size=$(curl -sI "$url" | grep -i Content-Length | awk '{print $2}' | tr -d '')
touch "$filepath" 
local_size=$(stat -c %s "$filepath")
curl -L "$url" -o "$filepath" > /dev/null 2>&1 &
while [ "$local_size" -lt "$online_size" ]; do
local_size=$(stat -c %s "$filepath")
ProgressBar "$local_size" "$online_size"
sleep 1
done
printf "\033c"
else
   indc "${R} ✖ Internet is not working, Please check your internet connection. ${N}"
sleep 3
indra
exit
fi
}

# Function to turn on or off Toggle Control Options
Turn() {
local bool=$1
local value=$2
local file=$3
local id=$4
local name=$5
SET "$value" "$bool" "$file"
ind "# Turning $bool $name"
source "$BLSRT/$id.sh"
}