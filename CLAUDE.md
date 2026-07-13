# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repo purpose

This is Daniel's personal dev-environment bootstrap / dotfiles repo (not an application). It currently automates a heavily customized **Vim** setup, plus manual scripts to snapshot/restore **VS Code** user settings. There are no tests, no lint config, and no CI — expected for a repo like this.

## Layout

- `.vimrc` — main Vim config (plugins via vim-plug, YouCompleteMe + clangd, custom keybindings, leader = `,`).
- `lightningWhite.vim` — custom colorscheme, installed to `~/.vim/colors`.
- `setupVim.sh` — bootstrap script that builds Vim from source and installs YouCompleteMe/clangd.
- `readme.md` — the authoritative documentation (setup steps, keybinding table, troubleshooting, known issues). Check it before assuming something is undocumented.
- `vscode/` — `settings.json`/`keybindings.json` (user-level VS Code config), plus `grabSettings.sh`/`restoreSettings.sh` for one-way manual backup/restore of `~/.config/Code/User`, and a `profiles/` snapshot including a binary `state.vscdb`.

## `setupVim.sh` — confirm before running

This script requires sudo but must **not** be run as root (`exit 1`s if `$EUID -eq 0`). Runs under `set -euo pipefail` — it aborts on the first failing command rather than limping on with a partially-broken toolchain. Before running it, always confirm with the user first — it:
- installs system packages via `apt-get`/`npm -g`,
- adds two third-party apt sources: the LLVM apt repo (`apt.llvm.org`, for a pinned `clang-format`/`clangd`/`libclang` version) and the `ppa:longsleep/golang-backports` PPA (for a pinned Go version),
- clones and builds Vim from source at a pinned tag (`VIM_VERSION` near the top of the script), replacing the apt-installed `vim`,
- builds/installs YouCompleteMe with clangd,
- edits **global** git config (`core.editor vim`, `merge.tool vimdiff`) and appends to the global gitignore (`*.cache`) and `~/.profile` — these affect every repo on the machine, not just this one.

Version numbers (`VIM_VERSION`, `CLANG_VERSION`, `GO_VERSION`, `JAVA_VERSION`) are variables at the top of the script — bump them there, in one place, when a distro's repos or apt.llvm.org drop a version.

It's idempotent aside from expected re-work: re-running re-backs-up `~/.vimrc` (by design — it's a timestamped backup, not a clobber) and rebuilds/reinstalls Vim and YouCompleteMe from scratch. The `go` PATH append and the gitignore `*.cache` line are both guarded against duplicate entries.

`.vimrc` and the colorscheme are **copied, not symlinked**, into `~/.vimrc` and `~/.vim/colors`. Local edits to `~/.vimrc` won't flow back into this repo automatically — copy changes back manually before committing.

## Claude Code / vim / tmux integration

`.vimrc` (search "Claude Code CLI integration") wires Vim to a tmux pane running `claude`, via a `vc()` bash helper (see readme.md) that opens/reattaches a tmux session named `work` with vim in the left pane and `claude` in the right. This depends on `g:claude_tmux_target = 'work:0.1'` matching the pane layout `vc()` creates — if either changes, update the other.

- `,cc` (visual mode) — sends the selected lines + a typed question into the Claude tmux pane.
- `,cD` (normal mode) — opens a scoped diff (before/after) of Claude's edit to that same line range.
- `autoread` + short `updatetime` + autocmds are set so Vim picks up file changes made by Claude on disk without prompting.

## Git conventions

Commit directly to `master` — no feature branches or PRs for this repo.

## Platform notes

Targets Debian-family systems (Ubuntu, LinuxMint, WSL). Recent commits show package versions occasionally need bumping per-distro (e.g. `clang-format-20`, `golang-1.24`, `openjdk-21-jre`). WSL clipboard integration (`clipboard=unnamedplus`) needs `vim-tkg` and an X server (VcXsrv/XLaunch) running on the Windows host — see the comment in `.vimrc`.
