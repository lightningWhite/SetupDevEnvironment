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

filetype off

call plug#begin()

" The following are examples of different formats supported.
" Keep Plugin commands between plug#begin/end.

" Git-in-Vim plugin
" Plug 'tpope/vim-fugitive'

" Code auto-completion
Plug 'ycm-core/YouCompleteMe'

" File browser
Plug 'preservim/nerdtree'

" Clang-format on save
Plug 'rhysd/vim-clang-format'

" A whole bunch of colorschemes
Plug 'flazz/vim-colorschemes'

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
" GoTo shortcut
nnoremap ,jd :YcmCompleter GoTo<CR>


" NERDTree Specific Settings
" Mapping to toggle the NERDTree window
nnoremap ,t :NERDTreeToggle<CR>
" Mapping to focus the NERDTree window
nnoremap ff :NERDTreeFocus<CR>
" Mapping to open NERDTree at the file in the editor
nnoremap ,f :NERDTreeFind<CR>

" vim-clang-format Specific Settings
let g:clang_format#auto_format=1 " Use a .clang-format file in the project

" flazz/vim-colorschemes
set t_Co=256 " Use 256 color mode to make sure colorschemes look correct
colorscheme sean

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

