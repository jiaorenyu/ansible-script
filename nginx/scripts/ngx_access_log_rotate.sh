#!/bin/sh

# ------------------------------------------------------------
# Program: Rotate the access log for nginx
#
# Author: jiaorenyu <jiaorenyu@gmail.com>
# Current version: 1.0
#
# Purpose:
# This script rotate access log to avoid huge file & kind for analysis.
#
# Notes:
# rotate "d" means rotate by day.
# rotate "h" means rotate by hour.
# rotate "m" means rotate by min.
# ------------------------------------------------------------

if [ $# != 1 ]; then
    echo "usage xx.sh domain"
    exit 1
fi

echo $1
domain=$1

NGX_PID=/home/data/logs/nginx/nginx.pid
NGX_LOG_PATH=/home/data/logs/nginx/${domain}

echo $NGX_LOG_PATH

function rotate() {
    rotate_date="$(date +'%Y%m%d' --date='1 day ago')"
    if [ "$1" = "d" ]; then
        rotate_date="$(date +'%Y%m%d' --date='1 day ago')"
    elif [ "$1" = "h" ]; then
        rotate_date="$(date +'%Y%m%d%H' --date='1 hour ago')"
    elif [ "$1" = "m" ]; then
        rotate_date="$(date +'%Y%m%d%H%M' --date='1 min ago')"
    fi

    mv ${NGX_LOG_PATH}/https-access-v2.log ${NGX_LOG_PATH}/https-access-v2-${rotate_date}.log
    kill -USR1 `cat ${NGX_PID}`
    sleep 1
    gzip ${NGX_LOG_PATH}/https-access-v2-${rotate_date}.log
    
}

old_version=`date +%Y%m%d --date "3 days ago"`
fn=${NGX_LOG_PATH}/https-access-v2-${old_version}*
rm  -f $fn

rotate "d"
