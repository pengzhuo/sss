#!/usr/bin/env bash
#该运行模式用于开发期间看debug日志

SYS_NAME=`uname`
echo "RUNTIME PLATFORM:" ${SYS_NAME}
if [ ${SYS_NAME}x == "Linux"x ] ; then
	./dzhy_xsdq ../conf/config_debug
elif [ ${SYS_NAME}x == "Darwin"x ] ; then
	skynet ../conf/config_debug
fi
