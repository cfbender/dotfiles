#!/bin/bash

firefoxDir=$(find ~/.mozilla/firefox/ -name "*.default-release" -type d)

ln -s ./chrome/userChrome.css "${firefoxDir}/chrome/userChrome.css"
