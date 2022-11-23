#!/usr/bin/env sh
#
# This script bootstraps the installation of my dotfiles.
#
# Installs all necessary dependencies and sets up a working neovim and shell
# environment. If on Linux, it also sets up a working tiling wm, status bar,
# compositor, and other goodies.
#

check() {
  if
    ! command -v "$1" 1>/dev/null 2>&1
  then
    echo "\`${1}\` must be installed."
    exit 1
  fi
}

end() { printf "Finished\n\n"; }

[ "$DOTFILES_DIR" = "" ] && dots_dir="$HOME/.dotfiles" || dots_dir="$DOTFILES_DIR"
[ "$(uname)" = 'Darwin' ] && is_macos=true || is_macos=false
[ "$(uname)" = 'Linux' ] && is_linux=true || is_linux=false

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
  paru -S --noconfirm fd fzf ripgrep starship tmux kitty                                # shell deps
  paru -S --noconfirm dunst kitty picom-jonaburg-fix polybar ranger stylua stow zathura # system deps
elif [ "$is_macos" = 'true' ]; then
  brew install kitty stylua stow
  brew install fd fzf ripgrep starship tmux kitty
fi
# install nvm
export NVM_DIR="$HOME/.nvm" && (
  git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
  cd "$NVM_DIR"
  git checkout "$(git describe --abbrev=0 --tags --match "v[0-9]*" "$(git rev-list --tags --max-count=1)")"
) && \. "$NVM_DIR/nvm.sh"
end

# symlink dotfiles
"$dots_dir"/sync.sh

[ "$is_linux" = 'true' ] && i3-msg restart

# install oh-my-zsh
echo "Installing oh-my-zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
end

# install oh-my-zsh plugins
echo "Installing oh-my-zsh plugins..."
omz_plugins=~/.oh-my-zsh/custom/plugins
git clone https://github.com/DarrinTisdale/zsh-aliases-exa "${omz_plugins}/zsh-aliases-exa"
git clone https://github.com/zsh-users/zsh-autosuggestions "${omz_plugins}/zsh-autosuggestions"
git clone https://github.com/lukechilds/zsh-nvm "${omz_plugins}/zsh-nvm"
git clone https://github.com/zsh-users/zsh-syntax-highlighting "${omz_plugins}/zsh-syntax-highlighting"
git clone https://github.com/mroth/evalcache "${omz_plugins}/evalcache"
end

nvm install node
nvm use node

# install/build custom neovim fork
echo "Installing neovim..."
git clone https://github.com/yesean/neovim.git ~/neovim
cd ~/neovim || exit
if [ "$is_macos" = 'true' ]; then
  xcode-select --install
  brew install ninja libtool automake cmake pkg-config gettext curl
elif [ "$is_linux" = 'true' ]; then
  sudo pacman -S --noconfirm base-devel cmake unzip ninja tree-sitter curl
fi

~/scripts/build-neovim.sh
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
end

# run sync script
cd "$dots_dir" || exit
./update.sh
