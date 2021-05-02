export LOCAL_SSH_AUTH_SOCK=$SSH_AUTH_SOCK
export APPLE_ID=$(/usr/libexec/PlistBuddy -c "print :Accounts:0:AccountID" ~/Library/Preferences/MobileMeAccounts.plist)
export APPLE_FIRST_NAME=$(/usr/libexec/PlistBuddy -c "print :Accounts:0:firstName" ~/Library/Preferences/MobileMeAccounts.plist)
export APPLE_LAST_NAME=$(/usr/libexec/PlistBuddy -c "print :Accounts:0:lastName" ~/Library/Preferences/MobileMeAccounts.plist)

# Docker-machine activation and env setup
if [[ $(docker-machine status default) != Running ]]; then
	docker-machine start default
fi
eval $(docker-machine env default)


# GPG Configuration Support
export GPG_TTY=$(tty)

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
# export ZSH="/Users/jn/.oh-my-zsh"
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="fox"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
	git
	docker
	docker-compose
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Directories
alias cdc="cd ~/code"

# Docker Machine
alias dm="docker-machine"
alias dmenv='eval $(docker-machine env); echo DOCKER_TLS_VERIFY = $DOCKER_TLS_VERIFY; echo DOCKER_HOST = $DOCKER_HOST; echo DOCKER_CERT_PATH = $DOCKER_CERT_PATH; echo DOCKER_MACHINE_NAME = $DOCKER_MACHINE_NAME'
alias dmls="docker-machine ls"
alias dmup="docker-machine start"
alias dmdn="docker-machine stop"

# Trezor
export TREZORCTL='~/code/trezor-firmware/.venv/bin/trezorctl'
alias tz=$TREZORCTL
alias tzclear="$TREZORCTL clear-session"
alias tzs="$TREZORCTL set"
alias tzd="$TREZORCTL device"
alias tzsd="$TREZORCTL device sd-protect"
alias tzgf="$TREZORCTL get-features"

# Trezor Agent (SSH/GPG Tools)
alias tza='trezor-agent'
tssh () {
	echo "\nTrezor SSH socket setup initiated"
    echo "Enter SSH identity (<user>@<domain>): "
    read id
    if [ -z "$id" ]; then
    	echo "No identity provided"
    	echo "\nUsing APPLE_ID of current user as SSH identity ($APPLE_ID)"
		id="$APPLE_ID"
	fi
	echo "\nRemember to unlock your trezor and watch for on-screen prompts"
    eval "eval $(trezor-agent -d $id)"
}

config_tgpg () {
	if [ ! -d "~/.gnupg/trezor" ]; then
		rm -r ~/.gnupg/trezor
	fi
	echo "\nTrezor GPG setup initiated"
    echo "Enter GPG identity (First Last <email>): "
    read id
    if [ -z "$id" ]; then
		id="$APPLE_FIRST_NAME $APPLE_LAST_NAME <$APPLE_ID>"
    	echo "No identity provided"
    	echo "\nUsing APPLE_ID of current user as GPG identity:"
    	echo $id
	fi
	echo "\nRemember to unlock your trezor and watch for on-screen prompts\n"
    eval "eval $(trezor-gpg init $id)"
    export GNUPGHOME=~/.gnupg/trezor
}

alias tgpg="export GNUPGHOME=~/.gnupg/trezor; gpg"
