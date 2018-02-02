In order to run a PX4-Gazebo simulator (headless):

1. Build the image from this git repository:

```
$ docker build https://github.com/JonasVautherin/docker.git#master:px4-gazebo-headless -t px4-gazebo-headless
```

2. Run it:

```
$ docker run --rm -it px4-gazebo-headless
```

`MAV_BROADCAST` is enabled by default, and the second MAVLink interface is not run in "onboard" mode in order to enable the broadcasting. Those changes are made by [edit_iris_config.bash](edit_iris_config.bash).
