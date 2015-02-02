#! /bin/bash


function git_auto_commit {
    git commit -m "Work stage $(date '+%F %T')" "$@"
}
