# Systemless Host
if [ ! -d "/data/adb/magisk" ]; then
    if [ "$(READ "BLS4" "$BLC")" = "OFF" ]; then
      rm -rf "$DB/system"
      rm -rf "$DB/worker"
      echo "\e[01;31m!! Reboot Required \e[0m"
      sleep 2
    elif [ ! "$(getprop sys.boot_completed)" == "1" ]; then
mount -t overlay -o lowerdir=/system/etc,upperdir=/data/INDRA/system/etc,workdir=/data/INDRA/worker SYSHOST /system/etc
    else
      mkdir -p "$DB/system/etc"
      cp -af /system/etc/hosts "$DB/system/etc/hosts"
     chcon -r u:object_r:system_file:s0 "$DB/system"
     chmod 644 "$DB/system/etc/hosts"
     mkdir -p "$DB/worker"
      echo "\e[01;31m!! Reboot Required \e[0m"
      sleep 2
    fi
      else
     echo "\e[01;31mIt's not Required on Magisk \e[0m"
     sleep 2
fi