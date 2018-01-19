# opkg-upgrade
List and install OpenWRT / LEDE opkg upgradable packages.  

Little `ash` app for easier opkg package upgrades.

**You should check for config conflicts after upgrades!**  
**Make sure you have enough space on root before installing stuff!**  
This script is small enough but SSL support for curl/wget is not!  
You also need free space for downloading and installing the packages!  
  
**If you use OpenWRT(LEDE) trunk (dev snapshots), you should probably NOT upgrade**  
As [mentioned here](https://lede-project.org/docs/user-guide/extroot_configuration?s[]=extroot#remote_file_systems), if you are using the trunk snapshots, upgrading can soft-brick your device.  
Main releases are fine (just trunk/snapshots are affected by this).  
It is probably the opposite for releases (recommended to upgrade), since you will get security patches if you upgrade those.

### Help example:
```
# ./opkg-upgrade.sh -h

Simple OPKG Updater v0.2.0

Usage: opkg-upgrade.sh [options]

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
  opkg-upgrade.sh -n -f      # run without updating listings and asking for upgrade
  opkg-upgrade.sh --install  # install to /usr/sbin/opkg-upgrade
  opkg-upgrade.sh -l         # just print upgrades available
  opkg-upgrade.sh -e         # just print html formatted email
  opkg-upgrade.sh -s 'mail@example.com'    # mail upgrade report if have updates
  opkg-upgrade.sh -a -s 'mail@example.com' # mail upgrade report even if NO updates
  opkg-upgrade.sh -u && echo 'upgrades are available' || echo 'no upgrades available'

```

### Example run:
```
# ./opkg-upgrade.sh

Simple OPKG Updater v0.1.2

Done | Updating package lists
Done | Getting upgradable packages list

Packages available for upgrade: 23

luci-app-statistics - git-17.126.47277-596f476-1 - git-17.129.29271-6467df3-1
luci-app-adblock - git-17.126.47277-596f476-1 - git-17.129.29271-6467df3-1
luci-lib-ip - git-17.126.47277-596f476-1 - git-17.129.29271-6467df3-1
luci-app-samba - git-17.126.47277-596f476-1 - git-17.129.29271-6467df3-1
luci-theme-bootstrap - git-17.126.47277-596f476-1 - git-17.129.29271-6467df3-1
luci-app-qos - git-17.126.47277-596f476-1 - git-17.129.29271-6467df3-1
luci-app-firewall - git-17.126.47277-596f476-1 - git-17.129.29271-6467df3-1
luci-app-diag-core - git-17.126.47277-596f476-1 - git-17.129.29271-6467df3-1
luci-proto-ppp - git-17.126.47277-596f476-1 - git-17.129.29271-6467df3-1
luci-mod-admin-full - git-17.126.47277-596f476-1 - git-17.129.29271-6467df3-1
luci-base - git-17.126.47277-596f476-1 - git-17.129.29271-6467df3-1
luci-app-commands - git-17.126.47277-596f476-1 - git-17.129.29271-6467df3-1
luci-app-vnstat - git-17.126.47277-596f476-1 - git-17.129.29271-6467df3-1
luci-proto-ipv6 - git-17.126.47277-596f476-1 - git-17.129.29271-6467df3-1
luci-app-wol - git-17.126.47277-596f476-1 - git-17.129.29271-6467df3-1
luci-app-upnp - git-17.126.47277-596f476-1 - git-17.129.29271-6467df3-1
luci-app-minidlna - git-17.126.47277-596f476-1 - git-17.129.29271-6467df3-1
luci-lib-nixio - git-17.126.47277-596f476-1 - git-17.129.29271-6467df3-1
luci-lib-jsonc - git-17.126.47277-596f476-1 - git-17.129.29271-6467df3-1
luci-app-p910nd - git-17.126.47277-596f476-1 - git-17.129.29271-6467df3-1
luci - git-17.126.47277-596f476-1 - git-17.129.29271-6467df3-1
luci-app-transmission - git-17.126.47277-596f476-1 - git-17.129.29271-6467df3-1
luci-app-openvpn - git-17.126.47277-596f476-1 - git-17.129.29271-6467df3-1

Proceed with upgrade? (Y/y to proceed) y

.... | Upgrading packages

Upgrading luci-app-statistics on root from git-17.126.47277-596f476-1 to git-17.129.29271-6467df3-1...
Downloading http://downloads.lede-project.org/releases/17.01.1/packages/mipsel_74kc/luci/luci-app-statistics_git-17.129.29271-6467df3-1_all.ipk
Upgrading luci-app-adblock on root from git-17.126.47277-596f476-1 to git-17.129.29271-6467df3-1...
Downloading http://downloads.lede-project.org/releases/17.01.1/packages/mipsel_74kc/luci/luci-app-adblock_git-17.129.29271-6467df3-1_all.ipk
Upgrading luci-lib-ip on root from git-17.126.47277-596f476-1 to git-17.129.29271-6467df3-1...
Downloading http://downloads.lede-project.org/releases/17.01.1/packages/mipsel_74kc/luci/luci-lib-ip_git-17.129.29271-6467df3-1_mipsel_74kc.ipk
Upgrading luci-app-samba on root from git-17.126.47277-596f476-1 to git-17.129.29271-6467df3-1...
Downloading http://downloads.lede-project.org/releases/17.01.1/packages/mipsel_74kc/luci/luci-app-samba_git-17.129.29271-6467df3-1_all.ipk
Upgrading luci-theme-bootstrap on root from git-17.126.47277-596f476-1 to git-17.129.29271-6467df3-1...
Downloading http://downloads.lede-project.org/releases/17.01.1/packages/mipsel_74kc/luci/luci-theme-bootstrap_git-17.129.29271-6467df3-1_all.ipk
Upgrading luci-app-qos on root from git-17.126.47277-596f476-1 to git-17.129.29271-6467df3-1...
Downloading http://downloads.lede-project.org/releases/17.01.1/packages/mipsel_74kc/luci/luci-app-qos_git-17.129.29271-6467df3-1_all.ipk
Upgrading luci-app-firewall on root from git-17.126.47277-596f476-1 to git-17.129.29271-6467df3-1...
Downloading http://downloads.lede-project.org/releases/17.01.1/packages/mipsel_74kc/luci/luci-app-firewall_git-17.129.29271-6467df3-1_all.ipk
Upgrading luci-app-diag-core on root from git-17.126.47277-596f476-1 to git-17.129.29271-6467df3-1...
Downloading http://downloads.lede-project.org/releases/17.01.1/packages/mipsel_74kc/luci/luci-app-diag-core_git-17.129.29271-6467df3-1_all.ipk
Upgrading luci-proto-ppp on root from git-17.126.47277-596f476-1 to git-17.129.29271-6467df3-1...
Downloading http://downloads.lede-project.org/releases/17.01.1/packages/mipsel_74kc/luci/luci-proto-ppp_git-17.129.29271-6467df3-1_all.ipk
Upgrading luci-mod-admin-full on root from git-17.126.47277-596f476-1 to git-17.129.29271-6467df3-1...
Downloading http://downloads.lede-project.org/releases/17.01.1/packages/mipsel_74kc/luci/luci-mod-admin-full_git-17.129.29271-6467df3-1_mipsel_74kc.ipk
Upgrading luci-base on root from git-17.126.47277-596f476-1 to git-17.129.29271-6467df3-1...
Downloading http://downloads.lede-project.org/releases/17.01.1/packages/mipsel_74kc/luci/luci-base_git-17.129.29271-6467df3-1_mipsel_74kc.ipk
Upgrading luci-app-commands on root from git-17.126.47277-596f476-1 to git-17.129.29271-6467df3-1...
Downloading http://downloads.lede-project.org/releases/17.01.1/packages/mipsel_74kc/luci/luci-app-commands_git-17.129.29271-6467df3-1_all.ipk
Upgrading luci-app-vnstat on root from git-17.126.47277-596f476-1 to git-17.129.29271-6467df3-1...
Downloading http://downloads.lede-project.org/releases/17.01.1/packages/mipsel_74kc/luci/luci-app-vnstat_git-17.129.29271-6467df3-1_all.ipk
Upgrading luci-proto-ipv6 on root from git-17.126.47277-596f476-1 to git-17.129.29271-6467df3-1...
Downloading http://downloads.lede-project.org/releases/17.01.1/packages/mipsel_74kc/luci/luci-proto-ipv6_git-17.129.29271-6467df3-1_all.ipk
Upgrading luci-app-wol on root from git-17.126.47277-596f476-1 to git-17.129.29271-6467df3-1...
Downloading http://downloads.lede-project.org/releases/17.01.1/packages/mipsel_74kc/luci/luci-app-wol_git-17.129.29271-6467df3-1_all.ipk
Upgrading luci-app-upnp on root from git-17.126.47277-596f476-1 to git-17.129.29271-6467df3-1...
Downloading http://downloads.lede-project.org/releases/17.01.1/packages/mipsel_74kc/luci/luci-app-upnp_git-17.129.29271-6467df3-1_all.ipk
Upgrading luci-app-minidlna on root from git-17.126.47277-596f476-1 to git-17.129.29271-6467df3-1...
Downloading http://downloads.lede-project.org/releases/17.01.1/packages/mipsel_74kc/luci/luci-app-minidlna_git-17.129.29271-6467df3-1_all.ipk
Upgrading luci-lib-nixio on root from git-17.126.47277-596f476-1 to git-17.129.29271-6467df3-1...
Downloading http://downloads.lede-project.org/releases/17.01.1/packages/mipsel_74kc/luci/luci-lib-nixio_git-17.129.29271-6467df3-1_mipsel_74kc.ipk
Upgrading luci-lib-jsonc on root from git-17.126.47277-596f476-1 to git-17.129.29271-6467df3-1...
Downloading http://downloads.lede-project.org/releases/17.01.1/packages/mipsel_74kc/luci/luci-lib-jsonc_git-17.129.29271-6467df3-1_mipsel_74kc.ipk
Upgrading luci-app-p910nd on root from git-17.126.47277-596f476-1 to git-17.129.29271-6467df3-1...
Downloading http://downloads.lede-project.org/releases/17.01.1/packages/mipsel_74kc/luci/luci-app-p910nd_git-17.129.29271-6467df3-1_all.ipk
Upgrading luci on root from git-17.126.47277-596f476-1 to git-17.129.29271-6467df3-1...
Downloading http://downloads.lede-project.org/releases/17.01.1/packages/mipsel_74kc/luci/luci_git-17.129.29271-6467df3-1_all.ipk
Upgrading luci-app-transmission on root from git-17.126.47277-596f476-1 to git-17.129.29271-6467df3-1...
Downloading http://downloads.lede-project.org/releases/17.01.1/packages/mipsel_74kc/luci/luci-app-transmission_git-17.129.29271-6467df3-1_all.ipk
Upgrading luci-app-openvpn on root from git-17.126.47277-596f476-1 to git-17.129.29271-6467df3-1...
Downloading http://downloads.lede-project.org/releases/17.01.1/packages/mipsel_74kc/luci/luci-app-openvpn_git-17.129.29271-6467df3-1_all.ipk
Configuring luci-app-statistics.
Configuring luci-lib-jsonc.
Configuring luci-app-adblock.
Configuring luci-lib-nixio.
Configuring luci-lib-ip.
Configuring luci-base.
Configuring luci-mod-admin-full.
Configuring luci-app-firewall.
Configuring luci-app-samba.
Configuring luci-theme-bootstrap.
Configuring luci-app-qos.
Configuring luci-app-diag-core.
Configuring luci-proto-ppp.
Configuring luci-app-commands.
Configuring luci-app-vnstat.
Configuring luci-proto-ipv6.
Configuring luci-app-wol.
Configuring luci-app-upnp.
Configuring luci-app-minidlna.
Configuring luci-app-p910nd.
Configuring luci.
Configuring luci-app-transmission.
Configuring luci-app-openvpn.
Collected errors:
 * resolve_conffiles: Existing conffile /etc/config/luci_statistics is different from the conffile in the new package. The new conffile will be placed at /etc/config/luci_statistics-opkg.
 * resolve_conffiles: Existing conffile /etc/config/luci is different from the conffile in the new package. The new conffile will be placed at /etc/config/luci-opkg.

Done | Upgrade finished

Please check for config file conflicts!

```

### When all up-to-date:
```
# ./opkg-upgrade.sh -f -n

Simple OPKG Updater v0.1.2

Done | Ignoring package lists update
Done | Getting upgradable packages list

No packages to install!
```
## Install using `git`:  
Clone it in current directory and use the `-i` option to install it to `/usr/sbin/opkg-upgrade`
```
# git clone git://github.com/tavinus/opkg-upgrade.git
# cd opkg-upgrade
# ./opkg-upgrade.sh -i
```

## Install using `curl` or `wget`:  

#### NOTE: curl / wget may fail because of missing SSL certificates.
You may choose to ignore the certificates check using:
 - `curl -k`
 - `wget --no-check-certificate`  

Or you will need to fix your `/etc/ssl/certs/ca-certificates.crt` installation.  
Please note that SSL support takes quite a lot of storage space.  

This should be enough to make SSL work:  
```
opkg install ca-certificates openssl-util
```
And this may be a workaround if you still have problems:
```
mkdir -p -m0755 /etc/ssl/certs && curl -k -o /etc/ssl/certs/ca-certificates.crt -L http://curl.haxx.se/ca/cacert.pem
```
Relevant links:
 - https://wiki.openwrt.org/doc/howto/wget-ssl-certs
 - https://forum.openwrt.org/viewtopic.php?pid=284368#p284368
 - https://dev.openwrt.org/ticket/19621

### Local install to current dir on `./opkg-upgrade.sh`:
using `wget`
```
TGT_INST='./opkg-upgrade.sh' && wget 'https://raw.githubusercontent.com/tavinus/opkg-upgrade/master/opkg-upgrade.sh' -O "$TGT_INST" && chmod 755 "$TGT_INST"
```
using `curl`
```
TGT_INST='./opkg-upgrade.sh' && curl -L 'https://raw.githubusercontent.com/tavinus/opkg-upgrade/master/opkg-upgrade.sh' -o "$TGT_INST" && chmod 755 "$TGT_INST"
```

### System install to  `/usr/sbin/opkg-upgrade` (no .sh extension) :
using `wget`
```
TGT_INST='/usr/sbin/opkg-upgrade' && wget 'https://raw.githubusercontent.com/tavinus/opkg-upgrade/master/opkg-upgrade.sh' -O "$TGT_INST" && chmod 755 "$TGT_INST"
```
using `curl`
```
TGT_INST='/usr/sbin/opkg-upgrade' && curl -L 'https://raw.githubusercontent.com/tavinus/opkg-upgrade/master/opkg-upgrade.sh' -o "$TGT_INST" && chmod 755 "$TGT_INST"
```
