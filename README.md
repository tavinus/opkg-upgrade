# opkg-upgrade
List and install OpenWRT / LEDE opkg upgradable packages.  

Little `ash` app for easier opkg package upgrades.

**You should check for config conflicts after upgrades!**  
**Make sure you have enough space on root before installing stuff!**  
This script is small enough but SSL support for curl/wget is not!  
You also need free space for downloading and installing the packages!  
  
**If you use OpenWRT trunk (dev snapshots), you should probably NOT upgrade**  
Upgrading development versions can soft-brick your device.  
You should try to backup your config and do a full install of a later snapshot if you are running dev/trunk.  
Main releases are fine (just trunk/snapshots are affected by this).  
It is probably the opposite for releases (recommended to upgrade), since you will get security patches if you upgrade those.
  
---------------------------------------------- 
#### If you want to support this project, you can do it here :coffee: :beer:   
  
[![paypal-image](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=A9N3VU2DHP82A&source=url)  
  
----------------------------------------------  
  
### Help example:
```
root@OpenWrt:~# opkg-upgrade --help

Simple OPKG Updater v0.4.1

Usage: opkg-upgrade [options]

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
  -m, --msmtp <email>   Use the system's msmtp to send update reports
                        You need to install and configure msmtp beforehand
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
  - You must have a working ssmtp or msmtp install to use the email functionality.
    Make sure you can send e-mails from it before trying from opkg-upgrade.

Examples:
  opkg-upgrade -n -f      # run without updating listings and asking for upgrade
  opkg-upgrade --install  # install to /usr/sbin/opkg-upgrade
  opkg-upgrade -l         # just print upgrades available
  opkg-upgrade -e         # just print html formatted email
  opkg-upgrade -s 'mail@example.com'    # mail upgrade report if have updates
  opkg-upgrade -a -m 'mail@example.com' # mail upgrade report even if NO updates
  opkg-upgrade -u && echo 'upgrades are available' || echo 'no upgrades available'

```

### Example run:
```
root@OpenWrt:~# opkg-upgrade

Simple OPKG Updater v0.4.0

Done | Updating package lists
Done | Getting upgradable packages list

Packages available for upgrade: 28

+-----+----------------------------+--------------------------+--------------------------+
|   # | Package                    | Current                  | Update                   |
+-----+----------------------------+--------------------------+--------------------------+
|   1 | cgi-io                     | 2021-09-08-98cef9dd-20   | 2022-08-10-901b0f04-21   |
|   2 | curl                       | 7.82.0-2                 | 7.83.1-4.1               |
|   3 | firewall                   | 2021-03-23-61db17ed-1    | 2021-03-23-61db17ed-1.1  |
|   4 | htop                       | 3.1.2-1                  | 3.2.1-1                  |
|   5 | libcurl4                   | 7.82.0-2                 | 7.83.1-4.1               |
|   6 | libevdev                   | 1.12.0-1                 | 1.13.0-1                 |
|   7 | libiwinfo-data             | 2021-04-30-c45f0b58-2.1  | 2022-04-26-dc6847eb-1    |
|   8 | libiwinfo-lua              | 2021-04-30-c45f0b58-2.1  | 2022-04-26-dc6847eb-1    |
|   9 | libiwinfo20210430          | 2021-04-30-c45f0b58-2.1  | 2022-04-26-dc6847eb-1    |
|  10 | libudev-zero               | 1.0.0-1                  | 1.0.1-1                  |
|  11 | libustream-wolfssl20201210 | 2022-01-16-868fd881-1    | 2022-01-16-868fd881-2    |
|  12 | luci-app-ddns              | git-21.349.33342-b5a40b3 | git-22.123.50005-9139ad4 |
|  13 | luci-app-firewall          | git-22.046.85957-59c3392 | git-22.089.67741-3856d50 |
|  14 | luci-app-opkg              | git-21.312.69848-4745991 | git-22.273.29015-e01e38c |
|  15 | luci-app-statistics        | git-22.072.58464-8cac3cb | git-22.115.68435-0473e99 |
|  16 | luci-base                  | git-22.046.85957-59c3392 | git-22.304.65299-04257f6 |
|  17 | luci-lib-jsonc             | git-19.317.29469-8da8f38 | git-22.097.61937-bc85ba5 |
|  18 | luci-mod-network           | git-22.046.85061-dd54dce | git-22.244.54918-77c916e |
|  19 | luci-mod-status            | git-22.046.85784-0ac2542 | git-22.089.70019-d4f0b06 |
|  20 | luci-mod-system            | git-22.019.40321-7a37d02 | git-22.264.46189-30ba277 |
|  21 | luci-theme-bootstrap       | git-22.047.35373-cc582eb | git-22.288.45155-afd0012 |
|  22 | nano                       | 6.2-2                    | 6.4-1                    |
|  23 | px5g-wolfssl               | 3                        | 4.1                      |
|  24 | rpcd                       | 2021-03-11-ccb75178-1    | 2022-02-19-8d26a1ba-1    |
|  25 | rpcd-mod-file              | 2021-03-11-ccb75178-1    | 2022-02-19-8d26a1ba-1    |
|  26 | rpcd-mod-iwinfo            | 2021-03-11-ccb75178-1    | 2022-02-19-8d26a1ba-1    |
|  27 | usbids                     | 0.354-1                  | 0.359-1                  |
|  28 | zlib                       | 1.2.11-4                 | 1.2.11-6                 |
+-----+----------------------------+--------------------------+--------------------------+

Proceed with upgrade? (Y/y to proceed) y

.... | Upgrading packages

Upgrading cgi-io on root from 2021-09-08-98cef9dd-20 to 2022-08-10-901b0f04-21...
Downloading https://downloads.openwrt.org/releases/21.02.2/packages/x86_64/packages/cgi-io_2022-08-10-901b0f04-21_x86_64.ipk
Upgrading curl on root from 7.82.0-2 to 7.83.1-4.1...
Downloading https://downloads.openwrt.org/releases/21.02.2/packages/x86_64/packages/curl_7.83.1-4.1_x86_64.ipk
Upgrading firewall on root from 2021-03-23-61db17ed-1 to 2021-03-23-61db17ed-1.1...
Downloading https://downloads.openwrt.org/releases/21.02.2/packages/x86_64/base/firewall_2021-03-23-61db17ed-1.1_x86_64.ipk
Warning: Unable to locate ipset utility, disabling ipset support
Warning: Section @zone[1] (wan) cannot resolve device of network 'wan6'
 * Flushing IPv4 filter table
 * Flushing IPv4 nat table
 * Flushing IPv4 mangle table
 * Flushing IPv6 filter table
 * Flushing IPv6 mangle table
 * Flushing conntrack table ...
Upgrading htop on root from 3.1.2-1 to 3.2.1-1...
Downloading https://downloads.openwrt.org/releases/21.02.2/packages/x86_64/packages/htop_3.2.1-1_x86_64.ipk
Upgrading libcurl4 on root from 7.82.0-2 to 7.83.1-4.1...
Downloading https://downloads.openwrt.org/releases/21.02.2/packages/x86_64/packages/libcurl4_7.83.1-4.1_x86_64.ipk
Installing libwolfssl5.5.1.99a5b54a (5.5.1-stable-2) to root...
Downloading https://downloads.openwrt.org/releases/21.02.2/packages/x86_64/base/libwolfssl5.5.1.99a5b54a_5.5.1-stable-2_x86_64.ipk
libwolfssl5.2.0.99a5b54a was autoinstalled and is now orphaned, removing.
Removing package libwolfssl5.2.0.99a5b54a from root...
Removing obsolete file /usr/lib/libcurl.so.4.7.0.
Upgrading libevdev on root from 1.12.0-1 to 1.13.0-1...
Downloading https://downloads.openwrt.org/releases/21.02.2/packages/x86_64/packages/libevdev_1.13.0-1_x86_64.ipk
Upgrading libiwinfo-data on root from 2021-04-30-c45f0b58-2.1 to 2022-04-26-dc6847eb-1...
Downloading https://downloads.openwrt.org/releases/21.02.2/packages/x86_64/base/libiwinfo-data_2022-04-26-dc6847eb-1_x86_64.ipk
Upgrading libiwinfo-lua on root from 2021-04-30-c45f0b58-2.1 to 2022-04-26-dc6847eb-1...
Downloading https://downloads.openwrt.org/releases/21.02.2/packages/x86_64/base/libiwinfo-lua_2022-04-26-dc6847eb-1_x86_64.ipk
Upgrading libiwinfo20210430 on root from 2021-04-30-c45f0b58-2.1 to 2022-04-26-dc6847eb-1...
Downloading https://downloads.openwrt.org/releases/21.02.2/packages/x86_64/base/libiwinfo20210430_2022-04-26-dc6847eb-1_x86_64.ipk
Upgrading libudev-zero on root from 1.0.0-1 to 1.0.1-1...
Downloading https://downloads.openwrt.org/releases/21.02.2/packages/x86_64/packages/libudev-zero_1.0.1-1_x86_64.ipk
Upgrading libustream-wolfssl20201210 on root from 2022-01-16-868fd881-1 to 2022-01-16-868fd881-2...
Downloading https://downloads.openwrt.org/releases/21.02.2/packages/x86_64/base/libustream-wolfssl20201210_2022-01-16-868fd881-2_x86_64.ipk
Upgrading luci-app-ddns on root from git-21.349.33342-b5a40b3 to git-22.123.50005-9139ad4...
Downloading https://downloads.openwrt.org/releases/21.02.2/packages/x86_64/luci/luci-app-ddns_git-22.123.50005-9139ad4_all.ipk
Upgrading luci-app-firewall on root from git-22.046.85957-59c3392 to git-22.089.67741-3856d50...
Downloading https://downloads.openwrt.org/releases/21.02.2/packages/x86_64/luci/luci-app-firewall_git-22.089.67741-3856d50_all.ipk
Upgrading luci-app-opkg on root from git-21.312.69848-4745991 to git-22.273.29015-e01e38c...
Downloading https://downloads.openwrt.org/releases/21.02.2/packages/x86_64/luci/luci-app-opkg_git-22.273.29015-e01e38c_all.ipk
Upgrading luci-app-statistics on root from git-22.072.58464-8cac3cb to git-22.115.68435-0473e99...
Downloading https://downloads.openwrt.org/releases/21.02.2/packages/x86_64/luci/luci-app-statistics_git-22.115.68435-0473e99_all.ipk
Upgrading luci-base on root from git-22.046.85957-59c3392 to git-22.304.65299-04257f6...
Downloading https://downloads.openwrt.org/releases/21.02.2/packages/x86_64/luci/luci-base_git-22.304.65299-04257f6_x86_64.ipk
Upgrading luci-lib-jsonc on root from git-19.317.29469-8da8f38 to git-22.097.61937-bc85ba5...
Downloading https://downloads.openwrt.org/releases/21.02.2/packages/x86_64/luci/luci-lib-jsonc_git-22.097.61937-bc85ba5_x86_64.ipk
Upgrading luci-mod-network on root from git-22.046.85061-dd54dce to git-22.244.54918-77c916e...
Downloading https://downloads.openwrt.org/releases/21.02.2/packages/x86_64/luci/luci-mod-network_git-22.244.54918-77c916e_all.ipk
Upgrading luci-mod-status on root from git-22.046.85784-0ac2542 to git-22.089.70019-d4f0b06...
Downloading https://downloads.openwrt.org/releases/21.02.2/packages/x86_64/luci/luci-mod-status_git-22.089.70019-d4f0b06_x86_64.ipk
Upgrading luci-mod-system on root from git-22.019.40321-7a37d02 to git-22.264.46189-30ba277...
Downloading https://downloads.openwrt.org/releases/21.02.2/packages/x86_64/luci/luci-mod-system_git-22.264.46189-30ba277_all.ipk
Upgrading luci-theme-bootstrap on root from git-22.047.35373-cc582eb to git-22.288.45155-afd0012...
Downloading https://downloads.openwrt.org/releases/21.02.2/packages/x86_64/luci/luci-theme-bootstrap_git-22.288.45155-afd0012_all.ipk
Upgrading nano on root from 6.2-2 to 6.4-1...
Downloading https://downloads.openwrt.org/releases/21.02.2/packages/x86_64/packages/nano_6.4-1_x86_64.ipk
Upgrading px5g-wolfssl on root from 3 to 4.1...
Downloading https://downloads.openwrt.org/releases/21.02.2/packages/x86_64/base/px5g-wolfssl_4.1_x86_64.ipk
libwolfssl5.1.1.99a5b54a was autoinstalled and is now orphaned, removing.
Removing package libwolfssl5.1.1.99a5b54a from root...
Upgrading rpcd on root from 2021-03-11-ccb75178-1 to 2022-02-19-8d26a1ba-1...
Downloading https://downloads.openwrt.org/releases/21.02.2/packages/x86_64/base/rpcd_2022-02-19-8d26a1ba-1_x86_64.ipk
Upgrading rpcd-mod-file on root from 2021-03-11-ccb75178-1 to 2022-02-19-8d26a1ba-1...
Downloading https://downloads.openwrt.org/releases/21.02.2/packages/x86_64/base/rpcd-mod-file_2022-02-19-8d26a1ba-1_x86_64.ipk
Upgrading rpcd-mod-iwinfo on root from 2021-03-11-ccb75178-1 to 2022-02-19-8d26a1ba-1...
Downloading https://downloads.openwrt.org/releases/21.02.2/packages/x86_64/base/rpcd-mod-iwinfo_2022-02-19-8d26a1ba-1_x86_64.ipk
Upgrading usbids on root from 0.354-1 to 0.359-1...
Downloading https://downloads.openwrt.org/releases/21.02.2/packages/x86_64/packages/usbids_0.359-1_x86_64.ipk
Upgrading zlib on root from 1.2.11-4 to 1.2.11-6...
Downloading https://downloads.openwrt.org/releases/21.02.2/packages/x86_64/base/zlib_1.2.11-6_x86_64.ipk
Configuring rpcd.
Configuring luci-lib-jsonc.
Configuring rpcd-mod-file.
Configuring cgi-io.
Configuring luci-base.
Configuring zlib.
Configuring libiwinfo-data.
Configuring libiwinfo20210430.
Configuring luci-app-statistics.
Configuring libevdev.
Configuring luci-app-opkg.
Configuring nano.
Configuring libiwinfo-lua.
Configuring luci-mod-system.
Configuring libwolfssl5.5.1.99a5b54a.
Configuring libustream-wolfssl20201210.
Configuring luci-theme-bootstrap.
/luci-static/bootstrap
/luci-static/bootstrap-dark
/luci-static/bootstrap-light
Configuring libudev-zero.
Configuring usbids.
Configuring px5g-wolfssl.
Configuring luci-mod-status.
Configuring rpcd-mod-iwinfo.
Configuring luci-mod-network.
Configuring luci-app-ddns.
Configuring firewall.
Warning: Unable to locate ipset utility, disabling ipset support
Warning: Section @zone[1] (wan) cannot resolve device of network 'wan6'
 * Populating IPv4 filter table
   * Rule 'Allow-DHCP-Renew'
   * Rule 'Allow-Ping'
   * Rule 'Allow-IGMP'
   * Rule 'Allow-IPSec-ESP'
   * Rule 'Allow-ISAKMP'
   * Forward 'lan' -> 'wan'
   * Zone 'lan'
   * Zone 'wan'
 * Populating IPv4 nat table
   * Zone 'lan'
   * Zone 'wan'
 * Populating IPv4 mangle table
   * Zone 'lan'
   * Zone 'wan'
 * Populating IPv6 filter table
   * Rule 'Allow-DHCPv6'
   * Rule 'Allow-MLD'
   * Rule 'Allow-ICMPv6-Input'
   * Rule 'Allow-ICMPv6-Forward'
   * Rule 'Allow-IPSec-ESP'
   * Rule 'Allow-ISAKMP'
   * Forward 'lan' -> 'wan'
   * Zone 'lan'
   * Zone 'wan'
 * Populating IPv6 mangle table
   * Zone 'lan'
   * Zone 'wan'
 * Flushing conntrack table ...
 * Set tcp_ecn to off
 * Set tcp_syncookies to on
 * Set tcp_window_scaling to on
 * Running script '/etc/firewall.user'
Configuring luci-app-firewall.
Configuring libcurl4.
Configuring curl.
Configuring htop.
Collected errors:
 * resolve_conffiles: Existing conffile /etc/config/luci is different from the conffile in the new package. The new conffile will be placed at /etc/config/luci-opkg.
 * resolve_conffiles: Existing conffile /etc/config/ucitrack is different from the conffile in the new package. The new conffile will be placed at /etc/config/ucitrack-opkg.
Done |
Upgrade finished

Please check for config file conflicts!
```

### When all up-to-date:
```
# ./opkg-upgrade.sh -f -n

Simple OPKG Updater v0.4.0

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

### Oneliners to run from internet ( downloads to `/tmp` ) :
```bash
# using wget with SSL
wget 'https://raw.githubusercontent.com/tavinus/opkg-upgrade/master/opkg-upgrade.sh' -O "/tmp/opkg-upgrade.sh" && chmod 755 "/tmp/opkg-upgrade.sh" && /tmp/opkg-upgrade.sh

# using wget WITHOUT SSL
wget --no-check-certificate 'https://raw.githubusercontent.com/tavinus/opkg-upgrade/master/opkg-upgrade.sh' -O "/tmp/opkg-upgrade.sh" && chmod 755 "/tmp/opkg-upgrade.sh" && /tmp/opkg-upgrade.sh

# using curl with SSL
curl -L 'https://raw.githubusercontent.com/tavinus/opkg-upgrade/master/opkg-upgrade.sh' -o "/tmp/opkg-upgrade.sh" && chmod 755 "/tmp/opkg-upgrade.sh" && /tmp/opkg-upgrade.sh

# using curl WITHOUT SSL
curl -k -L 'https://raw.githubusercontent.com/tavinus/opkg-upgrade/master/opkg-upgrade.sh' -o "/tmp/opkg-upgrade.sh" && chmod 755 "/tmp/opkg-upgrade.sh" && /tmp/opkg-upgrade.sh
```

### Local install to current dir ( `./opkg-upgrade.sh` ) :
Run with `./opkg-upgrade.sh` after downloading
```bash
# using wget with SSL
wget 'https://raw.githubusercontent.com/tavinus/opkg-upgrade/master/opkg-upgrade.sh' -O "opkg-upgrade.sh" && chmod 755 "opkg-upgrade.sh"

# using wget WITHOUT SSL
wget --no-check-certificate 'https://raw.githubusercontent.com/tavinus/opkg-upgrade/master/opkg-upgrade.sh' -O "opkg-upgrade.sh" && chmod 755 "opkg-upgrade.sh"

# using curl with SSL
curl -L 'https://raw.githubusercontent.com/tavinus/opkg-upgrade/master/opkg-upgrade.sh' -o "opkg-upgrade.sh" && chmod 755 "opkg-upgrade.sh"

# using curl WITHOUT SSL
curl -k -L 'https://raw.githubusercontent.com/tavinus/opkg-upgrade/master/opkg-upgrade.sh' -o "opkg-upgrade.sh" && chmod 755 "opkg-upgrade.sh"
```

### System install to `/usr/sbin/opkg-upgrade` (no .sh extension) :
Run with `opkg-upgrade` after downloading 
```bash
# using wget with SSL
wget 'https://raw.githubusercontent.com/tavinus/opkg-upgrade/master/opkg-upgrade.sh' -O "/usr/sbin/opkg-upgrade" && chmod 755 "/usr/sbin/opkg-upgrade"

# using wget WITHOUT SSL
wget --no-check-certificate 'https://raw.githubusercontent.com/tavinus/opkg-upgrade/master/opkg-upgrade.sh' -O "/usr/sbin/opkg-upgrade" && chmod 755 "/usr/sbin/opkg-upgrade"

# using curl with SSL
curl -L 'https://raw.githubusercontent.com/tavinus/opkg-upgrade/master/opkg-upgrade.sh' -o "/usr/sbin/opkg-upgrade" && chmod 755 "/usr/sbin/opkg-upgrade"

# using curl WITHOUT SSL
curl -k -L 'https://raw.githubusercontent.com/tavinus/opkg-upgrade/master/opkg-upgrade.sh' -o "/usr/sbin/opkg-upgrade" && chmod 755 "/usr/sbin/opkg-upgrade"
```
