#!/usr/bin/env sh
#
# Bootstrap a fresh Arch Linux install
#

[ "$DOTFILES_DIR" = "" ] && dots_dir="$HOME/.dotfiles" || dots_dir="$DOTFILES_DIR"
scripts_dir="$dots_dir"/scripts/scripts
. "$scripts_dir"/shared.sh

# install paru
if
  ! command -v paru 1>/dev/null 2>&1
then
  cd ~ || exit
  sudo pacman -S --needed base-devel
  git clone https://aur.archlinux.org/paru.git
  cd paru || exit
  makepkg -si
fi

set --                                `# --- display ---` \
xorg                                  `# display server` \
i3-gaps                               `# wm` \
picom-jonaburg-fix                    `# compositor` \
                                      `# --- login screen ---` \
lightdm                               `# display manager` \
web-greeter                           `# lightdm greeter` \
                                      `# --- shell ---` \
kitty                                 `# terminal` \
zsh                                   `# shell` \
starship                              `# shell prompt` \
tmux                                  `# multiplexer` \
git                                   `# vcs` \
exa                                   `# better ls` \
fd                                    `# better find` \
ripgrep                               `# better grep` \
git-delta                             `# better diff` \
fzf                                   `# fuzzy finder` \
lazygit                               `# git tui` \
htop                                  `# system monitor` \
direnv                                `# env helper` \
xclip                                 `# clipboard manager` \
zscroll-git                           `# text scroller` \
                                      `# --- audio ---` \
pipewire                              `# server` \
pipewire-pulse                        `# pulseaudio integration` \
wireplumber                           `# session manager` \
pavucontrol                           `# volume control` \
playerctl                             `# cli volume control` \
volnoti                               `# volume notifications` \
                                      `# --- fonts ---` \
apple-fonts                           `# general` \
inter-font                            `# general` \
ttf-jetbrains-mono                    `# terminal` \
ttf-nerd-fonts-symbols-2048-em-mono   `# symbols` \
ttf-material-design-icons-git         `# symbols` \
ttf-apple-emoji                       `# emojis` \
                                      `# --- desktop theme ---` \
catppuccin-gtk-theme-latte            `# theme` \
flatery-icon-theme-git                `# icons` \
apple_cursor                          `# cursors` \
                                      `# --- apps ---` \
brave-bin                             `# browser` \
vim                                   `# text editor` \
dunst                                 `# notifications` \
insync                                `# google drive` \
polybar                               `# menu bar` \
flameshot                             `# screenshot` \
i3lock-color                          `# screenlocker` \
rofi                                  `# general purpose picker` \
stow                                  `# dotfile manager` \
nemo                                  `# file browser` \
nemo-preview                          `# file browser previewer` \
ranger                                `# terminal file browser` \
zathura                               `# pdf viewer` \
zathura-pdf-poppler                   `# zathura pdf plugin`
feh                                   `# image viewer` \
i3-resurrect                          `# layout restoration` \
xidlehook                             `# command timer` \
                                      `# --- languages ---` \
nodejs                                `# js` \
npm                                   `# js pkg mgr` \
go                                    `# golang` \
lua                                   `# lua` \
luarocks                              `# lua pkg mgr` \
pyenv                                 `# python version manager` \

add "$@"

# git clone https://github.com/yesean/lightdm ~/lightdm
# cd ~/lightdm
# npm install && sh install.sh

sh "$scripts_dir"/install.sh
