#!/bin/bash

function dpaste {
    echo "$(cat|curl -F 'content=<-' https://dpaste.de/api/|tr -d '\"')/raw"
}
