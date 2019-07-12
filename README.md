# PX4-Gazebo simulator (headless)

## Quickstart

The Docker images resulting from this repo are available on [Docker Hub](https://hub.docker.com/r/jonasvautherin/px4-gazebo-headless/).

Note that the following commands are referring to the latest supported release of PX4, which is currently v1.9.2.

### Run in BROADCAST mode:

In this mode, the simulator will be available from your host (e.g. run the following command, and QGroundControl running on your computer will connect automatically).

```
$ docker run --rm -it jonasvautherin/px4-gazebo-headless:v1.9.2
```

`MAV_BROADCAST` is enabled by default, and the second MAVLink interface is not run in "onboard" mode in order to enable the broadcasting. Those changes are made by [edit_rcS.bash](edit_rcS.bash).

### Run with a custom IP for the second MAVLink interface

This mode is useful for running QGroundControl on the computer running docker, and the offboard app (e.g. using MAVSDK) on another device (e.g. a phone).

```
$ docker run --rm -it jonasvautherin/px4-gazebo-headless:v1.9.2 192.168.0.12
```

where `192.168.0.12` should be replaced by the IP listening on the API port 14540 (e.g. MAVSDK or MAVROS).

### Run with custom IP for both MAVLink interfaces

This mode is useful for running both QGroundControl and the offboard app (e.g. using MAVSDK) on another device than the one running docker.

```
$ docker run --rm -it jonasvautherin/px4-gazebo-headless:v1.9.2 192.168.0.10 10.0.0.12
```

where `192.168.0.10` should be replaced by the IP listening on the QGC port (e.g. QGroundControl) and `10.0.0.12` should be replaced by the IP listening on the API port (e.g. MAVSDK or MAVROS).

### Run with another start location

The start location can be set when running the container by setting the following environment variables:

* __PX4_HOME_LAT:__ starting latitude of the drone.
* __PX4_HOME_LON:__ starting longitude of the drone.
* __PX4_HOME_ALT:__ starting altitude of the drone.

For instance:

```
$ docker run --rm -it --env PX4_HOME_LAT=47.397742 --env PX4_HOME_LON=8.545594 --env PX4_HOME_ALT=488.0 jonasvautherin/px4-gazebo-headless:v1.9.2
```

## Manual build

Note that a clean build from the `master` branch will pull the latest upstream from the PX4 repository (as can be seen [here](https://github.com/JonasVautherin/px4-gazebo-headless/blob/master/Dockerfile#L26)). In order to build a stable version, change `master` for a tag (e.g. `v1.9.2`) in the following commands.

### Build the image from this git repository:

```
$ docker build https://github.com/JonasVautherin/px4-gazebo-headless.git#master -t px4-gazebo-headless
```

The starting location of the drone can be set at build time using build arguments (by default the drone is in Zuerich). The possible build arguments are:

* __HOME_LAT:__ starting latitude of the drone (defaults to 47.397742).
* __HOME_LON:__ starting longitude of the drone (defaults to 8.545594).
* __HOME_ALT:__ starting altitude of the drone (defaults to 488.0).

Build arguments can be added to the above command line as follows:

```
$ docker build https://github.com/JonasVautherin/px4-gazebo-headless.git#master --build-arg HOME_LAT=37.873350 --build-arg HOME_LON=-122.302525 --build-arg HOME_ALT=20 -t px4-gazebo-headless
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
