#!/bin/sh
###############################################
# Gustavo Arnosti Neves
#
# May / 2017
#
# Upgrade packages listed by:
# opkg list-upgradable
#
# Will list packages and ask for confirmation
# Use ./opkg-upgrade.sh --help for more info
#
# This Script:
# https://github.com/tavinus/opkg-upgrade


### Initialization
OPKGUPVERSION="0.1.2"
OPKGBIN="$(which opkg 2>/dev/null)"
BANNERSTRING="Simple OPKG Updater v$OPKGUPVERSION"

### Silly SH
TRUE=0
FALSE=1

### Execution FLAGS
CHECK_UPDATES_FLAG=$TRUE
FORCE_FLAG=$FALSE

### This scripts name
OPKGUP_NAME="$(basename $0)"

### Execution vars, populated later
PACKS=""
PACKS_NAMES=""
PACKS_COUNT=""


### Main function
main() {
    print_banner
    check_for_opkg
    if should_run_update; then
        opkg_update
    else
        message_ends "Ignoring package lists update"
    fi
    opkg_upgradable
    if ! opkg_has_update; then
        echo $'\nNo packages to install!\n'
        exit 0
    fi
    echo $'\n'"Packages available for upgrade: $PACKS_COUNT"$'\n'
    echo -e "$PACKS"
    if ! no_confirm; then
        if ! confirm_upgrade; then
            echo $'Cancelled by user!\n'
            exit 3
        fi
    else
        echo ""
    fi
    do_upgrade
    exit $?
}

### Parse CLI options
get_options() {
    while :; do
        case "$1" in
            -V|--version|--Version)
                print_banner 'nopadding' ; exit 0 ;;
            -h|--help|--Help)
                print_help ; exit 0 ;;
            -n|--no-pkg-update)
                CHECK_UPDATES_FLAG=$FALSE ; shift ;;
            -f|--force)
                FORCE_FLAG=$TRUE ; shift ;;
            *)  
                check_invalid_opts "$1" ; break ;;
        esac
    done
}

check_invalid_opts() {
    if [[ ! -z "$1" ]]; then
        print_banner
        echo "Invalid Option: $1"$'\n'
        exit 2
    fi
    return 0    
}

### Printing functions
print_banner() {
    local str=""
    if [[ "$1" = 'nopadding' ]]; then
        str="$BANNERSTRING"
    else
        str=$'\n'"$BANNERSTRING"$'\n'
    fi
    echo "$str"
}

print_help() {
    print_banner
    echo "Usage: $OPKGUP_NAME [-n,-f]

Options:
  -V, --version           Show program name and version and exits
  -h, --help              Show this help screen and exits
  -n, --no-opkg-update    Skip opkg update at the beginning,
                          may not find packages if not up to date
  -f, --force             Do not ask for confirmation,
                          will update everything available

Notes:
  Parameters should not be grouped.
  You must pass each parameter on its own.
  The order is irrelevant.

Examples:
  $OPKGUP_NAME -nf     # INVALID PARAMETER
  $OPKGUP_NAME -n -f   # VALID PARAMETERS
"
}

message_starts() {
    echo -n ".... | $1"$'\r'
}

message_ends() {
    [[ -z "$1" ]] && mess="" || mess="$1"
    echo "Done | $mess"
}

### Sanity checks
check_for_opkg() {
    if [[ ! -x "$OPKGBIN" ]]; then
        echo $'ERROR! Could not find or run OPKG binary\n'
        exit 1
    fi
}

### OPKG Update
opkg_update() {
    message_starts "Updating package lists"
    "$OPKGBIN" update >/dev/null;
    message_ends
}

should_run_update() {
    return $CHECK_UPDATES_FLAG
}

### OPKG Upgradable
opkg_upgradable() {
    message_starts "Getting upgradable packages list"
    PACKS="$($OPKGBIN list-upgradable)"
    #PACKS="$(cat pkg-example.txt)" # testing
    PACKS_NAMES="$(echo -ne "$PACKS" | awk '{ printf "%s ", $1 }')"
    PACKS_COUNT="$(echo "$PACKS" | wc -l)"
    message_ends
}

opkg_has_update() {
    [[ -z "$PACKS" ]] && return $FALSE
    return $TRUE
}

### CLI interaction
no_confirm() {
    return $FORCE_FLAG
}

confirm_upgrade() {
    read -p $'\nProceed with upgrade? (Y/y to proceed) ' -n 1 -r
    echo $'\n'
    if [[ "$REPLY" = Y || "$REPLY" = y ]]; then
        return $TRUE
    fi
    return $FALSE
}

### Upgrade packages
do_upgrade() {
    message_starts $'Upgrading packages\n\n'
    "$OPKGBIN" install $PACKS_NAMES
    ret=$?
    echo ""
    message_ends $'Upgrade finished\n'
    echo $'Please check for config file conflicts!\n'
    return $ret
}

### Start execution
get_options "$@"
main

exit 20 # should never get here
