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
        curl -L https://github.com/jhezjkp/dot-vimrc/raw/master/tools/install.sh | sh >> /dev/null
        cd ~/.vim
        git checkout vivia
        echo "\n\ninstall Powerline Python package:"
        echo "   sudo pip install https://github.com/Lokaltog/powerline/tarball/develop"
        echo "\nYour vim is now configured!\nPlease open vim and run \"\033[44;37m:BundleInstall\033[0m\" \
            command to finish the vim plugins installation.\033[0m"]]]
        exit 0
    else
        echo "vim is not installed or version to low(<7.0), please upgrade it before we continue."
        exit 1
    fi
else
    echo "not ubuntu"
fi
