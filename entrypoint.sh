#!/bin/bash

Xvfb :99 -screen 0 1600x1200x24+32 &
${SITL_RTSP_PROXY}/build/sitl_rtsp_proxy &

source ${WORKSPACE_DIR}/edit_rcS.bash $1 $2 &&
cd ${FIRMWARE_DIR} &&
HEADLESS=1 make px4_sitl gazebo_typhoon_h480
