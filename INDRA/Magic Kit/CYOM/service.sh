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

# Nullified Indra's Logs if found any
ind () {
      echo "$1 - [$(date)]" >> /dev/null;
}

# SET <property> <value> <file>
SET() {
  if [[ -f "$3" ]]; then
    if grep -q "$1=" "$3"; then
      sed -i "0,/^$1=/s|^$1=.*|$1=$2|" "$3"
    else
      echo "$1=$2" >> "$3"
    fi
  fi
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
    chmod +x "$script"
    . "$script"
}

# Start Executing Custom Module Scripts
for file in "$DB"/*.sh; do
    if [ -f "$file" ]; then
    EXSC "$file"
    fi
done

