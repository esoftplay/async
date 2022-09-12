#!/usr/bin/env sh

brew tap homebrew/services
brew install dtach
mkdir -p /opt
touch /opt/async.log
chmod 777 /opt/async.log
DTACH=$(which dtach)
uID=$(id -u)
cd ~/Library/LaunchAgents/

echo '<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
"http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>com.esoftplay.async</string>
    <key>ProgramArguments</key>
    <array>
      <string>'$DTACH'</string>
      <string>-A</string>
      <string>/tmp/async.socket</string>
      <string>/bin/sh</string>
      <string>/var/www/html/master/includes/system/docker/esoftplay_worker</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
  </dict>
</plist>'  > com.esoftplay.async.plist
/bin/launchctl load com.esoftplay.async.plist

# launchctl bootout gui/${uID} com.esoftplay.async.plist
launchctl bootstrap gui/${uID} com.esoftplay.async.plist
launchctl kickstart -k gui/${uID}/com.esoftplay.async