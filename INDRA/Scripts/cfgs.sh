#!/system/bin/sh 
 
# Menu
Menu() {
    echo -e '\n'
    printf "\033c" 
    indc "${C} ✦✧✦✧✦✧✦✧✦✧ Indra Vesh - Configuration ✧✦✧✦✧✦✧✦✧✦ ${N}"
    indc "${W} ✶ Module-specific settings to utilize custom scripts and other user-defined configurations. ✶ ${N}"
    indc "${Y}✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦ ${N}"
    indc "${W} ❐ [1] Custom Script ${G}["$(READ "CSST"  "$CFGC")"] ${N}"
    indc "${W} ❐ [2] Change Custom Script Directory ${N}"
    indc "${W} ❐ [3] Logs ${G}["$(READ "LOGS" "$CFGC")"] ${N}"
    indc "${W} ❐ [4] Minimal BootLoop Saver ${G}["$(READ "BTLOOP" "$CFGC")"] ${N}"
    indc "${R} ✖ [0] Return to Indra's Menu ${N}"
    indc "${R} ✖ [+] Exit Directly ${N}"
    indc "${Y}✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦ ${N}"
    indc "${C} ✷ Enter Number Respective to its option:  ${N}"
    read option
    case $option in
        1) Option1 ;;
        2) Option2 ;;
        3) Option3 ;;
        4) Option4 ;;
        0) Return ;;
        +) GoOut ;;
        *) Menu ;;
    esac    
    }

Option1 () {
    printf "\033c" 
    if [ "$(READ "CSST" "$CFGC")" = "Enabled" ]; then
      sed -i "0,/CSST/ s/CSST=.*/CSST=Disabled/" "$CFGC"
      else
      sed -i "0,/CSST/ s/CSST=.*/CSST=Enabled/" "$CFGC"
    fi
Menu
}

Option2 () {
    printf "\033c"
    if [ "$(READ "CSST" "$CFGC")" = "Enabled" ]; then
    indc "${G} Enter New Directory for your Custom Scripts${N}"
    indc "${G} Current Directory = "$(READ "CSDI" "$CFGC")" ${N}"
    indc "${G} Leave Empty to set Default one ${N}"
    read DIR
  if [ -z "$DIR" ]; then
    sed -i "0,/^CSDI=/s|^CSDI=.*|CSDI=/sdcard/#INDRA|" "$CFGC"
   indc "${G} Changed Directory to = /sdcard/#INDRA${N}"
   sleep 2
  elif [ -d "$DIR" ]; then
    sed -i "0,/^CSDI=/s|^CSDI=.*|CSDI=$DIR|" "$CFGC"
    indc "${G} Changed Directory to = $DIR${N}"
    sleep 2
    else
    indc "${R} ✖ $DIR Directory not Found${N}"
    sleep 2
    fi
else
indc "${R} ✖ Please enable Custom Script${N}"
sleep 2
fi
Menu
}

Option3 () {
    printf "\033c" 
    if [ "$(READ "LOGS" "$CFGC")" = "Enabled" ]; then
      sed -i "0,/LOGS/ s/LOGS=.*/LOGS=Disabled/" "$CFGC"
      else
      sed -i "0,/LOGS/ s/LOGS=.*/LOGS=Enabled/" "$CFGC"
    fi
Menu
}

Option4 () {
    printf "\033c" 
    if [ "$(READ "BTLOOP" "$CFGC")" = "Enabled" ]; then
      sed -i "0,/BTLOOP/ s/BTLOOP=.*/BTLOOP=Disabled/" "$CFGC"
      else
      sed -i "0,/BTLOOP/ s/BTLOOP=.*/BTLOOP=Enabled/" "$CFGC"
    fi
Menu
}

Return() {
    printf "\033c"
    indra
    printf "\033c"
}

printf "\033c"
Menu