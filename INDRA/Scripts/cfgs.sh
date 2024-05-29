#!/system/bin/sh 
 
# Menu
Menu() {
    echo -e '\n'
    printf "\033c" 
    indc "${C} ✦✧✦✧✦✧✦✧✦✧ Indra Vesh - Configuration ✧✦✧✦✧✦✧✦✧✦ ${N}"
    indc "${W} ✶ Module-specific settings to utilize custom scripts and other user-defined configurations. ✶ ${N}"
    indc "${Y}  ✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦ ${N}"
    indc "${W} ❐ [1] "$(READ "CSST"  "$CFGC")" Custom Script ${N}"
    indc "${W} ❐ [2] Change Custom Script Directory ${N}"
    indc "${W} ❐ [3] "$(READ "LOGS" "$CFGC")" Logs ${N}"
    indc "${W} ❐ [4] Clear Database ${N}"
    indc "${R} ✖ [0] Return to Indra's Menu ${N}"
    indc "${R} ✖ [+] Exit Directly ${N}"
    indc "${Y} ✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦ ${N}"
    indc "${C} ✷ Enter Number Respective to its Menu:  ${N}"
    read option
    case $option in
        1) Option1 ;;
        2) Option2 ;;
        3) Option3 ;;
        4) Option4 ;;
        0) GoOut ;;
        *) Menu ;;
    esac    
    }

Option1 () {
    printf "\033c" 
    if [ "$(READ "CSST" "$CFGC")" = "Enable" ]; then
      sed -i "0,/CSST/ s/CSST=.*/CSST=Disable/" "$CFGC"
      else
      sed -i "0,/CSST/ s/CSST=.*/CSST=Enable/" "$CFGC"
    fi
}

Option2 () {
    printf "\033c"
    indc "${G}Enter New Directory for your Custom Scripts${N}"
    indc "${G}Current Directory = "$(READ "CSDI" "$CFGC")" ${N}"
    read DIR
   if [ -d "$DIR" ]; then
    sed -i "0,/CSDI/ s/CSDI=.*/CSDI=$DIR/" "$CFGC"
    indc "${G} Changed Directory to = $DIR${N}"
    else
    indc "${R} ✖ $DIR Directory not Found${N}"
    fi
}

Option3 () {
    printf "\033c"
    . /$DB/Scripts/mks
}

Return() {
    printf "\033c"
    Menu
    printf "\033c"
}

printf "\033c"
Menu