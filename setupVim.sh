#!/bin/bash

if [[ "$EUID" -eq 0 ]]; then
  echo "This script must not be run as root! Exiting."
  exit 1
fi

# Since YouCompleteMe requires >=Vim 9.1, we have to build from source
# on some older systems (e.g. Ubuntu 22.04) to get a new enough version.
# This also allows us to enable python3 and clipboard support in the build.
echo "*** Building and installing Vim... ***"
sudo apt-get install git curl libx11-dev libxtst-dev libxt-dev libsm-dev libxpm-dev # Needed for clipboard support
git clone https://github.com/vim/vim.git || (cd vim ; git pull)
(cd vim/src && ./configure --enable-python3interp=yes --with-x && sudo make install)

# Install vim-plug Package Manager
echo "*** Installing the vim-plug plugin manager... ***"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Copy the custom colorscheme to the right location
echo "*** Seting up custom colorscheme... ***"
mkdir -p ~/.vim/colors
cp ./lightningWhite.vim ~/.vim/colors

echo "*** Backing up the existing .vimrc and copying the .vimrc in this repo to ~/.vimrc... ***"
mv ~/.vimrc ~/.vimrc_$(date +"%Y%m%d_%H%M%S")
cp ./.vimrc ~/.vimrc

# Install the plugins in the .vimrc file by running the following in vim
# (equivalent to opening vim and running :PlugInstall)
echo "*** Installing the plugins listed in the .vimrc file... ***"
vim +'PlugInstall --sync' +qa

## Setup YouCompleteMe ##

echo "*** Installing cmake... ***"
# There seem to be keyring issues with installing cmake this way... (2024-10-29)
# For now, we'll just install the version in the ubuntu default repos
## See https://apt.kitware.com/ for installing cmake (required for building YouCompleteMe)
#sudo apt-get update && sudo apt-get install ca-certificates gpg wget
#wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | sudo tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null
## Specific to Ubuntu Jammy - modify if needed
#echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ jammy main' | sudo tee /etc/apt/sources.list.d/kitware.list >/dev/null
#sudo apt-get update
#sudo rm /usr/share/keyrings/kitware-archive-keyring.gpg
#sudo apt-get install kitware-archive-keyring
sudo apt-get install cmake

# Install other dependencies
echo "*** Installing other YouCompleteMe dependencies... ***"
sudo apt-get install build-essential python3-dev npm golang clang-format-11 openjdk-19-jre

echo "*** Compiling and setting up YouCompleteMe... ***"
(cd ~/.vim/plugged/YouCompleteMe && ./install.py --all) # Note: CC=gcc-12 CXX=g++12 can be specified before ./install.py if needed

# User vim with git
echo "*** Configuring git to use vim... ***"
git config --global core.editor vim
git config --global merge.tool vimdiff
# Ignore YouCompleteMe-generated clangd cache directory in repos
echo "*.cache" >> ~/.gitignore
git config --global core.excludesFile ~/.gitignore

echo ""
echo "You may need to install 'g++-12' for symantic completion to work correctly in some situations."
echo ""
echo "*** Done setting up development environment! ***"
