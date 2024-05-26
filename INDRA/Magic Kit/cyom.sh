# Start Wizard
indc "${G} ✪ Starting Creating Wizard... ${N}"
sleep 2
if [ ! -d "$CYOM/Module" ]; then
mkdir -p "$CYOM/Module"
fi
indc "${R} ✪ You can use 'CTRL + C' anytime 
 to exit the Creating Wizard ${N}"
sleep 3

# Input Function for Meta Data
InputMTDT() {
local name=$1
printf "\033c"
indc "${C} ✪ Part - [1/4] Module Metadata ${N}"
indc "${G} ✪ $name ${N}"
read INPUT
until [ -n "$INPUT" ]; do
    read INPUT
done
}

# Input Function for Module Core
InputCORE() {
local name=$1
local desc=$2
printf "\033c"
indc "${C} ✪ Part - [2/4] Core of the Module ${N}"
indc "${G} ✪ $name ${N}"
if [ -n "$desc" ]; then
indc "${G} $desc ${N}"
fi
indc "${W} ✪ [1] Yes ${N}"
indc "${W} ✪ [2] No ${N}" 
read INPUT
while [ -z "$INPUT" ] || [ "$INPUT" -le "0" ] || [ "$INPUT" -ge "3" ]; do
    read INPUT
done
}

# Input Function for Core Module Features
InputFEA() {
local name=$1
local desc=$2
printf "\033c"
indc "${C} ✪ Part - [3/4] Core Features Selection ${N}"
indc "${G} ✪ $name ${N}"
if [ -n "$desc" ]; then
indc "${G} $desc ${N}"
fi
indc "${W} ✪ [1] Yes ${N}"
indc "${W} ✪ [2] No ${N}" 
read INPUT
while [ -z "$INPUT" ] || [ "$INPUT" -le "0" ] || [ "$INPUT" -ge "3" ]; do
    read INPUT
done
}

# Function to append some lines of codes
Append() {
local source_file="$1"
local destination_file="$2"
local comment="$3"
echo "$comment" >> "$destination_file"
sed -n "/$comment/,/^#/p" "$source_file" | sed -e "/$comment/d" -e '/^#/d' -e '/^[[:space:]]*$/d' | sed '/./,$!d' >> "$destination_file"
   echo "" >> "$destination_file" 
}

# Download zip bin if not found
if [ ! -f "$DB/zip" ]; then
Download "https://gitlab.com/shivamashokdhage6/indra-vesh/-/raw/main/zip?inline=false" "$DB/zip"
chmod +x "$DB/zip"
clear
fi

# Check if any saved state found
if [ -f "$MOD/MetadataDone" ] || [ -f "$MOD/CoreDone" ] || [ -f "$MOD/FeaDone" ] || [ -f "$MOD/Done" ]; then
indc "${G} ✪ Saved State Found !! ${N}"
indc "${G} ✪ Do you want to continue from Saved State? ${N}"
indc "${W} ✪ [1] Yes ${N}"
indc "${W} ✪ [2] No ${N}" 
read INPUT
while [ -z "$INPUT" ] || [ "$INPUT" -le "0" ] || [ "$INPUT" -ge "3" ]; do
read INPUT
done
if [ "$INPUT" -eq "2" ]; then
rm -rf "$MOD" > /dev/null;
mkdir -p "$MOD"
rm -rf "/data/MAGICKIT" > /dev/null;
fi
fi

if [ ! -f "$MOD/MetadataDone" ]; then
cp "$CYOM/module.prop" "$MOD/module.prop"
# Module Name
    InputMTDT "Enter Name for the Module"
    sed -i "/name/s/.*/name=$INPUT/" "$MOD/module.prop"
    
# Module Version
    InputMTDT "Enter Version for the Module"
    sed -i "0,/version/ s/version=.*/version=$INPUT/" "$MOD/module.prop"
    
# Module Author
    InputMTDT "Enter Author (Created By) For the Module"
    sed -i "/author/s/.*/author=$INPUT/" "$MOD/module.prop"
    
# Module Description 
    InputMTDT "Enter Description For the Module"
    sed -i "/description/s/.*/description=$INPUT/" "$MOD/module.prop"

printf "\033c"
 indc "${C} ✪ Part - [1/4] Module Metadata, Done ✔ ${N}"
 indc "${C} ✪ Part - [1/4] Saving State Please Wait ✔ ${N}"
 touch "/$MOD/MetadataDone"
 sleep 3
 fi

if [ ! -f "$MOD/CoreDone" ]; then
# Start Building Core of the Module
# System Props
InputCORE "Do you have any custom System Prop?" "It's a file in Magisk that lets you override or add system properties. For example, you could use it to trick apps into thinking your device is a different model." 
if [ "$INPUT" -eq "1" ]; then
indc "${G} ✪ Please enter proper directory of 
 your Custom System Prop. ${N}"
indc "${G} ✪ Example - /sdcard/Download/system.prop ${N}"
indc "${G} ✪ Leave Blank to Skip Custom Props ${N}"
read INPUT
if [ -z "$INPUT" ]; then
indc "${B} ✪ Will use Indra Vesh System Prop ${N}"
sleep 3
elif [ -f "$INPUT" ] && [ "$(basename "$INPUT")" = "system.prop" ]; then
indc "${B} ✪ Using Custom System Prop from $INPUT ${N}"
cp -af "$INPUT" "$MOD/system.prop"
touch "/$MOD/CustomProp"
sleep 3
else
while [ -n "$INPUT" ] && [ ! -f "$INPUT" ] || [ ! "$(basename "$INPUT")" = "system.prop" ]; do
indc "${R} ✖ Please enter proper directory of System Prop 
 Or Leave Empty to Skip Custom System Props ${N}"
read INPUT
done
indc "${B} ✪ Using Custom System Prop from $INPUT ${N}"
cp -af "$INPUT" "$MOD/system.prop"
touch "/$MOD/CustomProp"
sleep 3
fi
else
indc "${B} ✪ Will use Indra Vesh System Prop ${N}"
sleep 3
fi

# Service Script
InputCORE "Do you have any custom Service Script?" "A script in Magisk that runs during the boot animation. For example, it could be used to automatically start an SSH server every time the phone boots."
if [ "$INPUT" -eq "1" ]; then
indc "${G} ✪ Please enter proper directory of 
 your Custom Service Script. ${N}"
indc "${G} ✪ Example - /sdcard/Download/service.sh ${N}"
indc "${G} ✪ Leave Blank to Skip Custom Service Script ${N}"
read INPUT
if [ -z "$INPUT" ]; then
indc "${B} ✪ Using Inbuilt Service Script ${N}"
cp -af "$CYOM/service.sh" "$MOD/service.sh"
sleep 3
elif [ -f "$INPUT" ] && [ "$(basename "$INPUT")" = "service.sh" ]; then
indc "${B} ✪ Using Custom Service Script from $INPUT ${N}"
cp -af "$INPUT" "$MOD/service.sh"
touch "/$MOD/CustomService"
sleep 3
else
while [ -n "$INPUT" ] && [ ! -f "$INPUT" ] || [ ! "$(basename "$INPUT")" = "service.sh" ]; do
indc "${R} ✖ Please enter proper directory of Service Script 
 Or Leave Empty to Skip Custom Service Script ${N}"
read INPUT
done
indc "${B} ✪ Using Custom Service Script from $INPUT ${N}"
cp -af "$INPUT" "$MOD/service.sh"
touch "/$MOD/CustomService"
sleep 3
fi
else
indc "${B} ✪ Using Inbuilt Service Script ${N}"
cp -af "$CYOM/service.sh" "$MOD/service.sh"
sleep 3
fi

# Customize Script
InputCORE "Do you have any custom Customize Script?" "This script in Magisk defines custom actions during module installation. As an example, it might set up specific permissions or move files to certain locations based on your device's configuration."
if [ "$INPUT" -eq "1" ]; then
indc "${G} ✪ Please enter proper directory of 
 your Custom Customize Script. ${N}"
indc "${G} ✪ Example - /sdcard/Download/customize.sh ${N}"
indc "${G} ✪ Leave Blank to Skip Custom Customize Script ${N}"
read INPUT
if [ -z "$INPUT" ]; then
indc "${B} ✪ Using Inbuilt Customize Script ${N}"
cp -af "$CYOM/customize.sh" "$MOD/customize.sh"
sleep 3
elif [ -f "$INPUT" ] && [ "$(basename "$INPUT")" = "customize.sh" ]; then
indc "${B} ✪ Using Custom Service Script from $INPUT ${N}"
cp -af "$INPUT" "$MOD/customize.sh"
sleep 3
else
while [ -n "$INPUT" ] && [ ! -f "$INPUT" ] || [ ! "$(basename "$INPUT")" = "customize.sh" ]; do
indc "${R} ✖ Please enter proper directory of Customize Script 
 Or Leave Empty to Skip Custom Customize Script ${N}"
read INPUT
done
indc "${B} ✪ Using Custom Customize Script from $INPUT ${N}"
cp -af "$INPUT" "$MOD/customize.sh"
sleep 3
fi
else
indc "${B} ✪ Using Inbuilt Customize Script ${N}"
cp -af "$CYOM/customize.sh" "$MOD/customize.sh"
sleep 3
fi

cp -af  "$CYOM/META-INF" "$MOD"
printf "\033c"
 indc "${C} ✪ Part - [2/4] Core of the Module , Done ✔ ${N}"
 indc "${C} ✪ Part - [2/4] Saving State Please Wait ✔ ${N}"
 touch "/$MOD/CoreDone"
 sleep 3
 fi

if [ ! -f "$MOD/FeaDone" ]; then
# Start Adding Core Features from Indravesh
if [ ! -f "$MOD/CustomProp" ]; then
# Features Related to System Props
touch "$MOD/system.prop"
InputFEA "Do you want to use Latest Security Patch?"  "Note - This is one time security patch means will not update automatically next time."
if [ "$INPUT" -eq "1" ]; then
Append "$MODPATH/system.prop" "$MOD/system.prop" "# Latest Security Patch"
fi

InputFEA "Do you want to add Minimal System Props Tweaks?"  "It Includes different System level tweaks. May work or not work depend on device."
if [ "$INPUT" -eq "1" ]; then
while true; do
clear
indc "${G} ✪ Which system props tweaks you want to include? ${N}"
indc "${W} ✪ [1] Dalvik ${N}"
indc "${W} ✪ [2] Disable Debugging and Logs ${N}"
indc "${W} ✪ [3] Performance ${N}"
indc "${W} ✪ [4] Battery ${N}"
indc "${W} ✪ [5] Multi-tasking ${N}"
indc "${W} ✪ [6] Smoothness ${N}"
indc "${W} ✪ [7] Network ${N}"
indc "${B} ✪ [0] Save ${N}"
indc "${R} !! Only select tweak once and then save it ${N}"
    read option
    case $option in
        1) Append "$MODPATH/system.prop" "$MOD/system.prop" "# Dalvik Tweaks" ;;
        2) Append "$MODPATH/system.prop" "$MOD/system.prop" "# Disable Logs (LMK and Vidc)" ;;
        3) Append "$MODPATH/system.prop" "$MOD/system.prop" "# Performance" ;;
        4) Append "$MODPATH/system.prop" "$MOD/system.prop" "# Battery" ;;
        5) Append "$MODPATH/system.prop" "$MOD/system.prop" "# Multitasking" ;;
        6) Append "$MODPATH/system.prop" "$MOD/system.prop" "# Smoothness" ;;
        7) Append "$MODPATH/system.prop" "$MOD/system.prop" "# Network" ;;
        0) break  ;;
        *) indc "${R} ✖ Please Enter a Number Corresponding to Tweak. ${N}" ;;
    esac
done
fi
fi

printf "\033c"
 indc "${C} ✪ Part - [3/4] Core Features of the Module , Done ✔ ${N}"
 indc "${C} ✪ Part - [3/4] Saving State Please Wait ✔ ${N}"
 touch "/$MOD/FeaDone"
 sleep 3
 fi

if [ ! -f "$MOD/MenuDone" ]; then
# Turn off Everything by default
if [ ! -f "$MOD/CustomService" ]; then
cnt=1
mkdir -p /data/MAGICKIT
cp -af "$BLC" "/data/MAGICKIT"
MDB=/data/MAGICKIT
MBLC=/data/MAGICKIT/blc.txt
while true; do
name=$(READS "BLN$cnt" "$MBLC")
status=$(READ "BLS$cnt" "$MBLC")
sed -i "/BLS$cnt/s/.*/BLS$cnt=OFF/" "$MBLC"
if [ -z "$name" ]; then
break 
fi
cnt=$((cnt + 1))
done

# Menu
Menu() {
clear
indc "${C} ✪ Part - [4/4] Menu Features Selection ${N}"
cnt=1
while true; do
  name=$(READS "BLN$cnt" $MBLC)
  
  if [ -z "$name" ]; then
    indc "${B} ✪ [0] Save ${N}"
    indc "${C} ✪ Select Menu Features you want to add By default ${N}"
    read option

    if [ "$option" == "0" ]; then
    break

    elif [ "$option" -lt "$cnt" ] && echo "$option" | grep -qE '^[0-9]+$'; then
    id=$(READ "BLID$option" $MBLC)
    name=$(READS "BLN$option" $MBLC)
    link=$(READ "BLL$option" $MBLC)
    touch $BLSRT/$id.sh
    local_size=$(stat -c %s "/$BLSRT/$id.sh")
    
    if [ "$local_size" -eq "0" ]; then
    Download $link $BLSRT/$id.sh
    fi
    
    if [ ! "$local_size" -eq "0" ]; then
   cp -af "$BLSRT/$id.sh" "$MDB/$id.sh"
   sed -i "/BLS$option/s/.*/BLS$option=ON/" "$MBLC"
   Menu
  break
else
    indc "${R} ✖ Internet is not working, Please check your internet connection. ${N}" 
sleep 5
Menu
break
      fi
   fi
fi
  
  indc "${W} ❐ [$cnt] $name "
  
  cnt=$((cnt + 1))
    done
}
Menu
fi

printf "\033c"
 indc "${C} ✪ Part - [4/4] Menu Features of the Module , Done ✔ ${N}"
 indc "${C} ✪ Everything Done.. ✔ ${N}"
 sleep 3
 indc "${C} ✪ Finalizing Module.. ${N}"
 cp -af  "$CYOM/uninstall.sh" "$MOD"
rm -rf "$MOD/MetadataDone"
rm -rf "$MOD/CoreDone"
rm -rf "$MOD/CustomProp"
rm -rf "$MOD/FeaDone"
rm -rf "$MOD/MenuDone"
rm -rf "$MOD/CustomService"
cd "$MOD"
 $DB/zip -r "/sdcard/#INDRA/$(READ "name" "$MOD"/module.prop).zip" . >> /dev/null;
 sleep 3
 fi

indc "${G} ✪ Creation of "$(READ "name" "$MOD"/module.prop)" Module Completed ✔ ${N}"
indc "${C} ✪ You can find you module here "/sdcard/#INDRA/$(READ "name" "$MOD"/module.prop).zip" ${N}"
indc "${C} ✪ Returning to Indra Menu ${N}"
sleep 5
rm -rf "$MOD"
indra
exit