#!/usr/bin/env bash
#ps -ef|grep kwx_lobby|grep -v grep|cut -c 9-15|xargs kill -9

PIDFILE="../game.pid"
echo "Stopping... [pid:$(cat ${PIDFILE})]"
kill -9 $(cat ${PIDFILE})
