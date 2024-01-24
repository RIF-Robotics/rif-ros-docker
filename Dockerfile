ARG ROS_DISTRO=humble
ARG IMAGE_NAME=osrf/ros:${ROS_DISTRO}-desktop-full

FROM ${IMAGE_NAME}
MAINTAINER Kevin DeMarco
ENV DEBIAN_FRONTEND noninteractive
SHELL ["/bin/bash", "-c"]

RUN apt-get update \
    && apt-get install -y \
    python3-rosdep \
    python3-rosinstall \
    python3-rosinstall-generator \
    python3-wstool \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Create user
ENV USERNAME ros
RUN adduser --disabled-password --gecos '' $USERNAME \
    && usermod --shell /bin/bash $USERNAME \
    && adduser $USERNAME sudo \
    && adduser $USERNAME dialout \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

ENV HOME_DIR /home/${USERNAME}
USER $USERNAME

# .bashrc setup
RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ${HOME_DIR}/.bashrc \
    && echo "source /usr/share/gazebo/setup.sh" >> ${HOME_DIR}/.bashrc

RUN mkdir -p ${HOME_DIR}/workspace/src
WORKDIR ${HOME_DIR}/workspace

# Update rosdep
RUN source /opt/ros/${ROS_DISTRO}/setup.bash \
    && sudo apt-get update \
    && rosdep update

# Copy in ROS build script that uses catkin_make or colcon depending on ROS1 vs
# ROS2
COPY ./build-ros-workspace.sh .
RUN source /opt/ros/${ROS_DISTRO}/setup.bash \
    && ./build-ros-workspace.sh \
    && rm ./build-ros-workspace.sh

# Need to switch to root, so that when the rif_entrypoint.sh is run, the "ros"
# user is not running any processes. This is required, so we can run usermod to
# change the user's ID.
USER root
COPY rif_entrypoint.sh /rif_entrypoint.sh
ENTRYPOINT ["/rif_entrypoint.sh"]
CMD ["bash"]
