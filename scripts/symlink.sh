#!/bin/bash

# Up from scripts dir
cd ..

dotfilesDir=$(pwd)

function linkDotfile {
  dest="${HOME}/${1}"
  dateStr=$(date +%Y-%m-%d-%H%M)

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

  echo "Creating new symlink: ${dest}"
  ln -s ${dotfilesDir}/${1} ${dest}
}

linkDotfile .zshrc
linkDotfile .zprofile
linkDotfile .gitconfig
linkDotfile .config/gtk-3.0/gtk.css
linkDotfile .config/nvim/init.vim
linkDotfile .config/nvim/include/plugins.vim
linkDotfile .config/nvim/include/general.vim
linkDotfile .config/nvim/include/style.vim
linkDotfile .config/nvim/include/keybinds.vim
