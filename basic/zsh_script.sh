#!/usr/bin/env bash

# Set Up ZShell Environment

. `pwd`/helper.sh

echo "check if zsh is installed..."
which zsh >> /dev/null 2>&1
if [ $? -eq 0 ]
then
    zshVersion=`zsh --version  | sed -n '1p' | cut  -d " " -f2`
    echo "zsh version is ${zshVersion}, pass..."
    if [ -d ~/.oh-my-zsh ]
    then
        echo "zsh has been configured already."
        exit 0
    fi
    #configure zsh
    echo "configure zsh..."
    cd ~
    curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
    exit 0
else
    echo "zsh is not installed, please install it before we continue"
    #echo "    \033[44;37msudo apt-get install zsh\033[0m"
    get_install_cmd zsh
    print "\t$return_var"
    exit 1
fi
