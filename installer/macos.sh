#!/usr/bin/env sh

brew tap homebrew/services
brew install dtach
mkdir -p /opt
touch /opt/async.log
chmod 777 /opt/async.log
DTACH=$(which dtach)
# uID=$(id -u)

echo '<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
"http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>com.esoftplay.async</string>
    <key>EnvironmentVariables</key>
    <dict>
      <key>PATH</key>
      <string>/opt/homebrew/bin:/opt/homebrew/sbin:/usr/bin:/bin:/usr/sbin:/sbin</string>
    </dict>
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
</plist>'  > ~/Library/LaunchAgents/com.esoftplay.async.plist
launchctl unload -w ~/Library/LaunchAgents/com.esoftplay.async.plist
launchctl load -w ~/Library/LaunchAgents/com.esoftplay.async.plist

# launchctl bootout gui/${uID} com.esoftplay.async.plist
# launchctl bootstrap gui/${uID} com.esoftplay.async.plist
# launchctl kickstart -k gui/${uID}/com.esoftplay.async