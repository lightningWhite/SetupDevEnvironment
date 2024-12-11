#!/bin/bash
# Moves the settings files to ~/.config/Code/User and overwrites
# or adds to anything that was there before.

function yes_or_no 
{
  while true; do
    read -p "$* [y/n]: " yn
    case $yn in
        [Yy]*)  break ;;  
        [Nn]*) echo "Aborted" ; exit 1 ;;
    esac
  done
}

yes_or_no "WARNING: This will overwrite any matching existing settings. Continue?"

echo "Restoring VS Code user settings..."

cp *.json ~/.config/Code/User

cp -r profiles/ ~/.config/Code/User
