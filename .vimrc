" URL: http://vim.wikia.com/wiki/Example_vimrc
" Authors: http://vim.wikia.com/wiki/Vim_on_Freenode
" Description: A minimal, but feature rich, example .vimrc. If you are a
"              newbie, basing your first .vimrc on this file is a good choice.
"              If you're a more advanced user, building your own .vimrc based
"              on this file is still a good idea.
" Customized: By Daniel Hornberger
 
"------------------------------------------------------------
" Features {{{1
"
" These options and commands enable some very useful features in Vim, that
" no user should have to live without.
 
" Set 'nocompatible' to ward off unexpected things that your distro might
" have made, as well as sanely reset options when re-sourcing .vimrc
" This also makes it so Vim doesn't try to be reverse compatible with Vi.
set nocompatible

" Set ',' as the leader key (used by <leader> mappings throughout this file)
let mapleader = ","

filetype off

call plug#begin()

" The following are examples of different formats supported.
" Keep Plugin commands between plug#begin/end.

" Git-in-Vim plugin
Plug 'tpope/vim-fugitive'

" Code auto-completion
Plug 'ycm-core/YouCompleteMe'

" File browser
Plug 'preservim/nerdtree'

" Clang-format on save
Plug 'rhysd/vim-clang-format'

" A whole bunch of colorschemes
Plug 'flazz/vim-colorschemes'

" Ctrl-p to search for anything
Plug 'kien/ctrlp.vim'

" Status bar
Plug 'Lokaltog/powerling', {'rtp': 'powerline/bindings/vim/'}

" Markdown Rendering
Plug 'instant-markdown/vim-instant-markdown', {'for': 'markdown', 'do': 'yarn install'}

" All of your Plugins must be added before the following line
call plug#end()            " required

" Attempt to determine the type of a file based on its name and possibly its
" contents. Use this to allow intelligent auto-indenting for each filetype,
" and for plugins that are filetype specific.
filetype plugin indent on    " required for Vundle
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
"  :PlugInstall       - install the plugins listed in ~/.vimrc
"  :PlugUpdate        - update the installed plugins
"  :PlugUpdate <name> - update a specific plugin
"
" Put your non-Plugin stuff after this line
"------------------------------------------------------------------------------

"------------------------------------------------------------------------------
" Plugin Specific Configuration
"
" YouCompleteMe Specific Settings
" Use the experimental semantic highlighting feature
let g:ycm_enable_semantic_highlighting=1
" Increase the maximum number of diagnostics that can be displayed
let g:ycm_max_diagnostics_to_display=10000
" Automatically close the preview window
let g:ycm_autoclose_preview_window_after_completion=1

"--- Clangd Settings ---
" Let clangd fully control code completion
let g:ycm_clangd_uses_ycmd_caching=0
" Use clangd installed by the 'setupVim.sh' script, not YCM-bundled clangd for clang-tidy support.
" This must be an absolute path or vim will fallback to the built-in clangd
" The clangd completer script is located here if needed for debugging:
" ~/.vim/plugged/YouCompleteMe/third_party/ycmd/ycmd/completers/cpp/clangd_completer.py
let g:ycm_clangd_binary_path=exepath("/usr/local/bin/clangd")

" Pass additional args to clangd when it's started
" -- Using '--j=1' will cause it to index one file at a time to see where errors
"  may be happening
" -- Using '--log=verbose' will provide additional logs for debugging
" -- Using '--background-index=0' will make it only index the file you open
"  rather than all of them in the background. This can be helpful if clangd is
"  crashing on some file you never open, but it does make things slower.
" -- Using '--clang-tidy=0' will turn off clang-tidy
"let g:ycm_clangd_args = ['--clang-tidy=0', '--log=verbose', '--j=1', '--background-index=0', '--limit-results=1000']
" -- '--query-driver' allow-lists cross-compiler paths clangd may invoke to ask
"  for their built-in system include dirs (needed for projects using a
"  toolchain other than the host gcc/clang, e.g. PlatformIO/ESP-IDF's
"  xtensa-esp32-elf-gcc). Purely additive: harmless for projects whose
"  compile_commands.json reference compilers outside these globs.
let g:ycm_clangd_args = ['--query-driver=' . expand('~/.platformio/packages/toolchain-xtensa-esp-elf/bin/*')]

" GoTo shortcut
nnoremap <leader>jd :YcmCompleter GoTo<CR>

" NERDTree Specific Settings
" Mapping to toggle the NERDTree window
nnoremap <leader>t :NERDTreeToggle<CR>
" Mapping to focus the NERDTree window
nnoremap ff :NERDTreeFocus<CR>
" Mapping to open NERDTree at the file in the editor
nnoremap <leader>f :NERDTreeFind<CR>

" vim-clang-format Specific Settings
let g:clang_format#auto_format=1 " Use a .clang-format file in the project
" setupVim.sh symlinks its installed clang-format-<N> to /usr/local/bin/clang-format
let g:clang_format#command="clang-format"

" flazz/vim-colorschemes
set t_Co=256 " Use 256 color mode to make sure colorschemes look correct
colorscheme lightningWhite

"------------------------------------------------------------------------------

" Enable syntax highlighting
syntax on


" Show the tabline at the top of vim
set showtabline=2

" Allow switching tabs with shortcuts
nnoremap K :tabn<CR>
nnoremap J :tabp<CR>


"------------------------------------------------------------
" Must have options {{{1
"
" These are highly recommended options.
 
" Vim with default settings does not allow easy switching between multiple files
" in the same editor window. Users can use multiple split windows or multiple
" tab pages to edit multiple files, but it is still best to enable an option to
" allow easier switching between files.
"
" One such option is the 'hidden' option, which allows you to re-use the same
" window and switch from an unsaved buffer without saving it first. Also allows
" you to keep an undo history for multiple files when re-using the same window
" in this way. Note that using persistent undo also lets you undo in multiple
" files even in the same window, but is less efficient and is actually designed
" for keeping undo history after closing Vim entirely. Vim will complain if you
" try to quit without saving, and swap files will keep you safe if your computer
" crashes.
set hidden
 
" Note that not everyone likes working this way (with the hidden option).
" Alternatives include using tabs or split windows instead of re-using the same
" window as mentioned above, and/or either of the following options:
" set confirm
" set autowriteall
 
" Better command-line completion
set wildmenu
 
" Show partial commands in the last line of the screen
set showcmd
 
" Highlight searches (use <C-L> to temporarily turn off highlighting; see the
" mapping of <C-L> below)
set hlsearch

" Highligh search words while typing them
set incsearch
 
" Modelines have historically been a source of security vulnerabilities. As
" such, it may be a good idea to disable them and use the securemodelines
" script, <http://www.vim.org/scripts/script.php?script_id=1876>.
" set nomodeline


"------------------------------------------------------------
" Usability options {{{1
"
" These are options that users frequently set in their .vimrc. Some of them
" change Vim's behaviour in ways which deviate from the true Vi way, but
" which are considered to add usability. Which, if any, of these options to
" use is very much a personal preference, but they are harmless.
 
" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase
 
" Allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start
 
" When opening a new line and no filetype-specific indenting is enabled, keep
" the same indent as the line you're currently on. Useful for READMEs, etc.
set autoindent
 
" Stop certain movements from always going to the first character of a line.
" While this behaviour deviates from that of Vi, it does what most users
" coming from other editors would expect.
set nostartofline
 
" Display the cursor position on the last line of the screen or in the status
" line of a window
set ruler
 
" Always display the status line, even if only one window is displayed
set laststatus=2
 
" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm
 
" Use visual bell instead of beeping when doing something wrong
set visualbell
 
" And reset the terminal code for the visual bell. If visualbell is set, and
" this line is also included, vim will neither flash nor beep. If visualbell
" is unset, this does nothing.
set t_vb=
 
" Enable use of the mouse for all modes
set mouse=a
 
" Set the command window height to 2 lines, to avoid many cases of having to
" "press <Enter> to continue"
set cmdheight=2
 
" Display line numbers on the left
set number

" Use relative line numbers to the cursor's current position
set relativenumber

" Quickly time out on keycodes, but never time out on mappings
set notimeout ttimeout ttimeoutlen=200
 
" Use <F11> to toggle between 'paste' and 'nopaste'
set pastetoggle=<F11>

" Cause window splits to happen below the current window
set splitbelow

" Cause window splits to happen to the right of the current window
set splitright

" Set the terminal window size so it doesn't take up half the screen
"set termwinsize=10x0

" Use bar in insert mode, block in normal mode
let &t_SI = "\e[6 q"   " steady bar (insert)
let &t_EI = "\e[2 q"   " restore steady block (insert -> normal)
let &t_RS = "\e[2 q"   " restore steady block (for other restores)

"------------------------------------------------------------
" Indentation options {{{1
"
" Indentation settings according to personal preference.
 
" Indentation settings for using 4 spaces instead of tabs.
" Do not change 'tabstop' from its default value of 8 with this setup.
set shiftwidth=2
set softtabstop=2
set expandtab
 
" Indentation settings for using hard tabs for indent. Display tabs as
" four characters wide.
"set shiftwidth=2
"set tabstop=2

 
"------------------------------------------------------------
" Mappings {{{1
"
" Useful mappings
 
" Map Y to act like D and C, i.e. to yank until EOL, rather than act as yy,
" which is the default
map Y y$

" Map 'jk' to Escape for quick exits
:imap jk <Esc>
 
" Map <C-L> (redraw screen) to also turn off search highlighting until the
" next search
nnoremap <C-L> :nohl<CR><C-L>
"------------------------------------------------------------

"------------------------------------------------------------
" Copy and paste to and from the clipboard
" Note: vim-tkg needs to be installed since it supports
" clipboard. Also, if using this in WSL, VcXsrv needs to be
" installed on Windows and stared using XLaunch. Selecting 
" the default XLaunch settings works.
:set clipboard=unnamedplus

"------------------------------------------------------------
" Claude Code CLI integration {{{1
"
" Workflow: run vim and `claude` as two panes in the same tmux session
" (e.g. `tmux new-session -s work \; split-window -h`, vim on the left,
" `claude` running interactively on the right). Select a range in vim,
" hit <leader>cc, type a question, and it's pasted straight into the
" already-running Claude session (no CLAUDE.md/session reload per call).
" <leader>cD then shows a scoped before/after diff of just that
" selection once Claude's edit lands on disk.
"
" Set this to match your tmux session:pane (check with `tmux list-panes -t work`)
let g:claude_tmux_target = 'work:0.1'

" Pick up file changes written externally (by Claude) without prompting
set autoread
" How long (ms) of inactivity before CursorHold fires and triggers checktime
set updatetime=1000
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * checktime

" Send the visually selected lines, plus a typed question, into the
" Claude Code tmux pane. Remembers the selection so <leader>cD can later
" show a scoped diff of just this region.
function! SendToClaude() range
  let g:claude_snap_start = line("'<")
  let g:claude_snap_end   = line("'>")
  let g:claude_snap_lines = getline(g:claude_snap_start, g:claude_snap_end)

  let l:text = join(g:claude_snap_lines, "\n")
  let l:question = input("Ask Claude: ")
  call system('tmux set-buffer ' . shellescape(l:text . "\n\n" . l:question))
  call system('tmux paste-buffer -t ' . g:claude_tmux_target)
  call system('tmux send-keys -t ' . g:claude_tmux_target . ' Enter')
endfunction
vnoremap <leader>cc :<C-U>call SendToClaude()<CR>

" Show a scoped diff of just the last selection sent to Claude: old
" snapshot vs. whatever is now in that same line range, in two scratch
" buffers. Everything else in the file is ignored.
function! ShowClaudeScopedDiff()
  checktime
  if !exists('g:claude_snap_lines')
    echom "No Claude snapshot yet -- send a selection with <leader>cc first."
    return
  endif
  let l:new_lines = getline(g:claude_snap_start, g:claude_snap_end)

  tabnew
  setlocal buftype=nofile bufhidden=wipe noswapfile
  call setline(1, g:claude_snap_lines)
  diffthis
  vnew
  setlocal buftype=nofile bufhidden=wipe noswapfile
  call setline(1, l:new_lines)
  diffthis
endfunction
nnoremap <leader>cD :call ShowClaudeScopedDiff()<CR>
"------------------------------------------------------------

