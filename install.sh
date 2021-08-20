#!/bin/bash

if ! command -v stow &>/dev/null; then
  echo "GNU Stow must be installed in order to run the install script"
  exit 1
fi

# check if vscode is installed
while :; do
  case $1 in
  --vscode)
    vscode="SET"
    ;;
  *) break ;;
  esac
  shift
done

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
  programs=(alacritty efm-langserver git i3 nvim picom polybar prettier ranger rofi tmux vim Code zathura zsh)
elif [[ "$is_macos" == "true" ]]; then
  echo 'macOS machine detected!'
  echo 'Installing for macos:'
  programs=(alacritty efm-langserver git nvim prettier skhd tmux vim vscode yabai zsh)
else
  echo "Unknown machine detected."
  exit 1
fi

backup_file() {
  file=$1
  mv "$file" "${file}.old"
}

backup_retry_msg() {
  echo "Sync failed. Creating $1 backup."
  echo "Retrying $1 sync."
}

home_programs=(git tmux vim zsh)
for program in "${programs[@]}"; do
  # check if program uses top level home dir (doesnt use ~/.config)
  if [[ " ${home_programs[*]} " =~ " ${program} " ]]; then
    echo "Syncing $program dotfiles"
    if [[ "$program" == 'git' ]]; then
      stow -v 1 "$program" 2>/dev/null || {
        backup_file "$HOME/.gitconfig"
        backup_retry_msg "$program"
        stow -v 1 "$program"
      }
    elif [[ "$program" == 'tmux' ]]; then
      stow -v 1 "$program" 2>/dev/null || {
        backup_file "$HOME/.tmux.conf"
        backup_retry_msg "$program"
        stow -v 1 "$program"
      }
    elif [[ "$program" == 'vim' ]]; then
      # remove symlinks
      if [[ -L "$HOME/.vimrc" ]]; then
        echo "Removing symlink at $HOME/.vimrc"
        rm "$HOME/.vimrc"
      fi
      if [[ -L "$HOME/.vim" ]]; then
        echo "Removing symlink at $HOME/.vim"
        rm "$HOME/.vim"
      fi

      if [[ -f "$HOME/.vimrc" ]]; then
        echo "Backing up .vimrc"
        backup_file "$HOME/.vimrc"
      fi

      stow -v 1 "$program" 2>/dev/null || {
        backup_file "$HOME/.vim"
        backup_retry_msg "$program"
        stow -v 1 "$program"
      }

    elif [[ "$program" == 'zsh' ]]; then
      stow -v 1 "$program" 2>/dev/null || {
        backup_retry_msg "$program"
        backup_file "$HOME/.zshrc"
        backup_file "$HOME/.p10k.zsh"
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

    if [[ $program == "Code" ]]; then
      program="vscode"
    fi

    # try to symlink files of current program
    # if it fails, move the old program_dir to a backup
    echo "Syncing $program dotfiles"
    stow -v 1 "$program" 2>/dev/null || {
      backup_retry_msg "$program"
      backup_file "$program_dir"
      mkdir -p "$program_dir"
      stow -v 1 "$program"
    }
  fi
done

# clean and update packer
echo "Starting to sync packer.nvim..."
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
echo "Finished syncing packer."

if [[ $(command -v code) ]] &>/dev/null && [[ $vscode == "SET" ]]; then
  echo "Updating vscode extensions."
  ~/.dotfiles/vscode/.config/Code/scripts/install-extensions.sh 1>/dev/null
fi
