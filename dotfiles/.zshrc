# ------------------------------------------------------------------- #
# Optional dev overwrite
# ------------------------------------------------------------------- #

if ! [[ -z $ZSHRC_OVERWRITE ]] && [[ -f $ZSHRC_OVERWRITE ]]
then
    source $ZSHRC_OVERWRITE
    exit 0
fi

# ------------------------------------------------------------------- #
# oh-my-zsh config
# ------------------------------------------------------------------- #

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

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
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.

# ZSH_PLUGINS=git,git-flow,... can be set if you want plugins
plugins_env_str="${ZSH_PLUGINS:-F-Sy-H,git,zsh-autocomplete,zsh-autosuggestions}"
plugins=(${(@s:,:)plugins_env_str})

source ${ZSH}/oh-my-zsh.sh

# ------------------------------------------------------------------- #
# aliases
# ------------------------------------------------------------------- #

alias ls=lsd
alias sl="ls | rev"
alias lsl='ls -haltr'  # -halter  the `-e` is part of the `-l`

# Selectively enable features for non-Warp terminals.
if [[ $TERM_PROGRAM != "WarpTerminal" ]]; then
  # Aliasing batcat to cat will cause the autocomplete to slow down randomly.
  alias cat=batcat

  # Forcing interactive mode with system commands like cp, mv, rm will cause the
  # shell prompt to hang randomly. Even in non-Warp terminals forcing this
  # option causes hard to debug issues with shell scripts running under this zsh
  # session. Only uncomment this if you are absolutely sure this won't cause
  # issues.
  #if [[ -o interactive ]]; then
  #  alias cp='cp -i'
  #  alias mv='mv -i'
  #  alias rm='rm -i'
  #fi
fi

# git
alias grr='git reset HEAD~1'
alias gus='git reset HEAD'

# To customize prompt, run  or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ------------------------------------------------------------------- #
# Optional dev additions
# ------------------------------------------------------------------- #

if ! [[ -z $ZSHRC_EXTRA ]] && [[ -f $ZSHRC_EXTRA ]]
then
    source $ZSHRC_EXTRA
fi
