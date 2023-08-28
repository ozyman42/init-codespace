#!/bin/sh
# TODO: get from env var, don't generate on startup
sudo ssh-keygen -A
sudo /usr/sbin/sshd -E /tmp/sshd-out.txt
exec "$@"
