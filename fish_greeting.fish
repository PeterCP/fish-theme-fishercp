function fish_greeting
    set -l user (set_color cyan)(echo "$USER")(set_color normal)
    # set -l date (set_color green)(date +%H:%M:%S)(set_color normal)
    set -l date (set_color green)(date +%c)(set_color normal)
    printf 'Welcome to Fish Shell, %s! Today is %s.' $user $date
end
