#!/bin/sh
###############################################
# Gustavo Arnosti Neves
#
# May / 2017
#
# Upgrade packages listed by:
# opkg list-upgradable
# Will list packages and ask for confirmation
#
# This Script:
# PLACEHOLDER
#
# Simple oneliner version:
# https://gist.github.com/tavinus/997d896cebd575bfaf1706ce6e701c2d



OPKGUPVERSION="0.1.1"
OPKGBIN="$(which opkg 2>/dev/null)"

message_start() {
    echo -n ".... | $1"$'\r'
}

message_ends() {
    [[ -z "$1" ]] && mess="" || mess="$1"
    echo "Done | $mess"
}


echo $'\nSimple OPKG Updater v'"$OPKGUPVERSION"$'\n'

if [[ ! -x "$OPKGBIN" ]]; then
    echo $'ERROR! Could not find or run OPKG binary\n'
    exit 1
fi



message_start "Updating package lists"
# "$OPKGBIN" update >/dev/null;
message_ends


message_start "Getting upgradable packages list"
PACKS="$($OPKGBIN list-upgradable)"
message_ends


if [[ -z "$PACKS" ]]; then
    echo $'\nNo packages to install!\n'
    exit 0
fi


PACKS_NAMES="$(echo -ne "$PACKS" | awk '{ printf "%s ", $1 }')"


echo $'\nThese are the packages available for upgrade:\n'
echo -e "$PACKS"


read -p $'\nProceed with upgrade? (Y/y to proceed) ' -n 1 -r
echo $'\n'
if [[ "$REPLY" = Y || "$REPLY" = y ]]; then
    message_start $'Upgrading packages\n\n'
    "$OPKGBIN" install $PACKS_NAMES
    ret=$?
    echo ""
    message_ends $'Upgrade finished\n'
    echo $'\nPlease check for config file conflicts!\n'
    exit $ret
else
    echo $'Cancelled by user!\n'
    exit 0
fi


exit 0
