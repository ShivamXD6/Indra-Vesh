# Systemless Host
if [ ! -d "/data/adb/magisk" ]; then
    if [ "$(READ "BLS4" "$BLC")" = "OFF" ]; then
      rm -rf "$DB/system"
      echo "\e[01;31m!! Reboot Required \e[0m"
      sleep 2
    elif [ ! "$(getprop sys.boot_completed)" == "1" ]; then
      mount --bind "$DB/system/etc/hosts" /system/etc/hosts
    else
      mkdir -p "$DB/system/etc"
      cp -af /system/etc/hosts "$DB/system/etc/hosts"
      chmod 644 "$DB/system/etc/hosts"
      echo "\e[01;31m!! Reboot Required \e[0m"
      sleep 2
    fi
      else
     echo "\e[01;31mIt's not Required on Magisk \e[0m"
     sleep 2
fi