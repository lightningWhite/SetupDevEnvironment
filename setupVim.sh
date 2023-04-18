#!/bin/bash

# Make sure vim is installed and vim-gtk3 (for clipboard support)
echo "Installing vim and vim-gtk3..."
sudo apt-get install vim vim-gtk3

# Install vim-plug Package Manager
echo "Installing the vim-plug plugin manager..."
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "Copying the .vimrc in this repo to ~/.vimrc..."
cp ./.vimrc ~/.vimrc

# Install the plugins in the .vimrc file by running the following in vim
# (equivalent to opening vim and running :PlugInstall)
echo "Installing the plugins listed in the .vimrc file..."
vim +'PlugInstall --sync' +qa

# Install dependencies and compile YouCompleteMe
echo "Compiling and setting up YouCompleteMe..."
sudo apt install build-essential cmake vim-nox python3-dev npm golang
(cd ~/.vim/plugged/YouCompleteMe && ./install.py --all)
