FROM ubuntu:16.04

ENV WORKSPACE_DIR /root
ENV FIRMWARE_DIR ${WORKSPACE_DIR}/Firmware

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
                       unzip

RUN curl -ssL http://get.gazebosim.org > /tmp/install_gazebosim.sh
RUN sed -i "s/GZ_VER=9/GZ_VER=8/" /tmp/install_gazebosim.sh
RUN chmod +x /tmp/install_gazebosim.sh
RUN /tmp/install_gazebosim.sh

RUN git clone --depth 1 https://github.com/PX4/Firmware.git ${FIRMWARE_DIR}
RUN git -C ${FIRMWARE_DIR} submodule update --init --recursive

# Initial location of the drone
ARG HOME_LAT=47.397742
ENV PX4_HOME_LAT=${HOME_LAT}
ARG HOME_LON=8.545594
ENV PX4_HOME_LON=${HOME_LON}
ARG HOME_ALT=488.0
ENV PX4_HOME_ALT=${HOME_LAT}

COPY edit_rcS.bash ${WORKSPACE_DIR}
COPY entrypoint.sh /root/entrypoint.sh
RUN chmod +x /root/entrypoint.sh

RUN ["/bin/bash", "-c", " \
    cd ${FIRMWARE_DIR} && \
    DONT_RUN=1 make posix gazebo_iris && \
    DONT_RUN=1 make posix gazebo_iris \
"]

ENTRYPOINT ["/root/entrypoint.sh"]
