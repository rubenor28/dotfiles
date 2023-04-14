# Lines configured by zsh-newuser-install
# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/rubenor/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Alias
# alias grub-update="sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias purga="sudo pacman -Rns $(pacman -Qtdq) ; sudo fstrim -av"
alias mantenimiento="yay -Scc"
alias update="yay -Syu"

alias vm-on="sudo systemctl start libvirtd.service"
alias vm-off="sudo systemctl stop libvirtd.service"

alias ll='lsd -lh --group-dirs=first'
alias la='lsd -a --group-dirs=first'
alias l='lsd --group-dirs=first'
alias lla='lsd -lha --group-dirs=first'
alias ls='lsd --group-dirs=first'
alias cat='bat'
alias catc='bat -l ruby'

alias target='/home/rubenor/.config/polybar/scripts/settarget.sh'
alias ip1='sh /home/rubenor/.config/polybar/scripts/set-device.sh wlp3s0f3u3' 
alias ip2='sh /home/rubenor/.config/polybar/scripts/set-device.sh wlo1' 
alias ip3='sh /home/rubenor/.config/polybar/scripts/set-device.sh eno0' 

alias p='proxychains'
alias pf='proxychains firefox'

# Plugins
source ~/.config/zsh-config/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.config/zsh-config/zsh-autosuggestions/zsh-autosuggestions.zsh

# show git branch
setopt prompt_subst
autoload -Uz vcs_info
zstyle ':vcs_info:*' actionformats \
    '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats       \
    '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{5}]%f '
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'

zstyle ':vcs_info:*' enable git cvs svn

# or use pre_cmd, see man zshcontrib
vcs_info_wrapper() {
  vcs_info
  #if [ -n "$vcs_info_msg_0_" ]; then
  #  echo "%{$fg[blue]%}${vcs_info_msg_0_}%{$reset_color%}$del"
  #fi
}


# Promt
# PROMPT='%B%F{blue}󰣇%f%b  %B%F{cyan}%n%f%b %B%F{green}%~ %(?.%B%F{green}✓.%F{red}✕)%f%b %B%F{green}%f%b ' 
#PS1='%B%F{cyan}%~ %(?.%B%F{green}✓.%F{red}✕)%f%b $(vcs_info_wrapper)
#%B%F{green}%f%b ' 
PS1='%B%F{cyan}%~ %(?.%B%F{green}✓.%F{red}✕)%f%b 
%B%F{green}%f%b ' 

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
	bat extractPorts.tmp
	rm extractPorts.tmp
}
