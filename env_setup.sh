#!/bin/bash

if [ -z $1 ]; then
    echo "You must specify a ROS distribution."
    echo "For example: $0 humble"
    exit -1
fi

# Get the host user's IDs for the entrypoint script
echo -e "USER_ID=$(id -u ${USER})" > .env
echo -e "GROUP_ID=$(id -g ${USER})" >> .env

# Reference:
# https://stackoverflow.com/questions/16296753/can-you-run-gui-applications-in-a-linux-docker-container
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f .docker.xauth nmerge - >/dev/null 2>&1

# Write ROS distro
echo -e "ROS_DISTRO=$1" >> .env
