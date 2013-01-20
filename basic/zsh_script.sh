#!/usr/bin/env bash

# Set Up ZShell Environment

#check system distribution
distribution=`lsb_release -is`

if test $distribution=="Ubuntu"
then
    echo "=== Ubuntu =="
    echo "check if zsh is installed..."
    if [ `which zsh` ]
    then
        zshVersion=`zsh --version  | sed -n '1p' | cut  -d " " -f2`
        echo "zsh version is ${zshVersion}, pass..."
        #configure zsh
        echo "configure zsh..."
        cd ~
        curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
        exit 0
    else
        echo "zsh is not installed or version to low(<5.0.0), please upgrade it before we continue"
        echo "    \033[44;37msudo apt-get install zsh\033[0m"
        exit 1
    fi
else
    echo "not ubuntu"
fi
