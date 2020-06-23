#!/bin/bash

function kc_list {
    echo "KUBECONFIGS=$KUBECONFIGS"
    echo "KUBECONFIG=$KUBECONFIG"
    echo "HELM_HOME=$HELM_HOME"
}

function kc_change {
    if echo $KUBECONFIGS|grep -q ':'; then
        #local kubeconfig_dir=$(echo $KUBECONFIG|cut -d ':' -f 1|xargs dirname)
        IFS=':' read -ra kubeconfigs <<< "$KUBECONFIGS"

        # Set PS3 prompt
        PS3="Enter current KUBECONFIG: "

        # set shuttle list
        select kubeconfig in "${kubeconfigs[@]}"; do
            if [ -n "$kubeconfig" ]; then
                export KUBECONFIG=$kubeconfig
                echo "$kubeconfig selected"
                break
            fi
        done
    else
        export KUBECONFIG=$KUBECONFIGS
        echo "$KUBECONFIG selected"
    fi
    kc_helm_home
}

function kc_helm_home {
    export HELM_HOME="$HOME/.helm-$(kubectl config current-context|cut -d @ -f 2)"
    export PATH="$(echo ${PATH} | awk -v RS=: -v ORS=: '/helm/ {next} {print}')"
    export PATH="${HELM_HOME}/bin:${PATH}"
}

function kc_change_namespace {
    kc config view | grep -o 'namespace:.*'
    echo '-------------------'
    kc get namespaces
    echo '-------------------'

    # Set PS3 prompt
    PS3="Enter current namespace: "

    # set shuttle list
    select kubenamespace in $(kc get namespaces --no-headers=true|awk '{print $1}'); do
        if [ -n "$kubenamespace" ]; then
            kc config set-context $(kc config current-context) --namespace=$kubenamespace
            kc config view | grep -o 'namespace:.*'
            break
        fi
    done
}

function kc {
    local kubeconfig_path="$HOME/.kube/config"
    if [ -e "$kubeconfig_path" ]; then
        case $(stat --printf=%F $kubeconfig_path) in
            directory)
                KUBECONFIGS=$(printf ":%s" $(find $kubeconfig_path -type f))
                export KUBECONFIGS=${KUBECONFIGS:1}
            ;;
            "regular file")
                export KUBECONFIG=$kubeconfig_path
                export KUBECONFIGS=$kubeconfig_path
                kc_helm_home
            ;;
        esac
    else
        export KUBECONFIGS=$HOME/.kube/admin.conf
        export KUBECONFIG=$HOME/.kube/admin.conf
        kc_helm_home
    fi

    if [ -z "$KUBECONFIG" ] || echo "$KUBECONFIG"|grep -q ':' ; then
        kc_change
    fi
    kubectl --kubeconfig=$KUBECONFIG $@
}
