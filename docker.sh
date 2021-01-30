#!/bin/bash

function docker_tags {
    if [ -z "$1" ]; then
        echo "Repository and image are required!"
    else
        local repository=$(dirname $1)
        local imagename=$(basename $1)
        if [ "." == "$repository" ]; then
            local repository='library'
        fi
        curl -Ls "https://registry.hub.docker.com/v2/repositories/$repository/$imagename/tags?page_size=1024" |
            jq -r '."results"[]["name"]'
    fi
}
