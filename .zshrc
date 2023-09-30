# ~/.zshrc file for zsh interactive shells.
# see /usr/share/doc/zsh/examples/zshrc for examples
 
setopt autocd              # change directory just by typing its name
setopt correct            # auto correct mistakes
setopt interactivecomments # allow comments in interactive mode
setopt magicequalsubst     # enable filename expansion for arguments of the form ‘anything=expression’
setopt nonomatch           # hide error message if there is no match for the pattern
setopt notify              # report the status of background jobs immediately
setopt numericglobsort     # sort filenames numerically when it makes sense
setopt promptsubst         # enable command substitution in prompt

WORDCHARS=${WORDCHARS//\/} # Don't consider certain characters part of the word

# hide EOL sign ('%')
PROMPT_EOL_MARK=""

# configure key keybindings
#bindkey -e                                        # emacs key bindings
#bindkey ' ' magic-space                           # do history expansion on space
bindkey '^U' backward-kill-line                   # ctrl + U
bindkey '^[[3;5~' kill-word                       # ctrl + Supr
bindkey '^[[3~' delete-char                       # delete
bindkey '^[[1;5C' forward-word                    # ctrl + ->
bindkey '^[[1;5D' backward-word                   # ctrl + <-
bindkey '^[[5~' beginning-of-buffer-or-history    # page up
bindkey '^[[6~' end-of-buffer-or-history          # page down
bindkey '^[[H' beginning-of-line                  # home
bindkey '^[[F' end-of-line                        # end
bindkey '^[[Z' undo                               # shift + tab undo last action

# enable completion features
autoload -Uz compinit
compinit -d ~/.cache/zcompdump
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# History configurations
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=2000
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
#setopt share_history         # share command history data

# force zsh to show the complete history
alias history="history 0"

# Alias
# alias grub-update="sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias ll='lsd -lh --group-dirs=first'
alias la='lsd -a --group-dirs=first'
alias l='lsd --group-dirs=first'
alias lla='lsd -lha --group-dirs=first'
alias ls='lsd --group-dirs=first'
alias cat='bat'

alias zr='source ~/.zshrc'

alias vm-on='systemctl start libvirtd.service'
alias xg='startx ~/.config/X11/bspwm'
alias v='nvim'

# Plugins
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/sudo/sudo.plugin.zsh

PROMPT='%(?.%B%F{green}✓.%F{red}✕)%f%b %B%F{cyan}%~%n%F{green}%B%b%f '

function preexec() {
  timer=$(($(date +%s%0N)/1000000))
}

function precmd() {
  if [ $timer ]; then
    now=$(($(date +%s%0N)/1000000))
    elapsed=$(($now-$timer))

    # Calcular minutos, segundos y milisegundos
    minutes=$((elapsed / 60000))
    seconds=$(( (elapsed % 60000) / 1000 ))
    milliseconds=$((elapsed % 1000))

    # Obtener el nombre de la rama actual de Git (si estás en un repositorio)
    git_branch=""
    if [ -d .git ] || git rev-parse --is-inside-work-tree &>/dev/null; then
      git_branch=$(git symbolic-ref --short HEAD 2>/dev/null)
    fi

    export RPROMPT="%F{cyan}󱑆 ${minutes}:${seconds}s %F{red}󰊢 ${git_branch}% %{$reset_color%}"

    unset timer
  fi
}

# Promt
#PROMPT='%B%F{cyan}%~ %(?.%B%F{green}✓.%F{red}✕)%f%b 
#%B%F{green}%f%b ' 

PROMPT='%(?.%B%F{green}✓.%F{red}✕)%f%b %B%F{cyan}%~
%F{green}%B%b%f '

#PROMPT='%B%F{cyan}%~ %B%F{5}%f%b
#%(?.%B%F{green} .%F{red} )%f%b'

#%F{green}%B%b%f '
# %F{green}%B$(echo -e "\e[5m\e[0m")%b%f'

#precmd() {}

del-prompt-accept-line() {
    OLD_PROMPT="$PROMPT"
    PROMPT="%B%F{4}%f%b "
    zle reset-prompt
    PROMPT="$OLD_PROMPT"
    zle accept-line
}

zle -N del-prompt-accept-line
bindkey "^M" del-prompt-accept-line

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Utilidades
mkt () {
	mkdir {nmap,content,exploits}
}

extractPorts () {
	ports="$(cat $1 | grep -oP '\d{1,5}/open' | awk '{print $1}' FS='/' | xargs | tr ' ' ',')"
	service="$(cat $1 | grep -oP '\d{1,5}/open' | awk '{print $4}' FS='/' | xargs | tr ' ' ',')"
	ip_address="$(cat $1 | grep -oP '^Host: .* \(\)' | head -n 1 | awk '{print $2}')"
	echo -e "\n[*] Extracting information...\n" > extractPorts.tmp
	echo -e "\t[*] IP Address: $ip_address" >> extractPorts.tmp
	echo -e "\t[*] Open Ports: $ports" >> extractPorts.tmp
	echo -e "\t[*] Service: $service\n" >> extractPorts.tmp
	echo $ports | tr -d '\n' | xclip -sel clip
	echo -e "[*] Ports copied to clipboard\n" >> extractPorts.tmp
	batcat extractPorts.tmp
	rm extractPorts.tmp
}
