#!/usr/bin/env sh
BASEDIR=$(dirname $(dirname "$0"))
PHP=$(which php)
SVR=127.0.0.1:5888
sudo yum -y install lsof
mkdir -p $BASEDIR/logs
sudo echo '#!/bin/bash
# chkconfig: 2345 20 80
# description: Esoftplay async daemon
ulimit -n 16384

# Source function library.
. /etc/init.d/functions

start() {
  echo -n "Starting async: "
  gearmand -d
  '$PHP' '$BASEDIR'/bin/manager.php start
  '$PHP' -S '$SVR' -t '$BASEDIR'/web > '$BASEDIR'/logs/server.log &
}

stop() {
  echo -n "Stopping async: "
  '$PHP' '$BASEDIR'/bin/manager.php stop
  gearadmin --shutdown
  kill -9 $(lsof -t -i:5888)
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
       gearadmin --status
       gearadmin --workers
       ;;
    *)
       echo "Usage: $0 {start|stop|status|restart}"
esac

exit 0'  > /etc/init.d/esoftplay_async
sudo chmod +x /etc/init.d/esoftplay_async
sudo chkconfig --add esoftplay_async
sudo chkconfig --level 2345 esoftplay_async on
/etc/init.d/esoftplay_async start
