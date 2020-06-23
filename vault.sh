#!/bin/bash

function vt_list {
    echo "VAULT_ADDR=$VAULT_ADDR"
    ([ -n "$VAULT_TOKEN" ] && [ "empty" != "$VAULT_TOKEN" ])&&
        echo "VAULT_TOKEN exists" ||
        echo "VAULT_TOKEN not exists"
}

function vt_change {
    _vt_init
    if [ -z "$VAULTCONFIGS" ]; then
        echo "Vault configs not found"
        return 1
    else
        if [ -z "$VAULTCONFIGS" ] || echo "$VAULTCONFIGS"|grep -q ':' ; then
            #local vault_configs=$(echo $VAULTCONFIGS|cut -d ':' -f 1)
            IFS=':' read -ra _vault_configs <<< "$VAULTCONFIGS"

            # Set PS3 prompt
            PS3="Enter current VAULTCONFIG: "

            # set shuttle list
            select _vault_config in "${_vault_configs[@]}"; do
                if [ -n "$_vault_config" ]; then
                    export VAULTCONFIG=$_vault_config
                    echo "$VAULTCONFIG selected"
                    break
                fi
            done
        else
            export VAULTCONFIG=$VAULTCONFIGS
            echo "$VAULTCONFIG selected"
        fi
    fi
    _vt_apply
}

function _vt_apply {
    export VAULT_TOKEN=''
    if [ -n "$VAULTCONFIG" ]; then
        cat $VAULTCONFIG |sed '/^$/d' | sed 's/VAULT_TOKEN=.*/VAULT_TOKEN exists/'
        export $(cat $VAULTCONFIG |sed '/^$/d'|xargs)
    fi
}

function _vt_init {
    local vault_path="$HOME/.vault_configs"
    local vault_config_path="$vault_path"
    #[ -d "$vault_tokens_path" ] || mkdir -p $vault_tokens_path
    [ -d "$vault_config_path" ] || mkdir -p $vault_config_path
    #chmod 0700 $vault_tokens_path
    chmod 0700 $vault_config_path

    VAULTCONFIGS=$(printf ":%s" $(find $vault_config_path/ -type f -name 'config'))
    export VAULTCONFIGS=${VAULTCONFIGS:1}
}

function vt_login {
    _vt_init

    if [ -z "$VAULTCONFIG" ]; then
        vt_change &&
        vault status
    else
        export VAULT_TOKEN=$(vault login -field=token $@)
        sed "s/VAULT_TOKEN=.*/VAULT_TOKEN=$VAULT_TOKEN/" -i $VAULTCONFIG
    fi
}

function vt_token_save {
    _vt_init

    if [ -z "$VAULTCONFIG" ]; then
        vt_change &&
        vault status
    else
        if [ -f ~/.vault-token ]; then
            export VAULT_TOKEN=$(cat ~/.vault-token)
            sed "s/VAULT_TOKEN=.*/VAULT_TOKEN=$VAULT_TOKEN/" -i $VAULTCONFIG
            echo "Vault token saved"
        fi
    fi
}

function vt {
    _vt_init

    if [ -z "$VAULTCONFIG" ]; then
        vt_change &&
        vault status
    else
        echo cat $VAULTCONFIG
        cat $VAULTCONFIG |sed '/^$/d' | sed 's/VAULT_TOKEN=.*/VAULT_TOKEN exists/'
        vault status
    fi
}

function _vt_clear {
    unset VAULTCONFIGS
    unset VAULTCONFIG
}
