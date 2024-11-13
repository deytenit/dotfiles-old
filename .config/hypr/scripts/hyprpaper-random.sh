#!/usr/bin/env bash

INTERVAL=$1
DIR=$2

if [[ -z "$INTERVAL" || -z "$DIR" ]]; then
  echo "Usage: $0 <INTERVAL> <DIR>"
  exit 1
fi

LOCK="$HOME/.lock/hyprpaper-random.lock"

if pids=$(lsof -t "$LOCK"); then
  kill -15 $pids
fi

(
flock -n 100 || exit
MONITOR=($(hyprctl monitors | grep Monitor | awk '{print $2}'))
cache=""

while true; do
  if [[ $cache == $wallpaper ]]; then
    wallpaper=$(find "${DIR}" -type f | shuf -n 1)
  else
    cache=$wallpaper
    hyprctl -q hyprpaper unload all
    hyprctl -q hyprpaper preload "$wallpaper"
    for m in "${MONITOR[@]}"; do
      hyprctl -q hyprpaper wallpaper "$m,$wallpaper"
    done
    sleep "$INTERVAL"
  fi
done
) 100> $LOCK
