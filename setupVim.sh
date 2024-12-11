#!/bin/bash

if [[ "$EUID" -eq 0 ]]; then
  echo "This script must not be run as root! Exiting."
  exit 1
fi

# Since YouCompleteMe requires >=Vim 9.1, we have to build from source
# on some older systems (e.g. Ubuntu 22.04) to get a new enough version.
# This also allows us to enable python3 and clipboard support in the build.
echo "*** Building and installing Vim... ***"
sudo apt-get remove vim --assume-yes # Remove conflicting versions
sudo apt-get install git curl libncurses-dev libx11-dev libxtst-dev libxt-dev libsm-dev libxpm-dev # Needed for clipboard support
git clone https://github.com/vim/vim.git >> /dev/null || (cd vim ; git pull)
(cd vim && ./configure --enable-python3interp=yes --with-x && sudo make install)

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
sudo apt-get install cmake

# Install other dependencies
echo "*** Installing other YouCompleteMe dependencies... ***"
## Note that clang-format-11 allows formatting on save (see the .vimrc)
## Note that clangd-15 allows clang-tidy errors to be displayed in the editor (see the .vimrc)
sudo apt-get install build-essential python3-dev npm golang clang-format-11 clangd-15 openjdk-21-jre

echo "*** Compiling and setting up YouCompleteMe... ***"
#(cd ~/.vim/plugged/YouCompleteMe && \
#  ./install.py \ # Note: CC=gcc-12 CXX=g++12 can be specified before ./install.py if needed
#  #--all # Note: This used to work, but on Ubuntu 22.04 the 'go' completer failed
#        # to install, preventing the rest from working. So... Selecting the others
#        # manually.
#  #--clang-completer \ # C-family semantic completion engine through libclang
#  --clangd-completer  # C-family semantic completion engine through clangd lsp server
#  #--cs-completer \ # For C#
#  #--go-completer \ # For Go (broken on Ubuntu 22.04)
#  #--rust-completer \
#  #--rust-toolchain-version \
#  #--java-completer \
#  #--ts-completer \ # JavaScript and TypeScript
#  #--system-libclang \ # Use system libclang - Not recommended or supported
#  #--msvc \ # Specify Microsoft Visual Studio version
#  #--enable-coverage \ # Enable gcov coverage
#  #--enable-debug \ # Build ycm_core lib with debug symbols
#  #--build-dir \ # Specify build directory
#  ) 

(cd ~/.vim/plugged/YouCompleteMe && ./install.py --clangd-completer)

# Use vim with git
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
