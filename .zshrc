# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="robbyrussell"
ZSH_THEME="gentoo"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how many often would you like to wait before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

DISABLE_CORRECTION="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git brew gem history-substring-search vi-mode)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=/Users/anton/.rbenv/shims:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/X11/bin:/usr/local/sbin:/Users/anton/.rvm/bin:/Users/anton/.cask/bin
PATH=$PATH:/usr/local/OmniSharp
#PATH=/usr/local/bin:$PATH
#PATH=$PATH:/usr/local/sbin
#PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

export LC_ALL=en_US.UTF-8  
export LANG=en_US.UTF-8
export LC_CTYPE="en_US.UTF-8"

LEIN_FAST_TRAMPOLINE=y
export LEIN_FAST_TRAMPOLINE

export LEIN_JVM_OPTS=

export ITERM_24BIT=1

bindkey '^r' history-incremental-search-backward

# Local config
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local