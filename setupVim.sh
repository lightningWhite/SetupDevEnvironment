#!/bin/bash

# Install vim-plug Package Manager
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

cp ./.vimrc ~/.vimrc

# TODO: Compile YouCompleteMe
