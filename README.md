# RIF ROS Docker Development Environment

This repository makes it easy to start developing ROS applications within a
Docker development environment.

## Setup

The ROS distribution version is selected by specifying the distribution name to
the `env_setup.sh` script.

### ROS1 Noetic Example

1. Setup `.env` and `.docker.xauth` files for Docker Compose and to enable GUI
    access:

        ./env_setup.sh noetic

    This will create a `.env` file that Docker Compose will read in.

2. Starting with the OSRF Desktop Docker Image, build your own Docker Image:

        docker compose build

3. Start the Docker container:

        docker compose up -d dev

4. Step into the running Docker container:

        docker exec -it --user ros ros_noetic /bin/bash

5. Bring the Docker container down

        docker compose down


### ROS2 Humble Example

1. Setup `.env` and `.docker.xauth` files for Docker Compose and to enable GUI
    access:

        ./env_setup.sh humble

2. Starting with the OSRF Desktop Docker Image, build your own Docker Image:

        docker compose build

3. Start the Docker container:

        docker compose up -d dev

4. Step into the running Docker container:

        docker exec -it --user ros ros_humble /bin/bash

5. Bring the Docker container down

        docker compose down


### Mounting Code into Docker Container

To mount code from your local system into the container:

1. Start by setting up a ROS workspace directory structure on your host
system. For example:

        mkdir -p ~/ros1/workspace_2/src

2. Clone your git repos into the `~/ros1/workspace_2/src/` directory

3. Update the `docker-compose.yml` file to mount this `src` folder by adding an
   item to the `volumes` list:

        - ${HOME}/ros1/workspace_2/src:/home/ros/workspace/src

4. After running `docker compose up -d` and stepping into the container with
   `docker exec` you should be able to run `catkin_make` to build the
   workspace.


### Notes

1. You can use the `dev-nvidia` service if you have an NVIDIA GPU. To use your
   NVIDIA runtime, specify the `dev-nvidia` service when starting the
   container:

        docker compose up -d dev-nvidia

    Test that that NVIDIA runtime is working by running the `nvidia-smi`
    command.
