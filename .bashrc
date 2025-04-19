# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
# case "$TERM" in
#     xterm-color|*-256color) color_prompt=yes;;
# esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
	if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
		# We have color support; assume it's compliant with Ecma-48
		# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
		# a case would tend to support setf rather than setaf.)
		color_prompt=yes
	else
		color_prompt=
	fi
fi

if [ "$color_prompt" = yes ]; then
	PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
	PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
# case "$TERM" in
# xterm* | rxvt*)
#   PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
#   ;;
# *) ;;
# esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias ls='ls --color=auto'
	#alias dir='dir --color=auto'
	#alias vdir='vdir --color=auto'

	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi

# 自定义选项

# set ignoreeof
set -o ignoreeof
set +o emacs
set -o vi
export IGNOREEOF=1
export prompt_middle_char=@
export TERM="screen-256color"

# add useful path
if [ -d "$HOME/bin" ]; then
	PATH="$PATH:$HOME/bin"
fi
PATH="$PATH:."

# set useful alias
alias cl=clear
alias gitlog='git log --all --graph --decorate'
alias od='od -tx1 -tc -Ax' # -tx1 shows bytes in hex, -tc lists bytes in ASCII, -Ax shows address in hex
alias nv='nohup ~/APPS/neovide.AppImage > /dev/null 2>&1 &'

# set safer delete
alias del='fc -s ls=rm'

# VPN settings
alias clash=clash-linux-amd64-v3
alias proxyon='export http_proxy='http://127.0.0.1:7890';export https_proxy='http://127.0.0.1:7890''
alias proxyoff='unset http_proxy ; unset https_proxy'

# setup starship
eval "$(starship init bash)"

# ccache config (a compiler cache that makes compilation faster)
if [ -d "/usr/lib/ccache" ]; then
	if [[ ":$PATH:" != *":/usr/lib/ccache:"* ]]; then
		export PATH="/usr/lib/ccache:$PATH"
	fi
fi

# yarn config
if [ -d "$HOME/.yarn/bin" ]; then
	if [[ ":$PATH:" != *":$HOME/.yarn/bin:"* ]]; then
		export PATH="$HOME/.yarn/bin:$PATH"
	fi
fi
if [ -d "$HOME/.config/yarn/global/node_modules/.bin" ]; then
	if [[ ":$PATH:" != *":$HOME/.config/yarn/global/node_modules/.bin:"* ]]; then
		export PATH="$HOME/.config/yarn/global/node_modules/.bin:$PATH"
	fi
fi

# package manager: nvm
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
#
# below are the optimized nvm init with lazy-loading
nvm() {
	unset -f nvm
	export NVM_DIR="$HOME/.nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
	[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
	nvm "$@"
}

# rustup and cargo config
if [ -f "$HOME/.cargo/env" ]; then
	. "$HOME/.cargo/env" # source env for rust, which adds ~/.cargo/bin to PATH
fi
export RUSTUP_HOME=/home/zjw/.rustup
export CARGO_HOME=/home/zjw/.cargo

# neovim(nvim)
export PATH="$PATH:/opt/nvim-linux64/bin"
# set LLM API for avante.nvim
# export DEEPSEEK_API_KEY="sk-dc983f8c46eb47139c1233e1f62511d3"

# coc.nvim: add path to extensions
export PATH="$PATH:/home/zjw/.config/coc/extensions/node_modules/"

# FZF config
if [ -d "$HOME/APPS/fzf/bin" ]; then
	if [[ ":$PATH:" != *":$HOME/APPS/fzf/bin:"* ]]; then
		PATH="$PATH:$HOME/APPS/fzf/bin" # add path to fzf
	fi
fi
# Set up fzf key bindings and fuzzy completion
[ -f ~/APPS/.fzf.bash ] && source ~/APPS/.fzf.bash --no-opts
# more configs
export FZF_DEFAULT_OPTS='--bind ctrl-j:down,ctrl-k:up --preview "[[ $(file --mime {}) =~ binary ]] && echo {} is a binary file || (batcat --color=always {} || highlight -O ansi -l {} || cat {}) 2> /dev/null | head -500"'
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
export FZF_COMPLETION_TRIGGER='\'
export FZF_TMUX_HEIGHT='80%'
# fzf --preview "batcat --color=always --style=numbers --line-range=:500 {}"
export FZF_PREVIEW_COMMAND='[[ $(file --mime {}) =~ binary ]] && echo {} is a binary file || (batcat --color=always {} || highlight -O ansi -l {} || cat {}) 2> /dev/null | head -500'

# 7zip config
if [ -d "$HOME/APPS/7zip" ]; then
	if [[ ":$PATH:" != *":$HOME/APPS/7zip:"* ]]; then
		export PATH="$PATH:$HOME/APPS/7zip"
	fi
fi

# poppler config
# NOTE: poppler was installed in /usr/local/ and in /APPS/poppler/release
# but the one in release is not added to any path (as code below are commented)
# its use is to provide guidence for mannual uninstallation of the /local/ one
# since they share the same file structure
#
# if [ -d "$HOME/APPS/poppler/release/bin" ]; then
#   export PATH="$HOME/APPS/poppler/release/bin:$PATH"
# fi
# if [ -d "$HOME/APPS/poppler/release/lib" ]; then
#   export LD_LIBRARY_PATH="$HOME/APPS/poppler/release/lib:$LD_LIBRARY_PATH"
# fi
# if [ -d "$HOME/APPS/poppler/release/include" ]; then
#   export C_INCLUDE_PATH="$HOME/APPS/poppler/release/include/poppler/glib:$C_INCLUDE_PATH"
#   export CPLUS_INCLUDE_PATH="$HOME/APPS/poppler/release/include/poppler/cpp:$CPLUS_INCLUDE_PATH"
# fi
# if [ -d "$HOME/APPS/poppler/release/lib/pkgconfig" ]; then
#   export PKG_CONFIG_PATH="$HOME/APPS/poppler/release/lib/pkgconfig:$PKG_CONFIG_PATH"
# fi

# yazi file manager config
if [ -d "$HOME/APPS/yazi/target/release" ]; then
	if [[ ":$PATH:" != *":/home/zjw/APPS/yazi/target/release:"* ]]; then
		export PATH="$PATH:/home/zjw/APPS/yazi/target/release"
	fi
fi
function y() { # add shell wrapper: ch dir automatically when quit
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# kitty config
if [ -d "$HOME/APPS/kitty/bin" ]; then
	if [[ ":$PATH:" != *":/home/zjw/APPS/kitty/bin"* ]]; then
		export PATH="$PATH:/home/zjw/APPS/kitty/bin"
	fi
fi


# openssl config
# path to the newer version(v3.x) of openssl:
# export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/openssl/lib64/"
# path to version 1.1.1w of openssl, required by python
# export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/openssl_V1.1.1w/lib"

# verilator config
export VERILATOR_ROOT=/home/zjw/APPS/verilator
# export VERILATOR_SOLVER='z3 --in'
# export VERILATOR_AUTHOR_SITE=1 # to enable developer mode
export PATH="$PATH:$VERILATOR_ROOT/bin"
if [ -d "$VERILATOR_ROOT/include" ]; then
	if [[ ":$CPLUS_INCLUDE_PATH:" != *":$VERILATOR_ROOT/include:"* ]]; then
		export CPLUS_INCLUDE_PATH="$VERILATOR_ROOT/include:$CPLUS_INCLUDE_PATH"
	fi
fi

# config for ysyx project
# NEMU config
export NEMU_HOME=/home/zjw/ysyx-workbench/nemu
export AM_HOME=/home/zjw/ysyx-workbench/abstract-machine
if [ -d "$NEMU_HOME/include" ]; then
	if [[ ":$CPATH:" != *":$NEMU_HOME/include:"* ]]; then
		export CPATH="$NEMU_HOME/include:$CPATH"
	fi
fi
if [ -d "$NEMU_HOME/src/monitor/sdb" ]; then
	if [[ ":$CPATH:" != *":$NEMU_HOME/src/monitor/sdb:"* ]]; then
		export CPATH="$NEMU_HOME/src/monitor/sdb:$CPATH"
	fi
fi
if [ -d "$NEMU_HOME/src/isa/riscv32/include" ]; then
	if [[ ":$CPATH:" != *":$NEMU_HOME/src/isa/riscv32/include:"* ]]; then
		export CPATH="$NEMU_HOME/src/isa/riscv32/include:$CPATH"
	fi
fi
# NPC config
export NPC_HOME=/home/zjw/ysyx-workbench/npc
if [ -d "$NPC_HOME/obj_dir" ]; then
	if [[ ":$CPLUS_INCLUDE_PATH:" != *":$NPC_HOME/obj_dir:"* ]]; then
		export CPLUS_INCLUDE_PATH="$NPC_HOME/obj_dir:$CPLUS_INCLUDE_PATH"
	fi
fi
#   NVboard config
export NVBOARD_HOME=/home/zjw/ysyx-workbench/nvboard
if [ -d "$NVBOARD_HOME/usr/include" ]; then
	if [[ ":$CPLUS_INCLUDE_PATH:" != *":$NVBOARD_HOME/usr/include:"* ]]; then
		export CPLUS_INCLUDE_PATH="$NVBOARD_HOME/usr/include:$CPLUS_INCLUDE_PATH"
	fi
fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('/home/zjw/APPS/anaconda3/bin/conda' 'shell.bash' 'hook' 2>/dev/null)"
# if [ $? -eq 0 ]; then
# 	eval "$__conda_setup"
# else
# 	if [ -f "/home/zjw/APPS/anaconda3/etc/profile.d/conda.sh" ]; then
# 		. "/home/zjw/APPS/anaconda3/etc/profile.d/conda.sh"
# 	else
# 		export PATH="/home/zjw/APPS/anaconda3/bin:$PATH"
# 	fi
# fi
# unset __conda_setup
# <<< conda initialize <<<

# below are optimized conda init with lazy-loading
conda() {
	unset -f conda
	__conda_setup="$('/home/zjw/APPS/anaconda3/bin/conda' 'shell.bash' 'hook' 2>/dev/null)"
	if [ $? -eq 0 ]; then
		eval "$__conda_setup"
	else
		export PATH="/home/zjw/APPS/anaconda3/bin:$PATH"
	fi
	conda "$@"
}

# setup coursier: a package manager and laucher for Scala environment
# >>> coursier install directory >>>

# <<< coursier install directory <<<
if [ -d "$HOME/.local/share/coursier/bin" ]; then
	if [[ ":$PATH:" != *":$HOME/.local/share/coursier/bin:"* ]]; then
		export PATH="$PATH:$HOME/.local/share/coursier/bin"
	fi
fi
