function autovenv --on-event fish_prompt
    if not status is-interactive
        return
    end

    set dir (pwd)
    while test $dir != /
        for venv_dir in venv .venv virtualenv .virtualenv
            set candidate "$dir/$venv_dir"
            if test -f "$candidate/bin/activate"
                set dir /
                break
            end
            set -e candidate
        end

        set dir (dirname $dir)
    end

    if test -n "$VIRTUAL_ENV" -a "$candidate" != "$VIRTUAL_ENV"
        set -e PATH[(contains --index "$VIRTUAL_ENV/bin" $PATH)]
        set -e VIRTUAL_ENV
    end

    if test -z "$VIRTUAL_ENV" -a -n "$candidate"
        set -g VIRTUAL_ENV "$candidate"
        set -x VIRTUAL_ENV "$candidate"
        set -x -p PATH "$VIRTUAL_ENV/bin"
    end
end
