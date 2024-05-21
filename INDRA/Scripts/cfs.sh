#!/system/bin/sh
 
# Menu
Menu() {
    echo -e '\n'
    printf "\033c"
    
    indc "${C} ✦✧✦✧✦✧✦✧✦✧ Indra Vesh - Tune Dynamics ✧✦✧✦✧✦✧✦✧✦ ${N}"
    indc "${W} ✶ A Menu of Many Useful scripts to Do a lot of things, needs user input to do something ✶ ${N}"
    indc "${Y} ✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦ ${N}"
    
  cnt=1
  while true; do
  name=$(READS "CFN$cnt" $CFC)
  
  if [ -z "$name" ]; then
    indc "${R} ✖ [0] Return to Indra's Menu ${N}"
    indc "${R} ✖ [+] Exit Directly ${N}"
    indc "${Y} ✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦ ${N}"
    indc "${C} ✷ Enter Number to Open that Menu :  ${N}"   
    read option

    if [ "$option" == "0" ]; then
    Return

    elif [ "$option" == "+" ]; then
    GoOut

    elif [ "$option" -lt "$cnt" ] && echo "$option" | grep -qE '^[0-9]+$'; then
    id=$(READ "CFID$option" $CFC)
    name=$(READS "CFN$option" $CFC)
    link=$(READ "CFL$option" $CFC)
    touch $CFSRT/$id.sh
    local_size=$(stat -c %s "/$CFSRT/$id.sh")
    
    if [ "$local_size" -eq "0" ]; then
    Download $link $CFSRT/$id.sh
    fi
    
    if [ ! "$local_size" -eq "0" ]; then
   ind "Opening $name"
   . $CFSRT/$id.sh
else
    indc "${R} ✖ Internet is not working, Please check your internet connection. ${N}" 
sleep 5 & e_spinner 
Menu
      fi
fi
   Menu
  fi
  
  indc "${W} ❐ [$cnt] $name"
  
  cnt=$((cnt + 1))
    done
    }
     
Return() {
    printf "\033c"
    indra
    exit 
    printf "\033c"
}

printf "\033c"
Menu