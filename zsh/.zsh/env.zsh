# check for homebrew in home directory
if [[ -d $HOME/homebrew ]]; then
  export HOMEBREW="$HOME/homebrew"
else
  export HOMEBREW="/usr/local"
fi

export PATH=$HOME/.local/bin:$PATH                # dotfiles scripts
export PATH=$HOME/.cargo/bin:$PATH                # rust binaries
export PATH="$HOMEBREW/bin:$HOMEBREW/sbin:$PATH"  # homebrew binaries

export EDITOR=nvim
export BROWSER=firefox-developer-edition
export QT_QPA_PLATFORMTHEME=qt5ct
export GOPATH=$HOME/.local/share/go/
