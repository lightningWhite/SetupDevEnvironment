#!/bin/bash 

echo
echo
echo "        ---                              "    
echo "       |   |                             "         
echo "        \     ----- -----       ----     "                       
echo "         \    |       |   |   | |   \    "                 
echo "          \   |--     |   |   | |--/     "              
echo "       |   |  |       |   \___/ |        "                 
echo "        ---   -----                      "                 
echo
echo

echo Do you want to restore the previous setup? (Entering 'n' will run the setup) [y/n]
read doRestore
echo

if [ "$doRestore" = "y" ] 
then
    if [ -d ~/.backupDevEnvConfig ]
    then
        echo Restoring the previous setup...
        cp -r ~/.backupDevEnvConfig/. ~/.
        echo The previous setup has been restored. Exiting...
    else
        echo "The previous setup coudn't be restored! Exiting..."
    fi
    exit
else
    echo Proceeding with the dev environment setup...
fi

echo Checking current config files...

if [ ! -d ~/.backupDevEnvConfig ]; then
    mkdir ~/.backupDevEnvConfig
fi

askPermission=0

if [ -f ~/.bashrc ]; then
    echo The ~/.bashrc file will be backed up and replaced...
    cp ~/.bashrc ~/.backupDevEnvConfig/.
    askPermission=1
fi

if [ -f ~/.bash_aliases ]; then
    echo The ~/.bash_aliases file will be backed up and replaced...
    cp ~/.bash_aliases ~/.backupDevEnvConfig/.
    askPermission=1
fi

if [ -f ~/.vimrc ]; then
    echo The ~/.vimrc file will be backed up and replaced...
    cp ~/.vimrc ~/.backupDevEnvConfig/.
    askPermission=1
fi

if [ -f ~/.gitignore_global ]; then
    echo The ~/.gitignore_global file will be backed up and replaced...
    cp ~/.gitignore_global ~/.backupDevEnvConfig/.
    askPermission=1
fi

echo

if [ $askPermission -gt 0 ]; then
    echo Do you want to proceed and replace the above files? This can be undone. [y/n]
    read answer
    if [ "$answer" != "y" ]; then
        echo The dev environment setup will not proceed. Exiting...
        exit
    fi
fi

echo
echo Setting up the environment...
cp .bash_aliases ~/.
cp .bashrc ~/. && source ~/.bashrc
cp .vimrc ~/.
cp .gitignore_global ~/. && git config --global core.excludesfile ~/.gitignore_global

echo
echo The setup is complete!
