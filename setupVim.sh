#!/bin/bash

# Make sure vim is installed and vim-gtk3 (for clipboard support)
echo "*** Installing vim and vim-gtk3... ***"
sudo apt-get install vim vim-gtk3

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
# See https://apt.kitware.com/ for installing cmake (required for building YouCompleteMe)
sudo apt-get update && sudo apt-get install ca-certificates gpg wget
wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | sudo tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/nulla
# Specific to Ubuntu Jammy - modify if needed
echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ jammy main' | sudo tee /etc/apt/sources.list.d/kitware.list >/dev/null
sudo apt-get update
sudo rm /usr/share/keyrings/kitware-archive-keyring.gpg
sudo apt-get install kitware-archive-keyring
sudo apg-get install cmake

# Install other dependencies
echo "*** Installing other YouCompleteMe dependencies... ***"
sudo apt-get install build-essential vim-nox python3-dev npm golang clang-format-11 openjdk-19-jre

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
