#!/bin/sh
# Main source of inspiration and copy is:
# https://github.com/uphold/docker-litecoin-core/blob/master/0.18/Dockerfile
# Adapted to running the daemon only
ltcdata=LTC_DATA
#Daemon was complaining if i did not specify LTC_DATA location
mkdir -p "$ltcdata"
chmod 770 "$ltcdata" || echo "Could not chmod $ltcdata (may not have appropriate permissions)"
chown -R ltcuser "$ltcdata" || echo "Could not chown $ltcdata (may not have appropriate permissions)"

set -- "$@" -datadir="$ltcdata"
# id -u = 0 means that user is root
if [ "$(id -u)" = "0" ] && ([ "$1" = "litecoind" ]); then
  set -- gosu ltcuser "$@"
fi

exec "$@"
