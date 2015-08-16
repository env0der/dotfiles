# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="lambda2"

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
plugins=(git brew git history-substring-search jira osx redis-cli web-search wd)

source $ZSH/oh-my-zsh.sh

export LC_ALL=en_US.UTF-8  
export LANG=en_US.UTF-8
export LC_CTYPE="en_US.UTF-8"

LEIN_FAST_TRAMPOLINE=y
export LEIN_FAST_TRAMPOLINE

export LEIN_JVM_OPTS=

bindkey '^r' history-incremental-search-backward

e () {
    if [[ $1 == *":"* ]]; then
        file=$(awk '{sub(/:[0-9]*$/,"")}1' <<< "$1")
        line=$(awk '{sub(/^.*:/,"")}1' <<< "$1")
        emacsclient --no-wait +$line $file 
    else
        emacsclient --no-wait $1
    fi
}

# Local config
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
