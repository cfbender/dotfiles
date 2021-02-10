#!/bin/bash

killall -q polybar

while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

export MONITOR1=$(xrandr -q | grep " connected" | cut -d ' ' -f1 | sed -n 2p)
export MONITOR2=$(xrandr -q | grep " connected primary" | cut -d ' ' -f1 | head -n 1)
export MONITOR3=$(xrandr -q | grep " connected" | cut -d ' ' -f1 | sed -n 1p)

polybar bar &
polybar second &
polybar third &

echo "Bars launched..."
