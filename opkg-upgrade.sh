#!/bin/sh
###############################################
# Gustavo Arnosti Neves
#
# Created: May / 2017
# Updated: Dec / 2018
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
OPKGUPVERSION="0.3.5"
OPKGBIN="$(command -v opkg 2>/dev/null)"
SSMTPBIN="$(command -v ssmtp 2>/dev/null)"
BANNERSTRING="Simple OPKG Updater v$OPKGUPVERSION"
TIMESTAMP="$(date '+%Y/%m/%d %H:%M:%S' 2>/dev/null)"
OPKGUP_INSTALL_DIR='/usr/sbin'
OPENWRT_RELEASE="/etc/openwrt_release"
ROUTER_NAME="$(uname -n)"
HTML_FONT="font-family:'Trebuchet MS', Helvetica, sans-serif;"

### Silly SH
TRUE=0
FALSE=1

### Execution FLAGS
QUIET_MODE=$FALSE
CHECK_UPDATES_FLAG=$TRUE
FORCE_FLAG=$FALSE
JUST_CHECK_FLAG=$FALSE
JUST_PRINT_FLAG=$FALSE
SSMTP_SEND_FLAG=$FALSE
SEND_TO=""
ALWAYS_SEND_FLAG=$FALSE
HTML_FORMAT=$TRUE
JUST_PRINT_HTML_FLAG=$FALSE

### This scripts name
OPKGUP_NAME="$(basename $0)"
OPKGUP_LOCATION="$(readlink -f $0)"

### Execution vars, populated later
PACKS=""
PACKS_NAMES=""
PACKS_COUNT=0




########################### FUNCTIONS STARTS

# Load info from /etc/openwrt_release into memory
source_release() {
    if is_file "$OPENWRT_RELEASE"; then
        . "$OPENWRT_RELEASE"
    fi
}

# get opkg packages listings and upgradable info
opkg_init() {
    check_for_opkg
    if should_run_update; then
        opkg_update
    else
        message_ends "Ignoring package lists update"
    fi
    opkg_upgradable
}

# main function
main() {
    source_release
    print_banner
    opkg_init
    upgrade_check      # may exit here

    local uplist="$(list_upgrades)"
    if should_send_ssmtp || just_print_html; then
        if opkg_has_update || should_always_send || just_print_html; then
            QUIET_MODE=$FALSE
            local email_data=''
            if is_html_email; then
                email_data="$(print_html_email)"
            else
                email_data="$(print_txt_email "$uplist")"
            fi
            #local email_data="$(email_subject)"$'\n\n'"$(print_banner)"$'\n\n'"Report for: $ROUTER_NAME"$'\n\n'"$uplist"$'\n\n'"Generated on: $TIMESTAMP"
            if just_print_html; then
                echo -e "$email_data"
                exit 0
            else
                echo -e "$email_data" | "$SSMTPBIN" "$SEND_TO"
                exit $?
            fi
        fi
        exit 0
    else
        echo -e "$uplist"
    fi
    just_print && exit 0
    opkg_has_update || { echo '' ; exit 0 ; }
    
    openwrt_is_snapshot && print_snapshot_disclaimer

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

# Just checks if upgrades are available and exits with
# 0 - if there are updates available
# 1 - if there are NO updates available
# Depends on the $JUST_CHECK_FLAG to run
upgrade_check() {
    if just_check; then
        opkg_has_update && exit 0
        exit 1
    fi
}

# Prints the list of upgrades available,
# returns $TRUE if we have updates available, $FALSE otherwise
list_upgrades() {
    if opkg_has_update; then
        echo "Packages available for upgrade: $PACKS_COUNT"$'\n'
        #echo -e "$PACKS"
        print_packs_txt
        return $TRUE
    fi
    echo $'No packages to install!\n\n'
    return $FALSE
}

# Print router info in plain text
print_info_txt() {
                                           printf "%s\n" "Router name.: $ROUTER_NAME"
    is_not_empty "$DISTRIB_DESCRIPTION" && printf "%s\n" "Description.: $DISTRIB_DESCRIPTION"
    is_not_empty "$DISTRIB_TARGET"      && printf "%s\n" "Target......: $DISTRIB_TARGET"
    is_not_empty "$DISTRIB_ARCH"        && printf "%s\n" "Arch........: $DISTRIB_ARCH"
    echo ""
}

# Pretty print package lists in plain text
print_packs_txt() {
    echo -ne "$PACKS" | awk '
function rep(c, n){ s=sprintf("%" n "s",""); gsub(/ /,c,s); return s }
BEGIN{ j=1; } NR>0{
l[j, 1]=($1); 
l[j, 2]=($3); 
l[j++, 3]=($5);  
max[1]=(length($1)>max[1]?length($1):max[1]); 
max[2]=(length($3)>max[2]?length($3):max[2]); 
max[3]=(length($5)>max[3]?length($5):max[3]);
max[1]=(max[1]>=7?max[1]:7); 
max[2]=(max[2]>=7?max[2]:7); 
max[3]=(max[3]>=7?max[3]:7); 
} 
function div(){ printf "+-----+%s+%s+%s+\n", rep("-", max[1]+2), rep("-", max[2]+2), rep("-", max[3]+2) }
function head() { printf "| %3s | %-" max[1] "s | %-" max[2] "s | %-" max[3] "s |\n", "#", "Package", "Current", "Update" }
END {div() ; head() ; div() ; for (i=1; i<=NR; i++) printf "| %3d | %-" max[1] "s | %-" max[2] "s | %-" max[3] "s |\n", i, l[i, 1], l[i, 2], l[i, 3]; div()}'
}

### Parse CLI options
get_options() {
    while :; do
        case "$1" in
            -V|--version|--Version)
                print_banner 'nopadding' ; exit 0 ;;
            -h|--help|--Help)
                print_help ; exit 0 ;;
            -i|--install)
                self_install "$2" ; exit $? ;;
            -u|--upgrade-check|--upgrade-Check|--upgradecheck|--upgradeCheck)
                QUIET_MODE=$TRUE ; JUST_CHECK_FLAG=$TRUE ; shift ;;
            -l|--list-upgrades|--list-Upgrades|--listupgrades|--listUpgrades)
                QUIET_MODE=$TRUE ; JUST_PRINT_FLAG=$TRUE ; shift ;;
            -e|--email-list|--email-List|--emaillist|--emailList)
                QUIET_MODE=$TRUE ; JUST_PRINT_HTML_FLAG=$TRUE ; shift ;;
            -s|--ssmtp)
                ssmtp_check "$2" ; shift ; shift ;;
            -a|--always-send|--always-Send|--alwayssend|--alwaysSend)
                ALWAYS_SEND_FLAG=$TRUE ; shift ;;
            -t|--text-only|--text-Only|--textonly|--textOnly)
                HTML_FORMAT=$FALSE ; shift ;;
            -n|--no-pkg-update)
                CHECK_UPDATES_FLAG=$FALSE ; shift ;;
            -f|--force)
                FORCE_FLAG=$TRUE ; shift ;;
            -q|--quiet)
                QUIET_MODE=$TRUE ; shift ;;
            *)
                check_invalid_opts "$1" ; break ;;
        esac
    done
}

# In this script's case, just check we have and emty string and we should be fine
check_invalid_opts() {
    if is_not_empty "$1"; then
        print_banner
        echo "Invalid Option: $1"$'\n'
        exit 2
    fi
    return 0
}



###### PRINTING MESSAGES

# prints message to stderr
print_error() {
    echo "$@" >&2
}

# Prints Warning about upgrading beta/trunk versions
print_snapshot_disclaimer() {
    printf "\n%s\n%s\n%s\n%s\n" "WARNING! You are running a Beta / Snapshot / Trunk version!" "Upgrading snapshots MAY cause undesired results, including soft-bricks." "The current trunk head may not be compatible with your installed version!" "You have been warned! Proceed at your own risk!"
}

# prints program name and version
print_banner() {
    [[ "$1" = 'error' ]] && { print_error $'\n'"$BANNERSTRING"$'\n' ; return $TRUE ; }
    is_quiet && ! just_print && return $TRUE
    local str=""
    if [[ "$1" = 'nopadding' ]]; then
        str="$BANNERSTRING"
    else
        str=$'\n'"$BANNERSTRING"$'\n'
    fi
    echo "$str"
}

# prints help to screen and exits
print_help() {
    print_banner
    echo "Usage: $OPKGUP_NAME [options]

Options:
  -V, --version         Show program name and version and exits
  -h, --help            Show this help screen and exits
  -i, --install [dir]   Install opkg-upgrade to [dir] or /usr/sbin
                        Leave [dir] empty for default (/usr/sbin)
  -u, --upgrade-check   Returns SUCCESS if there are updates available
                        Quiet execution, returns 0 or 1
  -l, --list-upgrades   Prints the list of available updates and exits
  -e, --email-list      Prints the list of updates in html email format
                        Includes subject, mime type and html formated data
  -s, --ssmtp <email>   Use the system's ssmtp to send update reports
                        You need to install and configure ssmtp beforehand
  -a, --always-send     Send e-mail even if there are no updates
                        By default e-mails are only sent when updates are available
  -t, --text-only       Send e-mail in plain text format.
                        By default, e-mails are sent in html format.
  -n, --no-opkg-update  Skip opkg update at the beginning,
                        may not find packages if not up to date
  -f, --force           Do not ask for confirmation,
                        will update everything available

Notes:
  - Short options should not be grouped. You must pass each parameter on its own.
  - You must have a working ssmtp install to use the ssmtp functionality. Make
    sure you can send e-mails from it before trying from opkg-upgrade.

Examples:
  $OPKGUP_NAME -n -f      # run without updating listings and asking for upgrade
  $OPKGUP_NAME --install  # install to /usr/sbin/opkg-upgrade
  $OPKGUP_NAME -l         # just print upgrades available
  $OPKGUP_NAME -e         # just print html formatted email
  $OPKGUP_NAME -s 'mail@example.com'    # mail upgrade report if have updates
  $OPKGUP_NAME -a -s 'mail@example.com' # mail upgrade report even if NO updates
  $OPKGUP_NAME -u && echo 'upgrades are available' || echo 'no upgrades available'

"
}

# prints message to screen with trailling '\r' to change the line later
message_starts() {
    is_quiet && return $TRUE
    echo -n ".... | $1"$'\r'
}

# prints message to screen, closes a task message
message_ends() {
    is_quiet && return $TRUE
    is_empty "$1" && mess="" || mess="$1"
    echo "Done | $mess"
}

# checks if we have opkg available
check_for_opkg() {
    if ! is_executable "$OPKGBIN"; then
        print_error $'ERROR! Could not find or run OPKG binary\n'
        exit 1
    fi
}



##### ERROR HANDLING

# Displays a runtinme error and exits execution
rt_exception() {
    local r=1
    is_empty "$2" || r=$2
    print_error "$1"
    exit $r
}



###### OPKG UPDATE AND UPGRADEABLE

# update package listings
opkg_update() {
    message_starts "Updating package lists"
    local err="$("$OPKGBIN" update 2>&1 >/dev/null)";
    is_empty "$err" || rt_exception $'Error when trying to update the package listings.\nDebug Info:\n'"$err"
    message_ends
}

# get list of upgradable packages
opkg_upgradable() {
    message_starts "Getting upgradable packages list"
    PACKS="$($OPKGBIN list-upgradable | sort | grep -v 'marked HOLD or PREFER')"
    #[ $? -eq 0 ] || rt_exception $'Error when trying list upgradable packages. Permissions?\n'
    #PACKS="$(cat pkg-example.txt)" # testing
    if ! is_empty "$PACKS"; then
        PACKS_NAMES="$(echo -ne "$PACKS" | awk '{ printf "%s ", $1 }')"
        #echo -ne "$PACKS" | awk '{ printf "pack: %s from: %s to: %s \n", $1, $3, $5 }'
        PACKS_COUNT="$(echo "$PACKS" | wc -l)"
    fi
    message_ends
    is_quiet || echo ""
    return $TRUE
}



###### CREATING EMAILS

# prints an email report in html format
print_html_email() {
    echo "$(email_subject)""$(print_html_mime)""$(print_html_header)""$(print_html_table)""$(print_html_timestamp)"
}

# prints an email report in txt format
print_txt_email() {
    #echo "$(email_subject)"$'\n\n'"$(print_banner)"$'\n\n'"Report for: $ROUTER_NAME"$'\n\n'"$1"$'\n\n'"Generated on: $TIMESTAMP"
    echo "$(email_subject)"$'\n\n'"$(print_banner)"$'\n\n'"$(print_info_txt)"$'\n\n'"$1"$'\n\n'"Generated on: $TIMESTAMP"
}

# prints the packages html table
print_html_table() {
    echo '<br>'
    is_empty "$PACKS" && { echo '<br><br><h3 style="'"$HTML_FONT"' font-size:13pt; font-weight:bold">No packages to install.</h3>' ; return $TRUE ; }
    local td_padding='padding-left:8px;padding-right:10px;padding-top:12px;padding-bottom:12px;'
    local td_open='<td style=\"'"$td_padding"'\">'
    local th_open='<th style="'"$td_padding"'">'
    echo '<table border="1" width="600px" cellpadding="0" cellspacing="0" style="border-collapse:collapse; '"$HTML_FONT"' font-size:10pt">'
    echo '<tr style="background-color:#2f3263; color:#EEE;" align="left" margin=0 padding=0>'$'\n\t'"$th_open"'#</th>'$'\n\t'"$th_open"'Pack</th>'$'\n\t'"$th_open"'Current</th>'$'\n\t'"$th_open"'Update</th>'$'\n''</tr>'
    # most of the table is generated using awk
    echo -ne "$PACKS" | \
awk 'BEGIN{ i=1; l=""; } { if (i % 2) l=""; else l=" style=\"background-color:#dedfe8;\""; printf "<tr margin=0 padding=0 align=\"left\"%s>\n\t'"$td_open"'%s</td>\n\t'"$td_open"'%s</td>\n\t'"$td_open"'%s</td>\n\t'"$td_open"'%s</td>\n</tr>\n", l, i++, $1, $3, $5 }'
    echo '</table>'
    return $TRUE
}

# prints html email info
print_html_header() {
    echo $'\n\n''<h2 style="'"$HTML_FONT"' font-size:14pt; margin-top:1.5em; font-weight:bold">'"$(print_banner 'nopadding')"'</h2>'
    echo '<table border="1" width="600px" cellpadding="6pt" cellspacing="0" style="border-collapse:collapse;'"$HTML_FONT"' font-size:11pt">'
    
    echo '<tr><td style="font-weight:bold">Router Name</td><td>'"$ROUTER_NAME"'</td></tr>'
    is_not_empty "$DISTRIB_DESCRIPTION" && echo '<tr><td style="font-weight:bold">Description</td><td>'"$DISTRIB_DESCRIPTION"'</td></tr>'
    is_not_empty "$DISTRIB_TARGET" && echo '<tr><td style="font-weight:bold">Target</td><td>'"$DISTRIB_TARGET"'</td></tr>'
    is_not_empty "$DISTRIB_ARCH" && echo '<tr><td style="font-weight:bold">Arch</td><td>'"$DISTRIB_ARCH"'</td></tr>'
    echo '<tr><td style="font-weight:bold">Updates Count</td><td>'"$PACKS_COUNT"'</td></tr>'
    echo '</table>'
}

# prints html email mime type and format
print_html_mime() {
    echo $'\nMIME-Version: 1.0\nContent-Type: text/html; charset=utf-8'
}

# prints html email info footer
print_html_timestamp() {
    echo $'\n''<h4 style="'"$HTML_FONT"'">'"Generated on: $TIMESTAMP by "'<a href="https://github.com/tavinus/opkg-upgrade">opkg-upgrade</a></h4>'$'\n'
}

# prints the email subject
email_subject() {
    echo "Subject: opkg-upgrade report - $TIMESTAMP"
}



###### UPGRADING

# asks the user to confirm the upgrade
confirm_upgrade() {
    read -p $'\nProceed with upgrade? (Y/y to proceed) ' -n 1 -r
    echo $'\n'
    if [[ "$REPLY" = Y || "$REPLY" = y ]]; then
        return $TRUE
    fi
    return $FALSE
}

# run the upgrade
do_upgrade() {
    message_starts $'Upgrading packages\n\n'
    "$OPKGBIN" install $PACKS_NAMES
    ret=$?
    message_ends $'\nUpgrade finished\n'
    echo $'Please check for config file conflicts!\n'
    return $ret
}



###### SELF INSTALL

# Locates and copies itself to target location and make it executable
self_install() {
    print_banner
    is_empty "$1" || OPKGUP_INSTALL_DIR="$1"
    echo "Current Location: $OPKGUP_LOCATION"
    echo "      Target Dir: $OPKGUP_INSTALL_DIR"
    if ! is_dir "$OPKGUP_INSTALL_DIR"; then
        print_error $'\n'"Error! Target directory not found!"
        print_error " -> $OPKGUP_INSTALL_DIR"
        exit 40
    fi
    local t="$OPKGUP_INSTALL_DIR/opkg-upgrade"
    local status="$(cp "$OPKGUP_LOCATION" "$t" 2>&1)"
    #echo "status: $status"
    if is_not_empty "$status"; then
        print_error "  Could not copy: $t"
        print_error $'\n'"Error: $status"
        exit 33
    fi
    echo "    Installed to: $t"
    chmod +x "$t" 2>/dev/null
    [ $? -eq 0 ] && status="OK" || status="Fail"
    echo "chmod executable: $status"
    echo $'\nInstalled with success, bye!\n'
    exit $?
}



###### VALIDATORS

# returns $TRUE if we have a valid e-mail address, $FALSE otherwise
is_valid_email() {
    is_empty "$1" && return $FALSE
    local f=$(echo "$1" | grep -E -o "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}$")
    is_empty "$f" && return $FALSE
    return $TRUE
}

# returns $TRUE if it is a valid file, $FALSE otherwise
is_file() {
    [ -f "$1" ] && return $TRUE
    return $FALSE
}

# returns $TRUE if it is a valid folder, $FALSE otherwise
is_dir() {
    [ -d "$1" ] && return $TRUE
    return $FALSE
}

# Returns $TRUE if the file exists and is executable, $FALSE otherwise
is_executable() {
    [ -f "$1" ] && [ -x "$1" ] && return $TRUE
    return $FALSE
}

# returns $TRUE for an empty var, $FALSE otherwise
is_empty() {
    [ -z "$1" ] && return $TRUE
    return $FALSE
}

# returns $FALSE for an empty var, $TRUE otherwise
is_not_empty() {
    [ -z "$1" ] && return $FALSE
    return $TRUE
}

# returns $TRUE if $PACKS is not empty
opkg_has_update() {
    is_empty "$PACKS" && return $FALSE
    return $TRUE
}

# returns $TRUE if $DISTRIB_RELEASE equals SNAPSHOT
openwrt_is_snapshot() {
    [ "$DISTRIB_RELEASE" = "SNAPSHOT" ] && return $TRUE
    return $FALSE
}




###### OPERATION FLAGS

# returns $TRUE if we should use the HTML format, $FALSE for TXT format
is_html_email() {
    return $HTML_FORMAT
}

# returns $TRUE if we are running in quiet mode, $FALSE otherwise
is_quiet() {
    return $QUIET_MODE
}

# returns $TRUE if we should update the package listings, $FALSE otherwise
should_run_update() {
    return $CHECK_UPDATES_FLAG
}

# return $TRUE if we should ask the user before upgrading, $FALSE otherwise
no_confirm() {
    return $FORCE_FLAG
}

# returns $TRUE if we should just check for updates and exit, $FALSE otherwise
just_check() {
    return $JUST_CHECK_FLAG
}

# returns $TRUE if we should just print the list and exit, $FALSE otherwise
just_print() {
    return $JUST_PRINT_FLAG
}

# returns $TRUE if we should send email with ssmtp, $FALSE otherwise
should_send_ssmtp() {
    return $SSMTP_SEND_FLAG
}

# returns $TRUE if we should send the e-mail even if there is no updates, $FALSE otherwise
should_always_send() {
    return $ALWAYS_SEND_FLAG
}

# returns $TRUE if we should just print the html report and exit, $FALSE otherwise
just_print_html() {
    return $JUST_PRINT_HTML_FLAG
}



###### SSMTP functions

# Finds and checks for ssmtp executable, returns $TRUE if found, $FALSE otherwise
find_ssmtp() {
    is_executable "$SSMTPBIN" && return $TRUE
    SSMTPBIN='/usr/sbin/ssmtp'
    is_executable "$SSMTPBIN" && return $TRUE
    return $FALSE
}

# Checks for ssmtp program, validates the target email and sets globals for emails
ssmtp_check() {
    if ! find_ssmtp; then
        print_banner 'error'
        print_error "Error! Could not find or run the SSMTP executable, make sure it is installed!"
        exit 30
    fi
    if ! is_valid_email "$1"; then
        print_banner 'error'
        print_error "Error! You need to specify a valid target e-mail address!"
        print_error "Invalid address -> $1"
        exit 30
    fi
    SSMTP_SEND_FLAG=$TRUE
    SEND_TO="$1"
    QUIET_MODE=$TRUE
}





###### START EXECUTION

get_options "$@"
main

exit 20 # should never get here
