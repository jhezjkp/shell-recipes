#!/usr/bin/env bash

# Set Up Vim Environment

. `pwd`/helper.sh

echo "ensure vim is installed and version above 7.0"
which vim >> /dev/null 2>&1
if [ $? -eq 1 ]
then
    printf "vim is not installed!"
exit 1
fi


vimVersion=`vim --version  | sed -n '1p' | cut  -d " " -f5`
if [ $(echo "${vimVersion} >= 7" | bc) -eq 1 ]
then
    echo "vim version is ${vimVersion}, pass..."

    vimPython2Support=`vim --version | grep python2`
    if [ $vimPython2Support="" ]; then 
        printf "python2 is not compiled in vim, vim-nox need to be install\n"
        install_package vim-nox
    fi

    #configure vim
    echo "configure vim..."
    cd ~
    curl -L https://github.com/jhezjkp/dot-vimrc/raw/master/tools/install.sh | sh >> /dev/null
    cd ~/.vim
    git checkout vivia
    printf "\n\ninstall Powerline Python package:\n\t"
    print "pip install https://github.com/Lokaltog/powerline/tarball/develop"
    printf "\nYour vim is now configured!\nPlease open vim and run \n"
    printf "\t"
    print ":BundleInstall"
    echo "command to finish the vim plugins installation."
    exit 0
else
    echo "vim is not installed or version to low(<7.0), please upgrade it before we continue."
    exit 1
fi

