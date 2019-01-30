#!/bin/bash

function kc_list {
    echo "KUBECONFIG_CURRENT=$KUBECONFIG_CURRENT"
    echo "KUBECONFIG=$KUBECONFIG"
}

function kc_change {
    if echo $KUBECONFIG|grep -q ':'; then
        #local kubeconfig_dir=$(echo $KUBECONFIG|cut -d ':' -f 1|xargs dirname)
        IFS=':' read -ra kubeconfigs <<< "$KUBECONFIG"

        # Set PS3 prompt
        PS3="Enter current KUBECONFIG: "

        # set shuttle list
        select kubeconfig in "${kubeconfigs[@]}"; do
            if [ -n "$kubeconfig" ]; then
                export KUBECONFIG_CURRENT=$kubeconfig
                echo "$kubeconfig selected"
                break
            fi
        done
    else
        export KUBECONFIG_CURRENT=$KUBECONFIG
        echo "$KUBECONFIG selected"
    fi
}

function kc {
    if [ -z "$KUBECONFIG_CURRENT" ]; then
        kc_change
    fi
    kubectl --kubeconfig=$KUBECONFIG_CURRENT $@
}
