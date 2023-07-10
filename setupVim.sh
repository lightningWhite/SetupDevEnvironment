#!/bin/bash

# Make sure vim is installed and vim-gtk3 (for clipboard support)
echo "Installing vim and vim-gtk3..."
sudo apt-get install vim vim-gtk3

# Install vim-plug Package Manager
echo "Installing the vim-plug plugin manager..."
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Copy the custom colorscheme to the right location
mkdir ~/.vim/colors
cp ./lightningWhite.vim ~/.vim/colors

echo "Backing up the existing .vimrc and copying the .vimrc in this repo to ~/.vimrc..."
mv ~/.vimrc ~/.vimrc_$(date +"%Y%m%d_%H%M%S")
cp ./.vimrc ~/.vimrc

# Install the plugins in the .vimrc file by running the following in vim
# (equivalent to opening vim and running :PlugInstall)
echo "Installing the plugins listed in the .vimrc file..."
vim +'PlugInstall --sync' +qa

# Install dependencies and compile YouCompleteMe
echo "Compiling and setting up YouCompleteMe..."
sudo apt install build-essential cmake vim-nox python3-dev npm golang clang-format-11
(cd ~/.vim/plugged/YouCompleteMe && ./install.py --all)
