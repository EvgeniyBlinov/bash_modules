#!/bin/bash

function openssl_neighbor {
    local DOMAIN="${DOMAIN}"
    if [ -z "${DOMAIN}" ]; then
        read  -p 'Enter domain name: ' DOMAIN
    fi
    true |
    openssl s_client -showcerts -connect ${DOMAIN}:443 2>&1 |
    openssl x509 -text |
    grep -o 'DNS:[^,]*' |
    cut -f2 -d:
}
