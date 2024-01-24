#!/bin/bash

if ! command -v colcon &> /dev/null
then
    # colcon not found, probably using ROS1
    echo "Building with catkin_make"
    catkin_make
    echo 'source ~/workspace/devel/local_setup.bash' >> ${HOME_DIR}/.bashrc
else
    # colcon found, probably using ROS2
    echo "Building with colcon"
    colcon build --symlink-install
    echo 'source ~/workspace/install/local_setup.bash' >> ${HOME_DIR}/.bashrc
fi
