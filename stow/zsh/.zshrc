# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

plugins=(
	git
	fzf-tab
	zsh-syntax-highlighting
	zsh-autosuggestions
	ohmyzsh-full-autoupdate
	#vi-mode
)
# if not in MC shell add vi-mode
if [ -z "$MC_SID" ]; then
	plugins+=(vi-mode)
fi

source $ZSH/oh-my-zsh.sh

# enable vi mode
bindkey -v
# enable escape on jk in insert mode
bindkey -M viins 'jk' vi-cmd-mode
# https://github.com/mcornella/ohmyzsh/blob/master/plugins/vi-mode/README.md
VI_MODE_SET_CURSOR=true

# ZSH fix slow paste
zstyle ':bracketed-paste-magic' active-widgets '.self-*'

# ZSH disable matches
setopt +o nomatch

# ZSH big history
export HISTFILESIZE=1000000000
export HISTSIZE=1000000000
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# ZSH do not add to history if things start with space
setopt HIST_IGNORE_SPACE

# ZSH disable AUTOCD
# unsetopt AUTO_CD

# ZSH don't show "%" on partial lines
PROMPT_EOL_MARK=''

# ZSH disable matches
setopt +o nomatch

# fix slow paste (not sure if needed)
# zstyle ':bracketed-paste-magic' active-widgets '.self-*'

# theme https://starship.rs/guide/#%F0%9F%9A%80-installation
eval "$(starship init zsh)"

# fzf https://github.com/junegunn/fzf#using-git
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# fancy preview for fzf
export FZF_CTRL_R_OPTS="--preview 'echo {2..}'
  --preview-window wrap:top:20%
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-t:track+clear-query'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --height 60%
  --header 'Press CTRL-Y to copy ucommand into clipboard'"

# helper function to split folders in tmux panes
function split-folders() {
  local counter=0
  # Use fzf to select multiple folders
  local folders
  folders=$(ls -d */ | fzf --multi --preview 'ls -la {}')

  echo "Selected folders: $folders"

  if [[ -z "$folders" ]]; then
    echo "No folders selected. Exiting."
    return 1
  fi

  # Iterate over selected folders (handle newline-separated values)
  while IFS= read -r folder; do
    if ((counter % 4 == 0)); then
      tmux split-window -v "cd $folder && exec $SHELL"
    else
      tmux split-window -h "cd $folder && exec $SHELL"
    fi
    tmux select-layout tiled
    counter=$((counter + 1))
  done <<< "$folders"
}

# check is zoxide is install and source it
[ -f $(which zoxide) ] && eval "$(zoxide init zsh)" && alias cd='z'

# this will search dev folders with some ingnores
fcd() {
	local folder="$1" # Get the folder name from the first argument
	local selected_dir
	# is second argument is provided, set no_ignore variable to --no-ignore
	[[ -n "$2" ]] && local no_ignore="--no-ignore" || local no_ignore=""
	selected_dir=$(fd --type d $no_ignore --maxdepth 15 \
  -E '.vscode*' \
  -E '.idea*' \
  -E 'Library/*' \
  -E '_arch/*' \
  -E '.local/*' \
  -E 'node_modules/*' \
  -E 'bower_components/*' \
  -E 'public/*' \
  -E 'dist/*' \
  -E 'build/*' \
  -E 'target/*' \
  --hidden --strip-cwd-prefix --exclude .git \
  --base-directory $folder |	fzf +m --height 40%)
	cd "$folder/$selected_dir" || return

}
# Bind Ctrl+g to the fcd function with a folder of /dev/infrastructure
bindkey -s '^g' 'fcd $HOME no-ignore\n'

# Bind Ctrl+f to the fcd function with a folder of "dev"
bindkey -s '^f' 'fcd $HOME/dev\n'

# -- Use fd instead of fzf --

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}


# Brew
eval "$(/opt/homebrew/bin/brew shellenv)" # arm one
#eval "$(/usr/local/bin/brew shellenv)" # x86 one
# Intel Brew for components and are not supported on arm
alias brew64="arch -x86_64 /usr/local/homebrew/bin/brew"

export PATH=/usr/local/Homebrew/bin:$PATH # x86 path
export PATH=/opt/homebrew/bin:$PATH       # arm brew (takes precedence)

# DENO
export DENO_INSTALL="/Users/sjc-lp03734/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# thefuck
eval $(thefuck --alias)
eval $(thefuck --alias fk)

# clear tmux history and screen
c() {
   clear
   tmux clear-history
}


# # Idea
# alias idea='open -na "Idea.app" --args "$@"'

# GO
# export PATH=$PATH:$(go env GOPATH)/bin

# My BIN
export PATH=$PATH:$HOME/bin

# /Users/sjc-lp03734/.local/bin path
export PATH=$PATH:$HOME/.local/bin

# mysql
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"                                       # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion

# MC editor
export EDITOR=nvim

# disable AWS pager
export AWS_PAGER=""

# Aliases
alias k="kubectl"
alias ks="kubectl -n kube-system "
alias ka="kubectl --all-namespaces=true "
# Load kubectl completions
source <(kubectl completion zsh)
# Define alias
alias k=kubectl
# Enable completion for the alias
compdef k=kubectl
compdef ks=kubectl
compdef ka=kubectl

# Krew
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"


TF_BIN="tofu"

alias tf="${TF_BIN}"
alias tfa="${TF_BIN} apply"
alias tfp="${TF_BIN} plan"
alias tfi="${TF_BIN} init"
alias tff="tf fmt -recursive \"$(git rev-parse --show-toplevel)/terraform\""
alias tfo='${TF_BIN} output -json | jq "reduce to_entries[] as \$entry ({}; .[\$entry.key] = \$entry.value.value)"'
alias n="nvim ."


# check if eza is installed start code block
if [ -f $(which eza) ]; then
	# eza is installed
	alias ls="eza --icons=auto"
fi

alias la='ls -lah'
alias ll='ls -lah'

# open all below directories in tmux panes
alias splitdirs='for dir in */; do tmux split-window -v "cd '\''$dir'\'' && exec $SHELL"; tmux select-layout tiled; done'

# aws profile selector
alias aws-profile='export AWS_PROFILE=$(aws configure list-profiles | fzf)'
# kubectl context selector
alias kubectx='kubectl config use-context $(kubectl config get-contexts -o name | fzf)'


# display
alias display-restore='displayplacer "id:2997316B-A423-47EA-8390-865F1276C0E2 res:3096x1296 hz:100 color_depth:8 enabled:true scaling:on origin:(0,0) degree:0" "id:37D8832A-2D66-02CA-B9F7-8F30A301B230 res:1728x1117 hz:120 color_depth:8 enabled:true scaling:on origin:(-1728,0) degree:0" "id:33A9F171-8D5E-4A0A-8472-A882E0CEC299 res:1440x2560 hz:60 color_depth:8 enabled:true scaling:on origin:(3096,-466) degree:270"'

# krew
export PATH="${PATH}:${HOME}/.krew/bin"

# helm autocomplete
source <(helm completion zsh)

# aws autocomplete
# only if installed
[ -f $(which aws_completer) ] && complete -C $(which aws_completer) aws

# Idea fix to use COMMAND ARROWS
bindkey "\e\eOD" beginning-of-line
bindkey "\e\eOC" end-of-line

# ZSH system clipboard plugin
source "${ZSH_CUSTOM:-~/.zsh}/plugins/zsh-system-clipboard/zsh-system-clipboard.zsh"

# TERM for Tmux
# export TERM=screen-256color

# check if $TERM_PROGRAM == iTerm.app variable set to identify terminal
if [ "$TERM_PROGRAM" = "iTerm.app" ] ||  [ "$TERM_PROGRAM" = "WezTerm" ] ; then
	# tmux process detection, only go here is we are not in tmux
	if [ "$TMUX" = "" ]; then
		if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
			echo "We are in nvim terminal"
		else
			tmux attach-session -t 0
			# if above fails, create new session with non 0 exit code
			if [ $? -ne 0 ]; then
				# session setup in background
				tmux new-session -s 0 -d
				# windows setup
				#tmux kill-window -t 0
				tmux new-window -d -t 2 -n "sec" -c "$HOME"
				tmux new-window -d -t 3 -n "third" -c "$HOME"
				tmux new-window -d -t 4 -n "dev" -c "$HOME/dev"
				tmux new-window -d -t 5 -n "infra" -c "$HOME/dev/"
				tmux new-window -d -t 6 -n "temp" -c "$HOME/temp"
				tmux new-window -d -t 7 -n "Downloads" -c "$HOME/Downloads"
				tmux new-window -d -t 9 -n "last" -c "$HOME"
				# attach to new session
				tmux attach-session -t 0
			fi

		fi
	fi
fi

# TF autocomplet/e
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C "${TF_BIN}" "${TF_BIN}"

# Check if stern is installed if so enable completion
[ -f $(which stern) ] && source <(stern --completion=zsh)

# Yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# check if .zshrc-local exists and source it
if [ -f ~/.zshrc-local ]; then
	source ~/.zshrc-local
fi

complete -o nospace -C /usr/local/bin/tofu tofu
