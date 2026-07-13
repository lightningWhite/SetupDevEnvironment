#!/bin/bash
#
# Bootstraps Vim (built from source, pinned to a known-good commit) plus
# YouCompleteMe/clangd for C++ and Python completion. Safe to re-run; each
# step either overwrites its own output or is guarded to skip if already done.

set -euo pipefail

if [[ "$EUID" -eq 0 ]]; then
  echo "This script must not be run as root! Exiting."
  exit 1
fi

# --- Versions -----------------------------------------------------------
# Centralized here so bumping a version (e.g. when a distro's repo stops
# shipping one of these) only requires editing one line instead of hunting
# through the script.
#
# VIM_VERSION: a specific vim/vim tag, not a moving branch. Vim tags nearly
# every commit, so "latest" as of whenever this was last bumped is fine --
# the point is that two runs of this script months apart build the exact
# same Vim. Find newer tags at https://github.com/vim/vim/releases.
VIM_VERSION="v9.2.0780"
# clang-format/clangd/libclang, pulled from apt.llvm.org so the exact
# version is available regardless of what the OS's default repos carry.
CLANG_VERSION=20
# Go, pulled from the longsleep/golang-backports PPA for the same reason --
# distro-default `golang-go` versions lag and vary release to release.
GO_VERSION=1.24
JAVA_VERSION=21
# Vim needs a python3 dev environment to build +python3 support. Resolve
# whatever python3 is actually current on this system instead of hardcoding
# a version that will eventually stop existing on newer distro releases.
PYTHON3_BIN="$(command -v python3)"

echo "*** Updating apt package lists... ***"
sudo apt-get update

echo "*** Installing base build/runtime dependencies... ***"
# git/curl/wget/gnupg/software-properties-common: fetching sources & repos below.
# build-essential/cmake/python3-dev: needed to build Vim and YouCompleteMe/ycmd.
# npm: needed for the yarn/instant-markdown-d install right below.
# libncurses-dev + the libx11/libxt/libxtst/libsm/libxpm-dev: Vim's terminal UI
# and X11 clipboard integration (+clipboard), see the .vimrc clipboard section.
sudo apt-get install --assume-yes \
  git curl wget gnupg software-properties-common \
  build-essential cmake python3-dev npm \
  libncurses-dev libx11-dev libxtst-dev libxt-dev libsm-dev libxpm-dev

echo "*** Installing yarn/instant-markdown-d (for vim-instant-markdown)... ***"
sudo npm -g install yarn instant-markdown-d

# --- clang/clangd/clang-format (for YouCompleteMe C++ support) ----------
#
# Ubuntu/Mint's default repos only ever carry whatever clang version was
# current at release time, so pin a specific one via the official LLVM apt
# repository instead. This makes clangd/clang-format version-independent
# of the underlying distro release.
echo "*** Adding the LLVM apt repository for clang ${CLANG_VERSION}... ***"
UBUNTU_CODENAME="$(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")"
sudo mkdir -p /etc/apt/keyrings
wget -qO- https://apt.llvm.org/llvm-snapshot.gpg.key | sudo gpg --yes --dearmor -o /etc/apt/keyrings/llvm.gpg
echo "deb [signed-by=/etc/apt/keyrings/llvm.gpg] http://apt.llvm.org/${UBUNTU_CODENAME}/ llvm-toolchain-${UBUNTU_CODENAME}-${CLANG_VERSION} main" \
  | sudo tee /etc/apt/sources.list.d/llvm-${CLANG_VERSION}.list > /dev/null
sudo apt-get update

echo "*** Installing clang-format, clangd, and libclang ${CLANG_VERSION}... ***"
# clang-format: used for format-on-save (see vim-clang-format in .vimrc).
# clangd: the language server YouCompleteMe drives for C++ diagnostics/completion.
# libclang-dev: used by YouCompleteMe's ycmd (--system-libclang below).
sudo apt-get install --assume-yes \
  clang-format-${CLANG_VERSION} clangd-${CLANG_VERSION} libclang-${CLANG_VERSION}-dev

# Symlink to unversioned names so .vimrc doesn't need to track CLANG_VERSION.
sudo ln -sf /usr/bin/clangd-${CLANG_VERSION} /usr/local/bin/clangd
sudo ln -sf /usr/bin/clang-format-${CLANG_VERSION} /usr/local/bin/clang-format

# --- Go (required by YouCompleteMe's gopls/install tooling) -------------
echo "*** Adding the golang-backports PPA and installing Go ${GO_VERSION}... ***"
sudo add-apt-repository -y ppa:longsleep/golang-backports
sudo apt-get update
sudo apt-get install --assume-yes golang-${GO_VERSION}

# Guard against duplicate entries so re-running this script is idempotent, and
# append to $PATH (rather than baking in a snapshot of it) so it doesn't
# clobber whatever .bashrc/.profile already set up.
if ! grep -qF "/usr/lib/go-${GO_VERSION}/bin/" ~/.profile 2>/dev/null; then
  echo "# Add 'go' to the path for vim" >> ~/.profile
  echo "PATH=\"\$PATH:/usr/lib/go-${GO_VERSION}/bin/\"" >> ~/.profile
fi
# Export it here as well so the updated path is available in this script.
export PATH="${PATH}:/usr/lib/go-${GO_VERSION}/bin/"

echo "*** Installing Java ${JAVA_VERSION} (required by YouCompleteMe's jdt.ls completer)... ***"
sudo apt-get install --assume-yes openjdk-${JAVA_VERSION}-jre

# --- Build and install Vim from source -----------------------------------
#
# YouCompleteMe requires a recent Vim (>=9.1) that most distros don't ship,
# so build it from source, pinned to $VIM_VERSION for reproducibility.
echo "*** Fetching Vim ${VIM_VERSION}... ***"
if [[ -d vim/.git ]]; then
  (cd vim && git fetch --tags origin)
else
  git clone https://github.com/vim/vim.git
fi
(cd vim && git checkout "${VIM_VERSION}")

echo "*** Removing any distro-packaged vim (it would conflict with the one we're building)... ***"
sudo apt-get remove --assume-yes vim

echo "*** Compiling and installing Vim (this can take a few minutes)... ***"
# --with-features=huge: guarantees +clipboard/+xterm_clipboard are compiled in
#   (see the clipboard section of .vimrc) rather than relying on configure's
#   feature-level default, which isn't guaranteed across Vim/distro versions.
# --enable-fail-if-missing: abort the build if a requested feature (python3,
#   X11) can't actually be satisfied, instead of silently producing a Vim
#   that's missing it -- which would otherwise only surface later as a
#   confusing YouCompleteMe or clipboard failure.
# --enable-gui=no: this is a terminal-only workflow (see the tmux/Claude
#   integration in .vimrc); skip probing for GTK, which isn't installed here.
(cd vim && ./configure \
  --with-features=huge \
  --enable-multibyte \
  --enable-python3interp=yes \
  --with-python3-command="${PYTHON3_BIN}" \
  --enable-fail-if-missing \
  --enable-gui=no \
  --with-x \
  && sudo make install)
# Note: pass CC=gcc-12 CXX=g++-12 before ./configure above if the system
# default compiler is too old for a particular distro.

echo "*** Installing the vim-plug plugin manager... ***"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "*** Setting up custom colorscheme... ***"
mkdir -p ~/.vim/colors
cp ./lightningWhite.vim ~/.vim/colors

echo "*** Copying the .vimrc in this repo to ~/.vimrc... ***"
if [[ -f ~/.vimrc ]]; then
  echo "    (backing up existing ~/.vimrc first)"
  mv ~/.vimrc ~/.vimrc_"$(date +"%Y%m%d_%H%M%S")"
fi
cp ./.vimrc ~/.vimrc

# Install the plugins in the .vimrc file by running the following in vim
# (equivalent to opening vim and running :PlugInstall). Runs with the Vim we
# just built so the plugin manager and YouCompleteMe below see the same
# version this whole script targets.
echo "*** Installing the plugins listed in the .vimrc file... ***"
vim +'PlugInstall --sync' +qa

echo "*** Building YouCompleteMe (this can take a few minutes)... ***"
# --clangd-completer: bundle a fallback clangd (unused at runtime since
#   .vimrc points g:ycm_clangd_binary_path at the one installed above, but
#   keeps YCM's own install self-contained).
# --system-libclang: use the libclang-${CLANG_VERSION}-dev installed above.
(cd ~/.vim/plugged/YouCompleteMe && ./install.py --all --clangd-completer --system-libclang --verbose)

echo "*** Configuring git to use vim... ***"
git config --global core.editor vim
git config --global merge.tool vimdiff
# Ignore YouCompleteMe-generated clangd cache directory in repos. Guard
# against duplicate lines so re-running this script is idempotent.
if ! grep -qxF '*.cache' ~/.gitignore 2>/dev/null; then
  echo "*.cache" >> ~/.gitignore
fi
git config --global core.excludesFile ~/.gitignore

echo ""
echo "*** Done setting up development environment! ***"
echo ""
echo "Open a new shell (or run 'source ~/.profile') to pick up the PATH changes."
echo "You may need to install a matching g++ (e.g. g++-12) for semantic completion to work correctly in some situations."
