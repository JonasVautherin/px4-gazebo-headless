[![GitHub Actions Status](https://github.com/jonasvautherin/px4-gazebo-headless/workflows/Publish%20Docker/badge.svg?branch=master)](https://github.com/jonasvautherin/px4-gazebo-headless)[![Docker pulls](https://img.shields.io/docker/pulls/jonasvautherin/px4-gazebo-headless)](https://hub.docker.com/r/jonasvautherin/px4-gazebo-headless/)[![DockerHub version](https://img.shields.io/docker/v/jonasvautherin/px4-gazebo-headless/1.14.3)](https://hub.docker.com/r/jonasvautherin/px4-gazebo-headless/)


# PX4-Gazebo simulator (headless)

## Quickstart

The Docker images resulting from this repo are available on [Docker Hub](https://hub.docker.com/r/jonasvautherin/px4-gazebo-headless/).

Note that the following commands are referring to the latest supported release of PX4, which is currently v1.14.3.

### Run in BROADCAST mode:

In this mode, the simulator will be available from your host (e.g. run the following command, and QGroundControl running on your computer will connect automatically).

```
docker run --rm -it jonasvautherin/px4-gazebo-headless:1.14.3
```

In this configuration, the container will send MAVLink to the host on ports 14550 (for QGC) and 14540 (for e.g. MAVSDK).

### Run with a custom IP for the second MAVLink interface

This mode is useful for running QGroundControl on the computer running docker, and the offboard app (e.g. using MAVSDK) on another device (e.g. a phone).

```
docker run --rm -it jonasvautherin/px4-gazebo-headless:1.14.3 192.168.0.12
```

where `192.168.0.12` should be replaced by the IP listening on the API port 14540 (e.g. MAVSDK or MAVROS).

### Run with custom IP for both MAVLink interfaces

This mode is useful for running both QGroundControl and the offboard app (e.g. using MAVSDK) on another device than the one running docker.

```
docker run --rm -it jonasvautherin/px4-gazebo-headless:1.14.3 192.168.0.10 10.0.0.12
```

where `192.168.0.10` should be replaced by the IP listening on the QGC port 14550 (e.g. QGroundControl) and `10.0.0.12` should be replaced by the IP listening on the API port 14540 (e.g. MAVSDK or MAVROS).

### Exposing a video stream

When running with the Typhoon H480 vehicle (with `-v typhoon_h480`), a video stream will be available. Expose it with e.g. `-p 8554:8554`, like so:

```
docker run --rm -it -p 8554:8554 jonasvautherin/px4-gazebo-headless:1.14.3 -v typhoon_h480
```

### Run with another start location

The start location can be set when running the container by setting the following environment variables:

* __PX4_HOME_LAT:__ starting latitude of the drone.
* __PX4_HOME_LON:__ starting longitude of the drone.
* __PX4_HOME_ALT:__ starting altitude of the drone.

For instance:

```
docker run --rm -it --env PX4_HOME_LAT=47.397742 --env PX4_HOME_LON=8.545594 --env PX4_HOME_ALT=488.0 jonasvautherin/px4-gazebo-headless:1.14.3
```

## Manual build

Note that a clean build from the `master` branch will pull the latest upstream from the PX4 repository (as can be seen [here](https://github.com/JonasVautherin/px4-gazebo-headless/blob/master/Dockerfile#L26)). In order to build a stable version, change `master` for a tag (e.g. `v1.14.3`) in the following commands.

### Build the image from this git repository:

```
docker build https://github.com/JonasVautherin/px4-gazebo-headless.git#master -t px4-gazebo-headless
```

The starting location of the drone can be set at build time using build arguments (by default the drone is in Zuerich). The possible build arguments are:

* __HOME_LAT:__ starting latitude of the drone (defaults to 47.397742).
* __HOME_LON:__ starting longitude of the drone (defaults to 8.545594).
* __HOME_ALT:__ starting altitude of the drone (defaults to 488.0).

Build arguments can be added to the above command line as follows:

```
docker build https://github.com/JonasVautherin/px4-gazebo-headless.git#master --build-arg HOME_LAT=37.873350 --build-arg HOME_LON=-122.302525 --build-arg HOME_ALT=20 -t px4-gazebo-headless
```

### Troubleshooting

#### I cannot build the image

__Problem:__

Building the image fails with the following error:

```
c++: internal compiler error: Killed (program cc1plus)
Please submit a full bug report,
with preprocessed source if appropriate.
See <file:///usr/share/doc/gcc-5/README.Bugs> for instructions.
```

__Possible solution:__

If running on Docker for Mac, try to increase the memory in _Preferences > Advanced > Memory_. Increasing from 2GB to 4GB solved the problem for me.

If running on Docker for Windows, you can do it by right clicking on the Docker icon on the task bar and going into _Settings > Resources > Advanced > Memory_.

#### It doesn't work with Docker Toolbox

__Problem:__

Using Docker Toolbox (instead of Docker for Windows/Mac, for instance on Windows 10 Home), px4-gazebo-headless is not detected by QGroundControl running on the host.

__Solution:__

The container automatically detects if it is running inside Docker for Windows/Mac, but not if it is inside Docker Toolbox (let me know if you have a way to detect this). However, it seems that in Docker Toolbox, the host is assigned 10.0.2.2 by default (I am guessing this default is coming from VirtualBox). Therefore it works to redirect to this IP, as described above. For instance:

```
docker run --rm -it jonasvautherin/px4-gazebo-headless:1.14.3 10.0.2.2 10.0.2.2
```

### It doesn't connect with Podman

__Problem:__

Using podman, the MAVLink traffic for port 14550 (and 14540) does not seem to arrive in QGroundControl (and MAVSDK).

__Solution:__

Try to use the "host network" mode and set the MAVLink interfaces for both interfaces.

```
podman run --rm --network host -it jonasvautherin/px4-gazebo-headless:1.14.3 127.0.0.1 127.0.0.1
```
