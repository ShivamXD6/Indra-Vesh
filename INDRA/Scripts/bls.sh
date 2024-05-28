#!/system/bin/sh

# Menu
Menu() {
    echo -e '\n'
    printf "\033c" 
    indc "${C} ✦✧✦✧✦✧✦✧✦✧ Indra Vesh - Toggle Control ✧✦✧✦✧✦✧✦✧✦ ${N}"
    indc "${W} ✶ Toggle Control means, options with only 0 or 1 means which can turn on or off just like a switch. ✶ ${N}"
    indc "${Y} ✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦ ${N}"
    
cnt=1
while true; do
  name=$(READS "BLN$cnt" $BLC)
  status=$(READ "BLS$cnt" $BLC)
  
  if [ -z "$name" ]; then
    indc "${R} ✖ [0] Return to Indra's Menu ${N}"
    indc "${R} ✖ [+] Exit Directly ${N}"
    indc "${Y} ✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦ ${N}"
    indc "${C} ✷ Enter Number to Turn On or Off :  ${N}"   
    read option

    if [ "$option" == "0" ]; then
    Return

    elif [ "$option" == "+" ]; then
    GoOut

    elif [ "$option" -lt "$cnt" ] && echo "$option" | grep -qE '^[0-9]+$'; then
    id=$(READ "BLID$option" $BLC)
    name=$(READS "BLN$option" $BLC)
    status=$(READ "BLS$option" $BLC)
    link=$(READ "BLL$option" $BLC)
    touch $BLSRT/$id.sh
    local_size=$(stat -c %s "/$BLSRT/$id.sh")
    
    if [ "$local_size" -eq "0" ]; then
    Download $link $BLSRT/$id.sh
    fi
    
    if [ "$status" = "OFF" ] && [ ! "$local_size" -eq "0" ]; then
   Turn ON BLS$option $BLC $id "$name"
      elif [ "$status" = "ON" ] && [ ! "$local_size" -eq "0" ]; then
   Turn OFF BLS$option $BLC $id "$name"
else
    indc "${R} ✖ Internet is not working, Please check your internet connection. ${N}" 
sleep 3
Menu
break
      fi
    fi
Menu
break
 fi
  
  indc "${W} ❐ [$cnt] $name - ($status)"
  
  cnt=$((cnt + 1))
    done
    }

Return() {
    printf "\033c"
    indra
    exit 
    printf "\033c"
}

Reboot() {
    printf "\033c"
    reboot system
    printf "\033c"
}

printf "\033c"
Menu