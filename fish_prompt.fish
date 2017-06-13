# Fish git prompt
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate 'yes'
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showupstream 'yes'
set __fish_git_prompt_showcolorhints 'yes'
# set __fish_git_prompt_show_informative_status 'yes'
# set __fish_git_prompt_color_branch purple
# set __fish_git_prompt_color_upstream_ahead green
# set __fish_git_prompt_color_upstream_behind red

# Status Chars
set __fish_git_prompt_char_stateseparator ' '
set __fish_git_prompt_char_upstream_prefix ' '
set __fish_git_prompt_char_cleanstate '✓'
set __fish_git_prompt_char_dirtystate '!'
set __fish_git_prompt_char_stagedstate '→'
set __fish_git_prompt_char_stashstate '↩'
set __fish_git_prompt_char_invalidstate '✗'
set __fish_git_prompt_char_upstream_ahead '+'
set __fish_git_prompt_char_upstream_behind '-'
set __fish_git_prompt_char_untrackedfiles '☡'
# set __fish_git_prompt_char_untrackedfiles '…'
# set __fish_git_prompt_char_dirtystate '⚡'

set theme_prompt_char '=>'
set theme_prompt_color 'black'

# Display the state of the branch when inside of a git repo
# function __theme_prompt_parse_git_branch_state -d "Display the state of the branch"
#     git update-index --really-refresh -q 1>/dev/null

#     # Check for changes to be commited
#     if git_is_touched
#         echo -n "$__fish_git_prompt_char_dirtystate"
#     else
#         echo -n "$__fish_git_prompt_char_cleanstate"
#     end

#     # Check for untracked files
#     set -l git_untracked (command git ls-files --others --exclude-standard 2> /dev/null)
#     if [ -n "$git_untracked" ]
#         echo -n "$__fish_git_prompt_char_untrackedfiles"
#     end

#     # Check for stashed files
#     if git_is_stashed
#         echo -n "$__fish_git_prompt_char_stashstate"
#     end

#     # Check if branch is ahead, behind or diverged of remote
#     git_ahead
# end

# # Display the current branch
# function __theme_prompt_git_branch -d "Display the git branch"
#     echo (command git symbolic-ref --quiet --short HEAD 2> /dev/null; or git rev-parse --short HEAD 2> /dev/null; or echo -n '(unknown)')
# end

# # Display git status
# function __theme_prompt_git -a branch_color -a state_color -d "Display the git status"
#     set -l ref
#     set -l std_prompt (prompt_pwd)
#     set -l is_dot_git (string match '*/.git' $std_prompt)

#     if git_is_repo
#         and test -z $is_dot_git

#         set -l git_branch (__theme_prompt_git_branch)
#         set -l git_state (__theme_prompt_parse_git_branch_state)

#         printf ' '
#         set_color $branch_color
#         printf '<%s>' $git_branch
#         # set_color 0087ff
#         set_color $state_color
#         printf '[%s]' $git_state
#         set_color normal
#     end
# end

# Print current user
function __theme_prompt_get_user -a color -a root_color -d "Print current user"
    if test $USER = 'root'
        set_color -o $root_color
    else
        set_color $color
    end
    printf '%s' $USER
    set_color normal
end

# Get Machines Hostname
function __theme_prompt_get_host -a color -a ssh_color -d "Get Hostname"
    if test $SSH_TTY
        set_color -o $ssh_color
    else
        set_color $color
    end
    printf '%s' (hostname | cut -d . -f 1)
    set_color normal
end

# Get Project Working Directory
function __theme_prompt_get_path -a color -d "Get PWD"
    set_color $color
    printf '%s' (prompt_pwd)
    set_color normal
end

function __theme_prompt_get_extras -a rust_color -a python_color -d "Cargo and virtualenv displays"
    if test -e "Cargo.toml"
        printf " (rust:%s)" (set_color $rust_color)(rustup show | tail -n 2 | head -n 1 |  cut -d '-' -f 1)(set_color normal)
    end

    if test $VIRTUAL_ENV
        printf " (python:%s)" (set_color $python_color)(basename $VIRTUAL_ENV)(set_color normal)
    end
end

# Get left side of prompt
function __theme_prompt_left_side -d "Get left side of prompt"
    set -l u (__theme_prompt_get_user "green" "red") # User
    set -l h (__theme_prompt_get_host "yellow" "red") # Hostname
    set -l p (__theme_prompt_get_path "cyan") # Path
    # set -l g (__theme_prompt_git "purple" "blue") # Git
    set -l g (__fish_git_prompt) # Git
    set -l e (__theme_prompt_get_extras "red" "blue") # Virtualenv and Rust

    printf '%s@%s:%s%s%s' $u $h $p $g $e # Format prompt
end

# Get right side of prompt
function __theme_prompt_right_side -d "Get right side of prompt"
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

function get_padding -a length -d "Get padding of given length"
    set -l space ""
    for i in (seq 1 $length)
        set space " "$space
    end
    printf $space
end

function remove_color -a str -d "Remove color info from a string"
    printf $str | perl -pe 's/\x1b.*?[mGKH]//g'
end

function format_output -a length -a left -a right -d "Format output string"
    set -l padding (get_padding (math $length - (remove_color "$left$right" | string length)))
    echo -n "$left$padding$right"
end

function fish_prompt
    set -l right (__theme_prompt_right_side)
    set -l left (__theme_prompt_left_side)
    format_output $COLUMNS $left $right
    printf "\n%s " (set_color -o $theme_prompt_color)(echo "$theme_prompt_char")(set_color normal)
end
