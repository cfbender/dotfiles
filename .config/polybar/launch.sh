#!/bin/bash

killall -q polybar

while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

export MONITOR2=$(xrandr -q | grep " connected" | cut -d ' ' -f1 | head -n 1)
export MONITOR1=$(xrandr -q | grep " connected" | cut -d ' ' -f1 | sed -n 2p)

polybar bar &
polybar second &

echo "Bars launched..."
