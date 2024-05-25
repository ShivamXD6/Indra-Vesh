#!/system/bin/sh
 
# Menu
Menu() {
    echo -e '\n'
    printf "\033c"
    indc "${C} ✦✧✦✧✦✧✦✧✦✧ Indra Vesh - Magic Kit ✧✦✧✦✧✦✧✦✧✦ ${N}"
    indc "${W} ✶ A Tool to Create your custom module, to Merge modules into a single zip or to Edit Modules.✶ ${N}"
    indc "${Y}  ✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦ ${N}"
    indc "${W} ❐ [1] Create Your Own Module ${N}"
    indc "${W} ❐ [2] Merge Modules ${N}"
    indc "${W} ❐ [3] Edit Modules ${N}"
    indc "${R} ✖ [0] Exit ${N}"
    indc "${Y} ✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦ ${N}"
    indc "${C} ✷ Enter Number Respective to its Menu:  ${N}"
    read option
    case $option in
        1) Option1 ;;
        2) Option2 ;;
        3) Option3 ;;
        0) GoOut ;;
        *) Menu ;;
    esac    
    }

Option1 () {
    printf "\033c"
    . "/$DB/Magic Kit/cyom.sh"
}

Option2 () {
    printf "\033c"
    . /$DB/Scripts/cfs
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

Reboot() {
    printf "\033c"
    reboot system
    printf "\033c"
}

GoOut() {
    printf "\033c"
    ind "${G} ✓ All Done, See You next Time.${N}"
    exit
}

printf "\033c"
Menu 