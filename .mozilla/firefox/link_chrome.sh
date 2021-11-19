#!/bin/bash

firefoxDir=$(find /Users/$(whoami)/Library/Application\ Support/Firefox/Profiles -name "*.default-release" -type d)
currentDir=$(pwd)

if [[ -z "${firefoxDir}" ]]; then
  echo "Unable to find firefox installation"
  exit 420
fi

if [ ! -d "${firefoxDir}/chrome" ]; then
  echo "Creating nonexistent directory: ${firefoxDir}/chrome"
  mkdir ${firefoxDir}/chrome
fi

ln -s "${currentDir}/chrome/userChrome.css" "${firefoxDir}/chrome/userChrome.css"
