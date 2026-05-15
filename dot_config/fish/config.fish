## Homebrew (cross-platform)
set -l brew_paths /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew
for brew_path in $brew_paths
    if test -x $brew_path
        eval ($brew_path shellenv fish)
        break
    end
end


## Greeting
function fish_greeting
    if type -q fastfetch
        fastfetch
    end
end


## Man pages
set -x MANROFFOPT "-c"
set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"


## Done plugin settings
set -U __done_min_cmd_duration 10000
set -U __done_notification_urgency_level low


## Environment
# Source ~/.fish_profile if it exists
if test -f ~/.fish_profile
    source ~/.fish_profile
end

# Add ~/.local/bin to PATH
if test -d ~/.local/bin
    if not contains -- ~/.local/bin $PATH
        set -p PATH ~/.local/bin
    end
end


## Bang-bang history (!! and !$)
function __history_previous_command
    switch (commandline -t)
    case "!"
        commandline -t $history[1]; commandline -f repaint
    case "*"
        commandline -i !
    end
end

function __history_previous_command_arguments
    switch (commandline -t)
    case "!"
        commandline -t ""
        commandline -f history-token-search-backward
    case "*"
        commandline -i '$'
    end
end

if [ "$fish_key_bindings" = fish_vi_key_bindings ]
    bind -Minsert ! __history_previous_command
    bind -Minsert '$' __history_previous_command_arguments
else
    bind ! __history_previous_command
    bind '$' __history_previous_command_arguments
end


## Functions
function history
    builtin history --show-time='%F %T '
end

function backup --argument filename
    cp $filename $filename.bak
end

function copy
    set count (count $argv | tr -d \n)
    if test "$count" = 2; and test -d "$argv[1]"
        set from (echo $argv[1] | string trim --right --chars=/)
        set to (echo $argv[2])
        command cp -r $from $to
    else
        command cp $argv
    end
end


## Aliases

# ls -> eza
if type -q eza
    alias ls='eza -al --color=always --group-directories-first --icons'
    alias la='eza -a --color=always --group-directories-first --icons'
    alias ll='eza -l --color=always --group-directories-first --icons'
    alias lt='eza -aT --color=always --group-directories-first --icons'
    alias l.="eza -a | grep -e '^\.'"
else
    alias la='ls -A'
    alias ll='ls -l'
end

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

# Common
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias tarnow='tar -acf '
alias untar='tar -zxvf '
alias wget='wget -c '
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
alias please='sudo'
alias tb='nc termbin.com 9999'


## Dotfiles
alias config='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'


## tmux auto-attach
if type -q tmux
    if not test -n "$TMUX"; and not test -n "$SSH_CONNECTION"
        tmux attach-session -t default; or tmux new-session -s default
    end
end

export PATH="$HOME/.local/bin:$PATH"
