Development Environment Setup
===

# Overview

Whenever getting on a new machine, development container, or virtual machine, 
there are several things I miss that I usually have configured in my Linux 
development environment. This setup, though simple, takes time and effort
and it really can be automated. 

This repository contains some configuration files for some of the tools I
commonly use. To use it, clone the repository to your local machine and run
the `setupDevEnv.sh` bash script. This will replace the configuration files
with those in this repository and then source those that need to be source.
Then the environment will be all set up with just a few commands. Once the 
script has been run, it can be executed again and the most recently replaced
settings can be restored. However, only the most recent settings can be 
restored. 

**Note:** Executable privileges will need to be added to the script for it 
to be run: `chmod +x setupDevEnv.sh`. Also, for the terminal to immediately 
reflect the .bashrc changes, run the sript like this: `. ./setupDevEnv.sh`

Enjoy!

## Current Setup Configuration

### .bashrc
* Colored Terminal
* Bash Aliases

### .vimrc
* Map `jk` to `Esc`

### .gitignore_global
* Ignore `.vscode/`
* Runs `git config --global core.excludesfile ~/.gitignore_global`

## Additions
As additional environmental conveniences come up, this should be expanded
and maintained. This will make setting up a new environment easy and 
repeatable. 
