function fish_right_prompt
    # Customize the right prompt
      set -l code $status
    if test $code -ne 0
        set_color -o red
    else
        set_color green
    end
    printf '%d' $code
    set_color black
    printf '|'
    set_color -o black
    printf '%s' (date +%H:%M:%S)
    set_color normal
end
