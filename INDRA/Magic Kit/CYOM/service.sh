#!/system/bin/sh

# Defines
DB=/data/MAGICKIT
BLC=$DB/blc.txt
MODPATH="${0%/*}"

# Read Files (Without Space)
READ() {
  value=$(sed -e '/^[[:blank:]]*#/d;s/[\t\n\r ]//g;/^$/d' "$2" | grep -m 1 "^$1=" | cut -d'=' -f 2)
  echo "$value"
  return $?
}

# Write
write() {
 [[ ! -f "$1" ]] && return 1
 chmod +w "$1" 2> /dev/null
 if ! echo "$2" > "$1"   2> /dev/null
 then
  return 1  
 fi
}

# Execute Scripts
EXSC() {
    local script="$1"
    local comment="$2"
    chmod +x "$script"
    . "$script"
}

# Start Executing Custom Module Scripts
for file in "$DB"/*.sh; do
    if [ -f "$file" ]; then
    EXSC "$file" "Turning $status $name"
    fi
done