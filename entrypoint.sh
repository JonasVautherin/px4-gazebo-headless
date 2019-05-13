#!/bin/bash

source ${WORKSPACE_DIR}/edit_rcS.bash $1 $2 &&
cd ${FIRMWARE_DIR} &&
HEADLESS=1 make px4_sitl gazebo
