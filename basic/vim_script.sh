#!/usr/bin/env bash

# Set Up Vim Environment

#check system distribution
distribution=`lsb_release -is`

if test $distribution=="Ubuntu"
then
    echo "=== Ubuntu =="
    echo "ensure vim is installed and version above 7.0"
    #apt-get install vim
    vimVersion=`vim --version  | sed -n '1p' | cut  -d " " -f5`
    if [ $(echo "${vimVersion} >= 7" | bc) -eq 1 ]
    then
        echo "vim version is ${vimVersion}, pass..."
        #configure vim
        echo "configure vim..."
        cd ~
        creates=.vim/vimrc curl -L https://github.com/jhezjkp/dot-vimrc/raw/master/tools/install.sh | sh
        exit 0
    else
        echo "vim is not installed or version to low(<7.0), please upgrade it before we continue."
        exit 1
    fi
else
    echo "not ubuntu"
fi
