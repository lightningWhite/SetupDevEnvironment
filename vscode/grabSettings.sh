#!/bin/bash
# Copies the Visual Studio Code User settings to this directory

# Copy the default user settings
cp ~/.config/Code/User/*.json .

# Copy each of the profile settings
cp -r ~/.config/Code/User/profiles .
