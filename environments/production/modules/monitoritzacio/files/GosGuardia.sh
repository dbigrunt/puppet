#!/bin/bash
SCRIPT="/usr/lib64/nagios/plugins/check_linux_stats.pl"
$SCRIPT -M -w 90 -c 95 | grep -v OK
$SCRIPT -C -w 90 -c 95 -s 5 | grep -v OK
$SCRIPT -D -w 15 -c 10 -u % -p | grep -v OK 
$SCRIPT -L -w 10,8,5 -c 20,18,15 | grep -v OK 
$SCRIPT -N -w 10000 -c 100000000 -p eth0 | grep -v OK
