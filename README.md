[![Docker pulls](https://img.shields.io/docker/pulls/jonasvautherin/px4-gazebo-headless)](https://hub.docker.com/r/jonasvautherin/px4-gazebo-headless/)[![DockerHub version](https://img.shields.io/docker/v/jonasvautherin/px4-gazebo-headless/1.17.0)](https://hub.docker.com/r/jonasvautherin/px4-gazebo-headless/)


# PX4-Gazebo simulator (headless)

## Quickstart

The Docker images resulting from this repo are available on [Docker Hub](https://hub.docker.com/r/jonasvautherin/px4-gazebo-headless/).

Note that the following commands are referring to the latest supported release of PX4, which is currently v1.17.0.

### Run in BROADCAST mode:

In this mode, the simulator will be available from your host (e.g. run the following command, and QGroundControl running on your computer will connect automatically).

```
docker run --rm -it jonasvautherin/px4-gazebo-headless:1.17.0
```

In this configuration, the container will send MAVLink to the host on ports 14550 (for QGC) and 14540 (for e.g. MAVSDK).

### Run with a custom IP for the second MAVLink interface

This mode is useful for running QGroundControl on the computer running docker, and the offboard app (e.g. using MAVSDK) on another device (e.g. a phone).

```
docker run --rm -it jonasvautherin/px4-gazebo-headless:1.17.0 192.168.0.12
```

where `192.168.0.12` should be replaced by the IP listening on the API port 14540 (e.g. MAVSDK or MAVROS).

### Run with custom IP for both MAVLink interfaces

This mode is useful for running both QGroundControl and the offboard app (e.g. using MAVSDK) on another device than the one running docker.

```
docker run --rm -it jonasvautherin/px4-gazebo-headless:1.17.0 192.168.0.10 10.0.0.12
```

where `192.168.0.10` should be replaced by the IP listening on the QGC port 14550 (e.g. QGroundControl) and `10.0.0.12` should be replaced by the IP listening on the API port 14540 (e.g. MAVSDK or MAVROS).

### Exposing a video stream

When running with the `gz_x500_mono_cam` vehicle (with `-v gz_x500_mono_cam`), a video stream will be available. Expose it with e.g. `-p 8554:8554`, like so:

```
docker run --rm -it -p 8554:8554 jonasvautherin/px4-gazebo-headless:latest -v gz_x500_mono_cam
```

You can then access it with something like:

```
gst-launch-1.0 rtspsrc location=rtsp://127.0.0.1:8554/live ! rtph264depay ! avdec_h264 ! videoconvert ! autovideosink
```

### Run with another start location

The start location can be set when running the container by setting the following environment variables:

* __PX4_HOME_LAT:__ starting latitude of the drone.
* __PX4_HOME_LON:__ starting longitude of the drone.
* __PX4_HOME_ALT:__ starting altitude of the drone.

For instance:

```
docker run --rm -it --env PX4_HOME_LAT=47.397742 --env PX4_HOME_LON=8.545594 --env PX4_HOME_ALT=488.0 jonasvautherin/px4-gazebo-headless:1.17.0
```

## Manual build

Note that a clean build from the `master` branch will pull the latest upstream from the PX4 repository (as can be seen in the [Dockerfile](https://github.com/JonasVautherin/px4-gazebo-headless/blob/master/Dockerfile)). In order to build a stable version, change `master` for a tag (e.g. `v1.17.0`) in the following commands.

### Build the image from this git repository:

```
docker build https://github.com/JonasVautherin/px4-gazebo-headless.git#master -t px4-gazebo-headless
```

The PX4 revision to build can be set with the `PX4_VERSION` build argument. It accepts any branch, tag or commit of [PX4-Autopilot](https://github.com/PX4/PX4-Autopilot), and defaults to `main`:

```
docker build https://github.com/JonasVautherin/px4-gazebo-headless.git#master --build-arg PX4_VERSION=v1.17.0 -t px4-gazebo-headless
```

Note that the patches applied in this repository are kept in sync with the latest supported release, so building an older PX4 version may fail.
