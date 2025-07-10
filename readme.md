Development Environment Setup
===

# Overview

When getting on a new machine, development container, or virtual machine, 
there are several things I miss that I usually have configured in my Linux 
development environment. This setup, though simple, takes time and effort
and it really should be automated. 

Currently, this repo only contains a setup script to configure Vim.
As additional environmental conveniences come up, this should be expanded
and maintained. This will make setting up a new environment easy and 
repeatable. 

## Configuring Vim

The `setupVim.sh` script will set everything up for you.
Simply run `./setupVim.sh` and follow any prompts.
Elevated privileges are required during script execution since some steps
require additional packages to be installed.

This script will copy the .vimrc file to ~/.vimrc, install vim and any
dependencies, and install the plugins listed in the .vimrc file.
See the script for details.

You can now start vim, and everything should be set up.

### Set up a project with YouCompleteMe

- To find the function signatures and so forth, you need to
  Generate a compilation database. This can be done when running cmake by 
  adding the required flag to the rest of them:
  `-DCMAKE_EXPORT_COMPILE_COMMANDS=ON`. Note that this is typically already
  turned on by default.
- Then symlink the generated `compile_commands.json` file to the root of the
  project: `ln -sf ~/full/path/to/compile_commands.json ~/full/path/to/project/root`
- Now when you open a file within the project, things should work
- Here's an example of a compile command that can be run from anywhere to compile
  a cmake C++ project:
  `(cd ~/path/to/build_dir/; cmake ../srcDir -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DDEBIAN_BUILD=True -DCMAKE_BUILD_TYPE=Debug; make -j $(nproc);)`

To use vim as the default editor, run `git config --global core.editor vim`.
You can also setup git to use vimdiff as the merge conflict resolution tool.
To do this, run `git config --global merge.tool vimdiff`.
Then when merging and a conflict is encountered, run `git mergetool` to open
a three-way compare (local, base, and remote), and the actual file at the
bottom. This makes it easy to see what your changes were, what the common
parent is, and what is coming from the remote. Simply edit the bottom window
to what it should be, save with :wqa. Then run `git commit` to finish the merge.

### Customized Vim Usage Tips

Here are some commonly used key commands when using vim with the .vimrc in this repo.

| Command  | Action |
|----------|--------|
| i        | Enter insert mode |
| jk       | Exit insert mode or other commands (Esc equivalent) |
| j        | Move the cursor down when not in insert mode |
| k        | Move the cursor up when not in insert mode |
| h        | Move the cursor left when not in insert mode |
| l        | Move the cursor right when not in insert mode |
| Shift+:  | Enters the command mode at the bottom |
| :w       | Write/save the buffer |
| :q       | Quit and close the buffer |
| :qa      | Quit and close all buffers |
| :q!      | Quit and close without saving |
| y        | Yank/Copy selection |
| yy       | Yank/Copy the whole line |
| p        | Paste |
| dd       | Delete a whole line |
| u        | Undo |
| Ctrl+r   | Redo |
| r        | Replace the character under the cursor |
| cw       | Change the word under the cursor |
| w        | Move the cursor forward a word |
| b        | Move the cursor back a word |
| v        | Visual mode - allows you to select text for copying or whatever |
| /        | Enter search mode - just type what you're looking for after pushing this key and then hit enter |
| *        | Search all occurances of what's under the cursor |
| n        | Move to the next search occurance |
| N        | Move to the previous search occurance |
| Ctrl+l   | Clear the highlights |
| ,t       | Toggle opening the NERDTree window for directory navigation |
| ff       | This will focus the cursor in the NERDTree window - helpful after opening a tab or something |
| ,f       | This will open the NERDTree window with the cursor on the file currently in the editor |
| t        | If you hit this key in the NERDTree window, a new tab will be opened and switched to for the selected file |
| T        | If you hit this key in the NERDTree window, a new tab will be opened but not switched to for the selected file |
| J        | Switch to the tab to the left |
| K        | Switch to the tab to the right |
| ,jd      | GoTo the declaration or definition of whatever is under the cursor (YouCompleteMe) |
| Ctrl+o   | Go back to wherever you jumped from |
| %s/searchText/replaceText/gc | Search and replace globally in the file and ask for a confirmation for each replacement |
| :vsp     | Split the window vertically |
| :sp      | Split the window horizontally |
| Ctrl+ww  | Switch to another window |
| Ctl+v    | Enter visual block mode |
| I        | When in visual block mode, this will put the characters typed on every selected line after pressing 'jk' or Esc | 
| 0        | Go to the first of the line |
| $        | Go to the end of the line |
| <line#>gg| Go to the line number
| gg       | Go to the top of the buffer |
| GG       | Go to the bottom of the buffer |
|:colorscheme \<name\> | Change the colorscheme |
| q\<character\> | Begin recording a macro (series of key commands), escape, press 'q' to stop recording |
| @\<character\> | Execute the commands recorded in the macro identified by \<character\> |
| #@\<character\> | Execute the macro # of times |
| :term | Open a terminal in another window below the current one |
| :vert term | Open a terminal in another window to the side of the current one |
| Ctrl+w N | Enter vim text mode inside of an open terminal window (hit 'i' to exit) |
| m\<character\> | Set a marker named <character> at cursor location |
| \`\<character\> | Go to marker indicated by <character> |
| Ctrl+p | Fuzzy search for file |

### Troubleshooting

Here are a few things you can try to help in figuring out why autocompletion, etc. isn't working:

View the YcmDebugInfo in Vim:

```
:YcmDebugInfo
```

See if "Clangd running" is there. If it's not, it probably crashed.

You can look at the logs to try and see what happened:

```
:YcmToggleLogsa
# Select the clangd_stderr....log file
```

Look through these to see if it tells you what's going on.
You can increase the log verbosity by editing the .vimrc and adding a line like this:

```
let g:ycm_clangd_args = ["--log=verbose"]
```

You can also force it to only parse one file at a time by adding this arg:

```
let g:ycm_clangd_args = ["--log=verbose", "--j=1"]
```

This will likely tell you the last file it was processing before it crashed.
You can turn off background indexing with the following arg so it only parses the file you have open:

```
let g:ycm_clangd_args = ["--background-index=0"]
```

With background indexing off, you can go open the suspected file and check to see if the clangd crashes on that file but not others.
Then you can try commenting out code or whatever to see where the issue is.
You can try updating to a newer version of clangd if there's something causing a crash.
There are archives of clangd binaries you can just pull down and point YouCompleteMe to that newer binary to see how it handles that broken file.

Make sure to check the logs to see if it found your `compile_commands.json` file.

If autocompletion seems to be working, but clang-tidy checks aren't, look at the clangd logs and search for anything related to 'clang-tidy'.
It's possible there's an argument in the .clang-tidy file that it doesn't like.

## Customized VS Code Usage Tips

Vim bindings are configured, so a lot of the above commands will work, but there
are some differences.

Here is a table of some helpful common commands:

| Command  | Action |
|----------|--------|
| gh       | Display the hover help text on a symbol |
| gd       | Go to declaration |
| Ctrl+    | Open a terminal at the bottom |
