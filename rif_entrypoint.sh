#!/bin/bash
set -e

# References:
# https://techflare.blog/permission-problems-in-bind-mount-in-docker-volume/
# https://www.joyfulbikeshedding.com/blog/2021-03-15-docker-and-the-host-filesystem-owner-matching-problem.html

echo "RIF ROS Entrypoint!!"

USERNAME=ros

# Change
#groupmod --gid ${GROUP_ID} ${USERNAME}
#usermod --uid ${USER_ID} ${USERNAME}

# Drop privileges and execute next container command, or 'bash' if not
# specified.
if [[ $# -gt 0 ]]; then
    exec sudo -u ${USERNAME} -- "$@"
else
    exec sudo -u ${USERNAME} -- bash
fi
