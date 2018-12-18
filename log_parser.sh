#!/bin/bash

#This script is intended to parse log files sent from a customer to output the following information
#Code Location Name, Code Location ID, Job ID - statuses


usage() { echo "Usage: script.sh -s <hub-scan-file> -j <hub-jobrunner-file> || script.sh -l (parsing a running Hub server)" 1>&2; exit 1; }

scan_info () { awk '$7 ~ /Document/ && $11 ~ /associated/ { print "Code Location Name:" $14, "Code Location ID:" $19}' $s; }

live_info () { docker logs $(docker ps -qf label=com.docker.swarm.service.name=hub_scan) 2>&1 | awk '$7 ~ /Document/ && $11 ~ /associated/ { print "Code Location Name:" $14, "Code Location ID:" $19}'; }


if [[ $1 == "" ]]; then
    usage
    exit;
else
while getopts ":s:j:l" o; do
    case "${o}" in
        s)
            s=${OPTARG}
            scan_info $s
            ;;
        j)
            j=${OPTARG}
            ;;
        l)
            echo "Connecting to a live Hub server"
            live_info
            ;;
        *)
            usage
            ;;
    esac
done
fi
