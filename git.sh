#! /bin/bash


function git_auto_commit {
    git commit -m "$(cat <<END_HEREDOC
$(git rev-parse --abbrev-ref HEAD|awk -F '_' '{print "[#"$3"]"}')  $(git rev-parse --abbrev-ref HEAD)
Work stage $(date '+%F %T')
$(git status -s)
END_HEREDOC
)" "$@"
}

function git_branch_useful {
    for k in `git branch|perl -pe s/^..//`;do
        echo -e `git show --pretty=format:"%Cgreen%ci %Cblue%cr%Creset" $k|head -n 1`\\t$k;
    done|sort -r|column -t
}
