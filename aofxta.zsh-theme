PROMPT="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )"
PROMPT+=' %{$fg[cyan]%}%c%{$reset_color%} $(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

zmodload zsh/datetime

function preexec() {
  timer=${timer:-$EPOCHREALTIME}
}

function precmd() {
    if [ $timer ]; then
        # Milisecond (ms)
        local dt=$(( EPOCHREALTIME - timer ))
        local total_ms=$(( int(dt * 1000) ))
        local timer_show=""
        # If min_show_time default ms (0)
        local min_show_ms=$(( ${min_show_time:-0} * 1000 ))
        if [[ $total_ms -ge $min_show_ms ]]; then
            local hours=$(( total_ms / 3600000 ))
            local min=$(( (total_ms / 60000) % 60 ))
            local sec=$(( (total_ms / 1000) % 60 ))
            local ms=$(( total_ms % 1000 ))
            if [ "$total_ms" -le 60000 ]; then
                # If it's Less than or equal to 60 seconds
                if [ "$total_ms" -lt 1000 ]; then
                    timer_show="%{$fg[green]%}(${ms}ms)"
                else
                    timer_show="%{$fg[green]%}(${sec}s ${ms}ms)"
                fi
            # ถ้าใช้เวลา 1 ถึง 3 นาที
            elif [ "$total_ms" -gt 60000 ] && [ "$total_ms" -le 180000 ]; then
                timer_show="%{$fg[yellow]%}(${min}m ${sec}s ${ms}ms)"
            # If it takes more than 3 minutes, or even hours
            else
                if [ "$hours" -gt 0 ]; then
                    timer_show="%{$fg[red]%}(${hours}h ${min}m ${sec}s)"
                else
                    timer_show="%{$fg[red]%}(${min}m ${sec}s)"
                fi
            fi
            RPROMPT="${timer_show} %{$fg_bold[white]%}[%*]%f %{$reset_color%}"
        else
            RPROMPT="%{$fg_bold[white]%}[%*]%f %{$reset_color%}"
        fi
        unset timer
    fi
}

autoload -Uz add-zsh-hook
add-zsh-hook preexec preexec
add-zsh-hook precmd precmd