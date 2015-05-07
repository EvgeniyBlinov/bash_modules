#! /bin/bash

function ssh-add-aes {
    if which aescrypt  &> /dev/null; then
        if stat "$1" &> /dev/null; then
            echo -n 'Enter password:'
            read -s pass && ssh-add <(cat "$1" |aescrypt -d -p $pass -)
        else
            echo 'Encripted key not found!'
        fi
    else
        echo 'aescript not installed!'
    fi
}

