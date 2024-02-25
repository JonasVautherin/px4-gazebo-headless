#!/bin/bash

function show_help {
    echo ""
    echo "Usage: ${0} [-h | -v VEHICLE | -w WORLD] [HOST_API | HOST_QGC HOST_API]"
    echo ""
    echo "Run a headless px4-gazebo simulation in a docker container. The"
    echo "available vehicles and worlds are the ones available in PX4"
    echo "(i.e. when running e.g. \`make px4_sitl gazebo_iris__baylands\`)"
    echo ""
    echo "  -h    Show this help"
    echo "  -v    Set the vehicle (default: iris)"
    echo "  -w    Set the world (default: empty)"
    echo ""
    echo "  <HOST_API> is the host or IP to which PX4 will send MAVLink on UDP port 14540"
    echo "  <HOST_QGC> is the host or IP to which PX4 will send MAVLink on UDP port 14550"
    echo ""
    echo "By default, MAVLink is sent to the host."
}

function get_ip {
    output=$(getent hosts "$1" | awk '{print $1}')
    if [ -z $output ];
    then
        # No output, assume IP
        echo $1
    else
        # Got IP, use it
        echo $output
    fi
}

OPTIND=1 # Reset in case getopts has been used previously in the shell.

vehicle=iris
world=empty

while getopts "h?v:w:" opt; do
    case "$opt" in
    h|\?)
        show_help
        exit 0
        ;;
    v)  vehicle=$OPTARG
        ;;
    w)  world=$OPTARG
        ;;
    esac
done

shift $((OPTIND-1))


if [ "$#" -eq 1 ]; then
    IP_QGC=$(get_ip "$1")
elif [ "$#" -eq 2 ]; then
    IP_API=$(get_ip "$1")
    IP_QGC=$(get_ip "$2")
elif [ "$#" -gt 2 ]; then
    show_help
    exit 1;
fi

Xvfb :99 -screen 0 1600x1200x24+32 &
${SITL_RTSP_PROXY}/build/sitl_rtsp_proxy &

source ${WORKSPACE_DIR}/edit_rcS.bash ${IP_API} ${IP_QGC} &&
cd ${FIRMWARE_DIR} &&
HEADLESS=1 make px4_sitl gazebo_${vehicle}__${world}
