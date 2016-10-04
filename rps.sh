#!/usr/bin/env bash
#
# Simple CUI "request/sec" viewer

set -o errexit
set -o nounset
set -o pipefail

FREQUENCY=1

get_log_count() {
  wc -l "$logFile" | awk '{print $1}'
}

echo_with_date() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')]: $*"
}

usage_exit() {
  echo_with_date "Usage: $0 -f [log file]" >&2;
  exit 1;
}

if [ $# -eq 0 ]; then
  usage_exit
fi

while getopts f:h opt; do
  case $opt in
    f) logFile=$OPTARG    
      ;;
    h)  usage_exit
      ;;
    \?) usage_exit
      ;;
  esac
done

if [ ! -n "$logFile" ]; then
  usage_exit
fi

if [ ! -e "$logFile" ]; then
  echo_with_date "${logFile} does not exist." >&2
  exit 2
fi

lastNum=$(get_log_count)

while true; do
  currentNum=$(get_log_count)
  rps=$(((currentNum - lastNum) / FREQUENCY))
  echo_with_date ${rps}
  lastNum=$currentNum
  sleep $FREQUENCY
done
