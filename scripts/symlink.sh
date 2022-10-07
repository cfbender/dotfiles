#!/bin/bash

# Up from scripts dir
cd ..

dotfilesDir=$(pwd)

function linkDotfile {
  dest="${HOME}/${1}"
  dateStr=$(date +%Y-%m-%d-%H%M)

  newDir=$(dirname ${dest})
  if [ ! -d "${newDir}" ]; then
  echo "Creating nonexistent directory: ${newDir}"
  mkdir -p ${newDir}
  fi

  if [ -h ~/${1} ]; then
    # Existing symlink
    echo "Removing existing symlink: ${dest}"
    rm ${dest}

  elif [ -f "${dest}" ]; then
    # Existing file
    echo "Backing up existing file: ${dest}"
    mv ${dest}{,.${dateStr}}

  elif [ -d "${dest}" ]; then
    # Existing dir
    echo "Backing up existing dir: ${dest}"
    mv ${dest}{,.${dateStr}}
  fi

  echo "Creating new symlink at ${dest} pointing to ${dotfilesDir}/${1}"
  ln -s ${dotfilesDir}/${1} ${dest}
}

find . -type f -not -path "./scripts/*" -not -path "./.git/*" -not -path "./assets/*" -not -name "README.md" -not -path "./.config/nvim/old_config" | sed 's/^\.\///' | while read f
do
linkDotfile ${f}
done
