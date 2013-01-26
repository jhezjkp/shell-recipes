#!/usr/bin/env bash

#==
#== setup git
#==
function setup_git() {
    #personal config
    git config --global user.name "${1-jhezjkp}"
    git config --global user.email "${2-jhezjkp@163.com}"
    git config --global core.editor vim
    #alias
    git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --"
}

setup_git $@
