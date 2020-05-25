#!/bin/sh

set -o errexit
set -o nounset

trap quit INT TERM

COUNT=0

if ! [ $(id -u) = 0 ]; then
   echo "Must be run as root."
   exit 1
fi

LED="/sys/class/leds/led0"

if [[ ! -d $LED ]]
then
  echo "Could not find an LED at ${LED}"
  echo "Perhaps try '/sys/class/leds/ACT'?"
  exit 1
fi

function quit() {
  echo mmc0 >"${LED}/trigger"
}

echo -n "Blinking Raspberry Pi's LED - press CTRL-C to quit"

echo none >"${LED}/trigger"

while true
do
  let "COUNT=COUNT+1"
  if [[ $COUNT -lt 30 ]]
  then
    echo 1 >"${LED}/brightness"
    sleep 1
    echo 0 >"${LED}/brightness"
    sleep 1
  else
    quit
    break
  fi
done

