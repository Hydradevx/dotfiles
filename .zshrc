# Zsh configuration file

# -----------------------
# Oh My Zsh base
# -----------------------
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="agnoster"   # A clean powerline-like theme
plugins=(git z sudo)

source $ZSH/oh-my-zsh.sh

# -----------------------
# Aliases
# -----------------------
alias cls='clear'
alias ll='ls -la --color=auto'
alias gs='git status'
alias gp='git pull'
alias c='code'

# -----------------------
# Prompt customization
# -----------------------
# Show only "➜ <dir>"
PROMPT='%F{cyan}➜ %F{yellow}%1~%f '

# -----------------------
# Colors
# -----------------------
autoload -U colors && colors
setopt prompt_subst

pywalfox update
eval "$(starship init zsh)"
# -----------------------
# Run neofetch at startup
# -----------------------
neofetch