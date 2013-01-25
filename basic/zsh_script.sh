#!/usr/bin/env bash

# Set Up ZShell Environment

. `pwd`/helper.sh

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
    #echo "    \033[44;37msudo apt-get install zsh\033[0m"
    get_install_cmd zsh
    print "\t$return_var"
    exit 1
fi
