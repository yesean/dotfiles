# dotfiles

- [Intro](#intro)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)

## Intro

This repo contains my configuration files for various programs that I use on
Arch Linux and macOS.
I use [stow](https://www.gnu.org/software/stow/) to help manage my dotfiles.
Each directory contains config files for its namesake program (e.g. vim, zsh,
polybar, etc) and mirrors the home directory (necessary for stow).
The [install script](https://github.com/seanye24/dotfiles/blob/main/install.sh)
uses stow to create symlinks in your config directories and point them toward
files in the dotfiles repo.
The install script will also detect the OS (macOS or Linux) and only install the
relevant dotfiles.

## Prerequisites
- [stow](https://www.gnu.org/software/stow/)

## Getting Started

To get started, run:
```
cd
git clone https://github.com/seanye24/dotfiles.git .dotfiles
cd .dotfiles
./install.sh
```

And that's it! The config files should be installed and ready to go on your
system.
The install script isn't well tested so you may want to create the symlinks
manually or simply copy files from the repo into the correct locations.
