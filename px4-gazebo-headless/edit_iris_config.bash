#!/bin/bash

function is_ip_valid {
    if [[ $1 =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        return 0
    else
        echo "Invalid IP: $1"
        return 1
    fi
}

function is_docker_for_mac {
    getent hosts docker.for.mac.host.internal >/dev/null 2>&1
    return $?
}

function get_mac_host_ip {
    if ! is_docker_for_mac; then
        echo "ERROR: this is not a docker for mac container!"
        exit 1
    fi

    echo "$(getent hosts docker.for.mac.host.internal | awk '{ print $1 }')"
}

if [ "$#" -eq 1 ]; then
    if ! is_ip_valid $1; then exit 1; fi
    echo "14540 will be associated to $1"
    API_PARAM="-t $1"
elif [ "$#" -eq 2 ]; then
    if ! is_ip_valid $1 || ! is_ip_valid $2; then exit 1; fi
    echo "14550 will be associated to $1"
    echo "14540 will be associated to $2"
    QGC_PARAM="-t $1"
    API_PARAM="-t $2"
elif [ "$#" -gt 2 ]; then
    echo "Invalid parameters: [<IP for 14550> <IP for 14540>] | [<IP for 14540>]"
    exit 1;
fi

# Broadcast doesn't work with docker for mac, so we default to the mac host (docker.for.mac.localhost)
if is_docker_for_mac; then
    MAC_HOST=$(get_mac_host_ip)
    QGC_PARAM=${QGC_PARAM:-"-t ${MAC_HOST}"}
    API_PARAM=${API_PARAM:-"-t ${MAC_HOST}"}
fi

CONFIG_FILE=${FIRMWARE_DIR}/ROMFS/px4fmu_common/init.d-posix/rcS

sed -i "s/mavlink start \-x \-u $udp_gcs_port_local -r 4000000$/mavlink start \-x -u $udp_gcs_port_local -r 4000000 ${QGC_PARAM}/" ${CONFIG_FILE}
sed -i "s/mavlink start \-x \-u $udp_offboard_port_local -r 4000000 -m onboard -o $udp_offboard_port_remote$/mavlink start \-x -u $udp_offboard_port_local -r 4000000 -o $udp_offboard_port_remote ${API_PARAM}/" ${CONFIG_FILE}
