#!/bin/bash

openwrt_dhcp_leases () {
    local ROUTER="${1:-router}"
    ssh ${ROUTER} 'cat /tmp/dhcp.leases'
}
