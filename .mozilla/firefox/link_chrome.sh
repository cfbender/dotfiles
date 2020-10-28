#!/bin/bash

firefoxDir=$(find ~/.mozilla/firefox/ -name "*.default-release" -type d)
currentDir=$(pwd)
ln -s "${currentDir}/chrome/userChrome.css" "${firefoxDir}/chrome/userChrome.css"
