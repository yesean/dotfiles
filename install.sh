#!/bin/bash

if ! command -v stow &> /dev/null; then
  echo "GNU Stow must be installed in order to run the install script"
  exit 1
fi

[[ $(uname) = 'Darwin' ]] && is_macos=true || is_macos=false
[[ $(uname) = 'Linux' ]] && is_linux=true || is_linux=false

dotfiles_dir="$HOME/.dotfiles"
config_dir="$HOME/.config"

cd "$dotfiles_dir" || exit

# remove config dir symlink if it exists
if [[ -L $config_dir ]]; then
  echo "Removing symlink at $config_dir"
  rm "$config_dir"
fi

# create config directory if it doesn't exist
if [[ ! -d $config_dir ]]; then
  echo "Creating configuration directory at ~/.config/"
  mkdir -p "$config_dir"
fi

if [[ "$is_linux" == "true" ]]; then
  echo 'Linux machine detected!'
  echo 'Installing for linux:'
  programs=(alacritty git i3 nvim picom polybar prettier ranger rofi tmux vim vscode zathura zsh)
elif [[ "$is_macos" == "true" ]]; then
  echo 'macOS machine detected!'
  echo 'Installing for macos:'
  programs=(alacritty git nvim prettier skhd tmux vim vscode yabai zsh)
else
  echo "Unknown machine detected."
  exit 1
fi

home_programs=(git tmux vim zsh)
for program in "${programs[@]}"; do
  # check if program uses top level home dir (doesnt use ~/.config)
  if [[ " ${home_programs[*]} " =~ " ${program} " ]]; then
    echo "Syncing $program dotfiles"
    if [[ "$program" == 'git' ]]; then
      stow -v 1 "$program" 2> /dev/null || {
        echo "Sync failed. Creating $program backup."
        mv "$HOME/.gitconfig" "$HOME/.gitconfig.old"
        echo "Retrying $program sync."
        stow -v 1 "$program"
      }
    elif [[ "$program" == 'tmux' ]]; then
      stow -v 1 "$program" 2> /dev/null || {
        echo "Sync failed. Creating $program backup."
        mv "$HOME/.tmux.conf" "$HOME/.tmux.conf.old"
        echo "Retrying $program sync."
        stow -v 1 "$program"
      }
    elif [[ "$program" == 'vim' ]]; then
      if [[ -L "$HOME/.vimrc" ]]; then
        echo "Removing symlink at $HOME/.vimrc"
        rm "$HOME/.vimrc"
      fi
      if [[ -f "$HOME/.vimrc" ]]; then
        echo "Backing up .vimrc"
        mv "$HOME/.vimrc" "$HOME/.vimrc.old"
      fi
      if [[ -L "$HOME/.vim" ]]; then
        echo "Removing symlink at $HOME/.vim"
        rm "$HOME/.vim"
      fi
      mkdir -p "$HOME/.vim"

      stow -v 1 "$program" 2> /dev/null || {
        echo "Sync failed. Creating $program backup."
        mv "$HOME/.vim" "$HOME/.vim.old"
        mkdir -p "$HOME/.vim" "$HOME/.vim/plugin" "$HOME/.vim/syntax"
        echo "Retrying $program sync."
        stow -v 1 "$program"
      }
    elif [[ "$program" == 'zsh' ]]; then
      stow -v 1 "$program" 2> /dev/null || {
        echo "Sync failed. Creating $program backup."
        mv "$HOME/.zshrc" "$HOME/.zshrc.old"
        mv "$HOME/.p10k.zsh" "$HOME/.p10k.zsh.old"
        echo "Retrying $program sync."
        stow -v 1 "$program"
      }
    fi
  else
    # remove program dir symlink if it exists
    program_dir="$config_dir/$program"
    if [[ -L $program_dir ]]; then
      echo "Removing symlink at $program_dir"
      rm "$program_dir"
    fi

    mkdir -p "$program_dir"

    # try to symlink files of current program
    # if it fails, move the old program_dir to a backup
    echo "Syncing $program dotfiles"
    stow -v 1 "$program" 2> /dev/null || {
      echo "Sync failed. Creating $program backup."
      mv "$program_dir" "$program_dir.old"
      mkdir -p "$program_dir"
      echo "Retrying $program sync."
      stow -v 1 "$program"
    }
  fi
done
