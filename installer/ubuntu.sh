#!/usr/bin/env sh
BASEDIR=$(dirname $(dirname "$0"))
PHP=$(which php)
SVR=127.0.0.1:5888
mkdir -p $BASEDIR/logs
sudo apt-get -y install lsof
sudo echo '#!/bin/sh

### BEGIN INIT INFO
# Provides:          esoftplay_async
# Required-Start:    $local_fs $network $syslog
# Required-Stop:     $local_fs $network $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Example
# Description:       Example start-stop-daemon - Debian
### END INIT INFO

NAME="esoftplay_async"
PATH="/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin"

# Include functions
set -e
. /lib/lsb/init-functions

start() {
  echo -n "Starting async: "
  gearmand -d
  '$PHP' '$BASEDIR'/bin/manager.php start
  '$PHP' -S '$SVR' -t '$BASEDIR'/web > '$BASEDIR'/logs/server.log &
}

#We need this function to ensure the whole process tree will be killed
killtree() {
    local _pid=$1
    local _sig=${2-TERM}
    for _child in $(ps -o pid --no-headers --ppid ${_pid}); do
        killtree ${_child} ${_sig}
    done
    kill -${_sig} ${_pid}
}

stop() {
  echo -n "Stopping async: "
  '$PHP' '$BASEDIR'/bin/manager.php stop
  gearadmin --shutdown
  kill -9 $(lsof -t -i:5888)
}

status() {
	gearadmin --status
	gearadmin --workers
}

case "$1" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  restart)
    stop
    start
    ;;
  status)
    status
    ;;
  *)
    echo "Usage: $NAME {start|stop|restart|status}" >&2
    exit 1
    ;;
esac

exit 0'  > /etc/init.d/esoftplay_async
sudo chmod +x /etc/init.d/esoftplay_async
sudo update-rc.d esoftplay_async defaults
sudo service esoftplay_async start

# sudo chkconfig --add esoftplay_async
# sudo chkconfig --level 2345 esoftplay_async on
# /etc/init.d/esoftplay_async start
