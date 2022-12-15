#!/usr/bin/env sh
#
# This script bootstraps the installation of my dotfiles.
#
# Installs all necessary dependencies and sets up a working neovim and shell
# environment. If on Linux, it also sets up a working tiling wm, status bar,
# compositor, and other goodies.
#

[ "$DOTFILES_DIR" = "" ] && dots_dir="$HOME/.dotfiles" || dots_dir="$DOTFILES_DIR"
scripts_dir="$dots_dir"/scripts/scripts
. "$scripts_dir"/shared.sh

# intro
printf 'This script occasionally requires user input, do you understand? [y/n] '
read -r answer
if [ "$answer" != 'y' ]; then
  exit 0
fi

# check if system package manager is present
echo "Checking package manager..."
if [ "$is_macos" = 'true' ]; then
  check brew
elif [ "$is_linux" = 'true' ]; then
  check paru
else
  echo "This script only works on Arch Linux or MacOS."
  exit 1
fi
end

# install dependencies
echo "Installing dependencies..."
if [ "$is_linux" = 'true' ]; then
  add direnv fd fzf git-delta kitty ripgrep starship tmux zscroll-git                                  # shell deps
  add dunst htop i3-gaps kitty picom-jonaburg-fix polybar ranger stow xclip xidlehook zathura          # system deps
  add base-devel cmake unzip ninja tree-sitter curl                                                    # neovim deps
  add apple-fonts ttf-jetbrains-mono ttf-nerd-fonts-symbols-2048-em-mono ttf-material-design-icons-git # fonts
  add nodejs npm go lua luarocks pyenv                                                                 # languages
elif [ "$is_macos" = 'true' ]; then
  add direnv fd fzf git-delta kitty starship stow ripgrep tmux
  add kitty stow xclip
  add ninja libtool automake cmake pkg-config gettext curl
  add go lua luarocks pyenv
  xcode-select --install
fi

# install node
NVM_DIR="$HOME/.nvm"
ghcl nvm-sh/nvm "$NVM_DIR"
cd "$NVM_DIR" || exit
git checkout "$(git describe --abbrev=0 --tags --match "v[0-9]*" "$(git rev-list --tags --max-count=1)")"
sh "$NVM_DIR/nvm.sh"

# symlink dotfiles
"$scripts_dir"/sync.sh
[ "$is_linux" = 'true' ] && i3-msg restart

# install oh-my-zsh
echo "Installing oh-my-zsh..."
if [ -d ~/.oh-my-zsh/ ]; then
  echo "oh-my-zsh already installed"
else
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
fi
end

# install oh-my-zsh plugins
echo "Installing oh-my-zsh plugins..."
omz_plugins=~/.oh-my-zsh/custom/plugins
ghcl DarrinTisdale/zsh-aliases-exa "${omz_plugins}/zsh-aliases-exa"
ghcl zsh-users/zsh-autosuggestions "${omz_plugins}/zsh-autosuggestions"
ghcl lukechilds/zsh-nvm "${omz_plugins}/zsh-nvm"
ghcl zsh-users/zsh-syntax-highlighting "${omz_plugins}/zsh-syntax-highlighting"
ghcl mroth/evalcache "${omz_plugins}/evalcache"
end

# install/build custom neovim fork
echo "Installing neovim..."
ghcl yesean/neovim ~/neovim
cd ~/neovim || exit
"$scripts_dir"/build-neovim.sh
ghcl wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim --depth 1
end

# update dots
cd "$dots_dir" || exit
"$scripts_dir"/update.sh
