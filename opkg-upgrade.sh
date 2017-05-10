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
# From v0.1.2 it has -h, -V, -h and -f parameters
# Use ./opkg-upgrade.sh --help for more info
#
# This Script:
# https://gist.github.com/tavinus/bf6dff1c11e7c9951b829b4e33eb6076
#
# Simple oneliner version:
# https://gist.github.com/tavinus/997d896cebd575bfaf1706ce6e701c2d


### Initialization
OPKGUPVERSION="0.1.2"
OPKGBIN="$(which opkg 2>/dev/null)"

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
PACK_COUNT=""


### Main function
main() {
	print_banner
	if should_run_update; then
		opkg_update
	else
		message_ends "Ignoring Package lists update"
	fi
	opkg_upgradable
	if ! opkg_have_update; then
		echo $'\nNo packages to install!\n'
		exit 0
	fi
	echo $'\n'"Packages available for upgrade: $PACK_COUNT"$'\n'
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
				print_banner ; exit 0 ;;
			-h|--help|--Help)
				print_help ; exit 0 ;;
			-n|--no-pkg-update)
				CHECK_UPDATES_FLAG=$FALSE ; shift ;;
			-f|--force)
				FORCE_FLAG=$TRUE ; shift ;;
			-*) echo "Invalid option: $1" ; exit 2 ;;
			*) break ;;
		esac
	done
}

### Printing functions
print_banner() {
    echo $'\nSimple OPKG Updater v'"$OPKGUPVERSION"$'\n'
}

print_help() {
    print_banner
    echo "Usage: $OPKGUP_NAME [-nf]

Options:
  -V, --version           Show program name and version and exits
  -h, --help              Show this help screen and exits
  -n, --no-opkg-update    Skip opkg update at the beginning,
                          may not find packages if not up to date
  -f, --force             Do not ask for confirmation,
                          will update everything available
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
should_run_update() {
	return $CHECK_UPDATES_FLAG
}

opkg_update() {
	message_starts "Updating package lists"
	"$OPKGBIN" update >/dev/null;
	message_ends
}

### OPKG Upgradable
opkg_upgradable() {
	message_starts "Getting upgradable packages list"
	#PACKS="$($OPKGBIN list-upgradable)"
	PACKS="$(cat pkg-example.txt)" # testing
	PACKS_NAMES="$(echo -ne "$PACKS" | awk '{ printf "%s ", $1 }')"
    PACK_COUNT="$(echo "$PACKS" | wc -l)"
	message_ends
}

opkg_have_update() {
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
}

### Start execution
get_options "$@"
main

exit 20 # should never get here
