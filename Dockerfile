FROM ubuntu:18.04

ENV WORKSPACE_DIR /root
ENV FIRMWARE_DIR ${WORKSPACE_DIR}/Firmware

ENV DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true

RUN apt-get update && \
    apt-get install -y cmake \
                       curl \
                       git \
                       libeigen3-dev \
                       libopencv-dev \
                       libroscpp-dev \
                       protobuf-compiler \
                       python-empy \
                       python-jinja2 \
                       python-numpy \
                       python-toml \
                       python-yaml \
                       unzip \
                       gazebo9 \
                       libgazebo9-dev

RUN git clone https://github.com/PX4/Firmware.git ${FIRMWARE_DIR}
RUN git -C ${FIRMWARE_DIR} checkout stable
RUN git -C ${FIRMWARE_DIR} submodule update --init --recursive

COPY edit_rcS.bash ${WORKSPACE_DIR}
COPY entrypoint.sh /root/entrypoint.sh
RUN chmod +x /root/entrypoint.sh

RUN ["/bin/bash", "-c", " \
    cd ${FIRMWARE_DIR} && \
    DONT_RUN=1 make px4_sitl gazebo && \
    DONT_RUN=1 make px4_sitl gazebo \
"]

ENTRYPOINT ["/root/entrypoint.sh"]
