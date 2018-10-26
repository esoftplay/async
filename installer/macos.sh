#!/usr/bin/env sh
BASEDIR=$(dirname $(dirname "$0"))
PHP=$(which php)
SVR=127.0.0.1:5888
mkdir -p $BASEDIR/logs
brew tap homebrew/services
brew install gearman
brew services start gearman
echo '<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
"http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>com.esoftplay.watcher</string>
    <key>ProgramArguments</key>
    <array>
        <string>'$PHP'</string>
        <string>-S</string>
        <string>'$SVR'</string>
        <string>-t</string>
        <string>'$BASEDIR'/web</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
  </dict>
</plist>'  > ~/Library/LaunchAgents/com.esoftplay.watcher.plist
/bin/launchctl load ~/Library/LaunchAgents/com.esoftplay.watcher.plist
echo '<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
"http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>com.esoftplay.async</string>
    <key>ProgramArguments</key>
    <array>
        <string>'$PHP'</string>
        <string>'$BASEDIR'/bin/manager.php</string>
        <string>start</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
  </dict>
</plist>'  > ~/Library/LaunchAgents/com.esoftplay.async.plist
/bin/launchctl load ~/Library/LaunchAgents/com.esoftplay.async.plist
