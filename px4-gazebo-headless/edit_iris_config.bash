#!/bin/bash

IRIS_CONFIG_FILE=${FIRMWARE_DIR}/posix-configs/SITL/init/ekf2/iris

sed -i "s/mavlink start \-x \-u 14557 -r 4000000 -m onboard -o 14540/mavlink start \-x -u 14557 -r 4000000 -o 14540 /" ${IRIS_CONFIG_FILE}

echo 'param set MAV_BROADCAST 1' >> ${IRIS_CONFIG_FILE}
