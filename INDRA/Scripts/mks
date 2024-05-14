#!/system/bin/sh

# In Progress
word1="> > > > > C O M I N G - -"
word2="- - S O O N > > > > > >"
indc="$word1 $word2"
clear
i=0
while [ $i -le ${#indc} ]; do
  echo -ne "${indc:0:i}"
  sleep 0.1
  clear
  ((i++))
done

i=0
while [ $i -lt 5 ] ; do
echo -ne "${G}${word1} ${C}${word2}${N}"
sleep 0.5
clear
echo -ne "${C}${word1} ${G}${word2}${N}"
sleep 0.5
clear
((i++))
done
indra
exit
 
# Menu
Menu() {
    echo -e '\n'
    printf "\033c"
    
    indc "${C} ✦✧✦✧✦✧✦✧✦✧ Indra Vesh - Magic Kit ✧✦✧✦✧✦✧✦✧✦ ${N}"
    indc "${W} ✶ Welcome to Indra-Vesh - Updater ${N}"
    indc "${W} ✶ Created & Written By @ShastikXD ${N}"
    indc "${W} ✶ Version = VAJRA ${N}"
    indc "${Y} ✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦✧✦ ${N}"
    indc "${W} ❐ [1] Update Binary Lever ${N}"
    indc "${W} ❐ [2] Update Custom Forge ${N}"
    indc "${W} ❐ [3] Update MagicKit ${N}"
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
    . /$DB/Scripts/bls
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