#!/system/bin/sh
 
# Menu
Menu() {
    echo -e '\n'
    printf "\033c"
    indc "${C} ✦✧✦✧✦✧✦✧✦✧ Indra Vesh - Magic Kit ✧✦✧✦✧✦✧✦✧✦ ${N}"
    indc "${W} ✶ A Tool to Create your custom module, to Merge modules into a single zip or to Edit Modules.✶ ${N}"
    indc "${Y}  ✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦ ${N}"
    indc "${W} ❐ [1] Create Your Own Module ${N}"
    indc "${W} ❐ [2] Create Your Own Modules Package ${N}"
    indc "${R} ✖ [0] Return to Indra's Menu ${N}"
    indc "${R} ✖ [+] Exit Directly ${N}"
    indc "${Y} ✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦ ${N}"
    indc "${C} ✷ Enter Number Respective to its Menu:  ${N}"
    read option
    case $option in
        1) Option1 ;;
        2) Option2 ;;
        0) Return ;;
        +) GoOut ;;
        *) Menu ;;
    esac    
    }

Option1 () {
    printf "\033c"
    . "/$DB/Magic Kit/cyom.sh"
}

Option2 () {
    printf "\033c"
    . "/$DB/Magic Kit/merge.sh"
}

Return() {
    printf "\033c"
    indra
    exit
    printf "\033c"
} 

printf "\033c"
Menu