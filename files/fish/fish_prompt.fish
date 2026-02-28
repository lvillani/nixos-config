set -l last_status $status

# Blank line
echo ''

# User
set_color $fish_color_user
echo -n (whoami)
set_color normal

# <user> @ <host> separator
echo -n ' @ '

# Host
if set -q SSH_TTY
    set_color $fish_color_host_remote
else
    set_color $fish_color_host
end
echo -n (prompt_hostname)
if set -q SSH_TTY
    echo -n ' (ssh)'
end
set_color normal

echo -n ' '

# PWD
set_color $fish_color_cwd
echo -n (prompt_pwd)
set_color normal

# Git
__fish_git_prompt

# Virtualenv
if set -q VIRTUAL_ENV
    set -l venv_name (basename $VIRTUAL_ENV)
    set_color $fish_color_quote
    echo -n " ($venv_name)"
    set_color normal
end

# Container ID
if set -q CONTAINER_ID
    set_color $fish_color_quote
    echo -n " (in $CONTAINER_ID)"
    set_color normal
end

# Prompt
echo
if test $last_status -ne 0
    set_color $fish_color_error
    echo -n "[$last_status] "
end

echo -n '% '
set_color normal
