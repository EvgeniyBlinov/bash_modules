#! /bin/bash

function git_auto_commit {
    local OPTIND a m
    local MESSAGE=''
    local ALL=''
    while getopts "am:" opt; do
        case "$opt" in
        a)
            ALL='a'
            ;;
        m)
            MESSAGE=": $OPTARG"
            ;;
        esac
    done

    shift $((OPTIND-1))

    [ "$1" = "--" ] && shift
    #########################################################################

#$(git rev-parse --abbrev-ref HEAD|awk -F '_' '{print "[#"$3"]"}')  $(git rev-parse --abbrev-ref HEAD) $MESSAGE
    git commit \
        -${ALL}m "$(cat <<END_HEREDOC
$(git rev-parse --abbrev-ref HEAD) $MESSAGE


Work stage $(date '+%F %T')
$(git status -s)
END_HEREDOC
)"
}

function git_branch_useful {
    for k in `git branch|perl -pe s/^..//`;do
        echo -e `git show --pretty=format:"%Cgreen%ci %Cblue%cr%Creset" $k|head -n 1`\\t$k;
    done|sort -r|column -t
}
