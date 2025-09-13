# ZSH
## Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
## Load oh-my-zsh
source $ZSH/oh-my-zsh.sh
## Plugins
plugins=(
  git
  fzf-tab
  zsh-syntax-highlighting
  zsh-autosuggestions
  ohmyzsh-full-autoupdate
  #vi-mode
)
## if not in MC shell add vi-mode
if [ -z "$MC_SID" ]; then
  plugins+=(vi-mode)
fi
## ZSH system clipboard plugin: https://github.com/kutsan/zsh-system-clipboard
source "${ZSH_CUSTOM:-~/.zsh}/plugins/zsh-system-clipboard/zsh-system-clipboard.zsh"
## enable vi mode
bindkey -v
## enable escape on jk in insert mode
bindkey -M viins 'jk' vi-cmd-mode
## https://github.com/mcornella/ohmyzsh/blob/master/plugins/vi-mode/README.md
export VI_MODE_SET_CURSOR=true
## ZSH fix slow paste
zstyle ':bracketed-paste-magic' active-widgets '.self-*'
## ZSH disable matches
setopt +o nomatch
## ZSH do not add to history if things start with space
setopt HIST_IGNORE_SPACE
## ZSH big history
export HISTFILESIZE=1000000000
export HISTSIZE=1000000000
export SAVEHIST=1000000000
## ZSH don't show "%" on partial lines
PROMPT_EOL_MARK=''
## ZSH disable matches, so that * does not expand to files in the folder
setopt +o nomatch

# Startship there
## theme https://starship.rs/guide/#%F0%9F%9A%80-installation
if [ -f $(which starship) ]; then
  eval "$(starship init zsh)"
fi

# FZF
## fzf https://github.com/junegunn/fzf#using-git
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

## fancy preview for fzf
export FZF_CTRL_R_OPTS="--preview 'echo {2..}'
  --preview-window wrap:top:20%
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-t:track+clear-query'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --height 60%
  --header 'Press CTRL-Y to copy ucommand into clipboard'"
## -- Use fd instead of fzf --
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
##  Use fd (https://github.com/sharkdp/fd) for listing path candidates.
##  - The first argument to the function ($1) is the base path to start traversal
##  - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}
##  Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

# Zoxide
## check is zoxide is install and source it
[ -f $(which zoxide) ] && eval "$(zoxide init zsh)" && alias cd='z'

# Brew
eval "$(/opt/homebrew/bin/brew shellenv)" # arm one
## eval "$(/usr/local/bin/brew shellenv)" # x86 one
## Intel Brew for components and are not supported on arm
alias brew64="arch -x86_64 /usr/local/homebrew/bin/brew"
## Add Homebrew to PATH, put arm first
export PATH=/usr/local/Homebrew/bin:$PATH # x86 path
export PATH=/opt/homebrew/bin:$PATH       # arm brew (takes precedence)

# DENO
export DENO_INSTALL="/Users/sjc-lp03734/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# thefuck
if [ -f $(which thefuck) ]; then
  # thefuck is installed
  eval $(thefuck --alias)
  eval $(thefuck --alias fk)
fi

# PATHS
# My BIN
export PATH=$PATH:$HOME/bin
# /Users/sjc-lp03734/.local/bin path
export PATH=$PATH:$HOME/.local/bin
# mysql
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh" # This loads nvm
# Krew
export PATH="${PATH}:${HOME}/.krew/bin"
# Postgresql path
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"

# ALIASES
## CDR cd to the root of the git repo
alias cdr='cd $(git rev-parse --show-toplevel)'
## Kubectl
alias k="kubectl"
alias ks="kubectl -n kube-system "
alias ka="kubectl --all-namespaces=true "
## kubectl context selector
alias kx='kubectl config use-context $(kubectl config get-contexts -o name | fzf)'
## K9S with context selector
alias k9='k9s --context $(kubectl config get-contexts -o name | fzf)'
## Terraform
TF_BIN="tofu"
alias tf="${TF_BIN}"
alias tfa="${TF_BIN} apply"
alias tfp="${TF_BIN} plan"
alias tfi="${TF_BIN} init"
function tff() {
  tf fmt -recursive "$(git rev-parse --show-toplevel)/terraform"
}
alias tfo='${TF_BIN} output -json | jq "reduce to_entries[] as \$entry ({}; .[\$entry.key] = \$entry.value.value)"'
## Neovim
alias n="nvim ."
## EZA
if [ -f $(which eza) ]; then
  # eza is installed
  alias ls="eza --icons=auto"
fi
## LS
alias la='ls -lah'
alias ll='ls -lah'
## AWS
### AWS profile selector
alias aws-profile='export AWS_PROFILE=$(aws configure list-profiles | fzf)'
alias ap='aws-profile'
## displayplacer alias to restore my monitor setup
alias display-restore='displayplacer "id:2997316B-A423-47EA-8390-865F1276C0E2 res:3096x1296 hz:100 color_depth:8 enabled:true scaling:on origin:(0,0) degree:0" "id:37D8832A-2D66-02CA-B9F7-8F30A301B230 res:1728x1117 hz:120 color_depth:8 enabled:true scaling:on origin:(-1728,0) degree:0" "id:33A9F171-8D5E-4A0A-8472-A882E0CEC299 res:1440x2560 hz:60 color_depth:8 enabled:true scaling:on origin:(3096,-466) degree:270"'

# MODULES
## check if .zshrc-local exists and source it
if [ -f ~/.zshrc-local ]; then
  source ~/.zshrc-local
fi
## Functions
if [ -f ~/.zshrc-func ]; then
  source ~/.zshrc-func
fi

# 3RD PARTY TOOLS AND CONFIGS
## MC editor
export EDITOR=nvim
## disable AWS pager
export AWS_PAGER=""
## Idea fix to use COMMAND ARROWS
bindkey "\e\eOD" beginning-of-line
bindkey "\e\eOC" end-of-line

# SHELL-GPT
## Shell-GPT integration ZSH v0.2
_sgpt_zsh() {
  if [[ -n "$BUFFER" ]]; then
    _sgpt_prev_cmd=$BUFFER
    BUFFER+="⌛"
    zle -I && zle redisplay
    BUFFER=$(sgpt --shell --no-interaction <<<"$_sgpt_prev_cmd")
    zle end-of-line
  fi
}
zle -N _sgpt_zsh
bindkey ^p _sgpt_zsh

# Atuin integration - check if atuin is installed
## https://atuin.sh/#cli-section
if [ -f $(which atuin) ]; then
  eval "$(atuin init zsh --disable-up-arrow)"
fi

# CARAPACE
if [ -f $(which carapace) ]; then
  ## https://carapace-sh.github.io/carapace-bin/setup.html#zsh
  export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
  zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
  source <(carapace _carapace)
  zstyle ':completion:*:git:*' group-order 'main commands' 'alias commands' 'external commands'
fi
