#!/system/bin/sh
mkdir -p /data/MAGICKIT
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

# Read Files (With Space)
READS() {
  value=$(grep -m 1 "^$1=" "$2" | sed 's/^.*=//')
  echo "${value//[[:space:]]/ }"
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
ui_print "$(READS name "$MODPATH"/module.prop) "
ui_print "Created By - $(READS author "$MODPATH"/module.prop)"
ui_print "Version :- $(READS version "$MODPATH"/module.prop) "

# Permissions
chmod 755 "$MODPATH/service.sh"