#!/bin/bash

if [[ "$EUID" -eq 0 ]]; then
  echo "This script must not be run as root! Exiting."
  exit 1
fi

# Since YouCompleteMe now (Dec 2024) requires >=Vim 9.1, we have to build from source
# on some older systems (e.g. Ubuntu 22.04) to get a new enough version.
# This also allows us to enable python3 and clipboard support in the build.
echo "*** Building and installing Vim... ***"
sudo apt-get remove vim --assume-yes # Remove conflicting versions
sudo apt-get install --assume-yes git curl libncurses-dev libx11-dev libxtst-dev libxt-dev libsm-dev libxpm-dev # Needed for clipboard support
sudo npm -g install yarn instant-markdown-d # For markdown rendering with vim-instant-markdown plugin
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
sudo apt-get --assume-yes install cmake

# Install other dependencies
echo "*** Installing other YouCompleteMe dependencies... ***"
## Note that clang-format-11 allows formatting on save (see the .vimrc)
sudo apt-get install --assume-yes clang-format-11

# Instead of apt installing an older version, we're going to use a newer version
# of clangd in order to handle newer C++ features
# Note that clangd allows clang-tidy errors, autocompletion, etc. to be active
# in the editor (see the .vimrc). It will use whatever clang-tidy version is
# bundled in with clangd.
# Use 'let g:ycm_clangd_binary_path=exepath("~/.vim/plugged/YouCompleteMe/third_party/ycmd/ycmd/completers/cpp/clangd_20.1.0/bin/clangd")' in .vimrc to actually use it
# First, we'll install a few dependencies for clangd to work properly
sudo apt-get install --assume-yes build-essential python3-dev npm golang-1.20 openjdk-21-jre
# Now we'll download the clangd binary
wget https://github.com/clangd/clangd/releases/download/20.1.0/clangd-linux-20.1.0.zip -P /tmp
unzip /tmp/clangd-linux-20.1.0.zip -d ~/.vim/plugged/YouCompleteMe/third_party/ycmd/ycmd/completers/cpp/

# Since we had to install a newer version of go than the default golang, we need
# to update the path so it can be found. This newer version is required by YouCompleteMe.
sudo echo "# Add 'go' to the path for vim" >> ~/.profile
sudo echo "PATH=${PATH}:/usr/lib/go-1.20/bin/" >> ~/.profile
# Export it here as well so the updated path is available in this script
export PATH=${PATH}:/usr/lib/go-1.20/bin/

echo "*** Compiling and setting up YouCompleteMe... ***"
# Note: CC=gcc-12 CXX=g++12 can be specified before ./install.py if needed
# --clangd-completed: C-family semantic completion engine through clangd lsp server
# --system-libclang: Allow use of the system's libclang (see the .vimrc) - Technically not recommended or supported
(cd ~/.vim/plugged/YouCompleteMe && ./install.py --all --clangd-completer --system-libclang)

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
