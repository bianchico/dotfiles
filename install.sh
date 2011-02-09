#!/bin/bash

function relink() {
  if [[ -h "$1" ]]; then
    echo "Relinking $1"
    # Symbolic link? Then recreate.
    rm "$1"
    ln -sn "$2" "$1"
  elif [[ ! -e "$1" ]]; then
    echo "Linking $1"
    ln -sn "$2" "$1"
  else
    echo "$1 exists as a real file, skipping."
  fi
}

cd ~
relink .bash_profile ~/.dotfiles/bash_profile
relink .bashrc ~/.dotfiles/bashrc
# relink .gitconfig ~/.dotfiles/git-config
# relink .gitignore ~/.dotfiles/git-ignore-global
relink bin ~/.dotfiles/bin