#!/usr/bin/env bash

export LD_LIBRARY_PATH=../libs:$LD_LIBRARY_PATH

mkdir -p ../logs
PIDFILE="../game.pid"

SYS_NAME=`uname`
echo "RUNTIME PLATFORM:" ${SYS_NAME}
if [ ${SYS_NAME}x == "Linux"x ] ; then
	./dzhy_xsdq ../conf/config_linux
elif [ ${SYS_NAME}x == "Darwin"x ] ; then
	skynet ../conf/config_mac
fi
sleep 0.5
echo "Start success! [pid:$(cat ${PIDFILE})]"
