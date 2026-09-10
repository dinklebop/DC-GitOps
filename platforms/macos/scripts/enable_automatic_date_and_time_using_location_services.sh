#!/bin/zsh

uuid=$(/usr/sbin/ioreg -d2 -c IOPlatformExpertDevice | /usr/bin/awk -F'"' '/IOPlatformUUID/{print $(NF-1)}')

locationPrefs="/var/db/locationd/Library/Preferences/ByHost/com.apple.locationd.${uuid}"
timedPrefs="/private/var/db/timed/Library/Preferences/com.apple.timed.plist"
dateTimePrefs="/private/var/db/timed/Library/Preferences/com.apple.preferences.datetime.plist"

# Location Services on. 
/usr/bin/defaults write "${locationPrefs}" LocationServicesEnabled -int 1

# Automatic time zone flags, then re-own so timed honors them
/usr/bin/defaults write "${timedPrefs}" TMAutomaticTimeZoneEnabled -bool YES
/usr/bin/defaults write "${timedPrefs}" TMAutomaticTimeOnlyEnabled -bool YES
/usr/bin/defaults write "${dateTimePrefs}" timezoneset -bool YES
/usr/sbin/chown _timed:_timed "${timedPrefs}" "${dateTimePrefs}"

# Network time on
/usr/sbin/systemsetup -setusingnetworktime on

# Reload locationd so the change takes effect without a reboot
/usr/bin/killall locationd

exit 0