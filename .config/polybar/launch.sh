#!/bin/bash

killall -q polybar

while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

export MONITOR1=$(xrandr -q | grep " connected" | cut -d ' ' -f1 | sed -n 1p)
export MONITOR2=$(xrandr -q | grep " connected" | cut -d ' ' -f1 | sed -n 2p)
export MONITOR3=$(xrandr -q | grep " connected" | cut -d ' ' -f1 | sed -n 3p)

polybar bar &
if [[ MONITOR2 ]]; then polybar second & echo "Second bar on $MONITOR2"; fi &
if [[ MONITOR3 ]]; then polybar third & echo "Third bar on $MONITOR3"; fi

echo "Bars launched..."
