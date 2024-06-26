# Setup Module Pack Environment
indc "${G} ✪ Setting up Module Pack Environment... ${N}"
mkdir -p "$MODPACK/Modules"
mkdir -p "/sdcard/#INDRA/Modules"
cp -af "$MERGE/META-INF" "$MODPACK"
cp -af "$MERGE/module.prop" "$MODPACK"
cp -af "$MERGE/customize.sh" "$MODPACK"

# Download zip bin if not found
zip_size=$(stat -c %s "$DB/zip")
if [ "$local_size" -eq "0" ]; then
Download "https://raw.githubusercontent.com/ShivamXD6/Indra-Vesh/main/Portal/zip" "$DB/zip"
chmod +x "$DB/zip"
clear
fi
sleep 3

indc "${G} ✪ Give a name to your Module Pack ${N}"
read NAME

if [ -z "$NAME" ]; then
SET "name" "Module-Pack" "$MODPACK/module.prop"
setprop MPName Module-Pack
else
SET "name" "$NAME" "$MODPACK/module.prop"
setprop MPName "$NAME"
fi

Menu() {
printf "\033c"
rm -rf /data/tmp/*
indc "${C} ✪ Select Method you want to use to Pack Modules${N}"
indc "${W} ✪ Module Pack Name - $(getprop MPName)${N}"
indc "${W} ✪ [1] Quick - ${G}Fast${N}"
indc "${Y} ✪ This method will add All Currently Installed Modules into Pack.
 Not Recommended, if you're going to install Module Pack on other device or Custom ROMs. ${N}"
indc "${W} ✪ [2] Advanced - ${G}Slow ${N}"
indc "${Y} ✪ This method will add Modules from Custom Directory of your Choice.
 Recommended, for almost every module. ${N}"
indc "${W} ✪ [3] Change Module Pack Name ${N}"
indc "${R} ✪ [0] Return to Main Menu ${N}"
read option
    case $option in
        1) Option1 ;;
        2) Option2 ;;
        3) Option3 ;;
        0) Return ;;
        *) Menu ;;
    esac
}

Option1() {
indc "${G} ✪ Start Packing Currently Installed Modules... ${N}"
cnt=1
sleep 3
for module in "$ROOTDIR"/*; do
    if [ -d "$module" ]; then
        filename=$(basename "$module")
        if [ ! "$filename" = "lost+found" ]; then
        modname=$(READS name "$module/module.prop")
        cp -af "$module" "$MODPACK/Modules/$filename"
        indc "${G} ✪ [$cnt] Adding $modname into your $(READ "name" "$MODPACK"/module.prop) Module Pack ${N}"
        fi
sleep 1
    fi
cnt=$((cnt + 1))
done
SET "INSTYP" "QUICK" "$MODPACK/customize.sh"
cd "$MODPACK"
$DB/zip -r "/sdcard/#INDRA/$(READ "name" "$MODPACK"/module.prop).zip" . >> /dev/null;
indc "${C} ✪ Creation of $(READ "name" "$MODPACK"/module.prop) Module Pack Completed ✔ ${N}"
indc "${C} ✪ You can find you module pack here /sdcard/#INDRA/$(READ "name" "$MODPACK"/module.prop).zip ${N}"
rm -rf "$MODPACK"/Modules/*
sleep 5
Menu
}

Option2() {
indc "${G} ✪ Enter Directory in which your all Modules are located ${N}"
indc "${G} ✪ Or Leave Empty to use modules from /sdcard/#INDRA/Modules.${N}"
read DIR
if [ -z "$DIR" ]; then
DIR="/sdcard/#INDRA/Modules"
fi

if [ -d "$DIR" ]; then
indc "${G} ✪ Checking Modules in $DIR ${N}"
else
indc "${R} ✖ Please Enter Correct Directory of your Modules ${N}"
fi

if [ -d "$DIR" ] && ls "$DIR"/*.zip 1> /dev/null 2>&1; then
cnt=1
sleep 3
for module in "$DIR"/*.zip; do
    if [ -f "$module" ]; then
    unzip "$module" -d "/data/tmp" >> /dev/null;
    modfile=$(find "/data/tmp" -type f -name "module.prop" 2>/dev/null | head -n 1)
    if [ -n "$modfile" ]; then
        filename=$(basename "$module")
        modname=$(READS name "$modfile")
        cp -af "$module" "$MODPACK/Modules/$filename"
        indc "${G} ✪ [$cnt] Adding $modname into your $(getprop MPName) Module Pack ${N}"
        rm -rf /data/tmp/*
    fi
sleep 1
fi
cnt=$((cnt + 1))
done
SET "INSTYP" "ADVANCE" "$MODPACK/customize.sh"
cd "$MODPACK"
$DB/zip -r "/sdcard/#INDRA/$(getprop MPName).zip" . >> /dev/null;
indc "${C} ✪ Creation of $(getprop MPName) Module Pack Completed ✔ ${N}"
indc "${C} ✪ You can find your module pack here /sdcard/#INDRA/$(getprop MPName).zip ${N}"
rm -rf "$MODPACK"/Modules/*
sleep 5
else
indc "${R} ✪ No Modules Found in $DIR ${N}"
sleep 5
fi
Menu
}

Option3() {
indc "${G} ✪ Give a name to your Module Pack ${N}"
read NAME
SET "name" "$NAME" "$MODPACK/module.prop"
setprop MPName "$NAME"
Menu
}

Return() {
    printf "\033c"
    rm -rf "$MODPACK"
    rm -rf /data/tmp/*
    indra
    exit
}

Menu