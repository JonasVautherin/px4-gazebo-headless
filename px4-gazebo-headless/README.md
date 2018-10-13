# PX4-Gazebo simulator (headless)

### Build the image from this git repository:

```
$ docker build https://github.com/JonasVautherin/docker.git#master:px4-gazebo-headless -t px4-gazebo-headless
```

The starting location of the drone can be set at build time using build arguments (by default the drone is in Zuerich). The possible build arguments are:

* __HOME_LAT:__ starting latitude of the drone (defaults to 47.397742).
* __HOME_LON:__ starting longitude of the drone (defaults to 8.545594).
* __HOME_ALT:__ starting altitude of the drone (defaults to 488.0).

Build arguments can be added to the above command line as follows:

```
$ docker build https://github.com/JonasVautherin/docker.git#master:px4-gazebo-headless --build-arg HOME_LAT=37.873350 --build-arg HOME_LON=-122.302525 --build-arg HOME_ALT=20 -t px4-gazebo-headless
```

### Run it in BROADCAST mode:

```
$ docker run --rm -it px4-gazebo-headless
```

`MAV_BROADCAST` is enabled by default, and the second MAVLink interface is not run in "onboard" mode in order to enable the broadcasting. Those changes are made by [edit_rcS.bash](edit_rcS.bash).

### Run it with a custom IP for the second mavlink interface

```
$ docker run --rm -it px4-gazebo-headless 192.168.0.12
```

where `192.168.0.12` should be replaced by the IP listening on the API port 14540 (e.g. DroneCore or Mavros).

### Run it with custom IP for both mavlink interfaces

```
$ docker run --rm -it px4-gazebo-headless 192.168.0.10 10.0.0.12
```

where `192.168.0.10` should be replaced by the IP listening on the QGC port (e.g. QGroundControl) and `10.0.0.12` should be replaced by the IP listening on the API port (e.g. DroneCore or Mavros).

### Run with another start location

The start location of the drone can be set at build time (see instructions above), but also when running the container. For this, set the following environment variables:

* __PX4_HOME_LAT:__ starting latitude of the drone (defaults to 47.397742).
* __PX4_HOME_LON:__ starting longitude of the drone (defaults to 8.545594).
* __PX4_HOME_ALT:__ starting altitude of the drone (defaults to 488.0).

For instance:

```
$ docker run --rm -it --env PX4_HOME_LAT=47.397742 --env PX4_HOME_LON=8.545594 --env PX4_HOME_ALT=488.0 px4-gazebo-headless
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
