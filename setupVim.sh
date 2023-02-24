#!/bin/bash

# Make sure vim is installed and vim-gtk3 (for clipboard support)
sudo apt-get install vim vim-gtk3

# Install vim-plug Package Manager
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

cp ./.vimrc ~/.vimrc

# Install the plugins in the .vimrc file by running the following in vim
# (equivalent to opening vim and running :PlugInstall)
vim +'PlugInstall --sync' +qa

# Install dependencies and compile YouCompleteMe
sudo apt install build-essential cmake vim-nox python3-dev npm
(cd ~/.vim/plugged/YouCompleteMe && ./install.py --all)
