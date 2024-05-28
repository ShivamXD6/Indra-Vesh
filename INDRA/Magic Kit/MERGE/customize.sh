#!/system/bin/sh

# Abort in Recovery 
if ! $BOOTMODE; then
  ui_print " ! Only uninstall is supported in recovery"
  ui_print " - Uninstalling $(grep_prop name "$MODPATH"/module.prop)!"
  touch $MODPATH/remove
  sh $MODPATH/uninstall.sh
  recovery_cleanup
  rm -rf $NVBASE/modules_update/$MODID $TMPDIR 2>/dev/null
  exit 0
fi

# Read Files
READS() {
  value=$(grep -m 1 "^$1=" "$2" | sed 's/^.*=//')
  echo "${value//[[:space:]]/ }"
}

# Check which Rooting Tool were used to Root Mobile
if [ -d "/data/adb/magisk" ] && magisk -V >/dev/null 2&>1 || magisk -v >/dev/null 2&>1; then
ROOT="Magisk"
CMD="magisk --install-module"
elif [ -d "/data/adb/ksu" ] && ksud -V >/dev/null 2&>1 || ksud -v >/dev/null 2&>1; then
ROOT="KSU"
CMD="ksud module install"
elif [ -d "/data/adb/ap" ] && apd -V >/dev/null 2&>1 || apd -v >/dev/null 2&>1; then
ROOT="APatch"
CMD="apd module install"
else
ROOT="INVALID, Contact @ShastikXD On Telegram"
fi

# Installation Begins
ui_print ""
ui_print " - Installing $(READS name "$MODPATH"/module.prop) Module Pack "
ui_print ""
ui_print " - Created Using Magic Kit (From Indravesh Menu)"
ui_print ""
cp -af "$MODPATH/Modules" "/data/tmp/"

# Change Installation type for Each type of Package
INSTYP=QUICK
if [ "$INSTYP" = "QUICK" ]; then

cnt=1
for module in "$MODPATH/Modules"/*; do
    if [ -d "$module" ]; then
        filename=$(basename "$module")
        modname=$(READS name "$module/module.prop")
        ui_print " - [$cnt] - Installing $modname"
        ui_print ""
        cp -af "$MODPATH/Modules/$filename" "/data/adb/modules/$filename"
    fi
cnt=$((cnt + 1))
done

elif [ "$INSTYP" = "ADVANCE" ]; then

cnt=1
for module in "$MODPATH/Modules"/*.zip; do
    if [ -f "$module" ]; then
        filename=$(basename "$module")
        ui_print " - [$cnt] - Installing $filename"
        ui_print ""
       $CMD "/data/tmp/Modules/$filename"
    fi
cnt=$((cnt + 1))
done

fi
ui_print " - Installation Done of All Modules"
ui_print ""
ui_print " - Ignore Errors If you get any after this"
ui_print ""
ui_print " - You can Reboot Now!!"

# Cleanup
 rm -rf "$MODPATH"
rm -rf /data/tmp/Modules