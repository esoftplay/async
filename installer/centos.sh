#!/usr/bin/env sh

yum update -y
yum install -y git
cd /tmp
git clone https://github.com/crigler/dtach.git
cd dtach
./configure
make
mv dtach /usr/bin/
cd ../
rm -rf dtach
mkdir -p /opt
touch /opt/async.log
chmod 777 /opt/async.log

sudo echo '#!/bin/sh

# Include functions
if [ -f "/lib/lsb/init-functions" ]; then
  . /lib/lsb/init-functions
fi

if [ -f "/etc/init.d/functions" ]; then
  . /etc/init.d/functions
fi

start() {
  echo -n "Starting async: "
  touch /opt/async.log
  chmod 777 /opt/async.log
  dtach -n /tmp/async.socket /bin/sh /var/www/html/master/includes/system/docker/esoftplay_worker
}

stop() {
  echo -n "stopping async: "
  if [ -S "/tmp/async.socket" ]; then
    pkill dtach
  fi
}

status() {
  if [ -S "/tmp/async.socket" ]; then
    echo -n "ACTIVE async: $(wc -l < /opt/async.log) - $(wc -l < /tmp/async.log)"
  else
    echo -n "inactive async...."
  fi
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

echo ""
exit 0'  > /etc/init.d/esoftplay_async
sudo chmod +x /etc/init.d/esoftplay_async
sudo chkconfig --add esoftplay_async
sudo chkconfig --level 2345 esoftplay_async on
/etc/init.d/esoftplay_async start
