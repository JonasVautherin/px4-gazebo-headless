FROM ubuntu:24.04

ENV WORKSPACE_DIR /root
ENV FIRMWARE_DIR ${WORKSPACE_DIR}/px4
ENV SITL_RTSP_PROXY ${WORKSPACE_DIR}/sitl_rtsp_proxy

ENV DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true
ENV DISPLAY :99
ENV LANG C.UTF-8

RUN apt-get update && \
    apt-get install -y \
                       bc \
                       cmake \
                       curl \
                       git \
                       gnupg \
                       gstreamer1.0-plugins-bad \
                       gstreamer1.0-plugins-base \
                       gstreamer1.0-plugins-good \
                       gstreamer1.0-plugins-ugly \
                       iproute2 \
                       libgstreamer-plugins-base1.0-dev \
                       libgstrtspserver-1.0-dev \
                       libopencv-dev \
                       lsb-release \
                       python3-pip \
                       python3-empy \
                       python3-future \
                       python3-jinja2 \
                       python3-jsonschema \
                       python3-kconfiglib \
                       python3-yaml \
                       xvfb

RUN pip3 install --break-system-packages pyros-genmsg

RUN curl https://packages.osrfoundation.org/gazebo.gpg --output /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null && \
    apt-get update && \
    apt-get install -y gz-harmonic

RUN apt-get -y autoremove && \
    apt-get clean autoclean && \
    rm -rf /var/lib/apt/lists/{apt,dpkg,cache,log} /tmp/* /var/tmp/*

RUN git clone https://github.com/PX4/PX4-Autopilot.git ${FIRMWARE_DIR}
RUN git -C ${FIRMWARE_DIR} checkout main
RUN git -C ${FIRMWARE_DIR} submodule update --init --recursive

COPY fix-cmake-build.patch ${FIRMWARE_DIR}
RUN git -C ${FIRMWARE_DIR} apply fix-cmake-build.patch

COPY sitl_rtsp_proxy ${SITL_RTSP_PROXY}
RUN cmake -B${SITL_RTSP_PROXY}/build -H${SITL_RTSP_PROXY}
RUN cmake --build ${SITL_RTSP_PROXY}/build

RUN cmake -DCONFIG=px4_sitl_default -B${FIRMWARE_DIR}/build -S${FIRMWARE_DIR} && \
    cmake --build ${FIRMWARE_DIR}/build

COPY edit_rcS.bash ${WORKSPACE_DIR}
COPY entrypoint.sh /root/entrypoint.sh
RUN chmod +x /root/entrypoint.sh

ENTRYPOINT ["/root/entrypoint.sh"]
