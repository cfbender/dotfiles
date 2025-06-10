#!/bin/bash
vm_stat | awk -v ps=$(pagesize) -v total=$(sysctl -n hw.memsize) '/Pages active/{a=$3} /Pages wired/{w=$4} /Pages occupied by compressor/{c=$6} END{printf "%.0f%%\n", (a+w+c)*ps*100/total}'
