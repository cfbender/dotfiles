#!/bin/bash

firefoxDir=$(find ~/.mozilla/firefox/ -name "*.default-release" -type d)
currentDir=$(pwd)

if [ ! -d "${firefoxDir}/chrome" ]; then
echo "Creating nonexistent directory: ${firefoxDir}/chrome"
mkdir -p ${firefoxDir}/chrome
fi

ln -s "${currentDir}/chrome/userChrome.css" "${firefoxDir}/chrome/userChrome.css"
