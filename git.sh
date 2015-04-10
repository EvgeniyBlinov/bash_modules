#! /bin/bash


function git_auto_commit {
    git commit -m "$(cat <<END_HEREDOC
$(git rev-parse --abbrev-ref HEAD|awk -F '_' '{print "[#"$3"]"}')  $(git rev-parse --abbrev-ref HEAD)
Work stage $(date '+%F %T')
$(git status -s)
END_HEREDOC
)" "$@"
}
