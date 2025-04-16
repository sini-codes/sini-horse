function fish_prompt
    # Check if a command has just executed (status is set) or is in progress

    # Check if the current directory has changed since last prompt
    set -l current_pwd (pwd)
    if test "$current_pwd" != "$__last_pwd"
        set_color $fish_color_cwd
        echo -n (prompt_pwd)
        set -g __last_pwd "$current_pwd"
    end

    # set_color $fish_color_cwd
    # echo -n (prompt_pwd)
    # set_color normal
    set_color $fish_color_host
    # printf ' \uf0d1  '
    printf ' \u276F '
    set_color normal
end
