#!/usr/bin/env bash

# This script run at 00:00

# The app logs path
root_path=$(dirname "$0")"/../"
logs_path=${root_path}"logs/"
log_file_name="xsdq"
log_file_ext="log"
pid_file=${root_path}"game.pid"

mkdir -p ${logs_path}$(date -d "yesterday" +"%Y")/$(date -d "yesterday" +"%m")/
mv ${logs_path}${log_file_name}.${log_file_ext} ${logs_path}$(date -d "yesterday" +"%Y")/$(date -d "yesterday" +"%m")/${log_file_name}_$(date -d "yesterday" +"%Y%m%d").${log_file_ext}

kill -HUP $(cat ${pid_file})

#delete logs fro 7 days ago
find ${logs_path} -mtime +7 -name "*.${log_file_ext}" -exec rm -rf {} \;
