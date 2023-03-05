PROMPT="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )"
PROMPT+=' %{$fg[cyan]%}%c%{$reset_color%} $(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

function preexec() {
  timer=${timer:-$SECONDS}
  time_msg=""
}

function precmd() {
    if [ $timer ]; then
        timer_sec=$(($SECONDS - $timer))
        timer_show="" #$(($SECONDS - $timer))
        if [[ $timer_sec -ge $min_show_time ]]; then
            #RPROMPT='%{$fg_bold[red]%}(${timer_show}s)%f%{$fg_bold[white]%}[%*]%f %{$reset_color%}%'
            hours=$(($timer_sec/3600))
            min=$(($timer_sec/60))
            sec=$(($timer_sec%60))
            if [ "$timer_sec" -le 60 ]; then
                timer_show="$fg[green]$timer_sec s"
            elif [ "$timer_sec" -gt 60 ] && [ "$timer_sec" -le 180 ]; then
                timer_show="$fg[yellow]$min m $sec s"
            else
                if [ "$hours" -gt 0 ]; then
                    min=$(($min%60))
                    timer_show="$fg[red]$hours h $min m $sec s"
                else
                    timer_show="$fg[red]$min m $sec s"
                fi
            fi
            #printf "${ZSH_COMMAND_TIME_MSG}\n" "$timer_show"
            RPROMPT='%{$fg_bold[red]%}(${timer_show})%f%{$fg_bold[white]%}[%*]%f %{$reset_color%}%'
            #else
            #RPROMPT='%{$fg_bold[white]%}[%*]%f'
        fi
        unset timer
    fi
}

autoload -Uz add-zsh-hook
add-zsh-hook preexec preexec
add-zsh-hook precmd precmd